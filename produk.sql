-- =====================================================================
--  EpStore - Tabel Produk
--  Copy-paste seluruh isi file ini ke database `epstore`.
--
--  Kolom mengikuti Class Diagram (Produk): id, nama, harga, stok, deskripsi
--  Tambahan (Class Diagram belum lengkap, disesuaikan dengan UI Reference):
--    - kategori    : untuk filter kategori pada halaman katalog
--    - gambar      : path gambar LOKAL relatif terhadap context root proyek
--                    (file fisik diletakkan di: web/sources/images/products/)
--    - penjual_id  : relasi Komposisi  Penjual (1) -- (1..*) Produk
--                    ON DELETE CASCADE => produk ikut terhapus jika penjual dihapus
-- =====================================================================

USE `epstore`;

-- ---------------------------------------------------------------------
-- Pastikan ada penjual (relasi komposisi Penjual -> Produk).
-- namaToko "Toko Maju" sesuai UI Reference (halaman Detail Produk).
-- ---------------------------------------------------------------------
INSERT INTO `penjual` (`id`, `namaToko`) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Toko Maju')
ON DUPLICATE KEY UPDATE `namaToko` = VALUES(`namaToko`);

-- ---------------------------------------------------------------------
-- Tabel produk
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS `produk`;
CREATE TABLE `produk` (
    `id`         INT          NOT NULL AUTO_INCREMENT,
    `nama`       VARCHAR(150) NOT NULL,
    `harga`      DOUBLE       NOT NULL DEFAULT 0,
    `stok`       INT          NOT NULL DEFAULT 0,
    `deskripsi`  TEXT         DEFAULT NULL,
    `kategori`   VARCHAR(50)  NOT NULL DEFAULT 'Lainnya',
    `gambar`     VARCHAR(255) DEFAULT NULL,
    `penjual_id` VARCHAR(128) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `fk_produk_penjual` (`penjual_id`),
    CONSTRAINT `fk_produk_penjual` FOREIGN KEY (`penjual_id`)
        REFERENCES `penjual` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------
-- Data produk (gambar -> web/sources/images/products/<file>)
-- ---------------------------------------------------------------------
INSERT INTO `produk` (`nama`, `harga`, `stok`, `deskripsi`, `kategori`, `gambar`, `penjual_id`) VALUES
    ('Headphone Wireless',  150000, 15, 'Headphone wireless dengan kualitas suara jernih, baterai tahan lama, dan desain nyaman setiap hari.', 'Elektronik', 'sources/images/products/headphone.png',  '11111111-1111-1111-1111-111111111111'),
    ('Tas Ransel Pria',     120000,  8, 'Tas ransel pria tahan air dengan banyak kompartemen, cocok untuk kerja maupun kuliah.',              'Fashion',    'sources/images/products/tas-ransel.png', '11111111-1111-1111-1111-111111111111'),
    ('Sneakers Casual',     200000, 12, 'Sepatu sneakers casual ringan dan nyaman dipakai untuk aktivitas sehari-hari.',                      'Fashion',    'sources/images/products/sneakers.png',   '11111111-1111-1111-1111-111111111111'),
    ('Jam Tangan Digital',   85000, 20, 'Jam tangan digital anti air dengan fitur stopwatch, alarm, dan lampu LED.',                          'Elektronik', 'sources/images/products/jam-tangan.png', '11111111-1111-1111-1111-111111111111'),
    ('Power Bank 10000mAh',  95000, 14, 'Power bank kapasitas 10000mAh dengan dua port USB dan fast charging.',                               'Elektronik', 'sources/images/products/powerbank.png',  '11111111-1111-1111-1111-111111111111'),
    ('Mie Instan Kuah',       3000, 50, 'Mie instan kuah rasa ayam bawang, praktis dan lezat untuk segala suasana.',                          'Makanan',    'sources/images/products/mie-instan.png', '11111111-1111-1111-1111-111111111111'),
    ('Serum Wajah Glow',     75000, 25, 'Serum wajah dengan vitamin C untuk mencerahkan dan melembapkan kulit.',                              'Kecantikan', 'sources/images/products/serum.png',      '11111111-1111-1111-1111-111111111111'),
    ('Payung Lipat Otomatis',45000, 30, 'Payung lipat otomatis anti UV, ringkas dan mudah dibawa kemana saja.',                              'Lainnya',    'sources/images/products/payung.png',     '11111111-1111-1111-1111-111111111111');
