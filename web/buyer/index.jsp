<%-- 
    Document   : index (Buyer Home / Katalog Produk)
    Created on : Jun 17, 2026
    Author     : Kelompok 5
    Description: Halaman utama pembeli - katalog produk (UI Reference sec. 2)
--%>
<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?login");
        return;
    }
    String ctx = request.getContextPath();

    // -------------------------------------------------------------------
    // FRONT-END ONLY: sample data so the catalog renders standalone.
    // TODO (backend): replace this with products fetched in BuyerController
    //   e.g. request.getAttribute("produkList") populated from Produk model,
    //   then iterate over the real list below.
    // Columns: nama, kategori, harga, stok
    // -------------------------------------------------------------------
    String[][] produkList = {
        {"Headphone Wireless", "Elektronik", "150000", "15"},
        {"Tas Ransel Pria",    "Fashion",    "120000", "8"},
        {"Sneakers Casual",    "Fashion",    "200000", "12"},
        {"Jam Tangan Digital", "Elektronik", "85000",  "20"},
        {"Power Bank 10000mAh","Elektronik", "95000",  "14"},
        {"Mie Instan Kuah",    "Makanan",    "3000",   "50"}
    };

    String[] kategoriList = {"Semua", "Elektronik", "Fashion", "Makanan", "Kecantikan", "Lainnya"};
    String activeKategori = request.getParameter("kategori");
    if (activeKategori == null || activeKategori.isEmpty()) {
        activeKategori = "Semua";
    }
    String keyword = request.getParameter("q");
    if (keyword == null) {
        keyword = "";
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Beranda - EpStore</title>

        <!-- Google Fonts (Plus Jakarta Sans) -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <!-- Buyer theme -->
        <link href="<%= ctx %>/sources/buyer.css" rel="stylesheet">
    </head>

    <body>

        <!-- ===================== TOP NAVBAR ===================== -->
        <nav class="ep-navbar">
            <div class="container py-2">
                <div class="row align-items-center g-2">
                    <!-- Brand -->
                    <div class="col-auto">
                        <a href="<%= ctx %>/buyer" class="ep-brand">
                            <i class="bi bi-bag-fill"></i> EpStore
                        </a>
                    </div>

                    <!-- Search -->
                    <div class="col">
                        <form class="ep-search" action="<%= ctx %>/buyer" method="GET">
                            <div class="input-group">
                                <input type="text" name="q" class="form-control"
                                       placeholder="Cari produk..."
                                       value="<%= keyword.replace("\"", "&quot;") %>">
                                <button class="btn" type="submit" aria-label="Cari">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Actions -->
                    <div class="col-auto">
                        <div class="d-flex align-items-center gap-4">
                            <a href="<%= ctx %>/buyer/cart" class="ep-nav-action">
                                <span class="position-relative">
                                    <i class="bi bi-cart3 fs-5"></i>
                                    <span class="ep-cart-badge">0</span>
                                </span>
                                Keranjang
                            </a>
                            <a href="<%= ctx %>/auth?logout" class="ep-nav-action">
                                <i class="bi bi-box-arrow-right"></i> Logout
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <!-- ===================== SECONDARY MENU ===================== -->
        <div class="ep-submenu">
            <div class="container">
                <div class="d-flex gap-4">
                    <a href="<%= ctx %>/buyer" class="active">Home</a>
                    <a href="<%= ctx %>/buyer#kategori">Kategori</a>
                    <a href="<%= ctx %>/buyer/orders">Pesanan Saya</a>
                    <a href="<%= ctx %>/buyer/reviews">Ulasan</a>
                </div>
            </div>
        </div>

        <!-- ===================== CONTENT ===================== -->
        <main class="container py-4">

            <!-- Category filter -->
            <div class="ep-categories mb-4" id="kategori">
                <% for (String kat : kategoriList) {
                       boolean isActive = kat.equals(activeKategori);
                       String href = ctx + "/buyer?kategori=" + kat
                               + (keyword.isEmpty() ? "" : "&q=" + keyword);
                %>
                <a href="<%= href %>" class="ep-chip <%= isActive ? "active" : "" %>"><%= kat %></a>
                <% } %>
            </div>

            <!-- Product grid -->
            <div class="row g-3 g-md-4">
                <%
                    int shown = 0;
                    for (String[] p : produkList) {
                        String nama = p[0];
                        String kategori = p[1];
                        long harga = Long.parseLong(p[2]);
                        int stok = Integer.parseInt(p[3]);

                        // client-side-equivalent filtering (front-end demo)
                        boolean matchKat = activeKategori.equals("Semua") || activeKategori.equals(kategori);
                        boolean matchKey = keyword.isEmpty()
                                || nama.toLowerCase().contains(keyword.toLowerCase());
                        if (!matchKat || !matchKey) {
                            continue;
                        }
                        shown++;

                        String hargaFmt = String.format("%,d", harga).replace(',', '.');
                %>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="ep-product">
                        <div class="ep-product-img">
                            <%-- TODO(backend): use <img src="..."> when product images exist --%>
                            <i class="bi bi-image placeholder-icon"></i>
                        </div>
                        <div class="ep-product-body">
                            <p class="ep-product-name"><%= nama %></p>
                            <p class="ep-product-price">Rp<%= hargaFmt %></p>
                            <p class="ep-product-stock">Stok: <%= stok %></p>
                            <button type="button" class="ep-btn-cart" <%= stok == 0 ? "disabled" : "" %>>
                                <i class="bi bi-cart-plus"></i>
                                <%= stok == 0 ? "Stok Habis" : "Tambah ke Keranjang" %>
                            </button>
                        </div>
                    </div>
                </div>
                <% } %>

                <% if (shown == 0) { %>
                <div class="col-12">
                    <div class="ep-empty">
                        <i class="bi bi-search"></i>
                        Produk tidak ditemukan.
                    </div>
                </div>
                <% } %>
            </div>
        </main>

        <!-- Bootstrap Bundle JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
