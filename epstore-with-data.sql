-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 19, 2026 at 06:13 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `epstore`
--
CREATE DATABASE IF NOT EXISTS `epstore` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `epstore`;

-- --------------------------------------------------------

--
-- Table structure for table `barang_keranjang`
--

DROP TABLE IF EXISTS `barang_keranjang`;
CREATE TABLE `barang_keranjang` (
  `id` int NOT NULL,
  `id_keranjang` int NOT NULL,
  `id_produk` int NOT NULL,
  `qty` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ewallet`
--

DROP TABLE IF EXISTS `ewallet`;
CREATE TABLE `ewallet` (
  `id` int NOT NULL,
  `platform` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nomor_hp` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ewallet`
--

INSERT INTO `ewallet` (`id`, `platform`, `nomor_hp`) VALUES
(3, 'OVO', '081234567891');

-- --------------------------------------------------------

--
-- Table structure for table `keranjang`
--

DROP TABLE IF EXISTS `keranjang`;
CREATE TABLE `keranjang` (
  `id` int NOT NULL,
  `id_pembeli` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `total_harga` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `keranjang`
--

INSERT INTO `keranjang` (`id`, `id_pembeli`, `total_harga`) VALUES
(5, '70ceee20-5dea-46a2-9653-b4341b0c0c6a', 0),
(6, 'd7373195-9eef-422c-bb02-167189ec8177', 0);

-- --------------------------------------------------------

--
-- Table structure for table `kupon`
--

DROP TABLE IF EXISTS `kupon`;
CREATE TABLE `kupon` (
  `kode_promo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `persen_diskon` double NOT NULL DEFAULT '0',
  `expire_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kupon`
--

INSERT INTO `kupon` (`kode_promo`, `persen_diskon`, `expire_at`) VALUES
('GRANDLAUNCH', 50, '2026-07-20');

-- --------------------------------------------------------

--
-- Table structure for table `pembeli`
--

DROP TABLE IF EXISTS `pembeli`;
CREATE TABLE `pembeli` (
  `id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `alamat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nomor_telp` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pembeli`
--

INSERT INTO `pembeli` (`id`, `username`, `password`, `email`, `alamat`, `nomor_telp`) VALUES
('70ceee20-5dea-46a2-9653-b4341b0c0c6a', 'silver_kafka', 'silver_kafka', 'silver_kafka@example.com', NULL, NULL),
('d7373195-9eef-422c-bb02-167189ec8177', 'xiao_shogun', 'xiao_shogun', 'xiao_shogun@example.com', 'Jln. Telekomunikasi', '081324567892');

-- --------------------------------------------------------

--
-- Table structure for table `penjual`
--

DROP TABLE IF EXISTS `penjual`;
CREATE TABLE `penjual` (
  `id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `namaToko` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penjual`
--

INSERT INTO `penjual` (`id`, `namaToko`) VALUES
('70ceee20-5dea-46a2-9653-b4341b0c0c6a', 'Stelaron Store');

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

DROP TABLE IF EXISTS `produk`;
CREATE TABLE `produk` (
  `id` int NOT NULL,
  `penjual_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nama` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `harga` double NOT NULL DEFAULT '0',
  `stok` int NOT NULL DEFAULT '0',
  `kategori` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Lainnya',
  `deskripsi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `gambar` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id`, `penjual_id`, `nama`, `harga`, `stok`, `kategori`, `deskripsi`, `gambar`) VALUES
(9, '70ceee20-5dea-46a2-9653-b4341b0c0c6a', 'Air Jordan', 1175000, 2, 'Fashion', 'Original Air Jordan from Nike', 'sources/images/products/dc24a6e6-e47e-4fca-86f4-8c99704f9bf3_air_jordan.jpg'),
(10, '70ceee20-5dea-46a2-9653-b4341b0c0c6a', 'Rolex Watches', 5560000, 2, 'Fashion', 'Original Product of Rolex Watches', 'sources/images/products/e5c9f70a-67dc-45fd-8031-7802773a2564_rolex_watches.jpg'),
(11, '70ceee20-5dea-46a2-9653-b4341b0c0c6a', 'Mie Sedap Goreng', 3500, 8, 'Makanan', 'Mie Sedap Goreng Lezat Enak Berkali-kali', 'sources/images/products/d9c5e506-0c03-466c-aac3-95399ec15975_mie_sedap_goreng.jpg'),
(12, '70ceee20-5dea-46a2-9653-b4341b0c0c6a', 'Razer Blackshark v3 Pro', 2520000, 3, 'Elektronik', 'Latest Headphone from Razer Gaming Lineup', 'sources/images/products/2531aedb-b1ae-4a55-9bd4-237f86991c95_razer_blackshark_v3pro.jpg'),
(13, '70ceee20-5dea-46a2-9653-b4341b0c0c6a', 'Payung Lipat Portable', 55000, 6, 'Lainnya', 'Payung Lipat Portable Mudah Dipakai Import China', 'sources/images/products/733789d3-0234-4a64-93fa-257cc8f4acc2_payung.png'),
(14, '70ceee20-5dea-46a2-9653-b4341b0c0c6a', 'Pop Up Parade Figure Frieren', 572000, 1, 'Lainnya', 'Painted plastic non-scale complete product with stand included. Approximately 165mm in height.', 'sources/images/products/39163898-ef30-432f-995d-ef93f2cdfaa1_popup-parade-frieren.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

DROP TABLE IF EXISTS `transaksi`;
CREATE TABLE `transaksi` (
  `id` int NOT NULL,
  `pembeli_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal` datetime NOT NULL,
  `metode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Transfer Bank',
  `status_pembayaran` tinyint NOT NULL DEFAULT '0',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Menunggu Pembayaran',
  `total_harga` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id`, `pembeli_id`, `tanggal`, `metode`, `status_pembayaran`, `status`, `total_harga`) VALUES
(12, 'd7373195-9eef-422c-bb02-167189ec8177', '2026-06-20 01:02:48', 'Transfer Bank - BNI', 1, 'Selesai', 1851000),
(13, 'd7373195-9eef-422c-bb02-167189ec8177', '2026-06-20 01:06:58', 'E-Wallet - OVO', 0, 'Menunggu Pembayaran', 55000),
(14, 'd7373195-9eef-422c-bb02-167189ec8177', '2026-06-20 01:07:12', 'Transfer Bank - BNI', 1, 'Diproses', 572000),
(15, 'd7373195-9eef-422c-bb02-167189ec8177', '2026-06-20 01:07:34', 'E-Wallet - OVO', 1, 'Dibayar', 10500),
(16, 'd7373195-9eef-422c-bb02-167189ec8177', '2026-06-20 01:08:34', 'Transfer Bank - BNI', 1, 'Dikirim', 2520000);

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_item`
--

DROP TABLE IF EXISTS `transaksi_item`;
CREATE TABLE `transaksi_item` (
  `id` int NOT NULL,
  `transaksi_id` int NOT NULL,
  `produk_id` int NOT NULL,
  `nama_produk` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `harga` double NOT NULL DEFAULT '0',
  `qty` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi_item`
--

INSERT INTO `transaksi_item` (`id`, `transaksi_id`, `produk_id`, `nama_produk`, `harga`, `qty`) VALUES
(13, 12, 11, 'Mie Sedap Goreng', 3500, 2),
(14, 12, 9, 'Air Jordan', 1175000, 1),
(15, 12, 12, 'Razer Blackshark v3 Pro', 2520000, 1),
(16, 13, 13, 'Payung Lipat Portable', 55000, 1),
(17, 14, 14, 'Pop Up Parade Figure Frieren', 572000, 1),
(18, 15, 11, 'Mie Sedap Goreng', 3500, 3),
(19, 16, 12, 'Razer Blackshark v3 Pro', 2520000, 1);

-- --------------------------------------------------------

--
-- Table structure for table `transfer_bank`
--

DROP TABLE IF EXISTS `transfer_bank`;
CREATE TABLE `transfer_bank` (
  `id` int NOT NULL,
  `nama_bank` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `no_rekening` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transfer_bank`
--

INSERT INTO `transfer_bank` (`id`, `nama_bank`, `no_rekening`) VALUES
(3, 'BNI', '123456789123');

-- --------------------------------------------------------

--
-- Table structure for table `ulasan`
--

DROP TABLE IF EXISTS `ulasan`;
CREATE TABLE `ulasan` (
  `id` int NOT NULL,
  `produk_id` int NOT NULL,
  `rating` int NOT NULL DEFAULT '5',
  `nama_pembeli` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal` date DEFAULT NULL,
  `komentar` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `seller_reply` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ulasan`
--

INSERT INTO `ulasan` (`id`, `produk_id`, `rating`, `nama_pembeli`, `tanggal`, `komentar`, `seller_reply`) VALUES
(4, 11, 5, 'xiao_shogun', '2026-06-20', 'enak sekali ini woi', NULL),
(5, 9, 4, 'xiao_shogun', '2026-06-20', 'nyaman dipakai, hanya kemahalan', 'maaf, tapi karena dari pabrik memang mahal'),
(6, 12, 5, 'xiao_shogun', '2026-06-20', 'nyaman dipakai, kualitas bagus sekali', 'terimakasih ulasan baiknya');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang_keranjang`
--
ALTER TABLE `barang_keranjang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_barang_keranjang_id` (`id_keranjang`);

--
-- Indexes for table `ewallet`
--
ALTER TABLE `ewallet`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `keranjang`
--
ALTER TABLE `keranjang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `keranjang_pembeli_id` (`id_pembeli`);

--
-- Indexes for table `kupon`
--
ALTER TABLE `kupon`
  ADD PRIMARY KEY (`kode_promo`),
  ADD UNIQUE KEY `kode_promo` (`kode_promo`);

--
-- Indexes for table `pembeli`
--
ALTER TABLE `pembeli`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_username` (`username`);

--
-- Indexes for table `penjual`
--
ALTER TABLE `penjual`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_produk_penjual` (`penjual_id`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_transaksi_pembeli` (`pembeli_id`) USING BTREE;

--
-- Indexes for table `transaksi_item`
--
ALTER TABLE `transaksi_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_item_transaksi` (`transaksi_id`),
  ADD KEY `fk_item_produk` (`produk_id`);

--
-- Indexes for table `transfer_bank`
--
ALTER TABLE `transfer_bank`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ulasan`
--
ALTER TABLE `ulasan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ulasan_produk` (`produk_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang_keranjang`
--
ALTER TABLE `barang_keranjang`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `ewallet`
--
ALTER TABLE `ewallet`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `keranjang`
--
ALTER TABLE `keranjang`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `transaksi_item`
--
ALTER TABLE `transaksi_item`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `transfer_bank`
--
ALTER TABLE `transfer_bank`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ulasan`
--
ALTER TABLE `ulasan`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `barang_keranjang`
--
ALTER TABLE `barang_keranjang`
  ADD CONSTRAINT `fk_barang_keranjang_id` FOREIGN KEY (`id_keranjang`) REFERENCES `keranjang` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `keranjang`
--
ALTER TABLE `keranjang`
  ADD CONSTRAINT `keranjang_pembeli_id` FOREIGN KEY (`id_pembeli`) REFERENCES `pembeli` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `penjual`
--
ALTER TABLE `penjual`
  ADD CONSTRAINT `fk_penjual_pembeli_id` FOREIGN KEY (`id`) REFERENCES `pembeli` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `fk_produk_penjual` FOREIGN KEY (`penjual_id`) REFERENCES `penjual` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `fk_transaksi_pembeli` FOREIGN KEY (`pembeli_id`) REFERENCES `pembeli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaksi_item`
--
ALTER TABLE `transaksi_item`
  ADD CONSTRAINT `fk_item_produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_item_transaksi` FOREIGN KEY (`transaksi_id`) REFERENCES `transaksi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ulasan`
--
ALTER TABLE `ulasan`
  ADD CONSTRAINT `fk_ulasan_produk` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
