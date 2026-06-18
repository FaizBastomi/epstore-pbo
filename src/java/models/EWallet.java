package models;

/**
 * EWallet - metode pembayaran dompet digital (Class Diagram bagian D).
 *
 * Mengimplementasikan {@link Payable}. Bersama {@link TransferBank}, kelas ini
 * mewujudkan Polymorphism: keduanya menyediakan {@code prosesBayar(double)}
 * dengan perilaku masing-masing.
 *
 * @author Kelompok 5
 */
public class EWallet implements Payable {

    private String platform;   // mis. "OVO", "GoPay", "DANA"
    private String nomorHp;

    public EWallet() {
    }

    public EWallet(String platform, String nomorHp) {
        this.platform = platform;
        this.nomorHp = nomorHp;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public String getNomorHp() {
        return nomorHp;
    }

    public void setNomorHp(String nomorHp) {
        this.nomorHp = nomorHp;
    }

    /**
     * Simulasi pelunasan melalui e-wallet. Nominal harus &gt; 0.
     */
    @Override
    public boolean prosesBayar(double total) {
        return total > 0;
    }
}
