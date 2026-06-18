/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Pembeli;

/**
 *
 * @author voliya
 */
@WebServlet(name = "AuthController", urlPatterns = {"/auth"})
public class AuthController extends HttpServlet {

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
        if (request.getParameter("logout") != null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/auth?login");
        } else if (request.getParameter("login") != null) {
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else if (request.getParameter("registration") != null) {
            request.getRequestDispatcher("register_form.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing login or register parameter");
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
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();
        Pembeli pembeli = new Pembeli();

        if (request.getParameter("register") != null) {
            if (pembeli.isUsernameExists(username)) {
                request.setAttribute("error", "Username sudah digunakan, silakan pilih yang lain");
                request.getRequestDispatcher("register_form.jsp").forward(request, response);
                return;
            }

            String email = request.getParameter("email");
            pembeli.daftarAkun(username, password, email);
            request.setAttribute("success", "Registrasi berhasil");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {
            // Login
            if (pembeli.masukAkun(username, password)) {
                // Fetch the full pembeli data to get the email
                Pembeli fullPembeliData = pembeli.getPembeliByUsername(username);

                session.setAttribute("username", username);
                session.setAttribute("email", fullPembeliData != null ? fullPembeliData.getEmail() : null);
                session.setAttribute("pembeli_id", fullPembeliData != null ? fullPembeliData.getId() : null);
                response.sendRedirect(request.getContextPath() + "/");
            } else {
                request.setAttribute("error", "Username atau password salah");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        }
    }

}
