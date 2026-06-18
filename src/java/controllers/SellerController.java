package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Penjual;

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
        Penjual penjual = new models.Penjual().getPenjualByUsername(username);

        if (penjual == null || penjual.getNamaToko() == null || penjual.getNamaToko().trim().isEmpty()) {
            request.getRequestDispatcher("/seller/create_store.jsp").forward(request, response);
            return;
        }

        request.setAttribute("penjual", penjual);

        String path = request.getServletPath();
        if ("/seller/pesanan".equals(path)) {
            request.getRequestDispatcher("/seller/pesanan.jsp").forward(request, response);
        } else if ("/seller/ulasan".equals(path)) {
            request.getRequestDispatcher("/seller/ulasan.jsp").forward(request, response);
        } else if ("/seller/setting".equals(path)) {
            request.getRequestDispatcher("/seller/seller_setting.jsp").forward(request, response);
        } else {
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
                Penjual penjual = new models.Penjual();
                penjual.aturNamaToko(namaToko, username);
                response.sendRedirect(request.getContextPath() + "/seller");
            } else {
                request.setAttribute("error", "Nama toko tidak boleh kosong!");
                request.getRequestDispatcher("seller/create_store.jsp").forward(request, response);
            }
        } else if ("update_store".equals(action)) {
            String namaToko = request.getParameter("namaToko");
            if (namaToko != null && !namaToko.trim().isEmpty()) {
                Penjual penjual = new models.Penjual();
                penjual.aturNamaToko(namaToko, username);
                response.sendRedirect(request.getContextPath() + "/seller/setting?success=true");
            } else {
                request.setAttribute("error", "Nama toko tidak boleh kosong!");
                Penjual penjual = new models.Penjual().getPenjualByUsername(username);
                request.setAttribute("penjual", penjual);
                request.getRequestDispatcher("/seller/seller_setting.jsp").forward(request, response);
            }
        }
    }

}
