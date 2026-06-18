<%@page import="models.Keranjang"%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath();
    boolean showSearch = "true".equals(request.getParameter("showSearch"));
    String keyword = request.getParameter("keyword");
    if (keyword == null) {
        keyword = "";
    }
    String username = "";
    if (session != null && session.getAttribute("username") != null) {
        username = (String) session.getAttribute("username");
    }
    Keranjang keranjangNavbar = (session != null) ? (Keranjang) session.getAttribute("keranjang") : null;
    if (keranjangNavbar == null && session != null && session.getAttribute("pembeli_id") != null) {
        String pId = (String) session.getAttribute("pembeli_id");
        Keranjang cModel = new Keranjang();
        cModel.where("id_pembeli = '" + pId + "'");
        java.util.ArrayList<Keranjang> carts = cModel.get();
        if (carts != null && !carts.isEmpty()) {
            keranjangNavbar = carts.get(0);
        } else {
            keranjangNavbar = new Keranjang();
            keranjangNavbar.setIdPembeli(pId);
            keranjangNavbar.setTotalHarga(0);
            keranjangNavbar.insert();
            cModel.where("id_pembeli = '" + pId + "'");
            carts = cModel.get();
            keranjangNavbar = carts.get(0);
        }
        session.setAttribute("keranjang", keranjangNavbar);
    }
    int cartCountNavbar = (keranjangNavbar != null) ? keranjangNavbar.getTotalItem() : 0;

    String uriNavbar = request.getRequestURI();
    boolean isCartPage = uriNavbar.endsWith("cart.jsp") || uriNavbar.endsWith("/cart");
%>
<!-- ===================== TOP NAVBAR ===================== -->
<nav class="ep-navbar">
    <div class="container py-2">
        <% if (showSearch) {%>
        <div class="row align-items-center g-2">
            <!-- Brand -->
            <div class="col-auto">
                <a href="<%= ctx%>/buyer" class="ep-brand">
                    <i class="bi bi-bag-fill"></i> EpStore
                </a>
            </div>

            <!-- Search -->
            <div class="col">
                <form class="ep-search" action="<%= ctx%>/buyer" method="GET">
                    <div class="input-group">
                        <input type="text" name="q" class="form-control" placeholder="Cari produk..." value="<%= keyword.replace(" \"", "&quot;")%>">
                        <button class="btn" type="submit" aria-label="Cari">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>
            </div>

            <!-- Actions -->
            <div class="col-auto">
                <div class="d-flex align-items-center gap-4">
                    <a href="<%= ctx%>/buyer/cart" class="ep-nav-action <%= isCartPage ? "active" : ""%>">
                        <span class="position-relative">
                            <i class="bi bi-cart3 fs-5"></i>
                            <% if (cartCountNavbar > 0) {%>
                            <span class="ep-cart-badge"><%= cartCountNavbar%></span>
                            <% }%>
                        </span>
                        Keranjang
                    </a>

                    <!-- User Dropdown Menu -->
                    <div class="dropdown">
                        <a href="#" class="ep-nav-action dropdown-toggle d-flex align-items-center gap-1" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-person-circle fs-5"></i>
                            <span>
                                <%= username%>
                            </span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                            <li>
                                <a class="dropdown-item d-flex align-items-center gap-2"
                                   href="<%= ctx%>/buyer/user_setting.jsp">
                                    <i class="bi bi-gear"></i> Pengaturan
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center gap-2"
                                   href="<%= ctx%>/seller">
                                    <i class="bi bi-shop"></i> Mode Penjual
                                </a>
                            </li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li>
                                <a class="dropdown-item text-danger d-flex align-items-center gap-2"
                                   href="<%= ctx%>/auth?logout">
                                    <i class="bi bi-box-arrow-right"></i> Logout
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <% } else {%>
        <div class="d-flex align-items-center justify-content-between">
            <a href="<%= ctx%>/buyer" class="ep-brand">
                <i class="bi bi-bag-fill"></i> EpStore
            </a>
            <div class="d-flex align-items-center gap-4">
                <a href="<%= ctx%>/buyer/cart" class="ep-nav-action <%= isCartPage ? "active" : ""%>">
                    <span class="position-relative">
                        <i class="bi bi-cart3 fs-5"></i>
                        <% if (cartCountNavbar > 0) {%>
                        <span class="ep-cart-badge"><%= cartCountNavbar%></span>
                        <% }%>
                    </span>
                    Keranjang
                </a>

                <!-- User Dropdown Menu -->
                <div class="dropdown">
                    <a href="#" class="ep-nav-action dropdown-toggle d-flex align-items-center gap-1" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle fs-5"></i>
                        <span>
                            <%= username%>
                        </span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                        <li>
                            <a class="dropdown-item d-flex align-items-center gap-2"
                               href="<%= ctx%>/buyer/user_setting.jsp">
                                <i class="bi bi-gear"></i> Pengaturan
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item d-flex align-items-center gap-2"
                               href="<%= ctx%>/seller/index.jsp">
                                <i class="bi bi-shop"></i> Mode Penjual
                            </a>
                        </li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <li>
                            <a class="dropdown-item text-danger d-flex align-items-center gap-2"
                               href="<%= ctx%>/auth?logout">
                                <i class="bi bi-box-arrow-right"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <% }%>
    </div>
</nav>