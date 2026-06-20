package models;

import java.sql.Date;

public class Ulasan extends Model<Ulasan> {

    private int id, produk_id, rating, transaksi_id;
    private String komentar, nama_pembeli, seller_reply;
    private Date tanggal;

    public String getSellerReply() {
        return seller_reply;
    }

    public void setSellerReply(String seller_reply) {
        this.seller_reply = seller_reply;
    }

    public Ulasan() {
        this.table = "ulasan";
        this.primaryKey = "id";
    }

    public int getId() {
        return id;
    }

    public int getProdukId() {
        return produk_id;
    }

    public int getRating() {
        return rating;
    }

    public String getKomentar() {
        return komentar;
    }

    public String getNamaPembeli() {
        return nama_pembeli;
    }

    public Date getTanggal() {
        return tanggal;
    }

    public void setProdukId(int produk_id) {
        this.produk_id = produk_id;
    }

    public int getTransaksiId() {
        return transaksi_id;
    }

    public void setTransaksiId(int transaksi_id) {
        this.transaksi_id = transaksi_id;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public void setKomentar(String komentar) {
        this.komentar = komentar;
    }

    public void setNamaPembeli(String nama_pembeli) {
        this.nama_pembeli = nama_pembeli;
    }

    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }

    // Additional transient-like field to hold product info
    private Produk produk;

    public Produk getProduk() {
        return produk;
    }

    public void setProduk(Produk produk) {
        this.produk = produk;
    }
}
