<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // Temporary Dummy Class simulating database model
    public static class PesananDummy {

        private String id;
        private String pembeli;
        private double total;
        private String status;

        public PesananDummy(String id, String pembeli, double total, String status) {
            this.id = id;
            this.pembeli = pembeli;
            this.total = total;
            this.status = status;
        }

        public String getId() {
            return id;
        }

        public String getPembeli() {
            return pembeli;
        }

        public double getTotal() {
            return total;
        }

        public String getStatus() {
            return status;
        }
    }
%>
<%
    String ctx = request.getContextPath();

    // Dummy data prepared for database mapping replacement
    java.util.List<PesananDummy> pesananList = new java.util.ArrayList<>();
    pesananList.add(new PesananDummy("#001", "Budi", 420000, "Diproses"));
    pesananList.add(new PesananDummy("#002", "Ani", 150000, "Dikirim"));
    pesananList.add(new PesananDummy("#003", "Citra", 98000, "Baru"));
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Penjual - EpStore</title>

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
                <jsp:param name="activePage" value="dashboard" />
            </jsp:include>

            <!-- Content Area -->
            <div class="seller-content">
                <!-- Topbar -->
                <jsp:include page="components/topbar.jsp" />

                <!-- Main Dashboard Content -->
                <main class="dashboard-main">
                    <h1 class="dashboard-title">Dashboard</h1>

                    <!-- Recent Orders Table -->
                    <div class="card table-card mt-0">
                        <div class="table-card-header">
                            <h2 class="table-card-title">Pesanan Terbaru</h2>
                            <a href="<%= ctx%>/seller/pesanan.jsp" class="btn-see-all">Lihat Semua</a>
                        </div>
                        <div class="table-card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" style="font-size: 0.95rem;">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-4 py-3" style="font-weight: 600; color: #5a5c69;">Order</th>
                                            <th class="py-3" style="font-weight: 600; color: #5a5c69;">Pembeli</th>
                                            <th class="py-3" style="font-weight: 600; color: #5a5c69;">Total</th>
                                            <th class="pe-4 py-3" style="font-weight: 600; color: #5a5c69;">Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (pesananList != null && !pesananList.isEmpty()) {
                                                for (PesananDummy p : pesananList) {
                                                    String statusClass = "";
                                                    String status = p.getStatus();
                                                    if ("Diproses".equalsIgnoreCase(status)) {
                                                        statusClass = "status-diproses";
                                                    } else if ("Dikirim".equalsIgnoreCase(status)) {
                                                        statusClass = "status-dikirim";
                                                    } else if ("Baru".equalsIgnoreCase(status)) {
                                                        statusClass = "status-baru";
                                                    }
                                                    String hargaFmt = String.format(java.util.Locale.US, "%,.0f", p.getTotal()).replace(',', '.');
                                        %>
                                        <tr>
                                            <td class="ps-4 py-3 text-dark fw-bold"><%= p.getId()%></td>
                                            <td class="py-3"><%= p.getPembeli()%></td>
                                            <td class="py-3">Rp<%= hargaFmt%></td>
                                            <td class="pe-4 py-3">
                                                <span class="status-badge <%= statusClass%>"><%= status%></span>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        } else {
                                        %>
                                        <tr>
                                            <td colspan="4" class="text-center py-4 text-muted">Belum ada pesanan masuk.</td>
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
