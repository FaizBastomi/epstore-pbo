package models;

public class Penjual extends Akun {

    private String namaToko;

    public Penjual() {
        this.table = "penjual";
        this.primaryKey = "id";
    }

    public void aturNamaToko(String namaToko, String username) {
        Pembeli p = new Pembeli().getPembeliByUsername(username);
        if (p != null) {
            this.id = p.id;
            this.namaToko = namaToko;
            if (this.find(p.id) != null) {
                this.update();
            } else {
                this.insert();
            }
        }
    }

    public Penjual getPenjualByUsername(String username) {
        Pembeli p = new Pembeli().getPembeliByUsername(username);
        if (p != null) {
            Penjual penjual = (Penjual) this.find(p.id);
            if (penjual != null) {
                penjual.username = p.username;
                return penjual;
            }
        }
        return null;
    }

    public String getNamaToko() {
        return namaToko;
    }

    public String getId() {
        if (this.username != null) {
            Pembeli p = new Pembeli().getPembeliByUsername(this.username);
            if (p != null) {
                return p.id;
            }
        }
        return this.id;
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
