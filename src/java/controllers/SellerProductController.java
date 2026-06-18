package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.Part;
import java.io.File;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import models.Penjual;
import models.Produk;

@WebServlet(name = "SellerProductController", urlPatterns = {"/seller/produk", "/seller/produk/tambah", "/seller/produk/edit"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class SellerProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        String username = (String) session.getAttribute("username");
        Penjual penjual = new models.Penjual().getPenjualByUsername(username);

        if (penjual == null || penjual.getNamaToko() == null || penjual.getNamaToko().trim().isEmpty()) {
            request.getRequestDispatcher("/seller/create_store.jsp").forward(request, response);
            return;
        }

        request.setAttribute("penjual", penjual);

        String path = request.getServletPath();
        if ("/seller/produk".equals(path)) {
            Produk produkModel = new models.Produk();
            if (penjual != null) {
                produkModel.where("penjual_id = '" + penjual.getId() + "'");
            }
            ArrayList<Produk> listProduk = produkModel.get();
            request.setAttribute("listProduk", listProduk);
            request.getRequestDispatcher("/seller/produk/index.jsp").forward(request, response);
        } else if ("/seller/produk/tambah".equals(path)) {
            request.getRequestDispatcher("/seller/produk/tambah.jsp").forward(request, response);
        } else if ("/seller/produk/edit".equals(path)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                Produk produk = new models.Produk().find(idParam);
                request.setAttribute("produk", produk);
            }
            request.getRequestDispatcher("/seller/produk/edit.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        String username = (String) session.getAttribute("username");
        Penjual penjual = new Penjual().getPenjualByUsername(username);

        if (penjual == null || penjual.getNamaToko() == null || penjual.getNamaToko().trim().isEmpty()) {
            request.getRequestDispatcher("/seller/create_store.jsp").forward(request, response);
            return;
        }

        String path = request.getServletPath();
        if ("/seller/produk/tambah".equals(path)) {
            String nama = request.getParameter("nama");
            String deskripsi = request.getParameter("deskripsi");
            String kategori = request.getParameter("kategori");
            String hargaParam = request.getParameter("harga");
            String stokParam = request.getParameter("stok");
            String gambar = null;

            try {
                Part filePart = request.getPart("gambarFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String deployBasePath = request.getServletContext().getRealPath("");
                    String sourceBasePath = deployBasePath.replace(File.separator + "build" + File.separator + "web", File.separator + "web");
                    String deployPath = deployBasePath + File.separator + "sources" + File.separator + "images" + File.separator + "products";
                    String sourcePath = sourceBasePath + File.separator + "sources" + File.separator + "images" + File.separator + "products";
                    String uploadedPath = new Produk().uploadGambar(filePart, deployPath, sourcePath);
                    if (uploadedPath != null) {
                        gambar = uploadedPath;
                    } else {
                        request.setAttribute("error", "Gagal menyimpan gambar di server.");
                        request.getRequestDispatcher("/seller/produk/tambah.jsp").forward(request, response);
                        return;
                    }
                } else {
                    request.setAttribute("error", "Gambar wajib diunggah.");
                    request.getRequestDispatcher("/seller/produk/tambah.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("error", "Gagal menyimpan gambar di server.");
                request.getRequestDispatcher("/seller/produk/tambah.jsp").forward(request, response);
                return;
            }

            // Keep input values for refilling in case of error
            request.setAttribute("nama", nama);
            request.setAttribute("deskripsi", deskripsi);
            request.setAttribute("kategori", kategori);
            request.setAttribute("harga", hargaParam);
            request.setAttribute("stok", stokParam);
            request.setAttribute("gambar", gambar);

            // Simple validation
            if (nama == null || nama.trim().isEmpty() || hargaParam == null || stokParam == null) {
                request.setAttribute("error", "Nama, Harga, dan Stok wajib diisi.");
                request.getRequestDispatcher("/seller/produk/tambah.jsp").forward(request, response);
                return;
            }

            try {
                double harga = Double.parseDouble(hargaParam);
                int stok = Integer.parseInt(stokParam);

                if (harga < 0 || stok < 0) {
                    request.setAttribute("error", "Harga dan Stok tidak boleh bernilai negatif.");
                    request.getRequestDispatcher("/seller/produk/tambah.jsp").forward(request, response);
                    return;
                }

                if (kategori == null || kategori.trim().isEmpty()) {
                    kategori = "Lainnya";
                }

                Produk produk = new Produk();
                produk.setNama(nama);
                produk.setDeskripsi(deskripsi);
                produk.setKategori(kategori);
                produk.setHarga(harga);
                produk.setStok(stok);
                produk.setGambar(gambar);
                produk.setPenjualId(penjual.getId());

                produk.insert();
                response.sendRedirect(request.getContextPath() + "/seller/produk");
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Harga dan Stok harus berupa angka valid.");
                request.getRequestDispatcher("/seller/produk/tambah.jsp").forward(request, response);
            }
        } else if ("/seller/produk/edit".equals(path)) {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/seller/produk");
                return;
            }

            Produk produk = new Produk().find(idParam);
            if (produk == null) {
                response.sendRedirect(request.getContextPath() + "/seller/produk");
                return;
            }

            // Verify ownership
            if (!produk.getPenjualId().equals(penjual.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Anda tidak berhak mengedit produk ini.");
                return;
            }

            String nama = request.getParameter("nama");
            String deskripsi = request.getParameter("deskripsi");
            String kategori = request.getParameter("kategori");
            String hargaParam = request.getParameter("harga");
            String stokParam = request.getParameter("stok");
            String gambar = produk.getGambar(); // default to existing image path

            // Update temporarily for refilling form in case of validation error
            produk.setNama(nama);
            produk.setDeskripsi(deskripsi);
            produk.setKategori(kategori);
            request.setAttribute("produk", produk);

            // Simple validation
            if (nama == null || nama.trim().isEmpty() || hargaParam == null || stokParam == null) {
                request.setAttribute("error", "Nama, Harga, dan Stok wajib diisi.");
                request.getRequestDispatcher("/seller/produk/edit.jsp").forward(request, response);
                return;
            }

            try {
                double harga = Double.parseDouble(hargaParam);
                int stok = Integer.parseInt(stokParam);

                if (harga < 0 || stok < 0) {
                    request.setAttribute("error", "Harga dan Stok tidak boleh bernilai negatif.");
                    request.getRequestDispatcher("/seller/produk/edit.jsp").forward(request, response);
                    return;
                }

                if (kategori == null || kategori.trim().isEmpty()) {
                    kategori = "Lainnya";
                }

                // Handle file upload (optional for editing)
                Part filePart = request.getPart("gambarFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String deployBasePath = request.getServletContext().getRealPath("");
                    String sourceBasePath = deployBasePath.replace(File.separator + "build" + File.separator + "web", File.separator + "web");
                    String deployPath = deployBasePath + File.separator + "sources" + File.separator + "images" + File.separator + "products";
                    String sourcePath = sourceBasePath + File.separator + "sources" + File.separator + "images" + File.separator + "products";
                    String uploadedPath = new Produk().uploadGambar(filePart, deployPath, sourcePath);
                    if (uploadedPath != null) {
                        gambar = uploadedPath;
                    } else {
                        request.setAttribute("error", "Gagal menyimpan gambar di server.");
                        request.getRequestDispatcher("/seller/produk/edit.jsp").forward(request, response);
                        return;
                    }
                }

                produk.setHarga(harga);
                produk.setStok(stok);
                produk.setGambar(gambar);

                produk.update();
                response.sendRedirect(request.getContextPath() + "/seller/produk");
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Harga dan Stok harus berupa angka valid.");
                request.getRequestDispatcher("/seller/produk/edit.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "Gagal menyimpan gambar di server.");
                request.getRequestDispatcher("/seller/produk/edit.jsp").forward(request, response);
            }
        } else {
            String action = request.getParameter("action");
            if ("delete_produk".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    models.Produk p = new models.Produk().find(idParam);
                    if (p != null && p.getPenjualId().equals(penjual.getId())) {
                        String deployBasePath = request.getServletContext().getRealPath("");
                        p.deleteGambar(deployBasePath);
                        p.delete();
                    }
                }
                response.sendRedirect(request.getContextPath() + "/seller/produk");
            }
        }
    }
}
