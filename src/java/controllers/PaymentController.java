package controllers;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import models.COD;
import models.EWallet;
import models.Payable;
import models.PaymentMethod;
import models.PaymentStatus;
import models.QRIS;
import models.RiwayatPembayaran;
import models.Transaksi;
import models.TransferBank;

/**
 * PaymentController — Menangani logika tampilan (GET) dan pemrosesan (POST) pembayaran.
 *
 * <p>Menerapkan konsep <strong>Polymorphism</strong> melalui antarmuka {@link Payable} dan
 * pola desain <strong>Factory Method</strong> sederhana untuk menginisiasi jenis pembayaran.</p>
 *
 * <p>Route URL:
 * <ul>
 *   <li>{@code /buyer/payment} — Form pemilihan metode pembayaran.</li>
 *   <li>{@code /buyer/payment/receipt} — Halaman resi pembayaran.</li>
 * </ul>
 * </p>
 *
 * @author Payment Module (Kelompok 5)
 */
@WebServlet(name = "PaymentController", urlPatterns = {"/buyer/payment", "/buyer/payment/receipt"})
public class PaymentController extends HttpServlet {

    /** Biaya tetap ongkos kirim. */
    private static final double ONGKIR = 15000.0;
    
    /** Pajak PPN. */
    private static final double PAJAK_PERSEN = 0.11;

    /**
     * Memverifikasi sesi dan otorisasi pesanan.
     */
    private Transaksi verifikasiOtorisasi(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || session.getAttribute("pembeli_id") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?login");
            return null;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/buyer/orders");
            return null;
        }

        int trxId;
        try {
            trxId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/buyer/orders");
            return null;
        }

        int pembeliId = (Integer) session.getAttribute("pembeli_id");
        Transaksi trx = new Transaksi().find(trxId);

        // Pastikan transaksi ada dan milik pembeli yang login
        if (trx == null || trx.getIdPembeli() != pembeliId) {
            response.sendRedirect(request.getContextPath() + "/buyer/orders");
            return null;
        }

        return trx;
    }

    /**
     * Factory Method pembentukan objek {@link Payable} berdasarkan jenis pilihan.
     */
    private Payable buatMetodeBayar(PaymentMethod metode) {
        switch (metode) {
            case E_WALLET:
                return new EWallet();
            case QRIS:
                return new QRIS();
            case COD:
                return new COD();
            case TRANSFER_BANK:
            default:
                return new TransferBank();
        }
    }

    /**
     * Membuat kode bayar dummy (nomor VA, nomor e-wallet, kode QR).
     */
    private String generateKodeBayar(PaymentMethod metode, String subMetode) {
        switch (metode) {
            case TRANSFER_BANK:
                return "88000" + (1000000 + (int)(Math.random() * 8999999));
            case E_WALLET:
                return "08" + (100000000 + (int)(Math.random() * 899999999));
            case QRIS:
                return "QR-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            case COD:
                return "COD-" + System.currentTimeMillis();
            default:
                return "-";
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        Transaksi trx = verifikasiOtorisasi(request, response);
        if (trx == null) return;

        // Ambil data detail item
        request.setAttribute("transaksi", trx);
        request.setAttribute("items", trx.getItems());
        
        // Hitung total dengan ongkir & pajak
        double subtotal = trx.getTotalBayar(); // Ini sebenernya subtotal dari keranjang/transaksi awal (harga item * qty)
        double pajak = subtotal * PAJAK_PERSEN;
        double grandTotal = subtotal + ONGKIR + pajak;
        
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("ongkir", ONGKIR);
        request.setAttribute("pajak", pajak);
        request.setAttribute("grandTotal", grandTotal);

        if ("/buyer/payment/receipt".equals(path)) {
            request.getRequestDispatcher("/buyer/payment_receipt.jsp").forward(request, response);
        } else {
            // Jika sudah dibayar, langsung ke receipt
            if (!"Menunggu Pembayaran".equalsIgnoreCase(trx.getStatusPembayaran())) {
                response.sendRedirect(request.getContextPath() + "/buyer/payment/receipt?id=" + trx.getId());
                return;
            }
            request.getRequestDispatcher("/buyer/payment.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Transaksi trx = verifikasiOtorisasi(request, response);
        if (trx == null) return;

        // Validasi tidak bisa double bayar
        if (!"Menunggu Pembayaran".equalsIgnoreCase(trx.getStatusPembayaran())) {
            response.sendRedirect(request.getContextPath() + "/buyer/payment/receipt?id=" + trx.getId());
            return;
        }

        // Ambil input parameter form
        String metodeParam = request.getParameter("metode");
        String subMetode = request.getParameter("sub_metode");
        PaymentMethod metode = PaymentMethod.fromCode(metodeParam);

        // Kalkulasi ulang
        double subtotal = trx.getTotalBayar();
        double grandTotal = subtotal + ONGKIR + (subtotal * PAJAK_PERSEN);

        // Polymorphism: Controller hanya berurusan dengan "Payable"
        Payable pembayaran = buatMetodeBayar(metode);
        boolean isBayarBerhasil = pembayaran.prosesBayar(grandTotal);

        // Tentukan status akhir
        PaymentStatus finalStatus = isBayarBerhasil ? PaymentStatus.SUCCESS : PaymentStatus.FAILED;
        
        // COD atau E-Wallet pending scenario
        if (isBayarBerhasil && (metode == PaymentMethod.COD || metode == PaymentMethod.TRANSFER_BANK)) {
             // Simulasi transfer bank butuh verifikasi (dummy), COD bayar di tempat
             finalStatus = PaymentStatus.PENDING; 
             // Untuk mempermudah aliran di aplikasi e-commerce sederhana, kita anggap Transfer Bank langsung "SUCCESS"
             if(metode == PaymentMethod.TRANSFER_BANK) {
                 finalStatus = PaymentStatus.SUCCESS;
             }
        }

        // Simpan ke riwayat_pembayaran
        RiwayatPembayaran riwayat = new RiwayatPembayaran();
        riwayat.setTransaksiId(trx.getId());
        riwayat.setMetode(metode.getLabel());
        riwayat.setSubMetode(subMetode != null ? subMetode : metode.getLabel());
        riwayat.setKodeBayar(generateKodeBayar(metode, subMetode));
        riwayat.setJumlah(grandTotal);
        riwayat.setStatus(finalStatus.getValue());
        riwayat.setWaktuBayar(new Timestamp(System.currentTimeMillis()));
        riwayat.insert();

        // Update status_pembayaran di transaksi table
        if (finalStatus == PaymentStatus.SUCCESS || finalStatus == PaymentStatus.PENDING) {
             // Jika pending (COD), status e-commerce tetap Lunas secara sistem untuk dilanjutkan ke penjual (dummy)
             // Atau kita pisah statusnya. Sesuai kode sebelumnya, `update_status_pembayaran` mengganti string:
             String newStatusTx = (metode == PaymentMethod.COD) ? "COD - Menunggu Kurir" : "Lunas";
             trx.update_status_pembayaran(trx.getId(), newStatusTx);
        }

        // Redirect dengan pola PRG (Post-Redirect-Get) untuk mencegah resubmit form.
        response.sendRedirect(request.getContextPath() + "/buyer/payment/receipt?id=" + trx.getId());
    }
}
