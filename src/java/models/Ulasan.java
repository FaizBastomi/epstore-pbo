package models;

import java.sql.Date;

public class Ulasan extends Model<Ulasan> {

    private int id, produk_id, rating;
    private String komentar, nama_pembeli;
    private Date tanggal;

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
}
