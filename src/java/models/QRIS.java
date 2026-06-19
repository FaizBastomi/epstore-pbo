package models;

/**
 * QRIS — Implementasi pembayaran melalui QRIS (QR Code Indonesian Standard).
 *
 * <p>Mengimplementasikan {@link Payable} sebagai bagian dari mekanisme
 * Polymorphism metode pembayaran pada EpStore. Controller cukup memanggil
 * {@code prosesBayar(total)} melalui referensi {@link Payable} tanpa
 * mengetahui implementasi konkretnya.</p>
 *
 * <p>Pada simulasi ini, {@code prosesBayar} selalu berhasil selama
 * nominal yang dibayarkan positif.</p>
 *
 * <p>Kode QRIS statis ({@link #KODE_QRIS_DUMMY}) mengikuti format
 * payload EMVCO Merchant Presented Mode untuk keperluan tampilan dummy di UI.</p>
 *
 * @author Payment Module (Kelompok 5)
 */
public class QRIS implements Payable {

    /**
     * Kode QRIS dummy dalam format EMVCO MPM (simulasi tampilan UI).
     * Bukan kode valid untuk transaksi nyata.
     */
    private static final String KODE_QRIS_DUMMY =
            "00020101021226590016ID.CO.EPSTORE.WWW011893600503000000000021500000000000030303" +
            "00520459995303360540915000000058021D5910EPSTORE.ID6013JAKARTA PUSAT610540126" +
            "20703A016304DEAD";

    private final String kodeQris;

    /** Konstruktor default — memakai kode QRIS dummy. */
    public QRIS() {
        this.kodeQris = KODE_QRIS_DUMMY;
    }

    /**
     * Mendapatkan kode QRIS untuk ditampilkan di UI sebagai teks placeholder.
     *
     * @return kode QRIS string
     */
    public String getKodeQris() {
        return kodeQris;
    }

    /**
     * Simulasi pembayaran QRIS.
     * Pembayaran dianggap berhasil selama nominal positif.
     *
     * @param total nominal yang harus dibayar
     * @return {@code true} bila {@code total > 0}
     */
    @Override
    public boolean prosesBayar(double total) {
        return total > 0;
    }
}
