<%-- 
    Document   : payment (Buyer - Halaman Pembayaran DUMMY)
    Created on : Jun 18, 2026
    Author     : Kelompok 5
    Description: Halaman pembayaran SEMENTARA (dummy). Langkah-langkah
                 pembayaran sesungguhnya dikerjakan developer modul Pembayaran.
                 Untuk sekarang hanya menampilkan ringkasan pesanan + 2 tombol:
                   - "Pembayaran Berhasil" -> status pesanan jadi "Diproses".
                   - "Menunggu Pembayaran" -> status tetap menunggu.
                 Data transaksi dikirim oleh PaymentController (attribute
                 "transaksi").
--%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="models.Transaksi"%>
<%@page import="models.TransaksiItem"%>
<%@page import="models.Keranjang"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String rp(double v) {
        return "Rp" + String.format(Locale.US, "%,.0f", v).replace(',', '.');
    }
    String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?login");
        return;
    }
    String ctx = request.getContextPath();

    Transaksi transaksi = (Transaksi) request.getAttribute("transaksi");
    if (transaksi == null) {
        response.sendRedirect(ctx + "/buyer/orders");
        return;
    }
    List<TransaksiItem> items = transaksi.getDaftarItem();

    Keranjang keranjang = (Keranjang) ses.getAttribute("keranjang");
    int cartCount = (keranjang != null) ? keranjang.getTotalItem() : 0;
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pembayaran - EpStore</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="<%= ctx %>/sources/buyer.css" rel="stylesheet">
    </head>

    <body>

        <!-- ===================== TOP NAVBAR ===================== -->
        <nav class="ep-navbar">
            <div class="container py-2">
                <div class="d-flex align-items-center justify-content-between">
                    <a href="<%= ctx %>/buyer" class="ep-brand">
                        <i class="bi bi-bag-fill"></i> EpStore
                    </a>
                    <div class="d-flex align-items-center gap-4">
                        <a href="<%= ctx %>/buyer" class="ep-nav-action">Home</a>
                        <a href="<%= ctx %>/buyer/cart" class="ep-nav-action">
                            <span class="position-relative">
                                <i class="bi bi-cart3 fs-5"></i>
                                <% if (cartCount > 0) { %>
                                <span class="ep-cart-badge"><%= cartCount %></span>
                                <% } %>
                            </span>
                            Keranjang
                        </a>
                        <a href="<%= ctx %>/buyer/orders" class="ep-nav-action">Pesanan Saya</a>
                        <a href="<%= ctx %>/buyer/reviews" class="ep-nav-action">Ulasan</a>
                        <a href="<%= ctx %>/auth?logout" class="ep-nav-action">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- ===================== CONTENT ===================== -->
        <main class="container py-4" style="max-width: 760px;">

            <h1 class="ep-page-title">Pembayaran</h1>

            <!-- Catatan: halaman pembayaran ini masih dummy -->
            <div class="alert alert-warning py-2 d-flex align-items-center gap-2">
                <i class="bi bi-info-circle"></i>
                <span>Halaman pembayaran ini masih berupa simulasi (dummy).
                    Langkah pembayaran sesungguhnya akan ditambahkan kemudian.</span>
            </div>

            <!-- Ringkasan pesanan -->
            <div class="ep-cart-card">
                <div class="ep-pay-head">
                    <div>
                        <div class="ep-pay-order-id">Order #<%= String.format("%03d", transaksi.getIdTransaksi()) %></div>
                        <div class="ep-pay-method">
                            <i class="bi bi-credit-card"></i> <%= esc(transaksi.getMetode()) %>
                        </div>
                    </div>
                    <span class="ep-status-badge ep-status-menunggu">
                        <%= esc(transaksi.getStatus()) %>
                    </span>
                </div>

                <table class="ep-cart-table mt-3">
                    <thead>
                        <tr>
                            <th>Produk</th>
                            <th class="col-harga">Harga</th>
                            <th>Jumlah</th>
                            <th class="col-subtotal">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (items != null) { for (TransaksiItem it : items) { %>
                        <tr>
                            <td class="ep-cart-cell"><%= esc(it.getNamaProduk()) %></td>
                            <td class="ep-cart-cell"><%= rp(it.getHarga()) %></td>
                            <td class="ep-cart-cell"><%= it.getQty() %></td>
                            <td class="ep-cart-cell ep-cart-subtotal"><%= rp(it.getSubtotal()) %></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>

                <div class="ep-cart-total-row">
                    <span class="ep-cart-total-label">Total Pembayaran</span>
                    <span class="ep-cart-total-value"><%= rp(transaksi.getTotalHarga()) %></span>
                </div>
            </div>

            <!-- ===================== TOMBOL PEMBAYARAN (DUMMY) ===================== -->
            <div class="ep-cart-card">
                <h2 class="ep-section-title">Konfirmasi Pembayaran</h2>
                <p class="text-muted mb-3" style="font-size:.9rem;">
                    Pilih salah satu untuk mensimulasikan hasil pembayaran:
                </p>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <form method="post" action="<%= ctx %>/buyer/payment">
                            <input type="hidden" name="id" value="<%= transaksi.getIdTransaksi() %>">
                            <input type="hidden" name="action" value="success">
                            <button type="submit" class="ep-btn-pay-success w-100">
                                <i class="bi bi-check-circle"></i> Pembayaran Berhasil
                            </button>
                        </form>
                    </div>
                    <div class="col-sm-6">
                        <form method="post" action="<%= ctx %>/buyer/payment">
                            <input type="hidden" name="id" value="<%= transaksi.getIdTransaksi() %>">
                            <input type="hidden" name="action" value="waiting">
                            <button type="submit" class="ep-btn-pay-wait w-100">
                                <i class="bi bi-hourglass-split"></i> Menunggu Pembayaran
                            </button>
                        </form>
                    </div>
                </div>
            </div>

        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
