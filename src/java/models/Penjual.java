package models;

public class Penjual extends Akun {

    private String namaToko;

    public Penjual() {
        this.table = "penjual";
        this.primaryKey = "id";
    }

    public void aturNamaToko(String namaToko) {
        this.namaToko = namaToko;
        this.update();
    }

    public Penjual getPenjualByUsername(String username) {
        this.where("username = '" + username + "'");
        java.util.ArrayList<Akun> res = this.get();
        if (res != null && !res.isEmpty()) {
            return (Penjual) res.get(0);
        }
        return null;
    }

    public String getNamaToko() {
        return namaToko;
    }

    public void tambahProduk(String nama, String deskripsi, double harga, int stok) {
        Produk produk = new Produk();
        produk.setNama(nama);
        produk.setDeskripsi(deskripsi);
        produk.setHarga(harga);
        produk.setStok(stok);
        produk.insert();
    }

    public void editProduk(int idProduk, String nama, String deskripsi, double harga, int stok) {
        Produk produk = new Produk().find(String.valueOf(idProduk));
        if (produk != null) {
            produk.setNama(nama);
            produk.setDeskripsi(deskripsi);
            produk.setHarga(harga);
            produk.setStok(stok);
            produk.update();
        }
    }

    public void hapusProduk(int idProduk) {
        Produk produk = new Produk().find(String.valueOf(idProduk));
        if (produk != null) {
            produk.delete();
        }
    }
}
