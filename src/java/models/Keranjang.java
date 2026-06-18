package models;

import java.util.ArrayList;

public class Keranjang extends Model<Keranjang> {

    private int id;
    private String id_pembeli;
    private double total_harga;

    public Keranjang() {
        this.table = "keranjang";
        this.primaryKey = "id";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getIdPembeli() { return id_pembeli; }
    public void setIdPembeli(String id_pembeli) { this.id_pembeli = id_pembeli; }
    public double getTotalHarga() { return total_harga; }
    public void setTotalHarga(double total_harga) { this.total_harga = total_harga; }

    public ArrayList<BarangKeranjang> getDaftarItem() {
        BarangKeranjang bkModel = new BarangKeranjang();
        bkModel.where("id_keranjang = " + this.getId());
        ArrayList<BarangKeranjang> list = bkModel.get();
        return (list != null) ? list : new ArrayList<>();
    }

    private void hitungTotal() {
        double total = 0;
        for (BarangKeranjang item : getDaftarItem()) {
            total += item.getSubtotal();
        }
        this.total_harga = total;
        this.update();
    }

    public void tambahItem(int idProduk, int qty) {
        BarangKeranjang existing = getItem(idProduk);
        if (existing != null) {
            existing.setQty(existing.getQty() + qty);
            existing.update();
        } else {
            BarangKeranjang baru = new BarangKeranjang(this.getId(), idProduk, qty);
            baru.insert();
        }
        hitungTotal();
    }

    public void hapusItem(int idProduk) {
        BarangKeranjang existing = getItem(idProduk);
        if (existing != null) {
            existing.delete();
        }
        hitungTotal();
    }

    public void ubahQty(int idProduk, int qty) {
        BarangKeranjang existing = getItem(idProduk);
        if (existing != null) {
            existing.setQty(Math.max(1, qty));
            existing.update();
        }
        hitungTotal();
    }

    public void kosongkanKeranjang() {
        for (BarangKeranjang item : getDaftarItem()) {
            item.delete();
        }
        hitungTotal();
    }

    public BarangKeranjang getItem(int idProduk) {
        BarangKeranjang bkModel = new BarangKeranjang();
        bkModel.where("id_keranjang = " + this.getId() + " AND id_produk = " + idProduk);
        ArrayList<BarangKeranjang> existings = bkModel.get();
        return (existings != null && !existings.isEmpty()) ? existings.get(0) : null;
    }

    public int getTotalItem() {
        int total = 0;
        for (BarangKeranjang item : getDaftarItem()) {
            total += item.getQty();
        }
        return total;
    }

    public boolean isEmpty() {
        return getDaftarItem().isEmpty();
    }
}
