<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="models.RiwayatPembayaran"%>
<%@page import="models.PaymentStatus"%>
<%@page import="models.Transaksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Transaksi trx = (Transaksi) request.getAttribute("transaksi");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));

    // Ambil riwayat pembayaran terbaru untuk transaksi ini
    RiwayatPembayaran riwayat = new RiwayatPembayaran();
    riwayat.where("transaksi_id = " + trx.getId() + " ORDER BY waktu_bayar DESC LIMIT 1");
    ArrayList<RiwayatPembayaran> history = riwayat.get();
    
    RiwayatPembayaran lastPayment = history.isEmpty() ? null : history.get(0);
    PaymentStatus status = lastPayment != null ? PaymentStatus.fromString(lastPayment.getStatus()) : PaymentStatus.PENDING;
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Status Pembayaran - EpStore</title>
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
            </div>
        </nav>

        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-5">
                    
                    <div class="card ep-receipt-card mb-4">
                        <div class="ep-receipt-header">
                            <% if (status == PaymentStatus.SUCCESS) { %>
                                <i class="ri-checkbox-circle-fill ep-receipt-icon success"></i>
                                <h4 class="fw-bold mb-1 text-success">Pembayaran Berhasil</h4>
                                <p class="text-muted mb-0">Pesanan Anda segera diproses oleh penjual.</p>
                            <% } else if (status == PaymentStatus.PENDING) { %>
                                <i class="ri-time-fill ep-receipt-icon pending"></i>
                                <h4 class="fw-bold mb-1 text-warning">Menunggu Konfirmasi</h4>
                                <p class="text-muted mb-0">Pesanan telah tercatat. <%= lastPayment != null && "Cash on Delivery".equals(lastPayment.getMetode()) ? "Siapkan dana tunai untuk kurir." : "Kami sedang memverifikasi pembayaran Anda." %></p>
                            <% } else { %>
                                <i class="ri-close-circle-fill ep-receipt-icon failed"></i>
                                <h4 class="fw-bold mb-1 text-danger">Pembayaran Gagal</h4>
                                <p class="text-muted mb-0">Silakan coba lakukan pembayaran ulang.</p>
                            <% } %>
                        </div>
                        
                        <div class="ep-receipt-body">
                            <% if (lastPayment != null) { %>
                                <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                                    <span class="text-muted small">Waktu Pembayaran</span>
                                    <span class="fw-medium small"><%= new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(lastPayment.getWaktuBayar()) %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                                    <span class="text-muted small">Metode</span>
                                    <span class="fw-medium small"><%= lastPayment.getSubMetode() %> (<%= lastPayment.getMetode() %>)</span>
                                </div>
                                
                                <% if (lastPayment.getKodeBayar() != null && !lastPayment.getKodeBayar().equals("-")) { %>
                                    <div class="mb-3 border-bottom pb-3 text-center">
                                        <span class="text-muted small d-block mb-2">Kode / VA / Referensi</span>
                                        <div class="ep-va-box fs-5 py-2"><%= lastPayment.getKodeBayar() %></div>
                                    </div>
                                <% } %>

                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <span class="text-muted fw-medium">Total Pembayaran</span>
                                    <span class="fw-bold fs-4 text-primary"><%= fmt.format(lastPayment.getJumlah()) %></span>
                                </div>
                            <% } else { %>
                                <div class="alert alert-warning text-center">Data riwayat tidak ditemukan.</div>
                            <% } %>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/buyer/orders" class="btn btn-primary btn-lg rounded-pill fw-bold shadow-sm">
                            Lihat Daftar Pesanan
                        </a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-light btn-lg rounded-pill fw-medium text-muted">
                            Kembali ke Beranda
                        </a>
                    </div>

                </div>
            </div>
        </div>

    </body>
</html>
