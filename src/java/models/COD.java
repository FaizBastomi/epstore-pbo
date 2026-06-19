package models;

/**
 * COD (Cash on Delivery) — Implementasi pembayaran tunai saat barang tiba.
 *
 * <p>Mengimplementasikan {@link Payable}. Bersama {@link QRIS},
 * {@link EWallet}, dan {@link TransferBank}, kelas ini mewujudkan
 * Polymorphism pada sistem pembayaran EpStore: semua metode pembayaran
 * diperlakukan seragam melalui antarmuka {@link Payable}.</p>
 *
 * <p>COD selalu mengembalikan {@code true} dari {@code prosesBayar} karena
 * pesanan dikonfirmasi pada saat pemesanan; pembayaran fisik diselesaikan
 * oleh kurir/penjual saat paket diterima pembeli.</p>
 *
 * @author Payment Module (Kelompok 5)
 */
public class COD implements Payable {

    /** Konstruktor default. */
    public COD() {}

    /**
     * Konfirmasi pesanan COD.
     *
     * <p>COD selalu diterima pada saat pemesanan. Pembayaran fisik
     * diselesaikan di luar sistem (saat pengiriman tiba).</p>
     *
     * @param total nominal pesanan (tidak divalidasi; kurir yang memverifikasi)
     * @return selalu {@code true}
     */
    @Override
    public boolean prosesBayar(double total) {
        return true;
    }
}
