package models;

import java.util.ArrayList;
import java.util.UUID;

public class Akun extends Model<Akun> {

    protected String id;
    protected String username;
    protected String password;
    protected String email;

    public void daftarAkun(String username, String password, String email) {
        this.id = UUID.randomUUID().toString();
        this.username = username;
        this.password = password;
        this.email = email;
        this.insert();
    }

    public boolean masukAkun(String username, String password) {
        this.where("username = '" + username + "' AND password = '" + password + "'");
        ArrayList<Akun> res = this.get();
        if (res != null && !res.isEmpty()) {
            Akun a = res.get(0);
            this.id = a.id;
            this.username = a.username;
            this.password = a.password;
            return true;
        }
        return false;
    }

    public void gantiPassword(String newPasswd) {
        this.password = newPasswd;
        this.update();
    }

    public String getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
        this.update();
    }

    public boolean isUsernameExists(String username) {
        this.where("username = '" + username + "'");
        ArrayList<Akun> res = this.get();
        return res != null && !res.isEmpty();
    }
}
