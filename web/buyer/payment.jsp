<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="models.TransaksiItem"%>
<%@page import="models.Transaksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Transaksi trx = (Transaksi) request.getAttribute("transaksi");
    ArrayList<TransaksiItem> items = (ArrayList<TransaksiItem>) request.getAttribute("items");
    Double subtotal = (Double) request.getAttribute("subtotal");
    Double ongkir = (Double) request.getAttribute("ongkir");
    Double pajak = (Double) request.getAttribute("pajak");
    Double grandTotal = (Double) request.getAttribute("grandTotal");

    NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Selesaikan Pembayaran - EpStore</title>
        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet"/>
        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/sources/css/buyer.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/sources/css/payment.css">
    </head>
    <body class="bg-light">

        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/">
                    <i class="ri-store-2-fill me-2"></i>EpStore
                </a>
                <span class="text-muted fw-medium d-none d-md-block">Checkout Pembayaran</span>
                <div>
                    <a href="${pageContext.request.contextPath}/buyer/orders" class="btn btn-outline-secondary btn-sm rounded-pill">
                        Kembali ke Pesanan
                    </a>
                </div>
            </div>
        </nav>

        <div class="container py-5">
            <div class="row g-4 justify-content-center">
                
                <!-- Kiri: Detail Pembayaran & Form -->
                <div class="col-lg-8">
                    <form action="${pageContext.request.contextPath}/buyer/payment?id=<%= trx.getId() %>" method="POST" id="paymentForm">
                        
                        <div class="card border-0 shadow-sm rounded-4 mb-4">
                            <div class="card-body p-4">
                                <h5 class="fw-bold mb-4">Pilih Metode Pembayaran</h5>
                                
                                <!-- QRIS -->
                                <label class="ep-pay-method-card mb-3" id="card-qris">
                                    <input type="radio" name="metode" value="qris" required>
                                    <div class="ep-pay-icon"><i class="ri-qr-code-line"></i></div>
                                    <div class="flex-grow-1">
                                        <h6 class="mb-0 fw-bold">QRIS</h6>
                                        <small class="text-muted">Bayar instan pakai aplikasi e-wallet / m-banking.</small>
                                    </div>
                                    <i class="ri-checkbox-circle-fill text-primary fs-4 d-none check-icon"></i>
                                </label>
                                
                                <!-- Transfer Bank -->
                                <label class="ep-pay-method-card mb-3" id="card-transfer">
                                    <input type="radio" name="metode" value="transfer_bank" required>
                                    <div class="ep-pay-icon"><i class="ri-bank-card-line"></i></div>
                                    <div class="flex-grow-1">
                                        <h6 class="mb-0 fw-bold">Transfer Virtual Account</h6>
                                        <small class="text-muted">BCA, Mandiri, BNI, BRI.</small>
                                    </div>
                                    <i class="ri-checkbox-circle-fill text-primary fs-4 d-none check-icon"></i>
                                </label>

                                <!-- E-Wallet -->
                                <label class="ep-pay-method-card mb-3" id="card-ewallet">
                                    <input type="radio" name="metode" value="e_wallet" required>
                                    <div class="ep-pay-icon"><i class="ri-wallet-3-line"></i></div>
                                    <div class="flex-grow-1">
                                        <h6 class="mb-0 fw-bold">E-Wallet</h6>
                                        <small class="text-muted">OVO, GoPay, DANA, ShopeePay.</small>
                                    </div>
                                    <i class="ri-checkbox-circle-fill text-primary fs-4 d-none check-icon"></i>
                                </label>

                                <!-- COD -->
                                <label class="ep-pay-method-card" id="card-cod">
                                    <input type="radio" name="metode" value="cod" required>
                                    <div class="ep-pay-icon"><i class="ri-truck-line"></i></div>
                                    <div class="flex-grow-1">
                                        <h6 class="mb-0 fw-bold">Cash on Delivery (COD)</h6>
                                        <small class="text-muted">Bayar tunai ke kurir saat barang tiba.</small>
                                    </div>
                                    <i class="ri-checkbox-circle-fill text-primary fs-4 d-none check-icon"></i>
                                </label>
                            </div>
                        </div>

                        <!-- Panel Detail Dinamis yang muncul sesuai pilihan -->
                        <div class="card border-0 shadow-sm rounded-4 mb-4 ep-pay-detail-panel" id="panel-qris">
                            <div class="card-body p-4 text-center">
                                <h6 class="fw-bold mb-3">Scan QRIS Berikut</h6>
                                <div class="ep-qr-placeholder mb-3">
                                    <i class="ri-qr-code-line text-muted" style="font-size: 80px;"></i>
                                    <span class="fw-medium mt-2 text-dark">Simulasi QRIS</span>
                                </div>
                                <p class="text-muted small mb-0">Buka aplikasi m-banking atau e-wallet Anda, lalu scan QR di atas.</p>
                            </div>
                        </div>

                        <div class="card border-0 shadow-sm rounded-4 mb-4 ep-pay-detail-panel" id="panel-transfer">
                            <div class="card-body p-4">
                                <h6 class="fw-bold mb-3">Pilih Bank Tujuan</h6>
                                <div class="ep-submethod-grid mb-4">
                                    <label><input type="radio" name="sub_metode" value="BCA" class="d-none" checked> <div class="ep-submethod-label">BCA</div></label>
                                    <label><input type="radio" name="sub_metode" value="Mandiri" class="d-none"> <div class="ep-submethod-label">Mandiri</div></label>
                                    <label><input type="radio" name="sub_metode" value="BNI" class="d-none"> <div class="ep-submethod-label">BNI</div></label>
                                    <label><input type="radio" name="sub_metode" value="BRI" class="d-none"> <div class="ep-submethod-label">BRI</div></label>
                                </div>
                                <div class="alert alert-info border-0 text-center">
                                    Nomor Virtual Account akan digenerate setelah Anda klik tombol Bayar.
                                </div>
                            </div>
                        </div>

                        <div class="card border-0 shadow-sm rounded-4 mb-4 ep-pay-detail-panel" id="panel-ewallet">
                            <div class="card-body p-4">
                                <h6 class="fw-bold mb-3">Pilih E-Wallet</h6>
                                <div class="ep-submethod-grid mb-4">
                                    <label><input type="radio" name="sub_metode" value="GoPay" class="d-none" disabled> <div class="ep-submethod-label text-muted">GoPay</div></label>
                                    <label><input type="radio" name="sub_metode" value="OVO" class="d-none" checked> <div class="ep-submethod-label">OVO</div></label>
                                    <label><input type="radio" name="sub_metode" value="DANA" class="d-none"> <div class="ep-submethod-label">DANA</div></label>
                                    <label><input type="radio" name="sub_metode" value="ShopeePay" class="d-none"> <div class="ep-submethod-label">ShopeePay</div></label>
                                </div>
                                <div class="alert alert-info border-0 text-center">
                                    Kami akan mengirimkan notifikasi ke aplikasi Anda untuk konfirmasi pembayaran.
                                </div>
                            </div>
                        </div>

                        <div class="card border-0 shadow-sm rounded-4 mb-4 ep-pay-detail-panel" id="panel-cod">
                            <div class="card-body p-4 text-center">
                                <i class="ri-information-line fs-1 text-primary mb-2"></i>
                                <h6 class="fw-bold">Informasi Cash on Delivery</h6>
                                <p class="text-muted mb-0">Siapkan uang pas sejumlah <strong><%= fmt.format(grandTotal) %></strong> saat kurir tiba di lokasi Anda.</p>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg w-100 rounded-pill fw-bold shadow" id="btnSubmit" disabled>
                            Bayar Sekarang - <%= fmt.format(grandTotal) %>
                        </button>
                    </form>
                </div>

                <!-- Kanan: Order Summary -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 sticky-top" style="top: 100px;">
                        <div class="card-body p-4">
                            <h5 class="fw-bold mb-4">Ringkasan Pesanan</h5>
                            <p class="text-muted small mb-3">ID Pesanan: <strong>#ORD-<%= trx.getId() %></strong></p>
                            
                            <ul class="list-group list-group-flush mb-4 ep-summary-table">
                                <% for (TransaksiItem item : items) { %>
                                <li class="list-group-item px-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fw-medium text-truncate" style="max-width: 180px;"><%= item.getNamaProduk() %></div>
                                        <small class="text-muted"><%= item.getQty() %> x <%= fmt.format(item.getHarga()) %></small>
                                    </div>
                                    <span class="fw-medium"><%= fmt.format(item.getHarga() * item.getQty()) %></span>
                                </li>
                                <% } %>
                            </ul>

                            <div class="d-flex justify-content-between mb-2 small text-muted">
                                <span>Subtotal Produk</span>
                                <span><%= fmt.format(subtotal) %></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2 small text-muted">
                                <span>Ongkos Kirim</span>
                                <span><%= fmt.format(ongkir) %></span>
                            </div>
                            <div class="d-flex justify-content-between mb-3 small text-muted pb-3 border-bottom">
                                <span>Pajak PPN (11%)</span>
                                <span><%= fmt.format(pajak) %></span>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span class="fw-bold fs-5">Total Bayar</span>
                                <span class="fw-bold fs-4 text-primary"><%= fmt.format(grandTotal) %></span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // UI Logic untuk Radio Method Cards
            const methodCards = document.querySelectorAll('.ep-pay-method-card');
            const btnSubmit = document.getElementById('btnSubmit');
            const panels = {
                'qris': document.getElementById('panel-qris'),
                'transfer_bank': document.getElementById('panel-transfer'),
                'e_wallet': document.getElementById('panel-ewallet'),
                'cod': document.getElementById('panel-cod')
            };

            methodCards.forEach(card => {
                card.addEventListener('click', function() {
                    // Reset all
                    methodCards.forEach(c => {
                        c.classList.remove('selected');
                        c.querySelector('.check-icon').classList.add('d-none');
                    });
                    Object.values(panels).forEach(panel => {
                        if(panel) panel.style.display = 'none';
                    });

                    // Set active
                    this.classList.add('selected');
                    this.querySelector('.check-icon').classList.remove('d-none');
                    this.querySelector('input[type="radio"]').checked = true;

                    // Show corresponding panel
                    const methodVal = this.querySelector('input[type="radio"]').value;
                    if(panels[methodVal]) {
                        panels[methodVal].style.display = 'block';
                    }

                    // Enable button
                    btnSubmit.disabled = false;
                });
            });
        </script>
    </body>
</html>
