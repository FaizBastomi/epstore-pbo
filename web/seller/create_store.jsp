<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Buat Toko - EpStore</title>
        
        <!-- Google Fonts (Plus Jakarta Sans) -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <!-- Custom CSS -->
        <link href="<%= ctx %>/sources/seller.css" rel="stylesheet">
    </head>
    <body class="create-store-body">
        <div class="create-store-card">
            <h1>Selamat Datang di Seller Mode!</h1>
            <p>Langkah pertama, mari buat nama untuk toko Anda. Nama ini akan terlihat oleh semua pembeli.</p>
            
            <% if (error != null) { %>
                <div class="alert alert-danger" role="alert">
                    <%= error %>
                </div>
            <% } %>

            <form action="<%= ctx %>/seller" method="POST">
                <input type="hidden" name="action" value="create_store">
                <div class="mb-3 text-start">
                    <label for="namaToko" class="form-label fw-bold" style="color: #4a5568;">Nama Toko</label>
                    <input type="text" class="form-control" id="namaToko" name="namaToko" placeholder="Contoh: EpStore Official" required>
                </div>
                <button type="submit" class="btn btn-primary w-100 mt-3">Mulai Berjualan</button>
            </form>
            
            <a href="<%= ctx %>/buyer" class="back-link">Kembali ke Mode Pembeli</a>
        </div>
        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
