<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
%>
<header class="seller-topbar">
    <div class="topbar-right">
        <!-- Mode Pembeli -->
        <a href="<%= ctx %>/buyer" class="mode-pembeli-btn">
            <i class="bi bi-bag fs-5"></i>
            <span>Mode Pembeli</span>
        </a>
    </div>
</header>
