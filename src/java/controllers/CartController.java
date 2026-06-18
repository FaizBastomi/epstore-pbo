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
import models.Pembeli;
import models.Transaksi;

@WebServlet(name = "CartController", urlPatterns = {"/buyer/cart", "/buyer/checkout"})
public class CartController extends HttpServlet {

    private Keranjang getCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return null;
        }

        Pembeli p = new Pembeli().getPembeliByUsername((String) session.getAttribute("username"));
        if (p == null) {
            return null;
        }

        Keranjang k = new Keranjang();
        k.where("id_pembeli = '" + p.getId() + "'");
        ArrayList<Keranjang> list = k.get();
        if (list.isEmpty()) {
            k.setIdPembeli(p.getId());
            k.setTotalHarga(0);
            k.insert();
            k.where("id_pembeli = '" + p.getId() + "'");
            list = k.get();
        }

        Keranjang cart = list.get(0);
        session.setAttribute("keranjang", cart);
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
                int id = t.buatPesanan(cart, cart.getIdPembeli(), request.getParameter("metode"));
                if (id > 0) {
                    cart.kosongkanKeranjang();
                    response.sendRedirect(request.getContextPath() + "/buyer/payment?id=" + id);
                    return;
                }
                request.getSession().setAttribute("error", t.getMessage());
            }
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
