ulasan-- =====================================================================
--  EpStore - Tabel Ulasan (Review Produk)
--  Copy-paste ke database `epstore`. Jalankan SETELAH produk.sql.
--
--  Class Diagram (Ulasan): rating, komentar.
--  Catatan: pada Class Diagram, Ulasan berelasi dengan Transaksi. Karena
--  modul Transaksi belum dibuat, ulasan ditautkan langsung ke produk via
--  `produk_id`, dan ditambahkan `nama_pembeli` + `tanggal` untuk tampilan
--  (sesuai UI Reference bagian "Ulasan Pembeli").
-- =====================================================================

USE `epstore`;

DROP TABLE IF EXISTS `ulasan`;
CREATE TABLE `ulasan` (
    `id`           INT          NOT NULL AUTO_INCREMENT,
    `produk_id`    INT          NOT NULL,
    `rating`       INT          NOT NULL DEFAULT 5,
    `komentar`     TEXT         DEFAULT NULL,
    `nama_pembeli` VARCHAR(150) NOT NULL,
    `tanggal`      DATE         DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `fk_ulasan_produk` (`produk_id`),
    CONSTRAINT `fk_ulasan_produk` FOREIGN KEY (`produk_id`)
        REFERENCES `produk` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------
-- Data ulasan. produk_id mengacu ke urutan INSERT pada produk.sql:
--   1=Headphone Wireless, 2=Tas Ransel Pria, 3=Sneakers Casual,
--   4=Jam Tangan Digital, 5=Power Bank, 6=Mie Instan, 7=Serum, 8=Payung
-- ---------------------------------------------------------------------
INSERT INTO `ulasan` (`produk_id`, `rating`, `komentar`, `nama_pembeli`, `tanggal`) VALUES
    (1, 5, 'Barang bagus, kualitas suara jernih!',          'Budi',  '2024-05-12'),
    (1, 4, 'Pengiriman cepat, produk sesuai deskripsi.',    'Ani',   '2024-05-10'),
    (2, 5, 'Tasnya kuat dan banyak kantong, recommended.',  'Dewi',  '2024-05-08'),
    (3, 4, 'Nyaman dipakai, ukuran sesuai.',                'Rizal', '2024-05-05'),
    (5, 5, 'Pengisian cepat, kapasitas besar.',             'Sari',  '2024-05-03');
