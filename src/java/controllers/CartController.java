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
import models.BarangKeranjang;
import models.Keranjang;
import models.Produk;

/**
 * CartController - mengelola keranjang belanja pembeli (UI Reference sec. 4).
 *
 * Keranjang disimpan pada {@link HttpSession} (data sementara, sesuai deskripsi
 * "wadah penampung barang sementara" pada dokumen desain). Aksi yang didukung
 * melalui parameter "action": add, inc, dec, update, remove, clear, checkout.
 *
 * Pola Post-Redirect-Get (PRG) digunakan agar refresh halaman tidak mengirim
 * ulang aksi yang sama.
 *
 * @author Kelompok 5
 */
@WebServlet(name = "CartController", urlPatterns = {"/buyer/cart"})
public class CartController extends HttpServlet {

    /** Kunci atribut session tempat keranjang disimpan. */
    public static final String CART_SESSION_KEY = "keranjang";

    /**
     * Ambil keranjang dari session, buat baru bila belum ada.
     */
    private Keranjang getCart(HttpSession session) {
        Keranjang cart = (Keranjang) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new Keranjang();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }

    /**
     * Handles the HTTP <code>GET</code> method: menampilkan halaman keranjang.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        getCart(session); // pastikan keranjang ada di session
        request.getRequestDispatcher("/buyer/cart.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method: memproses aksi keranjang.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return;
        }

        Keranjang cart = getCart(session);
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "add":
                handleAdd(request, cart);
                break;
            case "inc":
                handleDelta(request, cart, 1);
                break;
            case "dec":
                handleDelta(request, cart, -1);
                break;
            case "update":
                handleUpdate(request, cart);
                break;
            case "remove":
                handleRemove(request, cart);
                break;
            case "clear":
                cart.kosongkanKeranjang();
                break;
            case "checkout":
                // Finalisasi checkout (pembuatan Transaksi & pembayaran) merupakan
                // tanggung jawab modul Transaksi/Pembayaran (lihat DesignDoc bagian D,
                // PIC berbeda) sehingga di luar lingkup fitur keranjang ini.
                session.setAttribute("cartInfo",
                        "Fitur checkout akan tersedia setelah modul Transaksi & Pembayaran selesai.");
                break;
            default:
                break;
        }

        // PRG: redirect kembali ke halaman keranjang.
        response.sendRedirect(request.getContextPath() + "/buyer/cart");
    }

    /**
     * Tambah produk ke keranjang. Kuantitas dibatasi maksimal sebesar stok.
     */
    private void handleAdd(HttpServletRequest request, Keranjang cart) {
        Integer produkId = parseInt(request.getParameter("produkId"));
        int qty = parseIntOrDefault(request.getParameter("qty"), 1);
        if (produkId == null || qty < 1) {
            return;
        }

        Produk produk = new Produk().find(String.valueOf(produkId));
        if (produk == null || produk.getStok() <= 0) {
            return;
        }

        // Batasi total kuantitas (yang sudah ada + yang baru) sesuai stok.
        BarangKeranjang existing = cart.getItem(produkId);
        int sudahAda = (existing != null) ? existing.getQty() : 0;
        if (sudahAda + qty > produk.getStok()) {
            qty = produk.getStok() - sudahAda;
        }
        if (qty < 1) {
            return; // sudah mencapai batas stok
        }

        cart.tambahItem(new BarangKeranjang(produk, qty));
    }

    /**
     * Naikkan/turunkan kuantitas satu item (untuk tombol +/-).
     * Dibatasi minimal 1 dan maksimal stok produk.
     */
    private void handleDelta(HttpServletRequest request, Keranjang cart, int delta) {
        Integer produkId = parseInt(request.getParameter("produkId"));
        if (produkId == null) {
            return;
        }
        BarangKeranjang item = cart.getItem(produkId);
        if (item == null) {
            return;
        }
        int newQty = item.getQty() + delta;
        if (newQty < 1) {
            newQty = 1;
        }
        int stok = (item.getProduk() != null) ? item.getProduk().getStok() : newQty;
        if (stok > 0 && newQty > stok) {
            newQty = stok;
        }
        cart.ubahQty(produkId, newQty);
    }

    /**
     * Set kuantitas item secara langsung. Qty &lt; 1 berarti hapus item.
     */
    private void handleUpdate(HttpServletRequest request, Keranjang cart) {
        Integer produkId = parseInt(request.getParameter("produkId"));
        Integer qty = parseInt(request.getParameter("qty"));
        if (produkId == null || qty == null) {
            return;
        }
        if (qty < 1) {
            cart.hapusItem(produkId);
        } else {
            cart.ubahQty(produkId, qty);
        }
    }

    /**
     * Hapus satu item dari keranjang.
     */
    private void handleRemove(HttpServletRequest request, Keranjang cart) {
        Integer produkId = parseInt(request.getParameter("produkId"));
        if (produkId != null) {
            cart.hapusItem(produkId);
        }
    }

    private static Integer parseInt(String s) {
        if (s == null) {
            return null;
        }
        try {
            return Integer.valueOf(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static int parseIntOrDefault(String s, int def) {
        Integer v = parseInt(s);
        return v == null ? def : v;
    }
}
