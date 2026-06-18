-- =====================================================================
--  EpStore - Tabel Transaksi & Item Transaksi
--  Copy-paste ke database `epstore`. Jalankan SETELAH dump_epstore.sql
--  (butuh tabel `pembeli`) dan produk.sql (butuh tabel `produk`).
--
--  Referensi: Class Diagram bagian D "Transaksi dan Polimorfisme
--  Pembayaran" & UI Reference sec. 5 "Pesanan Saya".
--
--  Class Diagram (Transaksi): id_transaksi, tanggal, metode,
--  status_pembayaran (boolean), total_harga, dan daftarItem
--  (ArrayList<BarangKeranjang>) melalui relasi Komposisi.
--
--  Pemetaan ke basis data:
--    - Atribut sederhana Transaksi  -> tabel `transaksi`
--    - daftarItem (komposisi dgn BarangKeranjang) -> tabel `transaksi_item`
--      (satu transaksi memiliki banyak baris item). Nama & harga produk
--      di-"snapshot" agar riwayat pesanan tetap utuh meskipun produk
--      di katalog kelak diubah/dihapus.
--
--  Catatan status:
--    - status_pembayaran : 0 = belum dibayar, 1 = sudah dibayar
--      (representasi boolean pada Class Diagram).
--    - status            : status pesanan untuk tab pada halaman
--      "Pesanan Saya": 'Menunggu Pembayaran', 'Diproses', 'Dikirim',
--      'Selesai'.
-- =====================================================================

USE `epstore`;

-- ---------------------------------------------------------------------
-- Tabel transaksi
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `transaksi_item`;
DROP TABLE IF EXISTS `transaksi`;

CREATE TABLE `transaksi` (
    `id_transaksi`      INT          NOT NULL AUTO_INCREMENT,
    `pembeli_id`        VARCHAR(128) NOT NULL,
    `tanggal`           DATETIME     NOT NULL,
    `metode`            VARCHAR(50)  NOT NULL DEFAULT 'Transfer Bank',
    `status_pembayaran` TINYINT      NOT NULL DEFAULT 0,
    `status`            VARCHAR(30)  NOT NULL DEFAULT 'Menunggu Pembayaran',
    `total_harga`       DOUBLE       NOT NULL DEFAULT 0,
    PRIMARY KEY (`id_transaksi`),
    KEY `fk_transaksi_pembeli` (`pembeli_id`),
    CONSTRAINT `fk_transaksi_pembeli` FOREIGN KEY (`pembeli_id`)
        REFERENCES `pembeli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------
-- Tabel transaksi_item (daftarItem: komposisi Transaksi -> BarangKeranjang)
--   - produk_id boleh NULL bila produk asli kelak dihapus (ON DELETE SET NULL),
--     namun nama_produk & harga tetap tersimpan sebagai snapshot.
-- ---------------------------------------------------------------------
CREATE TABLE `transaksi_item` (
    `id`           INT          NOT NULL AUTO_INCREMENT,
    `transaksi_id` INT          NOT NULL,
    `produk_id`    INT          DEFAULT NULL,
    `nama_produk`  VARCHAR(150) NOT NULL,
    `harga`        DOUBLE       NOT NULL DEFAULT 0,
    `qty`          INT          NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    KEY `fk_item_transaksi` (`transaksi_id`),
    KEY `fk_item_produk` (`produk_id`),
    CONSTRAINT `fk_item_transaksi` FOREIGN KEY (`transaksi_id`)
        REFERENCES `transaksi` (`id_transaksi`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_item_produk` FOREIGN KEY (`produk_id`)
        REFERENCES `produk` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
