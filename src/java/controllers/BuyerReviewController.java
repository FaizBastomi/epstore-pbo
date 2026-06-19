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

    private static String escape(String value) {
        return value.replace("'", "''");
    }
}
