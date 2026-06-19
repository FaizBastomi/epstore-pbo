<%@page import="models.Pembeli" %>
    <%@page import="jakarta.servlet.http.HttpSession" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <% HttpSession ses=request.getSession(false); if (ses==null || ses.getAttribute("username")==null) {
                response.sendRedirect(request.getContextPath() + "/auth?login" ); return; } String
                ctx=request.getContextPath(); Pembeli p=(Pembeli) request.getAttribute("pembeli"); String alamat=p
                !=null && p.getAlamat() !=null ? p.getAlamat() : "" ; String nomorTelp=p !=null && p.getNomor_telp()
                !=null ? p.getNomor_telp() : "" ; String error=(String) request.getAttribute("error"); String
                success=(String) request.getAttribute("success"); %>
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

                    <!-- SECONDARY MENU -->
                    <div class="ep-submenu">
                        <div class="container">
                            <div class="d-flex gap-4">
                                <a href="<%= ctx%>/buyer">Home</a>
                                <a href="<%= ctx%>/buyer#kategori">Kategori</a>
                                <a href="<%= ctx%>/buyer/orders">Pesanan Saya</a>
                                <a href="<%= ctx%>/buyer/reviews">Ulasan</a>
                            </div>
                        </div>
                    </div>

                    <!-- CONTENT -->
                    <main class="container py-5" style="max-width: 600px;">
                        <div class="ep-shadow-sm border-0 rounded-4 p-4 p-md-5 bg-white">
                            <h3 class="mb-4 fw-bold"><i class="bi bi-gear text-primary me-2"></i>Pengaturan Akun</h3>

                            <% if (error !=null) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                    <%= error %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                </div>
                                <% } %>

                                    <% if (success !=null) { %>
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <i class="bi bi-check-circle-fill me-2"></i>
                                            <%= success %>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                        </div>
                                        <% } %>


                                            <div class="mb-3">
                                                <label for="alamat" class="form-label fw-semibold">Alamat Pengiriman
                                                    <% if (alamat.isEmpty()) { %><span class="text-danger">*</span>
                                                        <% } %>
                                                </label>
                                                <textarea class="form-control" id="alamat" name="alamat"
                                                    rows="3"></textarea>
                                            </div>

                                            <div class="mb-4">
                                                <label for="nomor_telp" class="form-label fw-semibold">Nomor
                                                    Telepon</label>
                                                <input type="text" class="form-control" id="nomor_telp"
                                                    name="nomor_telp" value="<%= nomorTelp %>">
                                            </div>

                                            <div class="d-grid">
                                                <button type="submit"
                                                    class="btn btn-primary rounded-pill py-2 fw-semibold">Simpan
                                                    Perubahan</button>
                                            </div>
                                            </form>
                        </div>
                    </main>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>