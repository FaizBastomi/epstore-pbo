<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="models.Produk"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?login");
        return;
    }
    String ctx = request.getContextPath();
    @SuppressWarnings("unchecked")
    List<Produk> produkList = (List<Produk>) request.getAttribute("produkList");

    String activeKategori = (String) request.getAttribute("activeKategori");
    if (activeKategori == null || activeKategori.isEmpty()) {
        activeKategori = "Semua";
    }
    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) {
        keyword = "";
    }

    String[] kategoriList = {"Semua", "Elektronik", "Fashion", "Makanan", "Kecantikan", "Lainnya"};
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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <!-- Buyer theme -->
        <link href="<%= ctx%>/sources/buyer.css" rel="stylesheet">
    </head>

    <body>

        <jsp:include page="components/navbar.jsp">
            <jsp:param name="showSearch" value="true" />
            <jsp:param name="keyword" value="<%= keyword%>" />
        </jsp:include>

        <!-- ===================== SECONDARY MENU ===================== -->
        <div class="ep-submenu">
            <div class="container">
                <div class="d-flex gap-4">
                    <a href="<%= ctx%>/buyer" class="active">Home</a>
                    <a href="<%= ctx%>/buyer#kategori">Kategori</a>
                    <a href="<%= ctx%>/buyer/orders">Pesanan Saya</a>
                    <a href="<%= ctx%>/buyer/reviews">Ulasan</a>
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
                <a href="<%= href%>" class="ep-chip <%= isActive ? "active" : ""%>"><%= kat%></a>
                <% } %>
            </div>

            <!-- Product grid -->
            <div class="row g-3 g-md-4">
                <%
                    if (produkList != null && !produkList.isEmpty()) {
                        for (Produk p : produkList) {
                            int id = p.getId();
                            String nama = p.getNama();
                            int stok = p.getStok();
                            String gambar = p.getGambar();
                            String hargaFmt = String.format(Locale.US, "%,.0f", p.getHarga())
                                    .replace(',', '.');
                            String detailUrl = ctx + "/produk?id=" + id;
                %>
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="ep-product">
                        <a href="<%= detailUrl%>" class="ep-product-img">
                            <i class="bi bi-image placeholder-icon"></i>
                            <% if (gambar != null && !gambar.isEmpty()) {%>
                            <img src="<%= ctx%>/<%= gambar%>" alt="<%= nama%>"
                                 onerror="this.remove();">
                            <% }%>
                        </a>
                        <div class="ep-product-body">
                            <a href="<%= detailUrl%>" class="ep-product-name-link">
                                <p class="ep-product-name"><%= nama%></p>
                            </a>
                            <p class="ep-product-price">Rp<%= hargaFmt%></p>
                            <p class="ep-product-stock">Stok: <%= stok%></p>
                            <form method="post" action="<%= ctx%>/buyer/cart" class="ep-cart-add-form">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="produkId" value="<%= id%>">
                                <input type="hidden" name="qty" value="1">
                                <button type="submit" class="ep-btn-cart" <%= stok == 0 ? "disabled" : ""%>>
                                    <i class="bi bi-cart-plus"></i>
                                    <%= stok == 0 ? "Stok Habis" : "Tambah ke Keranjang"%>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <%      }
                } else { %>
                <div class="col-12">
                    <div class="ep-empty">
                        <i class="bi bi-search"></i>
                        Produk tidak ditemukan.
                    </div>
                </div>
                <% }%>
            </div>
        </main>

        <!-- Bootstrap Bundle JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
