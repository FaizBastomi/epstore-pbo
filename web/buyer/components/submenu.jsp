<%
    String ctx = request.getContextPath();
    String activePage = request.getParameter("active");
%>
<!-- ===================== SECONDARY MENU ===================== -->
<div class="ep-submenu">
    <div class="container">
        <div class="d-flex gap-4">
            <a href="<%= ctx%>/buyer" class="<%= "home".equals(activePage) ? "active" : "" %>">Home</a>
            <a href="<%= ctx%>/buyer#kategori" class="<%= "kategori".equals(activePage) ? "active" : "" %>">Kategori</a>
            <a href="<%= ctx%>/buyer/orders" class="<%= "orders".equals(activePage) ? "active" : "" %>">Pesanan Saya</a>
            <a href="<%= ctx%>/buyer/reviews" class="<%= "reviews".equals(activePage) ? "active" : "" %>">Ulasan</a>
        </div>
    </div>
</div>
