package models;

import java.util.ArrayList;
import java.time.LocalDateTime;

public class Transaksi extends Model<Transaksi> {
    private int id;
    private String pembeli_id;
    private LocalDateTime tanggal;
    private String metode;
    private int status_pembayaran;
    private String status;
    private double total_harga;
    private String kode_promo;

    public Transaksi() {
        this.table = "transaksi";
        this.primaryKey = "id";
    }

    public int getId() { return id; }
    public String getPembeliId() { return pembeli_id; }
    public LocalDateTime getTanggal() { return tanggal; }
    public String getMetode() { return metode; }
    public int getStatusPembayaran() { return status_pembayaran; }
    public double getTotalHarga() { return total_harga; }

    public String getStatus() {
        return status;
    }
    
    public String getKodePromo() { return kode_promo; }

    public ArrayList<TransaksiItem> getDaftarItem() {
        TransaksiItem ti = new TransaksiItem();
        ti.where("transaksi_id = " + this.id);
        ArrayList<TransaksiItem> list = ti.get();
        return list != null ? list : new ArrayList<>();
    }

    public int buatPesanan(Keranjang keranjang, String pembeliId, String metode, String couponCode) {
        this.pembeli_id = keranjang.getIdPembeli();
        this.metode = metode;
        this.tanggal = LocalDateTime.now();
        this.status_pembayaran = 0;
        this.status = "Menunggu Pembayaran";
        
        double total = keranjang.getTotalHarga();
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            Kupon k = new Kupon().find(couponCode.trim());
            if (k != null && k.cekMasaBerlaku()) {
                total -= k.hitungPotongan(total);
                this.kode_promo = k.getKodePromo();
            }
        }
        this.total_harga = total;
        this.insert();
        
        Transaksi t = new Transaksi();
        t.where("pembeli_id = '" + this.pembeli_id + "' ORDER BY id DESC LIMIT 1");
        ArrayList<Transaksi> list = t.get();
        if (list.isEmpty()) return 0;
        
        int newId = list.get(0).getId();
        for (BarangKeranjang bk : keranjang.getDaftarItem()) {
            Produk p = bk.getProduk();
            String nama = (p != null) ? p.getNama() : "Unknown";
            double harga = (p != null) ? p.getHarga() : 0;
            new TransaksiItem(newId, bk.getIdProduk(), nama, harga, bk.getQty()).insert();
        }
        return newId;
    }

    public void kurangiStok() {
        for (TransaksiItem item : getDaftarItem()) {
            Produk p = new Produk().find(item.getProdukId() + "");
            if (p != null) {
                p.setStok(p.getStok() - item.getQty());
                p.update();
            }
        }
    }

    public void updateStatus(String newStatus) {
        this.status = newStatus;
        this.update();
    }

    public void updateStatusPembayaran(boolean isPaid) {
        this.status_pembayaran = isPaid ? 1 : 0;
        if (isPaid && "Menunggu Pembayaran".equals(this.status)) {
            this.status = "Dibayar";
        }
        this.update();
    }
}
