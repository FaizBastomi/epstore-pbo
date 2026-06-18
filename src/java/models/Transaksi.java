package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;

/**
 * Transaksi - mengelola finalisasi pesanan / checkout
 * (Class Diagram bagian D; UI Reference sec. 5 "Pesanan Saya").
 *
 * Atribut sesuai Class Diagram: id_transaksi, tanggal, metode,
 * status_pembayaran, total_harga, dan daftarItem (komposisi dengan
 * BarangKeranjang). daftarItem dipetakan ke tabel `transaksi_item`
 * (lihat {@link TransaksiItem}).
 *
 * Catatan implementasi:
 * <ul>
 *   <li>{@code status_pembayaran} pada diagram bertipe boolean; di basis data
 *       disimpan sebagai TINYINT (0/1) agar kompatibel dengan helper berbasis
 *       reflection pada {@link Model}. Method {@link #isStatusPembayaran()}
 *       mengembalikan representasi boolean-nya.</li>
 *   <li>{@code status} (string) ditambahkan untuk tab pada halaman "Pesanan
 *       Saya": "Menunggu Pembayaran", "Diproses", "Dikirim", "Selesai".</li>
 *   <li>Operasi tulis ({@link #buatPesanan}, {@link #update_status_pembayaran})
 *       memakai {@link PreparedStatement} via {@link #getConnection()} agar
 *       mendukung generated key + penyisipan banyak item dalam satu transaksi
 *       basis data, sekaligus aman dari SQL injection. Operasi baca tetap
 *       memakai helper bawaan {@link Model} ({@code find}/{@code where}/{@code get}).</li>
 * </ul>
 *
 * @author Kelompok 5 (PIC: Gillbrian)
 */
public class Transaksi extends Model<Transaksi> {

    // ---- Nilai status pesanan (kolom `status`) ----
    public static final String STATUS_MENUNGGU = "Menunggu Pembayaran";
    public static final String STATUS_DIPROSES = "Diproses";
    public static final String STATUS_DIKIRIM = "Dikirim";
    public static final String STATUS_SELESAI = "Selesai";

    // Field names MUST match column names in table `transaksi`.
    private int id_transaksi;
    private String pembeli_id;
    private Timestamp tanggal;
    private String metode;
    private int status_pembayaran;       // 0 = belum dibayar, 1 = sudah dibayar
    private String status;
    private double total_harga;

    // Tidak dipetakan ke kolom; dimuat sesuai permintaan dari `transaksi_item`.
    private ArrayList<TransaksiItem> daftarItem;

    public Transaksi() {
        this.table = "transaksi";
        this.primaryKey = "id_transaksi";
    }

    /**
     * Buat pesanan baru dari isi keranjang (Class Diagram: buatPesanan(barang)).
     *
     * Menyimpan satu baris transaksi (status awal "Menunggu Pembayaran")
     * beserta seluruh item keranjang ke tabel {@code transaksi_item} dalam satu
     * transaksi basis data. Stok produk tidak dikurangi di sini karena proses
     * pelunasan masih berupa halaman dummy (modul Pembayaran dikerjakan PIC lain).
     *
     * @param keranjang isi keranjang belanja (dari session).
     * @param pembeliId id pembeli pemilik pesanan.
     * @param metode    metode pembayaran terpilih (mis. "Transfer Bank").
     * @return id_transaksi yang baru dibuat, atau -1 bila gagal.
     */
    public int buatPesanan(Keranjang keranjang, String pembeliId, String metode) {
        if (keranjang == null || keranjang.getDaftarItem() == null
                || keranjang.getDaftarItem().isEmpty() || pembeliId == null) {
            setMessage("Keranjang kosong atau pembeli tidak valid.");
            return -1;
        }

        Connection con = getConnection();
        if (con == null) {
            return -1;
        }

        try {
            con.setAutoCommit(false);

            String sqlTx = "INSERT INTO transaksi "
                    + "(pembeli_id, tanggal, metode, status_pembayaran, status, total_harga) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";
            int newId;
            try (PreparedStatement ps = con.prepareStatement(sqlTx, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, pembeliId);
                ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                ps.setString(3, (metode == null || metode.isEmpty()) ? "Transfer Bank" : metode);
                ps.setInt(4, 0);
                ps.setString(5, STATUS_MENUNGGU);
                ps.setDouble(6, keranjang.getTotalHarga());
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) {
                        con.rollback();
                        setMessage("Gagal memperoleh id transaksi.");
                        return -1;
                    }
                    newId = keys.getInt(1);
                }
            }

