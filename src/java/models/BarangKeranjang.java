package models;

/**
 * BarangKeranjang - kelas perantara yang mendefinisikan kuantitas sebuah
 * Produk di dalam Keranjang (Class Diagram, bagian C).
 *
 * Relasi: Agregasi (wajik putih) dengan Produk. Artinya, jika item dihapus
 * dari keranjang, objek asli Produk di katalog TIDAK ikut terhapus -- hanya
 * referensinya yang dilepas.
 *
 * Objek ini hidup sementara di dalam HttpSession (keranjang belanja), bukan
 * disimpan ke database, sehingga kelas ini tidak mewarisi {@link Model}.
 *
 * @author Kelompok 5
 */
public class BarangKeranjang {

    private int id;
    private Produk produk;
    private int qty;

    public BarangKeranjang(Produk produk, int qty) {
        this.id = (produk != null) ? produk.getId() : 0;
        this.produk = produk;
        this.qty = qty;
    }

    public int getId() {
        return id;
    }

    public Produk getProduk() {
        return produk;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    /**
     * Subtotal item = harga produk * kuantitas.
     */
    public double getSubtotal() {
        return (produk != null) ? produk.getHarga() * qty : 0;
    }
}
