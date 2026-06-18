<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    models.Penjual penjual = (models.Penjual) request.getAttribute("penjual");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
    
    String namaToko = "";
    if (penjual != null && penjual.getNamaToko() != null) {
        namaToko = penjual.getNamaToko();
    }
    
    String username = "";
    if (session != null && session.getAttribute("username") != null) {
        username = (String) session.getAttribute("username");
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pengaturan Toko - EpStore</title>

        <!-- Google Fonts (Plus Jakarta Sans) -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

        <!-- Custom CSS -->
        <link href="<%= ctx %>/sources/seller.css" rel="stylesheet">
    </head>
    <body>
        <div class="seller-wrapper">
            <!-- Sidebar -->
            <jsp:include page="components/sidebar.jsp">
                <jsp:param name="activePage" value="pengaturan" />
            </jsp:include>

            <!-- Content Area -->
            <div class="seller-content">
                <!-- Topbar -->
                <jsp:include page="components/topbar.jsp" />

                <!-- Main Dashboard Content -->
                <main class="dashboard-main">
                    <h1 class="dashboard-title">Pengaturan Toko</h1>

                    <!-- Settings Card -->
                    <div class="card table-card mt-0" style="max-width: 600px;">
                        <div class="table-card-header">
                            <h2 class="table-card-title"><i class="bi bi-shop me-2 text-success" style="color: #137333 !important;"></i>Informasi Toko</h2>
                        </div>
                        <div class="table-card-body">
                            <% if (error != null) { %>
                                <div class="alert alert-danger d-flex align-items-center gap-2 mb-4" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill"></i>
                                    <div><%= error %></div>
                                </div>
                            <% } %>
                            <% if ("true".equals(success)) { %>
                                <div class="alert alert-success d-flex align-items-center gap-2 mb-4" role="alert">
                                    <i class="bi bi-check-circle-fill"></i>
                                    <div>Nama toko berhasil diperbarui!</div>
                                </div>
                            <% } %>

                            <form action="<%= ctx %>/seller/setting" method="POST">
                                <input type="hidden" name="action" value="update_store">
                                
                                <!-- Shop Name Input -->
                                <div class="mb-4 text-start">
                                    <label for="namaToko" class="form-label fw-bold text-dark">Nama Toko</label>
                                    <input type="text" class="form-control" id="namaToko" name="namaToko" 
                                           value="<%= namaToko.replace("\"", "&quot;") %>" 
                                           placeholder="Masukkan nama toko baru..." required>
                                    <div class="form-text text-muted mt-2">
                                        Nama toko ini akan terlihat oleh semua pelanggan Anda di EpStore.
                                    </div>
                                </div>

                                <!-- Read-only Username -->
                                <div class="mb-4 text-start">
                                    <label class="form-label fw-bold text-muted">Username Pemilik</label>
                                    <input type="text" class="form-control bg-light" value="<%= username %>" disabled>
                                </div>

                                <!-- Save Button -->
                                <div class="text-start">
                                    <button type="submit" class="btn btn-seller-primary">
                                        <i class="bi bi-save me-2"></i>Simpan Perubahan
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap 5 JS Bundle -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
