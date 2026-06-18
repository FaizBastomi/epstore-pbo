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
 * Controller to handle buyer account settings.
 */
@WebServlet(name = "UserSettingController", urlPatterns = {"/buyer/setting"})
public class UserSettingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        String username = (String) session.getAttribute("username");
        Pembeli p = new Pembeli().getPembeliByUsername(username);

        request.setAttribute("pembeli", p);
        request.getRequestDispatcher("user_setting.jsp").forward(request, response);
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
        String alamat = request.getParameter("alamat");
        String nomorTelp = request.getParameter("nomor_telp");

        if (alamat == null || alamat.trim().isEmpty()) {
            request.setAttribute("error", "Alamat wajib diisi.");
            Pembeli p = new Pembeli().getPembeliByUsername(username);
            request.setAttribute("pembeli", p);
            request.getRequestDispatcher("user_setting.jsp").forward(request, response);
            return;
        }

        Pembeli p = new Pembeli().getPembeliByUsername(username);
        if (p != null) {
            p.updateProfil(alamat.trim(), nomorTelp != null ? nomorTelp.trim() : "");
            request.setAttribute("success", "Profil berhasil diperbarui.");
        } else {
            request.setAttribute("error", "Gagal memperbarui profil.");
        }

        // Fetch again to display updated data
        p = new Pembeli().getPembeliByUsername(username);
        request.setAttribute("pembeli", p);
        request.getRequestDispatcher("/buyer/user_setting.jsp").forward(request, response);
    }
}
