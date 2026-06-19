<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="models.Transaksi"%>
<%@page import="models.TransaksiItem"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String rp(double v) {
        return "Rp" + String.format(Locale.US, "%,.0f", v).replace(',', '.');
    }
    String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;");
    }
    // Kelas CSS badge sesuai status pesanan.
    String badgeClass(String status) {
        if (status == null) return "ep-status-menunggu";
        switch (status) {
            case "Diproses": return "ep-status-diproses";
            case "Dikirim":  return "ep-status-dikirim";
            case "Selesai":  return "ep-status-selesai";
            default:         return "ep-status-menunggu";
        }
    }
    // Ringkasan nama produk pada satu pesanan (dipisah koma).
    String ringkasProduk(List<TransaksiItem> items) {
        if (items == null || items.isEmpty()) return "-";
        StringBuilder sb = new StringBuilder();
        for (TransaksiItem it : items) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(it.getNamaProduk());
        }
        return sb.toString();
    }
%>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?login");
        return;
    }
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<Transaksi> pesananList = (List<Transaksi>) request.getAttribute("pesananList");

    String activeStatus = (String) request.getAttribute("activeStatus");
    if (activeStatus == null || activeStatus.isEmpty()) {
        activeStatus = "Semua";
    }

    String[] tabs = {"Semua", "Menunggu Pembayaran", "Diproses", "Dikirim", "Selesai"};

    DateTimeFormatter tglFmt = DateTimeFormatter.ofPattern("d MMM yyyy", new Locale("id", "ID"));

    // Pesan info (mis. hasil dari halaman pembayaran).
    String info = (String) ses.getAttribute("orderInfo");
    if (info != null) {
        ses.removeAttribute("orderInfo");
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pesanan Saya - EpStore</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="<%= ctx %>/sources/buyer.css" rel="stylesheet">
    </head>

    <body>

        <!-- ===================== TOP NAVBAR ===================== -->
        <jsp:include page="components/navbar.jsp" />

        <!-- ===================== CONTENT ===================== -->
        <main class="container py-4" style="max-width: 900px;">

            <h1 class="ep-page-title">Pesanan Saya</h1>

            <% if (info != null) { %>
            <div class="alert alert-success py-2"><%= esc(info) %></div>
            <% } %>

            <!-- ===================== TABS FILTER STATUS ===================== -->
            <div class="ep-order-tabs">
                <% for (String tab : tabs) {
                       boolean isActive = tab.equals(activeStatus);
                       String href = ctx + "/buyer/orders"
                               + (tab.equals("Semua") ? "" : "?status=" + tab.replace(" ", "%20"));
                %>
                <a href="<%= href %>" class="ep-order-tab <%= isActive ? "active" : "" %>"><%= tab %></a>
                <% } %>
            </div>

            <!-- ===================== DAFTAR PESANAN ===================== -->
            <% if (pesananList == null || pesananList.isEmpty()) { %>
            <div class="ep-cart-card">
                <div class="ep-empty">
                    <i class="bi bi-receipt"></i>
                    Belum ada pesanan pada kategori ini.
                    <div class="mt-3">
                        <a href="<%= ctx %>/buyer" class="ep-btn-shop">
                            <i class="bi bi-bag"></i> Mulai Belanja
                        </a>
                    </div>
                </div>
            </div>
            <% } else {
                   for (Transaksi t : pesananList) {
                       List<TransaksiItem> items = t.getDaftarItem();
                       String status = t.getStatus();
                       String tanggal = (t.getTanggal() != null) ? t.getTanggal().format(tglFmt) : "-";
            %>
            <div class="ep-order-card">
                <!-- Header: nomor order + tanggal -->
                <div class="ep-order-head">
                    <span class="ep-order-id">Order #<%= String.format("%03d", t.getId()) %></span>
                    <span class="ep-order-date"><%= tanggal %></span>
                </div>

                <!-- Ringkasan produk -->
                <div class="ep-order-products"><%= esc(ringkasProduk(items)) %></div>

                <!-- Footer: total + status + aksi -->
                <div class="ep-order-foot">
                    <span class="ep-order-total">Total: <strong><%= rp(t.getTotalHarga()) %></strong></span>
                    <div class="ep-order-actions">
                        <span class="ep-status-badge <%= badgeClass(status) %>"><%= esc(status) %></span>
                        <% if ("Menunggu Pembayaran".equals(status)) { %>
                        <a href="<%= ctx %>/buyer/payment?id=<%= t.getId() %>" class="ep-btn-order">
                            Bayar Sekarang
                        </a>
                        <% } else if ("Selesai".equals(status)) { %>
                        <a href="<%= ctx %>/buyer/reviews" class="ep-btn-order">Beri Ulasan</a>
                        <% } else { %>
                        <a href="<%= ctx %>/buyer/payment?id=<%= t.getId() %>" class="ep-btn-order">
                            Lihat Detail
                        </a>
                        <% } %>
                    </div>
                </div>
            </div>
            <%     }
               } %>

        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
