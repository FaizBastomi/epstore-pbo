package models;

import java.util.ArrayList;

/**
 * Keranjang - wadah penampung barang sementara bagi Pembeli
 * (Class Diagram, bagian C; UI Reference sec. 4 "Keranjang Belanja").
 *
 * Relasi: Komposisi dengan BarangKeranjang. Keranjang dimiliki oleh Pembeli
 * (komposisi: keberadaan keranjang bergantung pada pembeli) dan disimpan pada
 * HttpSession sebagai data sementara, sesuai deskripsi pada dokumen desain.
 *
 * Catatan: Pada diagram, getDaftarItem() tertulis mengembalikan
 * ArrayList&lt;Produk&gt;, namun atribut daftarItem bertipe
 * ArrayList&lt;BarangKeranjang&gt;. Di sini dikembalikan
 * ArrayList&lt;BarangKeranjang&gt; agar kuantitas tiap produk tetap terbawa
 * untuk ditampilkan pada halaman keranjang.
 *
 * @author Kelompok 5
 */
public class Keranjang {

    private int id_keranjang;
    private double total_harga;
    private ArrayList<BarangKeranjang> daftarItem;

    public Keranjang() {
        this.daftarItem = new ArrayList<>();
    }

    /**
     * Tambah item ke keranjang. Jika produk yang sama sudah ada, kuantitasnya
     * digabung (ditambahkan), bukan menambah baris baru.
     */
    public void tambahItem(BarangKeranjang barang) {
        if (barang == null || barang.getProduk() == null) {
            return;
        }
        BarangKeranjang existing = getItem(barang.getProduk().getId());
        if (existing != null) {
            existing.setQty(existing.getQty() + barang.getQty());
        } else {
            daftarItem.add(barang);
        }
        hitungTotal();
    }

    /**
     * Hapus item dari keranjang berdasarkan id produk.
     */
    public void hapusItem(int idProduk) {
        daftarItem.removeIf(item -> item.getProduk() != null
                && item.getProduk().getId() == idProduk);
        hitungTotal();
    }

    /**
     * Ubah kuantitas item produk tertentu (minimal 1).
     */
    public void ubahQty(int idProduk, int qty) {
        BarangKeranjang item = getItem(idProduk);
        if (item != null) {
            item.setQty(Math.max(1, qty));
        }
        hitungTotal();
    }

    /**
     * Kosongkan seluruh isi keranjang.
     */
    public void kosongkanKeranjang() {
        daftarItem.clear();
        hitungTotal();
    }

    public ArrayList<BarangKeranjang> getDaftarItem() {
        return daftarItem;
    }

    /**
     * Cari item berdasarkan id produk; null jika tidak ada.
     */
    public BarangKeranjang getItem(int idProduk) {
        for (BarangKeranjang item : daftarItem) {
            if (item.getProduk() != null && item.getProduk().getId() == idProduk) {
                return item;
            }
        }
        return null;
    }

    /**
     * Total seluruh unit produk di keranjang (untuk badge keranjang).
     */
    public int getTotalItem() {
        int total = 0;
        for (BarangKeranjang item : daftarItem) {
            total += item.getQty();
        }
        return total;
    }

    public boolean isEmpty() {
        return daftarItem.isEmpty();
    }

    /**
     * Total harga keranjang (selalu dihitung ulang dari daftar item).
     */
    public double getTotalHarga() {
        hitungTotal();
        return total_harga;
    }

    private void hitungTotal() {
        double total = 0;
        for (BarangKeranjang item : daftarItem) {
            total += item.getSubtotal();
        }
        this.total_harga = total;
    }

    public int getIdKeranjang() {
        return id_keranjang;
    }

    public void setIdKeranjang(int id_keranjang) {
        this.id_keranjang = id_keranjang;
    }
}
