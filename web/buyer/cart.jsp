<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="models.Keranjang"%>
<%@page import="models.BarangKeranjang"%>
<%@page import="models.Produk"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // Format angka -> "Rp150.000"
    String rp(double v) {
        return "Rp" + String.format(Locale.US, "%,.0f", v).replace(',', '.');
    }

    String esc(String s) {
        if (s == null) {
            return "";
        }
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

    Keranjang keranjang = (Keranjang) ses.getAttribute("keranjang");
    if (keranjang == null) {
        keranjang = new Keranjang();
        ses.setAttribute("keranjang", keranjang);
    }
    List<BarangKeranjang> items = keranjang.getDaftarItem();
    double total = keranjang.getTotalHarga();

    // Pesan info (mis. dari aksi checkout yang belum tersedia).
    String info = (String) ses.getAttribute("cartInfo");
    if (info != null) {
        ses.removeAttribute("cartInfo");
    }
    String error = (String) ses.getAttribute("error");
    if (error != null) {
        ses.removeAttribute("error");
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Keranjang Belanja - EpStore</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="<%= ctx%>/sources/buyer.css" rel="stylesheet">
    </head>

    <body>

        <jsp:include page="components/navbar.jsp">
            <jsp:param name="showSearch" value="false" />
        </jsp:include>

        <!-- ===================== CONTENT ===================== -->
        <main class="container py-4">

            <h1 class="ep-page-title">Keranjang Belanja</h1>

            <% if (info != null) {%>
            <div class="alert alert-info py-2"><%= esc(info)%></div>
            <% } %>
            <% if (error != null) {%>
            <div class="alert alert-danger py-2"><%= esc(error)%></div>
            <% } %>

            <% if (items == null || items.isEmpty()) {%>
            <!-- Empty state -->
            <div class="ep-cart-card">
                <div class="ep-empty">
                    <i class="bi bi-cart-x"></i>
                    Keranjang belanja kamu masih kosong.
                    <div class="mt-3">
                        <a href="<%= ctx%>/buyer" class="ep-btn-shop">
                            <i class="bi bi-bag"></i> Mulai Belanja
                        </a>
                    </div>
                </div>
            </div>
            <% } else { %>

            <!-- ===================== CART TABLE ===================== -->
            <div class="ep-cart-card">
                <div class="table-responsive">
                    <table class="ep-cart-table">
                        <thead>
                            <tr>
                                <th class="col-produk">Produk</th>
                                <th class="col-harga">Harga</th>
                                <th class="col-jumlah">Jumlah</th>
                                <th class="col-subtotal">Subtotal</th>
                                <th class="col-aksi">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (BarangKeranjang item : items) {
                                    Produk p = item.getProduk();
                                    int pid = p.getId();
                                    String nama = p.getNama();
                                    String gambar = p.getGambar();
                                    int qty = item.getQty();
                            %>
                            <tr>
                                <!-- Produk -->
                                <td>
                                    <div class="ep-cart-product">
                                        <a href="<%= ctx%>/produk?id=<%= pid%>" class="ep-cart-thumb">
                                            <i class="bi bi-image"></i>
                                            <% if (gambar != null && !gambar.isEmpty()) {%>
                                            <img src="<%= ctx%>/<%= esc(gambar)%>" alt="<%= esc(nama)%>"
                                                 onerror="this.remove();">
                                            <% }%>
                                        </a>
                                        <a href="<%= ctx%>/produk?id=<%= pid%>" class="ep-cart-name">
                                            <%= esc(nama)%>
                                        </a>
                                    </div>
                                </td>
                                <!-- Harga -->
                                <td class="ep-cart-cell"><%= rp(p.getHarga())%></td>
                                <!-- Jumlah -->
                                <td>
                                    <div class="ep-qty">
                                        <form method="post" action="<%= ctx%>/buyer/cart?dec" class="ep-qty-form">
                                            <input type="hidden" name="produkId" value="<%= pid%>">
                                            <button type="submit" aria-label="Kurangi"><i class="bi bi-dash"></i></button>
                                        </form>
                                        <span class="ep-qty-val"><%= qty%></span>
                                        <form method="post" action="<%= ctx%>/buyer/cart?inc" class="ep-qty-form">
                                            <input type="hidden" name="produkId" value="<%= pid%>">
                                            <button type="submit" aria-label="Tambah"><i class="bi bi-plus"></i></button>
                                        </form>
                                    </div>
                                </td>
                                <!-- Subtotal -->
                                <td class="ep-cart-cell ep-cart-subtotal"><%= rp(item.getSubtotal())%></td>
                                <!-- Aksi -->
                                <td>
                                    <form method="post" action="<%= ctx%>/buyer/cart?remove">
                                        <input type="hidden" name="produkId" value="<%= pid%>">
                                        <button type="submit" class="ep-btn-trash" aria-label="Hapus"
                                                title="Hapus dari keranjang">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>

                <!-- Total ringkas -->
                <div class="ep-cart-total-row">
                    <span class="ep-cart-total-label">Total</span>
                    <span class="ep-cart-total-value"><%= rp(total)%></span>
                </div>
            </div>

            <!-- ===================== PAYMENT + CHECKOUT ===================== -->
            <form method="post" action="<%= ctx%>/buyer/checkout">
                <div class="row g-4 mt-1">
                    <!-- Metode Pembayaran -->
                    <div class="col-lg-7">
                        <div class="ep-cart-card h-100">
                            <h2 class="ep-section-title">Metode Pembayaran</h2>
                            <div class="ep-pay-option">
                                <input class="form-check-input" type="radio" name="metode"
                                       id="payTransfer" value="Transfer Bank" checked>
                                <label class="form-check-label" for="payTransfer">Transfer Bank</label>
                            </div>
                            <div class="ep-pay-option">
                                <input class="form-check-input" type="radio" name="metode"
                                       id="payEwallet" value="E-Wallet">
                                <label class="form-check-label" for="payEwallet">E-Wallet</label>
                            </div>
                            <div class="ep-pay-option">
                                <input class="form-check-input" type="radio" name="metode"
                                       id="payCod" value="COD">
                                <label class="form-check-label" for="payCod">COD (Bayar di Tempat)</label>
                            </div>
                        </div>
                    </div>

                    <!-- Ringkasan Pembayaran -->
                    <div class="col-lg-5">
                        <div class="ep-summary-card">
                            <div class="ep-summary-row">
                                <span>Total Pembayaran</span>
                                <span class="ep-summary-total"><%= rp(total)%></span>
                            </div>
                            <button type="submit" class="ep-btn-checkout">Checkout</button>
                        </div>
                    </div>
                </div>
            </form>
            <% }%>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
