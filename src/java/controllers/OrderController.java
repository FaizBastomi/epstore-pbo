package controllers;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Transaksi;

@WebServlet(name = "OrderController", urlPatterns = {"/buyer/orders"})
public class OrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("username") == null) {
            res.sendRedirect(req.getContextPath() + "/auth?login");
            return;
        }

        String stat = req.getParameter("status");
        String pId = (String) s.getAttribute("pembeli_id");
        
        Transaksi t = new Transaksi();
        String w = "pembeli_id = '" + (pId == null ? "" : pId).replace("'", "''") + "'";
        if (stat != null && !stat.isEmpty() && !stat.equals("Semua")) {
            w += " AND status = '" + stat.replace("'", "''") + "'";
        }
        t.where(w + " ORDER BY id DESC");
        
        ArrayList<Transaksi> list = t.get();
        req.setAttribute("pesananList", list != null ? list : new ArrayList<>());
        req.setAttribute("activeStatus", (stat == null || stat.isEmpty()) ? "Semua" : stat);
        req.getRequestDispatcher("/buyer/orders.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doGet(req, res);
    }
}
