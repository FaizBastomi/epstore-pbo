package models;

import java.util.Date;

public class Kupon extends Model<Kupon> {

    public String kode_promo;
    public double persen_diskon;
    public Date expire_at;

    public Kupon() {
        this.table = "kupon";
        this.primaryKey = "kode_promo";
    }

    public String getKodePromo() { return kode_promo; }
    public double getPersenDiskon() { return persen_diskon; }

    public Double hitungPotongan(Double harga) {
        return harga == null ? 0.0 : harga * (persen_diskon / 100.0);
    }

    public boolean cekMasaBerlaku() {
        return expire_at == null || !new Date().after(expire_at);
    }
}
