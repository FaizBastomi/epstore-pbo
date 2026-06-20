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
        String newUsername = request.getParameter("username");
        String password = request.getParameter("password");
        String alamat = request.getParameter("alamat");
        String nomorTelp = request.getParameter("nomor_telp");

        Pembeli p = new Pembeli().getPembeliByUsername(username);

        if (alamat == null || alamat.trim().isEmpty()) {
            request.setAttribute("error", "Alamat wajib diisi.");
            request.setAttribute("pembeli", p);
            request.getRequestDispatcher("user_setting.jsp").forward(request, response);
            return;
        }

        if (p != null) {
            boolean relogin = false;
            if (newUsername != null && !newUsername.trim().isEmpty() && !newUsername.equals(username)) {
                if (p.isUsernameExists(newUsername)) {
                    request.setAttribute("error", "Username sudah terpakai.");
                    request.setAttribute("pembeli", p);
                    request.getRequestDispatcher("user_setting.jsp").forward(request, response);
                    return;
                }
                p.editUsername(username, newUsername.trim());
                relogin = true;
            }
            if (password != null && !password.isEmpty()) {
                p.gantiPassword(password);
                relogin = true;
            }

            p.updateProfil(alamat.trim(), nomorTelp != null ? nomorTelp.trim() : "");
            
            if (relogin) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/auth?login");
                return;
            }

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
