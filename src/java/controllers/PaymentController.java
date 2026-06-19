package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.EWallet;
import interfaces.Payable;
import models.Transaksi;
import models.TransferBank;

@WebServlet(name = "PaymentController", urlPatterns = {"/buyer/payment"})
public class PaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Transaksi t = getValidTransaksi(req, res);
        if (t == null) return;

        String info = "", m = t.getMetode();
        String name = m != null && m.contains(" - ") ? m.split(" - ", 2)[1] : (m != null ? m : "-");
        if (m != null && m.toLowerCase().contains("wallet")) {
            EWallet w = new EWallet().getDetail(name);
            if (w != null) info = "Nomor HP " + w.getPlatform() + ": <strong>" + w.getNomorHp() + "</strong>";
        } else if (m != null && m.toLowerCase().contains("bank")) {
            TransferBank b = new TransferBank().getDetail(name);
            if (b != null) info = "No. Rekening " + b.getNamaBank() + ": <strong>" + b.getNoRekening() + "</strong>";
        }
        
        req.setAttribute("paymentInfo", info);
        req.setAttribute("transaksi", t);
        req.getRequestDispatcher("/buyer/payment.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Transaksi t = getValidTransaksi(req, res);
        if (t == null) return;

        String action = req.getParameter("action");
        if ("success".equals(action)) {
            boolean ok = buatMetodeBayar(t.getMetode()).prosesBayar(t.getTotalHarga());
            t.updateStatusPembayaran(ok);
            req.getSession(false).setAttribute("orderInfo", ok ? "Pembayaran berhasil. Pesanan sedang diproses." : "Pembayaran gagal diproses. Silakan coba lagi.");
        } else if ("waiting".equals(action)) {
            t.updateStatusPembayaran(false);
            req.getSession(false).setAttribute("orderInfo", "Pesanan disimpan dengan status Menunggu Pembayaran.");
        }
        res.sendRedirect(req.getContextPath() + "/buyer/orders");
    }

    private Transaksi getValidTransaksi(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("username") == null) {
            res.sendRedirect(req.getContextPath() + "/auth?login");
            return null;
        }
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                Transaksi t = new Transaksi().find(idStr.trim());
                if (t != null && t.getPembeliId().equals(s.getAttribute("pembeli_id"))) return t;
            } catch (Exception ignored) {}
        }
        res.sendRedirect(req.getContextPath() + "/buyer/orders");
        return null;
    }

    private Payable buatMetodeBayar(String m) {
        String name = m != null && m.contains(" - ") ? m.split(" - ", 2)[1] : (m != null ? m : "-");
        if (m != null && m.toLowerCase().contains("wallet")) {
            EWallet w = new EWallet().getDetail(name);
            return w != null ? w : new EWallet(name, "-");
        }
        TransferBank b = new TransferBank().getDetail(name);
        return b != null ? b : new TransferBank(name, "-");
    }
}
