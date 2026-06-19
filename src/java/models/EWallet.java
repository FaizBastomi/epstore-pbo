package models;

import interfaces.Payable;
import java.util.ArrayList;

public class EWallet extends Model<EWallet> implements Payable {
    private int id;
    private String platform;
    private String nomor_hp;

    public EWallet() {
        this.table = "ewallet";
        this.primaryKey = "id";
    }

    public EWallet(String platform, String nomor_hp) {
        this();
        this.platform = platform;
        this.nomor_hp = nomor_hp;
    }

    @Override
    public boolean prosesBayar(double total) {
        return true;
    }

    public EWallet getDetail(String platform) {
        this.where("platform = '" + platform + "'");
        ArrayList<EWallet> list = this.get();
        return list.isEmpty() ? null : list.get(0);
    }

    public String getPlatform() { return platform; }
    public String getNomorHp() { return nomor_hp; }
}
