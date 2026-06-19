<%@page import="java.util.List"%>
<%@page import="models.Transaksi"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    List<Transaksi> orders = (List<Transaksi>) request.getAttribute("orders");
    if (orders == null) {
        orders = new java.util.ArrayList<>();
    }
    String activeStatus = (String) request.getAttribute("activeStatus");
    if (activeStatus == null) {
        activeStatus = "Semua";
    }
    String[] tabs = {"Semua", "Baru", "Diproses", "Dikirim", "Selesai"};
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pesanan Masuk - EpStore</title>

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
            <jsp:include page="components/sidebar.jsp">
                <jsp:param name="activePage" value="pesanan" />
            </jsp:include>

            <!-- Content Area -->
            <div class="seller-content">
                <!-- Topbar -->
                <jsp:include page="components/topbar.jsp" />

                <!-- Main Content -->
                <main class="dashboard-main">
                    <h1 class="dashboard-title">Pesanan Masuk</h1>

                    <!-- Status Filter Tabs -->
                    <div class="order-tabs">
                        <% for (String tab : tabs) {
                            boolean isActive = tab.equals(activeStatus);
                            String href = ctx + "/seller/pesanan" + (tab.equals("Semua") ? "" : "?status=" + tab);
                        %>
                        <a href="<%= href %>" class="order-tab <%= isActive ? "active" : "" %>"><%= tab %></a>
                        <% } %>
                    </div>

                    <!-- Orders Table -->
                    <div class="card table-card mt-0">
                        <div class="table-card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" style="font-size: 0.95rem;">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-4 py-3" style="font-weight: 600; color: #5a5c69;">Order</th>
                                            <th class="py-3" style="font-weight: 600; color: #5a5c69;">Pembeli</th>
                                            <th class="py-3" style="font-weight: 600; color: #5a5c69;">Total</th>
                                            <th class="py-3" style="font-weight: 600; color: #5a5c69;">Status</th>
                                            <th class="pe-4 py-3 text-center" style="width: 160px; font-weight: 600; color: #5a5c69;">Aksi</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (!orders.isEmpty()) {
                                                for (Transaksi order : orders) {
                                                    String status = order.getStatus();
                                                    String displayStatus = status;
                                                    String statusClass = "status-baru";
                                                    String actionText = "";
                                                    String nextStatus = "";

                                                    if ("Menunggu Pembayaran".equalsIgnoreCase(status)) {
                                                         displayStatus = "Belum Bayar";
                                                         statusClass = "status-baru";
                                                     } else if ("Dibayar".equalsIgnoreCase(status)) {
                                                         displayStatus = "Baru";
                                                         statusClass = "status-baru";
                                                         actionText = "Proses";
                                                         nextStatus = "Diproses";
                                                     } else if ("Diproses".equalsIgnoreCase(status)) {
                                                         displayStatus = "Diproses";
                                                         statusClass = "status-diproses";
                                                         actionText = "Kirim";
                                                         nextStatus = "Dikirim";
                                                     } else if ("Dikirim".equalsIgnoreCase(status)) {
                                                         displayStatus = "Dikirim";
                                                         statusClass = "status-dikirim";
                                                     } else if ("Selesai".equalsIgnoreCase(status)) {
                                                         displayStatus = "Selesai";
                                                         statusClass = "status-selesai";
                                                     }

                                                    String hargaFmt = String.format(Locale.US, "%,.0f", order.getTotalHarga()).replace(',', '.');
                                        %>
                                        <tr>
                                            <td class="ps-4 py-3 text-dark fw-bold">#<%= String.format("%03d", order.getId()) %></td>
                                            <td class="py-3 text-secondary"><%= ((java.util.Map<String,String>)request.getAttribute("buyerNames")).get(order.getPembeliId()) %></td>
                                            <td class="py-3 text-dark fw-semibold">Rp<%= hargaFmt %></td>
                                            <td class="py-3">
                                                <span class="status-badge <%= statusClass %>"><%= displayStatus %></span>
                                            </td>
                                            <td class="pe-4 py-3 text-center">
                                                <% if (!actionText.isEmpty()) { %>
                                                <form action="<%= ctx %>/seller/pesanan" method="POST" class="m-0">
                                                    <input type="hidden" name="action" value="update_status">
                                                    <input type="hidden" name="id" value="<%= order.getId() %>">
                                                    <input type="hidden" name="status" value="<%= nextStatus %>">
                                                    <button type="submit" class="btn btn-flat-action"><%= actionText %></button>
                                                </form>
                                                <% } else { %>
                                                <span class="text-muted" style="font-size: 0.9rem;">-</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">
                                                <i class="bi bi-receipt d-block mb-2 fs-3"></i>
                                                Belum ada pesanan pada kategori ini.
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
