<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="models.Keranjang"%>
<%@page import="models.BarangKeranjang"%>
<%@page import="models.Produk"%>
<%@page import="models.EWallet"%>
<%@page import="models.TransferBank"%>
<%@page import="models.Kupon"%>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // Format angka -> "Rp150.000"
    String rp(double v) {
        return "Rp" + String.format(Locale.US, "%,.0f", v).replace(',', '.');
    }

    String esc(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/auth?login");
        return;
    }
    String ctx = request.getContextPath();

    Keranjang keranjang = (Keranjang) ses.getAttribute("keranjang");
    if (keranjang == null) {
        keranjang = new Keranjang();
        ses.setAttribute("keranjang", keranjang);
    }
    List<BarangKeranjang> items = keranjang.getDaftarItem();
    double total = keranjang.getTotalHarga();

    List<TransferBank> banks = new TransferBank().get();
    List<EWallet> wallets = new EWallet().get();

    Kupon appliedKupon = (Kupon) ses.getAttribute("appliedKupon");
    double discount = 0;
    if (appliedKupon != null) {
        discount = appliedKupon.hitungPotongan(total);
    }
    double finalTotal = total - discount;

    // Pesan info (mis. dari aksi checkout yang belum tersedia).
    String info = (String) ses.getAttribute("cartInfo");
    if (info != null) {
        ses.removeAttribute("cartInfo");
    }
    String error = (String) ses.getAttribute("error");
    if (error != null) {
        ses.removeAttribute("error");
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Keranjang Belanja - EpStore</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="<%= ctx%>/sources/buyer.css" rel="stylesheet">
    </head>

    <body>

        <jsp:include page="components/navbar.jsp">
            <jsp:param name="showSearch" value="false" />
        </jsp:include>

        <!-- ===================== CONTENT ===================== -->
        <main class="container py-4">

            <h1 class="ep-page-title">Keranjang Belanja</h1>

            <% if (info != null) {%>
            <div class="alert alert-info py-2"><%= esc(info)%></div>
            <% } %>
            <% if (error != null) {%>
            <div class="alert alert-danger py-2"><%= esc(error)%></div>
            <% } %>

            <% if (items == null || items.isEmpty()) {%>
            <!-- Empty state -->
            <div class="ep-cart-card">
                <div class="ep-empty">
                    <i class="bi bi-cart-x"></i>
                    Keranjang belanja kamu masih kosong.
                    <div class="mt-3">
                        <a href="<%= ctx%>/buyer" class="ep-btn-shop">
                            <i class="bi bi-bag"></i> Mulai Belanja
                        </a>
                    </div>
                </div>
            </div>
            <% } else { %>

            <!-- ===================== CART TABLE ===================== -->
            <div class="ep-cart-card">
                <div class="table-responsive">
                    <table class="ep-cart-table">
                        <thead>
                            <tr>
                                <th class="col-produk">Produk</th>
                                <th class="col-harga">Harga</th>
                                <th class="col-jumlah">Jumlah</th>
                                <th class="col-subtotal">Subtotal</th>
                                <th class="col-aksi">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (BarangKeranjang item : items) {
                                    Produk p = item.getProduk();
                                    int pid = p.getId();
                                    String nama = p.getNama();
                                    String gambar = p.getGambar();
                                    int qty = item.getQty();
                            %>
                            <tr>
                                <!-- Produk -->
                                <td>
                                    <div class="ep-cart-product">
                                        <a href="<%= ctx%>/produk?id=<%= pid%>" class="ep-cart-thumb">
                                            <i class="bi bi-image"></i>
                                            <% if (gambar != null && !gambar.isEmpty()) {%>
                                            <img src="<%= ctx%>/<%= esc(gambar)%>" alt="<%= esc(nama)%>"
                                                 onerror="this.remove();">
                                            <% }%>
                                        </a>
                                        <a href="<%= ctx%>/produk?id=<%= pid%>" class="ep-cart-name">
                                            <%= esc(nama)%>
                                        </a>
                                    </div>
                                </td>
                                <!-- Harga -->
                                <td class="ep-cart-cell"><%= rp(p.getHarga())%></td>
                                <!-- Jumlah -->
                                <td>
                                    <div class="ep-qty">
                                        <form method="post" action="<%= ctx%>/buyer/cart?dec" class="ep-qty-form">
                                            <input type="hidden" name="produkId" value="<%= pid%>">
                                            <button type="submit" aria-label="Kurangi"><i class="bi bi-dash"></i></button>
                                        </form>
                                        <span class="ep-qty-val"><%= qty%></span>
                                        <form method="post" action="<%= ctx%>/buyer/cart?inc" class="ep-qty-form">
                                            <input type="hidden" name="produkId" value="<%= pid%>">
                                            <button type="submit" aria-label="Tambah"><i class="bi bi-plus"></i></button>
                                        </form>
                                    </div>
                                </td>
                                <!-- Subtotal -->
                                <td class="ep-cart-cell ep-cart-subtotal"><%= rp(item.getSubtotal())%></td>
                                <!-- Aksi -->
                                <td>
                                    <form method="post" action="<%= ctx%>/buyer/cart?remove">
                                        <input type="hidden" name="produkId" value="<%= pid%>">
                                        <button type="submit" class="ep-btn-trash" aria-label="Hapus"
                                                title="Hapus dari keranjang">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>

                <!-- Total ringkas -->
                <div class="ep-cart-total-row">
                    <span class="ep-cart-total-label">Total</span>
                    <span class="ep-cart-total-value"><%= rp(total)%></span>
                </div>
            </div>

            <!-- ===================== PAYMENT + CHECKOUT ===================== -->
            <form method="post" action="<%= ctx%>/buyer/checkout">
                <div class="row g-4 mt-1">
                    <div class="col-lg-7">
                        <div class="ep-cart-card h-100">
                            <h2 class="ep-section-title mb-3">Metode Pembayaran</h2>
                            <%
                                boolean hasBanks = (banks != null && !banks.isEmpty());
                                boolean hasWallets = (wallets != null && !wallets.isEmpty());

                                // Open Bank by default if it has options, or if both are empty (as fallback)
                                boolean openBank = hasBanks || (!hasBanks && !hasWallets);
                                String bankCollapseClass = openBank ? "show" : "";
                                String bankButtonClass = openBank ? "" : "collapsed";
                                String bankAriaExpanded = openBank ? "true" : "false";

                                boolean openWallet = !hasBanks && hasWallets;
                                String walletCollapseClass = openWallet ? "show" : "";
                                String walletButtonClass = openWallet ? "" : "collapsed";
                                String walletAriaExpanded = openWallet ? "true" : "false";

                                boolean firstChecked = true;
                            %>
                            <div class="accordion ep-payment-accordion" id="paymentAccordion">
                                <!-- Transfer Bank Accordion -->
                                <div class="accordion-item border rounded-3 mb-3 overflow-hidden">
                                    <h3 class="accordion-header" id="headingBank">
                                        <button class="accordion-button fw-bold <%= bankButtonClass%>" type="button" data-bs-toggle="collapse" data-bs-target="#collapseBank" aria-expanded="<%= bankAriaExpanded%>" aria-controls="collapseBank">
                                            <i class="bi bi-bank me-2 text-primary"></i> Transfer Bank
                                        </button>
                                    </h3>
                                    <div id="collapseBank" class="accordion-collapse collapse <%= bankCollapseClass%>" aria-labelledby="headingBank" data-bs-parent="#paymentAccordion">
                                        <div class="accordion-body bg-light p-3">
                                            <%
                                                if (banks != null && !banks.isEmpty()) {
                                                    for (TransferBank bank : banks) {
                                                        String val = "Transfer Bank - " + bank.getNamaBank();
                                            %>
                                            <label class="d-block card p-3 mb-2 ep-payment-card rounded-3 shadow-sm border" for="payBank_<%= esc(bank.getNamaBank())%>">
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <input class="form-check-input mt-0" type="radio" name="metode"
                                                               id="payBank_<%= esc(bank.getNamaBank())%>" value="<%= esc(val)%>" <%= firstChecked ? "checked" : ""%>>
                                                        <div>
                                                            <span class="fw-bold d-block text-dark"><%= esc(bank.getNamaBank())%></span>
                                                            <small class="text-muted">No. Rekening: <%= esc(bank.getNoRekening())%></small>
                                                        </div>
                                                    </div>
                                                    <i class="bi bi-credit-card text-secondary fs-4"></i>
                                                </div>
                                            </label>
                                            <%
                                                    firstChecked = false;
                                                }
                                            } else {
                                            %>
                                            <label class="d-block card p-3 mb-2 ep-payment-card rounded-3 shadow-sm border" for="payTransfer">
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <input class="form-check-input mt-0" type="radio" name="metode"
                                                               id="payTransfer" value="Transfer Bank" <%= firstChecked ? "checked" : ""%>>
                                                        <div>
                                                            <span class="fw-bold d-block text-dark">Transfer Bank</span>
                                                            <small class="text-muted">Transfer manual</small>
                                                        </div>
                                                    </div>
                                                    <i class="bi bi-credit-card text-secondary fs-4"></i>
                                                </div>
                                            </label>
                                            <%
                                                    firstChecked = false;
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>

                                <!-- E-Wallet Accordion -->
                                <div class="accordion-item border rounded-3 mb-3 overflow-hidden">
                                    <h3 class="accordion-header" id="headingWallet">
                                        <button class="accordion-button fw-bold <%= walletButtonClass%>" type="button" data-bs-toggle="collapse" data-bs-target="#collapseWallet" aria-expanded="<%= walletAriaExpanded%>" aria-controls="collapseWallet">
                                            <i class="bi bi-wallet2 me-2 text-primary"></i> E-Wallet
                                        </button>
                                    </h3>
                                    <div id="collapseWallet" class="accordion-collapse collapse <%= walletCollapseClass%>" aria-labelledby="headingWallet" data-bs-parent="#paymentAccordion">
                                        <div class="accordion-body bg-light p-3">
                                            <%
                                                if (wallets != null && !wallets.isEmpty()) {
                                                    for (EWallet wallet : wallets) {
                                                        String val = "E-Wallet - " + wallet.getPlatform();
                                            %>
                                            <label class="d-block card p-3 mb-2 ep-payment-card rounded-3 shadow-sm border" for="payEwallet_<%= esc(wallet.getPlatform())%>">
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <input class="form-check-input mt-0" type="radio" name="metode"
                                                               id="payEwallet_<%= esc(wallet.getPlatform())%>" value="<%= esc(val)%>" <%= firstChecked ? "checked" : ""%>>
                                                        <div>
                                                            <span class="fw-bold d-block text-dark"><%= esc(wallet.getPlatform())%></span>
                                                            <small class="text-muted">No. HP: <%= esc(wallet.getNomorHp())%></small>
                                                        </div>
                                                    </div>
                                                    <i class="bi bi-phone text-secondary fs-4"></i>
                                                </div>
                                            </label>
                                            <%
                                                    firstChecked = false;
                                                }
                                            } else {
                                            %>
                                            <label class="d-block card p-3 mb-2 ep-payment-card rounded-3 shadow-sm border" for="payEwallet">
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <input class="form-check-input mt-0" type="radio" name="metode"
                                                               id="payEwallet" value="E-Wallet" <%= firstChecked ? "checked" : ""%>>
                                                        <div>
                                                            <span class="fw-bold d-block text-dark">E-Wallet</span>
                                                            <small class="text-muted">E-Wallet Platform</small>
                                                        </div>
                                                    </div>
                                                    <i class="bi bi-phone text-secondary fs-4"></i>
                                                </div>
                                            </label>
                                            <%
                                                    firstChecked = false;
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Ringkasan Pembayaran -->
                    <div class="col-lg-5">
                        <div class="ep-summary-card">
                            <div class="mb-3">
                                <label class="form-label fw-bold text-dark mb-1" style="font-size: 0.85rem;">Kupon Promo</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" name="couponCode" placeholder="Masukkan kode promo" 
                                           value="<%= appliedKupon != null ? esc(appliedKupon.getKodePromo()) : "" %>"
                                           <%= appliedKupon != null ? "readonly" : "" %>>
                                    <% if (appliedKupon == null) { %>
                                        <button class="btn btn-outline-primary" type="submit" name="applyCoupon" value="1" formaction="<%= ctx%>/buyer/cart">Apply</button>
                                    <% } else { %>
                                        <button class="btn btn-outline-danger" type="submit" name="removeCoupon" value="1" formaction="<%= ctx%>/buyer/cart">Batal</button>
                                    <% } %>
                                </div>
                            </div>
                            <hr class="my-3">
                            <% if (appliedKupon != null) { %>
                                <div class="ep-summary-row" style="font-size: 0.95rem;">
                                    <span>Total Awal</span>
                                    <span class="text-secondary"><%= rp(total) %></span>
                                </div>
                                <div class="ep-summary-row text-success mb-2" style="font-size: 0.95rem;">
                                    <span>Potongan (<%= String.format("%.0f", appliedKupon.getPersenDiskon()) %>%)</span>
                                    <span>- <%= rp(discount) %></span>
                                </div>
                            <% } %>
                            <div class="ep-summary-row mb-3">
                                <span>Total Pembayaran</span>
                                <span class="ep-summary-total"><%= rp(finalTotal)%></span>
                            </div>
                            <button type="submit" class="ep-btn-checkout">Checkout</button>
                        </div>
                    </div>
                </div>
            </form>
            <% }%>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
