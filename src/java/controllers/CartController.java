package controllers;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.BarangKeranjang;
import models.Keranjang;
import models.Transaksi;
import models.Kupon;

@WebServlet(name = "CartController", urlPatterns = {"/buyer/cart", "/buyer/checkout"})
public class CartController extends HttpServlet {

    private Keranjang getCart(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("username") == null) {
            res.sendRedirect(req.getContextPath() + "/auth?login");
            return null;
        }

        String pId = (String) s.getAttribute("pembeli_id");
        if (pId == null) return null;

        Keranjang k = new Keranjang();
        k.where("id_pembeli = '" + pId + "'");
        ArrayList<Keranjang> list = k.get();
        if (list.isEmpty()) {
            k.setIdPembeli(pId);
            k.setTotalHarga(0);
            k.insert();
            k.where("id_pembeli = '" + pId + "'");
            list = k.get();
        }

        Keranjang cart = list.get(0);
        s.setAttribute("keranjang", cart);
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (getCart(request, response) != null) {
            request.getRequestDispatcher("/buyer/cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Keranjang cart = getCart(request, response);
        if (cart == null) {
            return;
        }

        if ("/buyer/checkout".equals(request.getServletPath())) {
            if (!cart.isEmpty()) {
                Transaksi t = new Transaksi();
                String code = request.getParameter("couponCode");
                int id = t.buatPesanan(cart, cart.getIdPembeli(), request.getParameter("metode"), code);
                if (id > 0) {
                    cart.kosongkanKeranjang();
                    request.getSession().removeAttribute("appliedKupon");
                    response.sendRedirect(request.getContextPath() + "/buyer/payment?id=" + id);
                    return;
                }
                request.getSession().setAttribute("error", t.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/buyer/cart");
            return;
        }

        if (request.getParameter("applyCoupon") != null) {
            String code = request.getParameter("couponCode");
            if (code != null && !code.trim().isEmpty()) {
                Kupon kupon = new Kupon().find(code.trim());
                if (kupon != null && kupon.cekMasaBerlaku()) {
                    request.getSession().setAttribute("appliedKupon", kupon);
                } else {
                    request.getSession().setAttribute("error", "Kupon tidak valid atau sudah kedaluwarsa.");
                }
            }
            response.sendRedirect(request.getContextPath() + "/buyer/cart");
            return;
        }

        if (request.getParameter("removeCoupon") != null) {
            request.getSession().removeAttribute("appliedKupon");
            response.sendRedirect(request.getContextPath() + "/buyer/cart");
            return;
        }

        try {
            int produkId = Integer.parseInt(request.getParameter("produkId"));
            if (request.getParameter("add") != null) {
                int qty = request.getParameter("qty") != null ? Integer.parseInt(request.getParameter("qty")) : 1;
                cart.tambahItem(produkId, qty);
            } else if (request.getParameter("remove") != null) {
                cart.hapusItem(produkId);
            } else if (request.getParameter("inc") != null || request.getParameter("dec") != null) {
                BarangKeranjang bk = cart.getItem(produkId);
                if (bk != null) cart.ubahQty(produkId, bk.getQty() + (request.getParameter("inc") != null ? 1 : -1));
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/buyer/cart");
    }
}
