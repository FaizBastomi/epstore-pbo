<%@page import="java.util.List"%>
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
    List<Produk> produkList = (List<Produk>) request.getAttribute("produkList");
    String transaksiId = (String) request.getAttribute("transaksi_id");
    if (produkList == null || produkList.isEmpty()) {
        response.sendRedirect(ctx + "/buyer/orders");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Review Produk - EpStore</title>
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
        <style>
            .star-rating {
                display: flex;
                flex-direction: row-reverse;
                justify-content: flex-end;
                gap: 0.5rem;
            }
            .star-rating input {
                display: none;
            }
            .star-rating label {
                font-size: 2rem;
                color: #dee2e6;
                cursor: pointer;
                transition: color 0.15s ease, transform 0.1s ease;
            }
            .star-rating label:hover,
            .star-rating label:hover ~ label,
            .star-rating input:checked ~ label {
                color: #ffc107;
            }
            .star-rating label:hover {
                transform: scale(1.1);
            }
        </style>
    </head>
    <body>

        <jsp:include page="components/navbar.jsp">
            <jsp:param name="showSearch" value="false" />
        </jsp:include>

        <!-- CONTENT -->
        <main class="container py-4" style="max-width: 600px;">
            <div class="d-flex align-items-center gap-3 mb-4">
                <a href="<%= ctx%>/buyer/orders" class="btn btn-outline-secondary rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 38px; height: 38px; padding: 0;">
                    <i class="bi bi-arrow-left fs-5"></i>
                </a>
                <h2 class="mb-0">Tulis Review</h2>
            </div>

            <form action="<%= ctx%>/buyer/reviews" method="POST">
                <input type="hidden" name="add" value="1">
                <input type="hidden" name="transaksi_id" value="<%= transaksiId%>">

                <% for (int i = 0; i < produkList.size(); i++) {
                        Produk produk = produkList.get(i);
                %>
                <div class="ep-cart-card <%= i > 0 ? "mt-3" : ""%>">
                    <!-- Product Info -->
                    <div class="d-flex align-items-center gap-3 pb-3 border-bottom mb-3">
                        <% if (produk.getGambar() != null && !produk.getGambar().isEmpty()) {%>
                        <img src="<%= ctx%>/<%= produk.getGambar()%>" alt="<%= produk.getNama()%>" class="rounded-3" style="width: 70px; height: 70px; object-fit: cover; background-color: #f8f9fa;">
                        <% } else { %>
                        <div class="rounded-3 d-flex align-items-center justify-content-center" style="width: 70px; height: 70px; background-color: #f8f9fa;">
                            <i class="bi bi-image text-muted fs-3"></i>
                        </div>
                        <% }%>
                        <div>
                            <h6 class="mb-1 fw-bold"><%= produk.getNama()%></h6>
                            <div class="text-muted small"><%= produk.getDeskripsi()%></div>
                        </div>
                    </div>

                    <input type="hidden" name="produk_ids" value="<%= produk.getId()%>">

                    <div class="mb-4">
                        <label class="form-label fw-bold">Berikan Rating</label>
                        <div class="star-rating">
                            <input type="radio" id="star5_<%= produk.getId()%>" name="rating_<%= produk.getId()%>" value="5" required />
                            <label for="star5_<%= produk.getId()%>" title="5 Bintang"><i class="bi bi-star-fill"></i></label>

                            <input type="radio" id="star4_<%= produk.getId()%>" name="rating_<%= produk.getId()%>" value="4" />
                            <label for="star4_<%= produk.getId()%>" title="4 Bintang"><i class="bi bi-star-fill"></i></label>

                            <input type="radio" id="star3_<%= produk.getId()%>" name="rating_<%= produk.getId()%>" value="3" />
                            <label for="star3_<%= produk.getId()%>" title="3 Bintang"><i class="bi bi-star-fill"></i></label>

                            <input type="radio" id="star2_<%= produk.getId()%>" name="rating_<%= produk.getId()%>" value="2" />
                            <label for="star2_<%= produk.getId()%>" title="2 Bintang"><i class="bi bi-star-fill"></i></label>

                            <input type="radio" id="star1_<%= produk.getId()%>" name="rating_<%= produk.getId()%>" value="1" />
                            <label for="star1_<%= produk.getId()%>" title="1 Bintang"><i class="bi bi-star-fill"></i></label>
                        </div>
                    </div>

                    <div class="mb-2">
                        <label for="komentar_<%= produk.getId()%>" class="form-label fw-bold">Komentar</label>
                        <textarea class="form-control bg-light" id="komentar_<%= produk.getId()%>" name="komentar_<%= produk.getId()%>" rows="3" placeholder="Bagaimana kualitas produk ini?"></textarea>
                    </div>
                </div>
                <% }%>

                <div class="d-grid mt-4">
                    <button type="submit" class="btn btn-primary py-2 border-0">Kirim Semua Review</button>
                </div>
            </form>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
