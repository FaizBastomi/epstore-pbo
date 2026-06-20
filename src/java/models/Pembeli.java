package models;

import java.util.ArrayList;

public class Pembeli extends Akun {

    private String alamat;
    private String nomor_telp;

    public Pembeli() {
        this.table = "pembeli";
        this.primaryKey = "id";
    }

    public void editUsername(String oldUsername, String newUsername) {
        this.where("username = '" + oldUsername + "'");
        ArrayList<Akun> res = this.get();
        if (res != null && !res.isEmpty()) {
            Pembeli p = (Pembeli) res.get(0);
            p.username = newUsername;
            p.update();
        }
    }

    public Pembeli getPembeliByUsername(String username) {
        this.where("username = '" + username + "'");
        ArrayList<Akun> res = this.get();
        if (res != null && !res.isEmpty()) {
            return (Pembeli) res.get(0);
        }
        return null;
    }

    public String getAlamat() {
        return alamat;
    }

    public String getNomor_telp() {
        return nomor_telp;
    }

    public void setAlamat(String alamat) {
        this.alamat = alamat;
        this.update();
    }

    public void setNomor(String nomor_telp) {
        this.nomor_telp = nomor_telp;
        this.update();
    }

    public void updateProfil(String alamat, String nomor_telp) {
        this.alamat = alamat;
        this.nomor_telp = nomor_telp;
        this.update();
    }

    public String getUsername() {
        return this.username;
    }

    @Override
    public String getEmail() {
        return this.email;
    }
}
