/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Pembeli;
import models.Transaksi;

/**
 * OrderController - halaman "Pesanan Saya" (UI Reference sec. 5).
 *
 * Menampilkan seluruh transaksi milik pembeli yang sedang login, dengan filter
 * status opsional (tab: Semua, Menunggu Pembayaran, Diproses, Dikirim, Selesai).
 *
 * @author Kelompok 5
 */
@WebServlet(name = "OrderController", urlPatterns = {"/buyer/orders"})
public class OrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        String pembeliId = resolvePembeliId(session);
        ArrayList<Transaksi> pesananList = new ArrayList<>();

        if (pembeliId != null) {
            String status = request.getParameter("status");

            Transaksi model = new Transaksi();
            StringBuilder where = new StringBuilder("pembeli_id = '" + escape(pembeliId) + "'");
            if (status != null && !status.isEmpty() && !status.equalsIgnoreCase("Semua")) {
                where.append(" AND status = '").append(escape(status)).append("'");
            }
            model.where(where.toString());
            model.addQuery("ORDER BY id_transaksi DESC");
            pesananList = model.get();

            request.setAttribute("activeStatus",
                    (status == null || status.isEmpty()) ? "Semua" : status);
        } else {
            request.setAttribute("activeStatus", "Semua");
        }

        request.setAttribute("pesananList", pesananList);
        request.getRequestDispatcher("/buyer/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Ambil id pembeli dari session; bila belum ada, cari berdasarkan username.
     */
    private String resolvePembeliId(HttpSession session) {
        String pembeliId = (String) session.getAttribute("pembeli_id");
        if (pembeliId == null) {
            String username = (String) session.getAttribute("username");
            if (username != null) {
                Pembeli pembeli = new Pembeli().getPembeliByUsername(username);
                if (pembeli != null) {
                    pembeliId = pembeli.getId();
                    session.setAttribute("pembeli_id", pembeliId);
                }
            }
        }
        return pembeliId;
    }

    /**
     * Minimal escaping of single quotes for the concatenation-based query builder.
     */
    private static String escape(String value) {
        return value.replace("'", "''");
    }
}
