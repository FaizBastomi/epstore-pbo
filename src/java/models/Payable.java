package models;

/**
 * Payable - kontrak standar untuk seluruh metode pembayaran
 * (Class Diagram bagian D; &laquo;interface&raquo; Payable).
 *
 * Diimplementasikan oleh {@link EWallet} dan {@link TransferBank}. Adanya
 * antarmuka tunggal {@code prosesBayar} memungkinkan terjadinya Polymorphism
 * saat proses pelunasan transaksi: kode pemanggil cukup memegang referensi
 * bertipe {@code Payable} tanpa perlu tahu implementasi konkretnya.
 *
 * @author Kelompok 5
 */
public interface Payable {

    /**
     * Proses pembayaran sejumlah {@code total}.
     *
     * Pada simulasi EpStore, halaman pembayaran bersifat dummy sehingga
     * implementasi hanya memvalidasi nominal dan mengembalikan status berhasil.
     *
     * @param total nominal yang harus dibayar.
     * @return {@code true} bila pembayaran dianggap berhasil.
     */
    boolean prosesBayar(double total);
}
