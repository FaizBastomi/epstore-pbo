package models;

import java.sql.Timestamp;

/**
 * RiwayatPembayaran — Entitas untuk tabel `riwayat_pembayaran`.
 *
 * <p>Menyimpan audit trail dari setiap usaha pembayaran yang dilakukan oleh pembeli.
 * Kelas ini membungkus properti dari tabel menggunakan arsitektur Model ORM kustom.</p>
 *
 * @author Payment Module (Kelompok 5)
 */
public class RiwayatPembayaran extends Model<RiwayatPembayaran> {

    private int id;
    private int transaksi_id;
    private String metode;
    private String sub_metode;
    private String kode_bayar;
    private double jumlah;
    private String status;
    private Timestamp waktu_bayar;

    public RiwayatPembayaran() {
        this.table = "riwayat_pembayaran";
        this.primaryKey = "id";
    }

    // Getters and Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTransaksiId() {
        return transaksi_id;
    }

    public void setTransaksiId(int transaksi_id) {
        this.transaksi_id = transaksi_id;
    }

    public String getMetode() {
        return metode;
    }

    public void setMetode(String metode) {
        this.metode = metode;
    }

    public String getSubMetode() {
        return sub_metode;
    }

    public void setSubMetode(String sub_metode) {
        this.sub_metode = sub_metode;
    }

    public String getKodeBayar() {
        return kode_bayar;
    }

    public void setKodeBayar(String kode_bayar) {
        this.kode_bayar = kode_bayar;
    }

    public double getJumlah() {
        return jumlah;
    }

    public void setJumlah(double jumlah) {
        this.jumlah = jumlah;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getWaktuBayar() {
        return waktu_bayar;
    }

    public void setWaktuBayar(Timestamp waktu_bayar) {
        this.waktu_bayar = waktu_bayar;
    }
}
