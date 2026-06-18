package controllers;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Produk;

@WebServlet(name = "PembeliController", urlPatterns = {"/buyer"})
public class BuyerController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * Loads the product catalog from the database, applying optional
     * category ("kategori") and search keyword ("q") filters, then forwards
     * the result to the buyer home page.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String kategori = request.getParameter("kategori");
        String keyword = request.getParameter("q");

        Produk produkModel = new Produk();

        // Build WHERE conditions. NOTE: the base Model uses string concatenation,
        // so values are escaped minimally here to avoid breaking the query.
        ArrayList<String> conditions = new ArrayList<>();
        if (kategori != null && !kategori.isEmpty() && !kategori.equalsIgnoreCase("Semua")) {
            conditions.add("kategori = '" + escape(kategori) + "'");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            conditions.add("nama LIKE '%" + escape(keyword.trim()) + "%'");
        }
        if (!conditions.isEmpty()) {
            produkModel.where(String.join(" AND ", conditions));
        }
        produkModel.addQuery("ORDER BY id ASC");

        ArrayList<Produk> produkList = produkModel.get();

        request.setAttribute("produkList", produkList);
        request.setAttribute("activeKategori",
                (kategori == null || kategori.isEmpty()) ? "Semua" : kategori);
        request.setAttribute("keyword", keyword == null ? "" : keyword);

        request.getRequestDispatcher("buyer/index.jsp").forward(request, response);
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
    }

    /**
     * Minimal escaping of single quotes for the concatenation-based query builder.
     */
    private static String escape(String value) {
        return value.replace("'", "''");
    }

}
