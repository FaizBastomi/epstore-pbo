package models;

/**
 * TransaksiItem - satu baris item di dalam sebuah {@link Transaksi}.
 *
 * Merupakan perwujudan basis data dari relasi Komposisi
 * Transaksi -- BarangKeranjang (Class Diagram bagian D, atribut
 * {@code daftarItem: ArrayList<BarangKeranjang>}). Nama & harga produk
 * disimpan sebagai snapshot agar riwayat pesanan tetap utuh meskipun produk
 * di katalog kelak berubah/terhapus.
 *
 * Field names MUST match column names in table `transaksi_item`
 * (pemetaan berbasis reflection pada {@link Model}).
 *
 * @author Kelompok 5
 */
public class TransaksiItem extends Model<TransaksiItem> {

    private int id, transaksi_id, produk_id, qty;
    private String nama_produk;
    private double harga;

    public TransaksiItem() {
        this.table = "transaksi_item";
        this.primaryKey = "id";
    }

    public int getId() {
        return id;
    }

    public int getTransaksiId() {
        return transaksi_id;
    }

    public int getProdukId() {
        return produk_id;
    }

    public String getNamaProduk() {
        return nama_produk;
    }

    public double getHarga() {
        return harga;
    }

    public int getQty() {
        return qty;
    }

    /**
     * Subtotal baris = harga snapshot * kuantitas.
     */
    public double getSubtotal() {
        return harga * qty;
    }
}
