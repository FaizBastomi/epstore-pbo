package controllers;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Penjual;
import models.Produk;
import models.Ulasan;

@WebServlet(name = "ProductController", urlPatterns = { "/produk" })
public class ProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // Validate id as integer (also prevents SQL injection on the lookup).
        int produkId;
        try {
            produkId = Integer.parseInt(idParam == null ? "" : idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/buyer");
            return;
        }

        Produk produk = new Produk().find(String.valueOf(produkId));
        if (produk == null) {
            response.sendRedirect(request.getContextPath() + "/buyer");
            return;
        }

        // Seller name (composition Penjual -> Produk).
        String namaToko = null;
        String penjualId = produk.getPenjualId();
        if (penjualId != null && !penjualId.isEmpty()) {
            Penjual penjual = (Penjual) new Penjual().find(penjualId);
            if (penjual != null) {
                namaToko = penjual.getNamaToko();
            }
        }

        // Reviews for this product.
        Ulasan ulasanModel = new Ulasan();
        ulasanModel.where("produk_id = '" + produkId + "'");
        ulasanModel.addQuery("ORDER BY tanggal DESC, id DESC");
        ArrayList<Ulasan> ulasanList = ulasanModel.get();

        request.setAttribute("produk", produk);
        request.setAttribute("namaToko", namaToko);
        request.setAttribute("ulasanList", ulasanList);

        request.getRequestDispatcher("buyer/product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
