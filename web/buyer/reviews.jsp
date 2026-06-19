<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="models.Ulasan"%>
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
    List<Ulasan> reviewList = (List<Ulasan>) request.getAttribute("ulasanList");

    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ulasan Saya - EpStore</title>
        <!-- Google Fonts -->
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
            <jsp:param name="showSearch" value="false" />
        </jsp:include>

        <!-- SECONDARY MENU -->
        <div class="ep-submenu">
            <div class="container">
                <div class="d-flex gap-4">
                    <a href="<%= ctx%>/buyer">Home</a>
                    <a href="<%= ctx%>/buyer#kategori">Kategori</a>
                    <a href="<%= ctx%>/buyer/orders">Pesanan Saya</a>
                    <a href="<%= ctx%>/buyer/reviews" class="active">Ulasan</a>
                </div>
            </div>
        </div>

        <!-- CONTENT -->
        <main class="container py-4">
            <h2 class="mb-4">Ulasan Saya</h2>

            <div class="row">
                <div class="col-12">
                    <% if (reviewList != null && !reviewList.isEmpty()) { %>
                    <div class="list-group ep-shadow-sm border-0 rounded-4">
                        <% for (Ulasan u : reviewList) {
                                Produk p = u.getProduk();
                                String namaProduk = p != null ? p.getNama() : "Produk Tidak Ditemukan";
                                String gambar = p != null ? p.getGambar() : null;
                                String tgl = u.getTanggal() != null ? sdf.format(u.getTanggal()) : "-";
                        %>
                        <div class="list-group-item p-4 border-bottom">
                            <div class="d-flex gap-3">
                                <% if (gambar != null && !gambar.isEmpty()) {%>
                                <img src="<%= ctx%>/<%= gambar%>" alt="Produk" class="rounded-3" style="width: 80px; height: 80px; object-fit: cover; background-color: #f8f9fa;">
                                <% } else { %>
                                <div class="rounded-3 d-flex align-items-center justify-content-center" style="width: 80px; height: 80px; background-color: #f8f9fa;">
                                    <i class="bi bi-image text-muted fs-4"></i>
                                </div>
                                <% }%>

                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <h6 class="mb-0 fw-bold"><%= namaProduk%></h6>
                                        <small class="text-muted"><%= tgl%></small>
                                    </div>

                                    <div class="text-warning mb-2">
                                        <% for (int i = 0; i < u.getRating(); i++) { %>
                                        <i class="bi bi-star-fill"></i>
                                        <% } %>
                                        <% for (int i = u.getRating(); i < 5; i++) { %>
                                        <i class="bi bi-star"></i>
                                        <% }%>
                                    </div>

                                    <p class="mb-0 text-muted" style="font-size: 0.95rem;">
                                        <%= u.getKomentar() != null ? u.getKomentar() : ""%>
                                    </p>
                                    <% if (u.getSellerReply() != null && !u.getSellerReply().trim().isEmpty()) {%>
                                    <div class="mt-2 p-3 bg-light rounded border-start border-primary border-3">
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <i class="bi bi-reply-fill text-primary"></i>
                                            <strong class="text-dark small">Balasan Penjual</strong>
                                        </div>
                                        <p class="mb-0 text-secondary small"><%= u.getSellerReply()%></p>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } else {%>
                    <div class="text-center py-5 ep-empty">
                        <i class="bi bi-chat-square-text" style="font-size: 3rem; color: #dee2e6;"></i>
                        <p class="mt-3 text-muted">Anda belum memberikan ulasan apapun.</p>
                        <a href="<%= ctx%>/buyer" class="btn btn-primary rounded-pill px-4 mt-2">Mulai Belanja</a>
                    </div>
                    <% }%>
                </div>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
