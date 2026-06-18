<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="models.Produk"%>
<%@page import="models.Ulasan"%>
<%@page import="models.Keranjang"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // Render 5 stars based on rating (filled vs empty).
    String renderStars(int rating) {
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            sb.append(i <= rating ? "<i class=\"bi bi-star-fill\"></i>"
                    : "<i class=\"bi bi-star\"></i>");
        }
        return sb.toString();
    }
%>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?login");
        return;
    }
    String ctx = request.getContextPath();

    // Jumlah item keranjang (untuk badge) dari session.
    Keranjang keranjang = (Keranjang) ses.getAttribute("keranjang");
    int cartCount = (keranjang != null) ? keranjang.getTotalItem() : 0;

    Produk produk = (Produk) request.getAttribute("produk");
    if (produk == null) {
        // Accessed without going through ProductController.
        response.sendRedirect(ctx + "/buyer");
        return;
    }

    String namaToko = (String) request.getAttribute("namaToko");
    if (namaToko == null || namaToko.isEmpty()) {
        namaToko = "-";
    }

    @SuppressWarnings("unchecked")
    List<Ulasan> ulasanList = (List<Ulasan>) request.getAttribute("ulasanList");

    String nama = produk.getNama();
    String kategori = produk.getKategori();
    String deskripsi = produk.getDeskripsi();
    int stok = produk.getStok();
    String gambar = produk.getGambar();
    String hargaFmt = String.format(Locale.US, "%,.0f", produk.getHarga()).replace(',', '.');

    SimpleDateFormat sdf = new SimpleDateFormat("d MMMM yyyy", new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= nama%> - EpStore</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link href="<%= ctx%>/sources/buyer.css" rel="stylesheet">
    </head>

    <body>

        <jsp:include page="components/navbar.jsp">
            <jsp:param name="showSearch" value="false" />
        </jsp:include>

        <!-- ===================== CONTENT ===================== -->
        <main class="container py-4">

            <!-- Breadcrumb -->
            <nav class="ep-breadcrumb mb-4" aria-label="breadcrumb">
                <a href="<%= ctx%>/buyer">Home</a>
                <i class="bi bi-chevron-right"></i>
                <a href="<%= ctx%>/buyer?kategori=<%= kategori%>"><%= kategori%></a>
                <i class="bi bi-chevron-right"></i>
                <span class="current"><%= nama%></span>
            </nav>

            <div class="row g-4">
                <!-- Left: image + thumbnails -->
                <div class="col-lg-5">
                    <div class="ep-detail-img mb-3">
                        <i class="bi bi-image placeholder-icon"></i>
                        <% if (gambar != null && !gambar.isEmpty()) {%>
                        <img src="<%= ctx%>/<%= gambar%>" alt="<%= nama%>" onerror="this.remove();">
                        <% } %>
                    </div>
                    <div class="ep-thumbs">
                        <div class="ep-thumb active">
                            <i class="bi bi-image"></i>
                            <% if (gambar != null && !gambar.isEmpty()) {%>
                            <img src="<%= ctx%>/<%= gambar%>" alt="<%= nama%>" onerror="this.remove();">
                            <% }%>
                        </div>
                    </div>
                </div>

                <!-- Right: info -->
                <div class="col-lg-7">
                    <h1 class="ep-detail-name"><%= nama%></h1>
                    <p class="ep-detail-price">Rp<%= hargaFmt%></p>

                    <div class="ep-detail-meta">
                        <div class="ep-meta-row">
                            <span class="ep-meta-label">Kategori</span>
                            <span class="ep-meta-value"><%= kategori%></span>
                        </div>
                        <div class="ep-meta-row">
                            <span class="ep-meta-label">Stok</span>
                            <span class="ep-meta-value"><%= stok%></span>
                        </div>
                        <div class="ep-meta-row">
                            <span class="ep-meta-label">Penjual</span>
                            <span class="ep-meta-value"><%= namaToko%></span>
                        </div>
                    </div>

                    <div class="ep-detail-desc">
                        <span class="ep-meta-label d-block mb-1">Deskripsi</span>
                        <p class="mb-0"><%= deskripsi == null ? "" : deskripsi%></p>
                    </div>

                    <!-- Quantity + Add to cart -->
                    <form method="post" action="<%= ctx %>/buyer/cart">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="produkId" value="<%= produk.getId() %>">
                        <div class="d-flex align-items-center gap-3 my-4">
                            <span class="ep-meta-label">Jumlah</span>
                            <div class="ep-qty">
                                <button type="button" onclick="changeQty(-1)" aria-label="Kurangi">
                                    <i class="bi bi-dash"></i>
                                </button>
                                <input type="text" id="qty" name="qty" value="<%= stok > 0 ? 1 : 0 %>"
                                       data-max="<%= stok %>" readonly>
                                <button type="button" onclick="changeQty(1)" aria-label="Tambah">
                                    <i class="bi bi-plus"></i>
                                </button>
                            </div>
                        </div>

                        <button type="submit" class="ep-btn-cart ep-btn-cart-lg"
                                <%= stok == 0 ? "disabled" : "" %>>
                            <i class="bi bi-cart-plus"></i>
                            <%= stok == 0 ? "Stok Habis" : "Tambah ke Keranjang" %>
                        </button>
                    </form>
                </div>
            </div>

            <!-- ===================== REVIEWS ===================== -->
            <section class="ep-reviews mt-5">
                <h2 class="ep-section-title">Ulasan Pembeli</h2>

                <% if (ulasanList != null && !ulasanList.isEmpty()) {
                        for (Ulasan u : ulasanList) {
                            String tgl = u.getTanggal() != null ? sdf.format(u.getTanggal()) : "";
                %>
                <div class="ep-review">
                    <div class="ep-review-avatar"><i class="bi bi-person-circle"></i></div>
                    <div class="ep-review-body">
                        <div class="ep-review-head">
                            <span class="ep-review-name"><%= u.getNamaPembeli()%></span>
                            <span class="ep-stars"><%= renderStars(u.getRating())%></span>
                            <span class="ep-review-date"><%= tgl%></span>
                        </div>
                        <p class="ep-review-text"><%= u.getKomentar() == null ? "" : u.getKomentar()%></p>
                    </div>
                </div>
                <%     }
                } else { %>
                <div class="ep-empty">
                    <i class="bi bi-chat-square-text"></i>
                    Belum ada ulasan untuk produk ini.
                </div>
                <% }%>
            </section>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                function changeQty(delta) {
                                    const input = document.getElementById('qty');
                                    const max = parseInt(input.dataset.max) || 0;
                                    let val = (parseInt(input.value) || 0) + delta;
                                    if (val < 1)
                                        val = 1;
                                    if (val > max)
                                        val = max;
                                    if (max === 0)
                                        val = 0;
                                    input.value = val;
                                }
        </script>
    </body>
</html>
