<%@page import="java.util.List"%>
<%@page import="models.Ulasan"%>
<%@page import="models.Produk"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    List<Ulasan> reviews = (List<Ulasan>) request.getAttribute("reviews");
    if (reviews == null) {
        reviews = new java.util.ArrayList<>();
    }
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    if (currentPage == null) {
        currentPage = 1;
    }
    Boolean hasNext = (Boolean) request.getAttribute("hasNext");
    if (hasNext == null) {
        hasNext = false;
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ulasan Pembeli - EpStore</title>

        <!-- Google Fonts (Plus Jakarta Sans) -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

        <!-- Custom CSS -->
        <link href="<%= ctx%>/sources/seller.css" rel="stylesheet">
        <style>
            .review-card-item {
                cursor: pointer;
                transition: background-color 0.2s ease;
            }
            .review-card-item:hover {
                background-color: #f8f9fa;
            }
            .rating-star {
                color: #ffc107;
            }
            .reply-panel-container {
                position: sticky;
                top: 20px;
            }
        </style>
    </head>
    <body>
        <div class="seller-wrapper">
            <!-- Sidebar -->
            <jsp:include page="components/sidebar.jsp">
                <jsp:param name="activePage" value="ulasan" />
            </jsp:include>

            <!-- Content Area -->
            <div class="seller-content">
                <!-- Topbar -->
                <jsp:include page="components/topbar.jsp" />

                <!-- Main Content -->
                <main class="dashboard-main">
                    <h1 class="dashboard-title">Ulasan Pembeli</h1>

                    <div class="row g-4">
                        <!-- Left Column: Reviews List -->
                        <div class="col-lg-8 col-md-7">
                            <div class="card table-card mt-0">
                                <div class="table-card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table align-middle mb-0" style="font-size: 0.95rem;">
                                            <thead class="table-light">
                                                <tr>
                                                    <th class="ps-4 py-3" style="font-weight: 600; color: #5a5c69; width: 30%;">Produk</th>
                                                    <th class="py-3" style="font-weight: 600; color: #5a5c69; width: 45%;">Ulasan</th>
                                                    <th class="py-3" style="font-weight: 600; color: #5a5c69; width: 15%;">Tanggal</th>
                                                    <th class="pe-4 py-3 text-center" style="font-weight: 600; color: #5a5c69; width: 10%;">Aksi</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    if (!reviews.isEmpty()) {
                                                        for (Ulasan rev : reviews) {
                                                            Produk p = rev.getProduk();
                                                            String pName = p != null ? p.getNama() : "Produk Tidak Diketahui";
                                                            String pImg = p != null ? p.getGambar() : "";
                                                %>
                                                <tr class="review-card-item" onclick="selectReview('<%= rev.getId() %>', '<%= pName.replace("'", "\\'") %>', '<%= pImg %>', '<%= rev.getNamaPembeli().replace("'", "\\'") %>', <%= rev.getRating() %>, '<%= rev.getKomentar() != null ? rev.getKomentar().replace("'", "\\'").replace("\n", " ").replace("\r", " ") : "" %>', '<%= rev.getSellerReply() != null ? rev.getSellerReply().replace("'", "\\'").replace("\n", " ").replace("\r", " ") : "" %>')">
                                                    <td class="ps-4 py-3">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <% if (pImg != null && !pImg.trim().isEmpty()) { %>
                                                            <img src="<%= ctx %>/<%= pImg %>" alt="<%= pName %>" class="rounded" style="width: 40px; height: 40px; object-fit: cover;">
                                                            <% } else { %>
                                                            <div class="bg-light rounded d-flex align-items-center justify-content-center text-muted" style="width: 40px; height: 40px;"><i class="bi bi-image"></i></div>
                                                            <% } %>
                                                            <div class="text-truncate" style="max-width: 150px;" title="<%= pName %>"><%= pName %></div>
                                                        </div>
                                                    </td>
                                                    <td class="py-3">
                                                        <div class="fw-bold mb-1"><%= rev.getNamaPembeli() %></div>
                                                        <div class="mb-1 text-warning">
                                                            <% for (int i = 0; i < 5; i++) { %>
                                                            <i class="bi <%= i < rev.getRating() ? "bi-star-fill" : "bi-star" %> rating-star"></i>
                                                            <% } %>
                                                        </div>
                                                        <div class="text-secondary text-wrap" style="max-width: 300px;"><%= rev.getKomentar() != null ? rev.getKomentar() : "-" %></div>
                                                        <% if (rev.getSellerReply() != null && !rev.getSellerReply().trim().isEmpty()) { %>
                                                        <div class="mt-2 p-2 bg-light rounded text-muted border-start border-success border-3" style="font-size: 0.85rem; max-width: 300px;">
                                                            <strong>Balasan Anda:</strong> <%= rev.getSellerReply() %>
                                                        </div>
                                                        <% } %>
                                                    </td>
                                                    <td class="py-3 text-muted"><%= rev.getTanggal() %></td>
                                                    <td class="pe-4 py-3 text-center">
                                                        <button class="btn btn-sm btn-outline-success" type="button">Balas</button>
                                                    </td>
                                                </tr>
                                                <%
                                                        }
                                                    } else {
                                                %>
                                                <tr>
                                                    <td colspan="4" class="text-center py-5 text-muted">
                                                        <i class="bi bi-chat-left-text d-block mb-2 fs-3"></i>
                                                        Belum ada ulasan masuk.
                                                    </td>
                                                </tr>
                                                <%
                                                    }
                                                %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Pagination Controls -->
                            <% if (currentPage > 1 || hasNext) { %>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <% if (currentPage > 1) { %>
                                <a href="<%= ctx %>/seller/ulasan?page=<%= currentPage - 1 %>" class="btn btn-outline-secondary btn-sm"><i class="bi bi-chevron-left"></i> Sebelumnya</a>
                                <% } else { %>
                                <div></div>
                                <% } %>
                                <span class="text-muted" style="font-size: 0.9rem;">Halaman <%= currentPage %></span>
                                <% if (hasNext) { %>
                                <a href="<%= ctx %>/seller/ulasan?page=<%= currentPage + 1 %>" class="btn btn-outline-secondary btn-sm">Selanjutnya <i class="bi bi-chevron-right"></i></a>
                                <% } else { %>
                                <div></div>
                                <% } %>
                            </div>
                            <% } %>
                        </div>

                        <!-- Right Column: Reply Panel -->
                        <div class="col-lg-4 col-md-5">
                            <div class="card reply-panel-container shadow-sm border-0">
                                <div class="card-body" id="reply-card-placeholder">
                                    <div class="text-center py-5 text-muted">
                                        <i class="bi bi-chat-left-dots fs-1 d-block mb-3 text-secondary"></i>
                                        <p class="m-0">Pilih ulasan di sebelah kiri untuk menulis balasan.</p>
                                    </div>
                                </div>
                                <div class="card-body d-none" id="reply-card-active">
                                    <h5 class="card-title fw-bold mb-4">Balas Ulasan</h5>
                                    
                                    <!-- Product Info -->
                                    <div class="d-flex align-items-center gap-3 mb-4 p-3 bg-light rounded-3">
                                        <img id="reply-product-img" src="" alt="" class="rounded" style="width: 55px; height: 55px; object-fit: cover;">
                                        <div id="reply-product-no-img" class="bg-secondary rounded d-flex align-items-center justify-content-center text-white" style="width: 55px; height: 55px;"><i class="bi bi-image"></i></div>
                                        <div class="overflow-hidden">
                                            <h6 class="mb-1 text-truncate" id="reply-product-name" style="font-size: 0.95rem; font-weight: 600;"></h6>
                                            <span class="text-muted" style="font-size: 0.85rem;">Produk Toko</span>
                                        </div>
                                    </div>

                                    <!-- Review Detail -->
                                    <div class="mb-4">
                                        <div class="d-flex align-items-center justify-content-between mb-2">
                                            <span class="fw-bold text-dark" id="reply-buyer-name" style="font-size: 0.95rem;"></span>
                                            <div id="reply-stars" class="text-warning"></div>
                                        </div>
                                        <p class="text-secondary bg-light p-3 rounded-3" id="reply-buyer-comment" style="font-size: 0.9rem; font-style: italic;"></p>
                                    </div>

                                    <!-- Alert Success Mock -->
                                    <div class="alert alert-success d-none mb-3" id="reply-success-alert">
                                        <i class="bi bi-check-circle-fill me-2"></i> Balasan berhasil dikirim! (Simulasi)
                                    </div>

                                    <!-- Reply Form -->
                                    <form id="reply-form" action="<%= ctx %>/seller" method="POST">
                                        <input type="hidden" name="action" value="reply_ulasan">
                                        <input type="hidden" name="page" value="<%= currentPage %>">
                                        <input type="hidden" name="ulasanId" id="reply-ulasanId">
                                        <div class="mb-3">
                                            <label for="replyText" class="form-label fw-semibold" style="font-size: 0.9rem; color: #5a5c69;">Tulis Balasan Anda</label>
                                            <textarea class="form-control" name="replyText" id="replyText" rows="4" placeholder="Ketik balasan untuk pembeli..." required></textarea>
                                        </div>
                                        <div class="d-grid gap-2">
                                            <button type="submit" class="btn btn-seller-primary">Simpan Balasan</button>
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="cancelReply()">Batal</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap 5 JS Bundle -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- JavaScript for Reply Interaction -->
        <script>
            function selectReview(id, pName, pImg, buyerName, rating, comment, sellerReply) {
                // Hide placeholder, show active card
                document.getElementById('reply-card-placeholder').classList.add('d-none');
                document.getElementById('reply-card-active').classList.remove('d-none');
                
                // Set hidden fields and text
                document.getElementById('reply-ulasanId').value = id;
                document.getElementById('replyText').value = sellerReply || '';

                // Populate product image
                const imgEl = document.getElementById('reply-product-img');
                const noImgEl = document.getElementById('reply-product-no-img');
                if (pImg && pImg.trim() !== '') {
                    imgEl.src = '<%= ctx %>/' + pImg;
                    imgEl.alt = pName;
                    imgEl.classList.remove('d-none');
                    noImgEl.classList.add('d-none');
                } else {
                    imgEl.classList.add('d-none');
                    noImgEl.classList.remove('d-none');
                }

                // Populate text
                document.getElementById('reply-product-name').innerText = pName;
                document.getElementById('reply-buyer-name').innerText = buyerName;
                document.getElementById('reply-buyer-comment').innerText = comment && comment.trim() !== '' ? '"' + comment + '"' : '"Tidak ada komentar"';

                // Populate stars
                let starsHtml = '';
                for (let i = 0; i < 5; i++) {
                    starsHtml += `<i class="bi \${i < rating ? 'bi-star-fill' : 'bi-star'} rating-star"></i>`;
                }
                document.getElementById('reply-stars').innerHTML = starsHtml;
                
                // Focus textarea
                document.getElementById('replyText').focus();
            }

            function cancelReply() {
                document.getElementById('reply-card-placeholder').classList.remove('d-none');
                document.getElementById('reply-card-active').classList.add('d-none');
            }
        </script>
    </body>
</html>
