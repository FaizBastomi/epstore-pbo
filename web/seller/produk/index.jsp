<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.Produk"%>
<%@page import="java.util.Locale"%>
<%
    String ctx = request.getContextPath();
    List<Produk> listProduk = (List<Produk>) request.getAttribute("listProduk");
    if (listProduk == null) {
        listProduk = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kelola Produk - EpStore</title>

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
    </head>
    <body>
        <div class="seller-wrapper">
            <!-- Sidebar -->
            <jsp:include page="../components/sidebar.jsp">
                <jsp:param name="activePage" value="produk" />
            </jsp:include>

            <!-- Content Area -->
            <div class="seller-content">
                <!-- Topbar -->
                <jsp:include page="../components/topbar.jsp" />

                <!-- Main Dashboard Content -->
                <main class="dashboard-main">
                    <!-- Header Kelola Produk -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h1 class="dashboard-title mb-0">Kelola Produk</h1>
                        <a href="<%= ctx%>/seller/produk/tambah" class="btn btn-seller-primary d-flex align-items-center gap-2">
                            <i class="bi bi-plus-lg"></i> Tambah Produk
                        </a>
                    </div>

                    <!-- Products Table Card -->
                    <div class="card table-card mt-0">
                        <div class="table-card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" style="font-size: 0.95rem;">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-4 py-3 text-center" style="width: 70px; font-weight: 600; color: #5a5c69;">No</th>
                                            <th class="py-3" style="font-weight: 600; color: #5a5c69;">Produk</th>
                                            <th class="py-3" style="font-weight: 600; color: #5a5c69;">Kategori</th>
                                            <th class="py-3" style="font-weight: 600; color: #5a5c69;">Harga</th>
                                            <th class="py-3 text-center" style="width: 120px; font-weight: 600; color: #5a5c69;">Stok</th>
                                            <th class="pe-4 py-3 text-center" style="width: 150px; font-weight: 600; color: #5a5c69;">Aksi</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (!listProduk.isEmpty()) {
                                                int no = 1;
                                                for (Produk p : listProduk) {
                                                    String hargaFmt = String.format(Locale.US, "%,.0f", p.getHarga()).replace(',', '.');
                                        %>
                                        <tr>
                                            <td class="ps-4 py-3 text-center fw-bold text-dark"><%= no++%></td>
                                            <td class="py-3">
                                                <div class="d-flex align-items-center gap-3">
                                                    <!-- Thumbnail image -->
                                                    <div class="product-img-wrapper position-relative overflow-hidden rounded bg-light border d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; flex-shrink: 0;">
                                                        <i class="bi bi-image text-muted" style="font-size: 1.2rem; position: absolute;"></i>
                                                        <% if (p.getGambar() != null && !p.getGambar().trim().isEmpty()) {%>
                                                        <img src="<%= ctx%>/<%= p.getGambar()%>" alt="<%= p.getNama()%>" class="position-relative w-100 h-100 object-fit-cover" onerror="this.remove();" style="z-index: 1;">
                                                        <% }%>
                                                    </div>
                                                    <!-- Product Name -->
                                                    <span class="fw-semibold text-dark"><%= p.getNama()%></span>
                                                </div>
                                            </td>
                                            <td class="py-3"><span class="badge bg-secondary-subtle text-secondary-emphasis px-2 py-1 rounded-2" style="font-size: 0.85rem;"><%= p.getKategori() != null ? p.getKategori() : "-"%></span></td>
                                            <td class="py-3 text-dark fw-medium">Rp<%= hargaFmt%></td>
                                            <td class="py-3 text-center"><%= p.getStok()%></td>
                                            <td class="pe-4 py-3 text-center">
                                                <div class="d-flex justify-content-center gap-2">
                                                    <!-- Edit Action -->
                                                    <a href="<%= ctx%>/seller/produk/edit?id=<%= p.getId()%>" class="btn btn-sm btn-primary d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; border-radius: 6px;" title="Edit Produk">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <!-- Delete Action -->
                                                    <form action="<%= ctx%>/seller/produk" method="POST" class="d-inline m-0" onsubmit="return confirm('Apakah Anda yakin ingin menghapus produk ini?');">
                                                        <input type="hidden" name="action" value="delete_produk">
                                                        <input type="hidden" name="id" value="<%= p.getId()%>">
                                                        <button type="submit" class="btn btn-sm btn-danger d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; border-radius: 6px;" title="Hapus Produk">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        } else {
                                        %>
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted">
                                                <i class="bi bi-box-seam d-block mb-2 fs-3"></i>
                                                Belum ada produk. Klik tombol "Tambah Produk" untuk mulai berjualan.
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
                </main>
            </div>
        </div>

        <!-- Bootstrap 5 JS Bundle -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
