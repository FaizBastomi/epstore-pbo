-- =====================================================================
--  EpStore - Tabel Riwayat Pembayaran (Modul Pembayaran)
--
--  Jalankan file ini SETELAH transaksi.sql (butuh tabel `transaksi`).
--
--  Tujuan tabel:
--    Merekam setiap percobaan pembayaran sebagai audit trail.
--    Setiap POST ke /buyer/payment menghasilkan satu baris baru di sini.
--
--  Kolom:
--    id           - auto-increment PK
--    transaksi_id - FK ke transaksi.id_transaksi
--    metode       - metode utama: "QRIS", "Transfer Bank", "E-Wallet", "Cash on Delivery"
--    sub_metode   - sub-pilihan: "BCA", "OVO", "QRIS", "COD" (nullable)
--    kode_bayar   - nomor VA / kode QRIS / kode COD yang digenerate (nullable)
--    jumlah       - grand total yang dibayarkan (subtotal + ongkir + pajak)
--    status       - "PENDING" | "SUCCESS" | "FAILED"
--    waktu_bayar  - timestamp percobaan pembayaran
-- =====================================================================

USE `epstore`;

DROP TABLE IF EXISTS `riwayat_pembayaran`;

CREATE TABLE `riwayat_pembayaran` (
    `id`           INT          NOT NULL AUTO_INCREMENT,
    `transaksi_id` INT          NOT NULL,
    `metode`       VARCHAR(50)  NOT NULL,
    `sub_metode`   VARCHAR(100) DEFAULT NULL,
    `kode_bayar`   VARCHAR(100) DEFAULT NULL,
    `jumlah`       DOUBLE       NOT NULL DEFAULT 0,
    `status`       VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
    `waktu_bayar`  DATETIME     NOT NULL,
    PRIMARY KEY (`id`),
    KEY `fk_riwayat_transaksi` (`transaksi_id`),
    CONSTRAINT `fk_riwayat_transaksi`
        FOREIGN KEY (`transaksi_id`) REFERENCES `transaksi` (`id_transaksi`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =====================================================================
-- Sample data (opsional — uncomment untuk testing)
-- Ganti '1' dengan id_transaksi yang valid di database Anda.
-- =====================================================================
-- INSERT INTO `riwayat_pembayaran`
--   (transaksi_id, metode, sub_metode, kode_bayar, jumlah, status, waktu_bayar)
-- VALUES
--   (1, 'Transfer Bank', 'BCA', '123400000001', 166850.00, 'SUCCESS', NOW()),
--   (2, 'QRIS', 'QRIS', 'EPQR-00000002', 233350.00, 'PENDING', NOW());
