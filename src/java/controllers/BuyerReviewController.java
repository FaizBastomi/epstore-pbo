package controllers;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Ulasan;
import models.Produk;
import models.Transaksi;
import models.TransaksiItem;

/**
 * Controller to handle displaying buyer's reviews.
 */
@WebServlet(name = "BuyerReviewController", urlPatterns = {"/buyer/reviews"})
public class BuyerReviewController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        if (request.getParameter("add") != null) {
            String transaksiId = request.getParameter("transaksi_id");
            if (transaksiId != null) {
                Transaksi t = new Transaksi().find(transaksiId.trim());
                if (t != null) {
                    ArrayList<TransaksiItem> items = t.getDaftarItem();
                    ArrayList<Produk> produkList = new ArrayList<>();
                    for (TransaksiItem item : items) {
                        Produk p = new Produk().find(String.valueOf(item.getProdukId()));
                        if (p != null) {
                            produkList.add(p);
                        }
                    }
                    request.setAttribute("produkList", produkList);
                    request.setAttribute("transaksi_id", transaksiId);
                    request.getRequestDispatcher("add_review.jsp").forward(request, response);
                    return;
                }
            }
        }

        String username = (String) session.getAttribute("username");

        Ulasan ulasanModel = new Ulasan();
        ulasanModel.where("nama_pembeli = '" + escape(username) + "'");
        ulasanModel.addQuery("ORDER BY tanggal DESC");
        ArrayList<Ulasan> ulasanList = ulasanModel.get();

        if (ulasanList != null) {
            for (Ulasan u : ulasanList) {
                Produk p = new Produk();
                p = p.find(String.valueOf(u.getProdukId()));
                u.setProduk(p);
            }
        }

        request.setAttribute("ulasanList", ulasanList);
        request.getRequestDispatcher("reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        if (request.getParameter("add") != null) {
            String[] produkIds = request.getParameterValues("produk_ids");
            String username = (String) session.getAttribute("username");

            if (produkIds != null) {
                for (String pId : produkIds) {
                    String ratingStr = request.getParameter("rating_" + pId);
                    String komentar = request.getParameter("komentar_" + pId);

                    if (ratingStr != null) {
                        int rating = 5;
                        try {
                            rating = Integer.parseInt(ratingStr);
                        } catch (Exception e) {
                        }

                        Ulasan u = new Ulasan();
                        u.setProdukId(Integer.parseInt(pId));
                        u.setRating(rating);
                        u.setKomentar(komentar);
                        u.setNamaPembeli(username);
                        u.setTanggal(new java.sql.Date(System.currentTimeMillis()));
                        u.insert();
                    }
                }
                response.sendRedirect(request.getContextPath() + "/buyer/reviews");
                return;
            }
        }
    }

    private static String escape(String value) {
        return value.replace("'", "''");
    }
}
