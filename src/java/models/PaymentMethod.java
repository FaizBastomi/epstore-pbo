package models;

/**
 * PaymentMethod — Enum seluruh metode pembayaran yang tersedia di EpStore.
 *
 * <p>Menerapkan prinsip Open/Closed: metode pembayaran baru dapat ditambahkan
 * tanpa mengubah kode yang sudah ada, selama kelas implementasinya
 * mengimplementasikan {@link Payable}.</p>
 *
 * <p>Setiap konstanta membawa:
 * <ul>
 *   <li>{@code label}  — teks yang ditampilkan di UI.</li>
 *   <li>{@code code}   — kode internal untuk parameter form HTML.</li>
 * </ul>
 * </p>
 *
 * @author Payment Module (Kelompok 5)
 */
public enum PaymentMethod {

    /** Pembayaran via QR Code Indonesian Standard (QRIS). */
    QRIS("QRIS", "qris"),

    /** Pembayaran via transfer ke Virtual Account bank. */
    TRANSFER_BANK("Transfer Bank", "transfer_bank"),

    /** Pembayaran via dompet digital (OVO, GoPay, DANA, ShopeePay). */
    E_WALLET("E-Wallet", "e_wallet"),

    /** Pembayaran tunai saat barang tiba (Cash on Delivery). */
    COD("Cash on Delivery", "cod");

    private final String label;
    private final String code;

    PaymentMethod(String label, String code) {
        this.label = label;
        this.code = code;
    }

    /**
     * Label yang ditampilkan di antarmuka pengguna.
     *
     * @return label UI (mis. "Transfer Bank")
     */
    public String getLabel() {
        return label;
    }

    /**
     * Kode internal yang digunakan sebagai value pada form HTML.
     *
     * @return kode pendek (mis. "transfer_bank")
     */
    public String getCode() {
        return code;
    }

    /**
     * Resolusi dari string parameter form ke instance enum.
     * Default ke {@link #TRANSFER_BANK} bila tidak cocok atau null.
     *
     * @param code string dari request parameter "metode"
     * @return PaymentMethod yang sesuai
     */
    public static PaymentMethod fromCode(String code) {
        if (code == null || code.trim().isEmpty()) return TRANSFER_BANK;
        for (PaymentMethod pm : values()) {
            if (pm.code.equalsIgnoreCase(code.trim())) return pm;
        }
        return TRANSFER_BANK;
    }
}
