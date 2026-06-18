package models;

public class BarangKeranjang extends Model<BarangKeranjang> {

    private int id;
    private int id_keranjang;
    private int id_produk;
    private int qty;

    public BarangKeranjang() {
        this.table = "barang_keranjang";
        this.primaryKey = "id";
    }

    public BarangKeranjang(int idKeranjang, int idProduk, int qty) {
        this();
        this.id_keranjang = idKeranjang;
        this.id_produk = idProduk;
        this.qty = qty;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdKeranjang() { return id_keranjang; }
    public void setIdKeranjang(int id_keranjang) { this.id_keranjang = id_keranjang; }
    public int getIdProduk() { return id_produk; }
    public void setIdProduk(int id_produk) { this.id_produk = id_produk; }
    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }

    public Produk getProduk() {
        return (id_produk > 0) ? new Produk().find(String.valueOf(this.id_produk)) : null;
    }

    public double getSubtotal() {
        Produk p = getProduk();
        return (p != null) ? p.getHarga() * qty : 0;
    }
}