            String sqlItem = "INSERT INTO transaksi_item "
                    + "(transaksi_id, produk_id, nama_produk, harga, qty) "
                    + "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlItem)) {
                for (BarangKeranjang b : keranjang.getDaftarItem()) {
                    Produk p = b.getProduk();
                    ps.setInt(1, newId);
                    if (p != null) {
                        ps.setInt(2, p.getId());
                    } else {
                        ps.setNull(2, Types.INTEGER);
                    }
                    ps.setString(3, (p != null) ? p.getNama() : "Produk");
                    ps.setDouble(4, (p != null) ? p.getHarga() : 0);
                    ps.setInt(5, b.getQty());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            con.commit();
            this.id_transaksi = newId;
            this.pembeli_id = pembeliId;
            this.metode = metode;
            this.status = STATUS_MENUNGGU;
            this.status_pembayaran = 0;
            this.total_harga = keranjang.getTotalHarga();
            return newId;
        } catch (SQLException e) {
            setMessage(e.getMessage());
            try {
                con.rollback();
            } catch (SQLException ex) {
                // diabaikan
            }
            return -1;
        } finally {
            try {
                con.close();
            } catch (SQLException ex) {
                // diabaikan
            }
        }
    }

    /**
     * Perbarui status pembayaran (Class Diagram:
     * update_status_pembayaran(status: boolean)).
     *
     * <ul>
     *   <li>{@code true}  -&gt; status_pembayaran = 1, status pesanan "Diproses"
     *       ("Pembayaran Berhasil").</li>
     *   <li>{@code false} -&gt; status_pembayaran = 0, status pesanan
     *       "Menunggu Pembayaran".</li>
     * </ul>
     *
     * @param sudahDibayar hasil pelunasan dari halaman pembayaran.
     */
    public void update_status_pembayaran(boolean sudahDibayar) {
        Connection con = getConnection();
        if (con == null) {
            return;
        }
        String newStatus = sudahDibayar ? STATUS_DIPROSES : STATUS_MENUNGGU;
        int paid = sudahDibayar ? 1 : 0;
        String sql = "UPDATE transaksi SET status_pembayaran = ?, status = ? "
                + "WHERE id_transaksi = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, paid);
            ps.setString(2, newStatus);
            ps.setInt(3, this.id_transaksi);
            ps.executeUpdate();
            this.status_pembayaran = paid;
            this.status = newStatus;
        } catch (SQLException e) {
            setMessage(e.getMessage());
        } finally {
            try {
                con.close();
            } catch (SQLException ex) {
                // diabaikan
            }
        }
    }

    /**
     * Daftar item pesanan ini (dimuat sekali dari tabel {@code transaksi_item}).
     */
    public ArrayList<TransaksiItem> getDaftarItem() {
        if (daftarItem == null) {
            TransaksiItem itemModel = new TransaksiItem();
            itemModel.where("transaksi_id = '" + id_transaksi + "'");
            itemModel.addQuery("ORDER BY id ASC");
            daftarItem = itemModel.get();
            if (daftarItem == null) {
                daftarItem = new ArrayList<>();
            }
        }
        return daftarItem;
    }

    // ---------- Getters ----------
    public int getIdTransaksi() {
        return id_transaksi;
    }

    public String getPembeliId() {
        return pembeli_id;
    }

    public Timestamp getTanggal() {
        return tanggal;
    }

    public String getMetode() {
        return metode;
    }

    public int getStatusPembayaran() {
        return status_pembayaran;
    }

    /**
     * Representasi boolean dari status_pembayaran (sesuai Class Diagram).
     */
    public boolean isStatusPembayaran() {
        return status_pembayaran == 1;
    }

    public String getStatus() {
        return status;
    }

    public double getTotalHarga() {
        return total_harga;
    }
}
