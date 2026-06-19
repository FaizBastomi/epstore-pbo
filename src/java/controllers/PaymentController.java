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
import models.EWallet;
import models.Payable;
import models.Transaksi;
import models.TransferBank;

/**
 * PaymentController - halaman pembayaran (DUMMY).
 *
 * Halaman pembayaran sesungguhnya (langkah-langkah pembayaran) akan dikerjakan
 * developer lain (modul Pembayaran). Untuk sementara halaman ini hanya
 * menampilkan ringkasan pesanan dan DUA tombol:
 * <ul>
 *   <li>"Pembayaran Berhasil" -&gt; {@code update_status_pembayaran(true)}
 *       (status pesanan menjadi "Diproses").</li>
 *   <li>"Menunggu Pembayaran" -&gt; {@code update_status_pembayaran(false)}.</li>
 * </ul>
 *
 * Demonstrasi Polymorphism: tombol "Pembayaran Berhasil" memanggil
 * {@link Payable#prosesBayar(double)} melalui implementasi yang dipilih sesuai
 * metode transaksi ({@link EWallet} atau {@link TransferBank}).
 *
 * @author Kelompok 5
 */
@WebServlet(name = "PaymentController", urlPatterns = {"/buyer/payment"})
public class PaymentController extends HttpServlet {

    /**
     * Tampilkan halaman pembayaran dummy untuk satu transaksi.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        Transaksi transaksi = findOwnedTransaksi(request, session);
        if (transaksi == null) {
            response.sendRedirect(request.getContextPath() + "/buyer/orders");
            return;
        }

        request.setAttribute("transaksi", transaksi);
        request.getRequestDispatcher("/buyer/payment.jsp").forward(request, response);
    }

    /**
     * Proses penekanan tombol pembayaran (dummy).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        Transaksi transaksi = findOwnedTransaksi(request, session);
        if (transaksi == null) {
            response.sendRedirect(request.getContextPath() + "/buyer/orders");
            return;
        }

        String action = request.getParameter("action");
        if ("success".equals(action)) {
            // Polymorphism: pilih implementasi Payable sesuai metode transaksi.
            Payable metodeBayar = buatMetodeBayar(transaksi.getMetode());
            boolean berhasil = metodeBayar.prosesBayar(transaksi.getTotalHarga());
            transaksi.updateStatusPembayaran(berhasil);
            session.setAttribute("orderInfo", berhasil
                    ? "Pembayaran berhasil. Pesanan kamu sedang diproses."
                    : "Pembayaran gagal diproses. Silakan coba lagi.");
        } else if ("waiting".equals(action)) {
            transaksi.updateStatusPembayaran(false);
            session.setAttribute("orderInfo",
                    "Pesanan disimpan dengan status Menunggu Pembayaran.");
        }

        // PRG -> tampilkan daftar pesanan ("Pesanan Saya").
        response.sendRedirect(request.getContextPath() + "/buyer/orders");
    }

    /**
     * Ambil transaksi berdasarkan parameter id dan pastikan milik pembeli yang
     * sedang login (mencegah akses transaksi orang lain).
     */
    private Transaksi findOwnedTransaksi(HttpServletRequest request, HttpSession session) {
        String idParam = request.getParameter("id");
        int id;
        try {
            id = Integer.parseInt(idParam == null ? "" : idParam.trim());
        } catch (NumberFormatException e) {
            return null;
        }

        Transaksi transaksi = new Transaksi().find(String.valueOf(id));
        if (transaksi == null) {
            return null;
        }

        String pembeliId = (String) session.getAttribute("pembeli_id");
        if (pembeliId != null && !pembeliId.equals(transaksi.getPembeliId())) {
            return null; // bukan milik pembeli ini
        }
        return transaksi;
    }

    /**
     * Pabrik sederhana metode pembayaran (Polymorphism via {@link Payable}).
     */
    private Payable buatMetodeBayar(String metode) {
        if (metode != null && metode.toLowerCase().contains("wallet")) {
            return new EWallet("E-Wallet", "-");
        }
        // Default & "Transfer Bank"/"COD" -> diperlakukan sebagai transfer bank.
        return new TransferBank("Bank", "-");
    }
}
