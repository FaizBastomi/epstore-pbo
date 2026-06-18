<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String activePage = request.getParameter("activePage");
    if (activePage == null) {
        activePage = "dashboard";
    }
    String ctx = request.getContextPath();
%>
<aside class="seller-sidebar">
    <div class="sidebar-header">
        <h5 class="m-0 fw-bold text-dark"><i class="bi bi-shop me-2 text-success" style="color: #137333 !important;"></i>Area Penjual</h5>
    </div>
    <ul class="nav flex-column sidebar-nav">
        <li class="nav-item">
            <a href="<%= ctx %>/seller" class="nav-link <%= "dashboard".equals(activePage) ? "active" : "" %>">
                <i class="bi bi-grid-1x2-fill"></i> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= ctx %>/seller/produk" class="nav-link <%= "produk".equals(activePage) ? "active" : "" %>">
                <i class="bi bi-box-seam"></i> Produk
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= ctx %>/seller/pesanan" class="nav-link <%= "pesanan".equals(activePage) ? "active" : "" %>">
                <i class="bi bi-receipt"></i> Pesanan
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= ctx %>/seller/ulasan" class="nav-link <%= "ulasan".equals(activePage) ? "active" : "" %>">
                <i class="bi bi-chat-left-text"></i> Ulasan
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= ctx %>/seller/setting" class="nav-link <%= "pengaturan".equals(activePage) ? "active" : "" %>">
                <i class="bi bi-gear"></i> Pengaturan Toko
            </a>
        </li>
    </ul>
</aside>
