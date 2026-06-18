package models;

/**
 * TransferBank - metode pembayaran transfer bank (Class Diagram bagian D).
 *
 * Mengimplementasikan {@link Payable}. Bersama {@link EWallet}, kelas ini
 * mewujudkan Polymorphism melalui {@code prosesBayar(double)}.
 *
 * @author Kelompok 5
 */
public class TransferBank implements Payable {

    private String namaBank;       // mis. "BCA", "BNI", "Mandiri"
    private String nomorRekening;

    public TransferBank() {
    }

    public TransferBank(String namaBank, String nomorRekening) {
        this.namaBank = namaBank;
        this.nomorRekening = nomorRekening;
    }

    public String getNamaBank() {
        return namaBank;
    }

    public void setNamaBank(String namaBank) {
        this.namaBank = namaBank;
    }

    public String getNomorRekening() {
        return nomorRekening;
    }

    public void setNomorRekening(String nomorRekening) {
        this.nomorRekening = nomorRekening;
    }

    /**
     * Simulasi pelunasan melalui transfer bank. Nominal harus &gt; 0.
     */
    @Override
    public boolean prosesBayar(double total) {
        return total > 0;
    }
}
