<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");

    // Retrieve values to preserve input in case of error
    String nama = (String) request.getAttribute("nama");
    String deskripsi = (String) request.getAttribute("deskripsi");
    String kategori = (String) request.getAttribute("kategori");
    String harga = (String) request.getAttribute("harga");
    String stok = (String) request.getAttribute("stok");
    String gambarSelected = (String) request.getAttribute("gambar");

    if (nama == null) {
        nama = "";
    }
    if (deskripsi == null) {
        deskripsi = "";
    }
    if (kategori == null) {
        kategori = "Lainnya";
    }
    if (harga == null) {
        harga = "";
    }
    if (stok == null) {
        stok = "";
    }
    if (gambarSelected == null) {
        gambarSelected = "sources/images/products/headphone.png"; // default
    }%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tambah Produk Baru - EpStore</title>

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
        <link href="<%= ctx%>/sources/seller_produk.css" rel="stylesheet">
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
                    <!-- Header -->
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <a href="<%= ctx%>/seller/produk" class="btn btn-outline-secondary d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; border-radius: 8px;" title="Kembali ke Daftar Produk">
                            <i class="bi bi-arrow-left"></i>
                        </a>
                        <h1 class="dashboard-title mb-0">Tambah Produk Baru</h1>
                    </div>

                    <!-- Form Card -->
                    <div class="card table-card mt-0" style="max-width: 900px;">
                        <div class="table-card-header">
                            <h2 class="table-card-title"><i class="bi bi-box-seam me-2 text-success" style="color: #137333 !important;"></i>Detail Informasi Produk</h2>
                        </div>
                        <div class="table-card-body p-4">
                            <% if (error != null) {%>
                            <div class="alert alert-danger d-flex align-items-center gap-2 mb-4" role="alert">
                                <i class="bi bi-exclamation-triangle-fill"></i>
                                <div><%= error%></div>
                            </div>
                            <% }%>

                            <form action="<%= ctx%>/seller/produk/tambah" method="POST" id="tambahProdukForm" enctype="multipart/form-data">
                                <div class="row">
                                    <!-- Left Column: Basic Details -->
                                    <div class="col-md-7 border-end pe-md-4 text-start">
                                        <!-- Product Name -->
                                        <div class="mb-4">
                                            <label for="nama" class="form-label fw-bold text-dark">Nama Produk <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="nama" name="nama" 
                                                   value="<%= nama.replace("\"", "&quot;")%>" 
                                                   placeholder="Contoh: Kemeja Flanel Slim Fit" required>
                                        </div>

                                        <!-- Category & Price in Row -->
                                        <div class="row mb-4">
                                            <div class="col-sm-6">
                                                <label for="kategori" class="form-label fw-bold text-dark">Kategori <span class="text-danger">*</span></label>
                                                <select class="form-select form-control" id="kategori" name="kategori" required>
                                                    <option value="Elektronik" <%= "Elektronik".equals(kategori) ? "selected" : ""%>>Elektronik</option>
                                                    <option value="Fashion" <%= "Fashion".equals(kategori) ? "selected" : ""%>>Fashion</option>
                                                    <option value="Makanan" <%= "Makanan".equals(kategori) ? "selected" : ""%>>Makanan</option>
                                                    <option value="Kecantikan" <%= "Kecantikan".equals(kategori) ? "selected" : ""%>>Kecantikan</option>
                                                    <option value="Lainnya" <%= "Lainnya".equals(kategori) ? "selected" : ""%>>Lainnya</option>
                                                </select>
                                            </div>
                                            <div class="col-sm-6">
                                                <label for="harga" class="form-label fw-bold text-dark">Harga (Rp) <span class="text-danger">*</span></label>
                                                <input type="number" class="form-control" id="harga" name="harga" min="0" step="any"
                                                       value="<%= harga%>" 
                                                       placeholder="Contoh: 150000" required>
                                            </div>
                                        </div>

                                        <!-- Stock -->
                                        <div class="mb-4" style="max-width: 250px;">
                                            <label for="stok" class="form-label fw-bold text-dark">Jumlah Stok <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control" id="stok" name="stok" min="0"
                                                   value="<%= stok%>" 
                                                   placeholder="Contoh: 10" required>
                                        </div>

                                        <!-- Description -->
                                        <div class="mb-4">
                                            <label for="deskripsi" class="form-label fw-bold text-dark">Deskripsi Produk</label>
                                            <textarea class="form-control" id="deskripsi" name="deskripsi" rows="5" 
                                                      placeholder="Jelaskan spesifikasi, keunggulan, ukuran, atau detail produk Anda..."><%= deskripsi%></textarea>
                                        </div>
                                    </div>

                                    <!-- Right Column: Product Image Selection -->
                                    <div class="col-md-5 ps-md-4 text-start">
                                        <label for="gambarFile" class="form-label fw-bold text-dark mb-3">Gambar Produk <span class="text-danger">*</span></label>

                                        <input type="file" class="form-control mb-4" id="gambarFile" name="gambarFile" accept="image/*" required>

                                        <!-- Selected Preview -->
                                        <div class="card bg-light border p-3 text-center mb-4" id="previewContainer" style="display: none;">
                                            <small class="text-muted d-block mb-2">Pratinjau Gambar</small>
                                            <div class="mx-auto rounded border bg-white overflow-hidden d-flex align-items-center justify-content-center" style="width: 120px; height: 120px;">
                                                <img id="imagePreview" src="" alt="Preview" class="w-100 h-100 object-fit-cover">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <hr class="my-4">

                                <!-- Buttons -->
                                <div class="d-flex justify-content-end gap-3">
                                    <a href="<%= ctx%>/seller/produk" class="btn btn-outline-secondary px-4">Batal</a>
                                    <button type="submit" class="btn btn-seller-primary px-4">
                                        <i class="bi bi-plus-lg me-2"></i>Tambah Produk
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

        <!-- JavaScript for Interactive Form Elements -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const gambarFile = document.getElementById('gambarFile');
                const imagePreview = document.getElementById('imagePreview');
                const previewContainer = document.getElementById('previewContainer');

                gambarFile.addEventListener('change', function () {
                    if (this.files && this.files[0]) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            imagePreview.src = e.target.result;
                            previewContainer.style.display = 'block';
                        };
                        reader.readAsDataURL(this.files[0]);
                    } else {
                        previewContainer.style.display = 'none';
                        imagePreview.src = '';
                    }
                });
            });
        </script>
    </body>
</html>
