/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author voliya
 */
public class Produk extends Model<Produk> {

    // Field names MUST match column names in table `produk` (reflection-based mapping).
    private int id, stok;
    private String nama, deskripsi, kategori, gambar, penjual_id;
    private double harga;

    public Produk() {
        this.table = "produk";
        this.primaryKey = "id";
    }

    // ---------- Getters ----------
    public int getId() {
        return id;
    }

    public int getStok() {
        return stok;
    }

    public String getNama() {
        return nama;
    }

    public String getDeskripsi() {
        return deskripsi;
    }

    public double getHarga() {
        return harga;
    }

    public String getKategori() {
        return kategori;
    }

    public String getGambar() {
        return gambar;
    }

    public String getPenjualId() {
        return penjual_id;
    }

    // ---------- Setters ----------
    public void setStok(int stok) {
        this.stok = stok;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public void setDeskripsi(String deskripsi) {
        this.deskripsi = deskripsi;
    }

    public void setHarga(double harga) {
        this.harga = harga;
    }

    public void setKategori(String kategori) {
        this.kategori = kategori;
    }

    public void setGambar(String gambar) {
        this.gambar = gambar;
    }

    public void setPenjualId(String penjual_id) {
        this.penjual_id = penjual_id;
    }
}
