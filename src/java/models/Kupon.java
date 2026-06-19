package models;

import java.util.Date;

public class Kupon extends Model<Kupon> {

    private int id;
    private String kodePromo;
    private double persenDiskon;
    private Date expireAt;

    public Kupon() {
        this.table = "kupon";
        this.primaryKey = "id";
    }

    public Double hitungPotongan(Double harga) {
        if (harga == null) {
            return 0.0;
        }
        return harga * (persenDiskon / 100.0);
    }

    public boolean cekMasaBerlaku() {
        if (expireAt == null) {
            return true; // Asumsi jika tidak ada expireAt, maka selalu berlaku
        }
        Date currentDate = new Date();
        return currentDate.before(expireAt) || currentDate.equals(expireAt);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getKodePromo() {
        return kodePromo;
    }

    public void setKodePromo(String kodePromo) {
        this.kodePromo = kodePromo;
    }

    public double getPersenDiskon() {
        return persenDiskon;
    }

    public void setPersenDiskon(double persenDiskon) {
        this.persenDiskon = persenDiskon;
    }

    public Date getExpireAt() {
        return expireAt;
    }

    public void setExpireAt(Date expireAt) {
        this.expireAt = expireAt;
    }
}
