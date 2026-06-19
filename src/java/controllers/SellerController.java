package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import models.Pembeli;
import models.Penjual;
import models.Produk;
import models.Transaksi;
import models.Ulasan;

@WebServlet(name = "SellerController", urlPatterns = {"/seller", "/seller/pesanan", "/seller/ulasan", "/seller/setting"})
public class SellerController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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

        request.setAttribute("penjual", penjual);

        String path = request.getServletPath();
        if ("/seller/pesanan".equals(path)) {
            String stat = request.getParameter("status");
            Transaksi t = new Transaksi();
            t.select("transaksi.*");
            t.join("transaksi_item", "transaksi.id = transaksi_item.transaksi_id");
            t.join("produk", "transaksi_item.produk_id = produk.id");
            String cond = "produk.penjual_id = '" + penjual.getId() + "'";
            if (stat != null && !stat.isEmpty() && !"Semua".equals(stat)) {
                String dbStatus = "Baru".equals(stat) ? "Dibayar" : stat;
                cond += " AND transaksi.status = '" + dbStatus.replace("'", "''") + "'";
            }
            t.where(cond);
            t.addQuery("GROUP BY transaksi.id ORDER BY transaksi.tanggal DESC");
            ArrayList<Transaksi> orders = t.get();
            Map<String, String> buyerNames = new HashMap<>();
            for (Transaksi o : orders) {
                if (!buyerNames.containsKey(o.getPembeliId())) {
                    Pembeli p = (Pembeli) new Pembeli().find(o.getPembeliId());
                    buyerNames.put(o.getPembeliId(), p != null ? p.getUsername() : o.getPembeliId());
                }
            }
            request.setAttribute("orders", orders);
            request.setAttribute("buyerNames", buyerNames);
            request.setAttribute("activeStatus", stat != null ? stat : "Semua");
            request.getRequestDispatcher("/seller/pesanan.jsp").forward(request, response);
        } else if ("/seller/ulasan".equals(path)) {
            int pageParam = 1;
            try { if (request.getParameter("page") != null) pageParam = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
            Ulasan u = new Ulasan();
            u.select("ulasan.*");
            u.join("produk", "ulasan.produk_id = produk.id");
            u.where("produk.penjual_id = '" + penjual.getId() + "' ORDER BY ulasan.tanggal DESC LIMIT 10 OFFSET " + ((pageParam - 1) * 10));
            ArrayList<Ulasan> reviews = u.get();
            for (Ulasan rev : reviews) rev.setProduk((Produk) new Produk().find(String.valueOf(rev.getProdukId())));
            
            request.setAttribute("reviews", reviews);
            request.setAttribute("currentPage", pageParam);
            request.setAttribute("hasNext", reviews.size() == 10);
            request.getRequestDispatcher("/seller/ulasan.jsp").forward(request, response);
        } else if ("/seller/setting".equals(path)) {
            request.getRequestDispatcher("/seller/seller_setting.jsp").forward(request, response);
        } else {
            Transaksi t = new Transaksi();
            t.select("transaksi.*");
            t.join("transaksi_item", "transaksi.id = transaksi_item.transaksi_id");
            t.join("produk", "transaksi_item.produk_id = produk.id");
            t.where("produk.penjual_id = '" + penjual.getId() + "'");
            t.addQuery("GROUP BY transaksi.id ORDER BY transaksi.tanggal DESC LIMIT 5");
            ArrayList<Transaksi> orders = t.get();
            Map<String, String> buyerNames = new HashMap<>();
            for (Transaksi o : orders) {
                if (!buyerNames.containsKey(o.getPembeliId())) {
                    Pembeli p = (Pembeli) new Pembeli().find(o.getPembeliId());
                    buyerNames.put(o.getPembeliId(), p != null ? p.getUsername() : o.getPembeliId());
                }
            }
            request.setAttribute("recentOrders", orders);
            request.setAttribute("buyerNames", buyerNames);
            request.getRequestDispatcher("/seller/index.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        String username = (String) session.getAttribute("username");
        String action = request.getParameter("action");

        if ("create_store".equals(action)) {
            String namaToko = request.getParameter("namaToko");
            if (namaToko != null && !namaToko.trim().isEmpty()) {
                Penjual penjual = new Penjual();
                penjual.aturNamaToko(namaToko, username);
                response.sendRedirect(request.getContextPath() + "/seller");
            } else {
                request.setAttribute("error", "Nama toko tidak boleh kosong!");
                request.getRequestDispatcher("seller/create_store.jsp").forward(request, response);
            }
        } else if ("update_store".equals(action)) {
            String namaToko = request.getParameter("namaToko");
            if (namaToko != null && !namaToko.trim().isEmpty()) {
                Penjual penjual = new Penjual();
                penjual.aturNamaToko(namaToko, username);
                response.sendRedirect(request.getContextPath() + "/seller/setting?success=true");
            } else {
                request.setAttribute("error", "Nama toko tidak boleh kosong!");
                Penjual penjual = new Penjual().getPenjualByUsername(username);
                request.setAttribute("penjual", penjual);
                request.getRequestDispatcher("/seller/seller_setting.jsp").forward(request, response);
            }
        } else if ("update_status".equals(action)) {
            String id = request.getParameter("id");
            String status = request.getParameter("status");
            if (id != null && status != null) {
                Transaksi t = new Transaksi().find(id);
                if (t != null) {
                    if ("Diproses".equals(status) && !"Diproses".equals(t.getStatus())) {
                        t.kurangiStok();
                    }
                    t.updateStatus(status);
                }
            }
            response.sendRedirect(request.getContextPath() + "/seller/pesanan");
            return;
        } else if ("reply_ulasan".equals(action)) {
            String id = request.getParameter("ulasanId");
            String reply = request.getParameter("replyText");
            if (id != null && reply != null && !reply.trim().isEmpty()) {
                Ulasan u = new Ulasan().find(id);
                if (u != null) {
                    u.setSellerReply(reply.trim());
                    u.update(); // ponytail: native ORM update
                }
            }
            String pageParam = request.getParameter("page");
            response.sendRedirect(request.getContextPath() + "/seller/ulasan" + (pageParam != null ? "?page=" + pageParam : ""));
            return;
        }
    }

}
