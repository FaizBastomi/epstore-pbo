package models;

/**
 * PaymentStatus — Enum status pembayaran dalam tabel {@code riwayat_pembayaran}.
 *
 * <p>Menerapkan prinsip Encapsulation: nilai string status disatukan di satu
 * tempat sehingga tidak ada "magic string" yang tersebar di seluruh kode.</p>
 *
 * <ul>
 *   <li>{@link #PENDING}  — pembayaran diinisiasi namun belum dikonfirmasi
 *       (mis. COD, Transfer Bank menunggu verifikasi manual).</li>
 *   <li>{@link #SUCCESS}  — pembayaran berhasil diverifikasi dan diterima.</li>
 *   <li>{@link #FAILED}   — pembayaran gagal diproses.</li>
 * </ul>
 *
 * @author Payment Module (Kelompok 5)
 */
public enum PaymentStatus {

    /** Pembayaran sedang menunggu konfirmasi. */
    PENDING("PENDING"),

    /** Pembayaran berhasil diverifikasi. */
    SUCCESS("SUCCESS"),

    /** Pembayaran gagal. */
    FAILED("FAILED");

    private final String value;

    PaymentStatus(String value) {
        this.value = value;
    }

    /**
     * Nilai string yang disimpan ke kolom {@code status} di database.
     *
     * @return string value ("PENDING" / "SUCCESS" / "FAILED")
     */
    public String getValue() {
        return value;
    }

    /**
     * Parse status dari string database. Default ke {@link #PENDING}
     * bila string tidak dikenali atau null.
     *
     * @param s string status dari database
     * @return PaymentStatus yang sesuai
     */
    public static PaymentStatus fromString(String s) {
        if (s == null) return PENDING;
        for (PaymentStatus ps : values()) {
            if (ps.value.equalsIgnoreCase(s)) return ps;
        }
        return PENDING;
    }
}
