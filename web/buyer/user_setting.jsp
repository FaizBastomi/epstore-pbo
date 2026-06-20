<%@page import="models.Pembeli" %>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?login");
        return;
    }
    String ctx = request.getContextPath();
    Pembeli p = (Pembeli) request.getAttribute("pembeli");
    if (p == null) {
        p = new Pembeli().getPembeliByUsername((String) ses.getAttribute("username"));
    }
    String usernameVal = p != null ? p.getUsername() : "";
    String emailVal = p != null ? p.getEmail() : "";
    String alamat = p != null && p.getAlamat() != null ? p.getAlamat() : "";
    String nomorTelp = p != null && p.getNomor_telp() != null ? p.getNomor_telp() : "";
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="id">

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pengaturan Akun - EpStore</title>
        <!-- Google Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap"
            rel="stylesheet">
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
              rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <!-- Buyer theme -->
        <link href="<%= ctx%>/sources/buyer.css" rel="stylesheet">
    </head>

    <body>

        <jsp:include page="components/navbar.jsp">
            <jsp:param name="showSearch" value="false" />
        </jsp:include>

        <jsp:include page="components/submenu.jsp" />

        <!-- CONTENT -->
        <main class="container py-4">
            <!-- Title on top of the card -->
            <h3 class="mb-4 fw-bold text-dark"><i class="bi bi-gear-fill text-primary me-2"></i>Pengaturan Akun</h3>

            <div class="ep-shadow-sm border-0 rounded-4 p-4 p-md-5 bg-white">
                <% if (error != null) {%>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <%= error%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                            aria-label="Close"></button>
                </div>
                <% } %>

                <% if (success != null) {%>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    <%= success%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                            aria-label="Close"></button>
                </div>
                <% } %>

                <!-- Profile Info / Form -->
                <form action="<%= ctx %>/buyer/setting" method="POST">
                    <!-- Read-Only Account Details -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-dark" style="font-size: 0.9rem;">Username</label>
                            <input type="text" class="form-control" name="username" 
                                   value="<%= usernameVal %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-muted" style="font-size: 0.9rem;">Email</label>
                            <input type="email" class="form-control bg-light text-secondary border-0" 
                                   value="<%= emailVal %>" disabled readonly>
                        </div>
                    </div>

                    <hr class="my-4 text-muted opacity-25">

                    <!-- Editable Profile Details -->
                    <div class="mb-3">
                        <label for="alamat" class="form-label fw-semibold text-dark">Alamat Pengiriman
                            <% if (alamat.isEmpty()) { %><span class="text-danger">*</span>
                            <% }%>
                        </label>
                        <textarea class="form-control" id="alamat" name="alamat" rows="3" 
                                  placeholder="Masukkan alamat pengiriman lengkap"><%= alamat %></textarea>
                    </div>

                    <div class="mb-4">
                        <label for="nomor_telp" class="form-label fw-semibold text-dark">Nomor Telepon</label>
                        <input type="text" class="form-control" id="nomor_telp" name="nomor_telp" 
                               placeholder="Masukkan nomor telepon aktif" value="<%= nomorTelp %>">
                    </div>

                    <hr class="my-4 text-muted opacity-25">

                    <div class="mb-4">
                        <label for="password" class="form-label fw-semibold text-dark">Password Baru</label>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Kosongkan jika tidak ingin mengubah password">
                        <small class="text-muted">Akan diminta login ulang setelah ganti username/password</small>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary rounded-pill py-2 fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i> Simpan Perubahan
                        </button>
                    </div>
                </form>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>