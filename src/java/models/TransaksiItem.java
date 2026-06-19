package models;

public class TransaksiItem extends Model<TransaksiItem> {
    private int id;
    private int transaksi_id;
    private int produk_id;
    private String nama_produk;
    private double harga;
    private int qty;

    public TransaksiItem() {
        this.table = "transaksi_item";
        this.primaryKey = "id";
    }

    public TransaksiItem(int transaksi_id, int produk_id, String nama_produk, double harga, int qty) {
        this();
        this.transaksi_id = transaksi_id;
        this.produk_id = produk_id;
        this.nama_produk = nama_produk;
        this.harga = harga;
        this.qty = qty;
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

    public double getSubtotal() {
        return harga * qty;
    }
}
