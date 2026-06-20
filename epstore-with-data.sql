-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 20, 2026 at 02:45 PM
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
(1, '14eb88aa-523c-4c4e-b4e9-181465a95379', 0),
(2, '0889a465-7711-4539-ad84-1abe6ad6c20b', 0);

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
('LAUNCH', 50, '2026-07-20');

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
('0889a465-7711-4539-ad84-1abe6ad6c20b', 'xiao_shogun', 'xiao_shogun', 'xiao_shogun@example.com', NULL, NULL),
('14eb88aa-523c-4c4e-b4e9-181465a95379', 'silver_kafka', 'silver_kafka', 'silver_kafka@example.com', NULL, NULL);

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
('14eb88aa-523c-4c4e-b4e9-181465a95379', 'Stelaron Store');

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
(1, '14eb88aa-523c-4c4e-b4e9-181465a95379', 'Air Jordan', 1150000, 2, 'Fashion', '', 'sources/images/products/98bae12d-625f-4454-9040-8de5d035a0d4_air_jordan.jpg'),
(2, '14eb88aa-523c-4c4e-b4e9-181465a95379', 'Frieren Figure', 750000, 4, 'Lainnya', '', 'sources/images/products/1b9e2acc-5847-4ea3-a55d-7d0a12586e54_popup-parade-frieren.jpg'),
(3, '14eb88aa-523c-4c4e-b4e9-181465a95379', 'Rolex Watches', 2500000, 1, 'Fashion', 'Rolex Watches', 'sources/images/products/c53ecf6e-0c9e-488f-a77a-199c1704e99e_rolex_watches.jpg'),
(4, '14eb88aa-523c-4c4e-b4e9-181465a95379', 'Razer Blackshark v3 Pro', 800000, 10, 'Elektronik', 'Razer Blackshark v3 Pro', 'sources/images/products/4f67e00c-e753-4e27-9bf6-60b6f4bb56a8_razer_blackshark_v3pro.jpg'),
(5, '14eb88aa-523c-4c4e-b4e9-181465a95379', 'Payung Portable', 55000, 5, 'Lainnya', 'Payung Portable', 'sources/images/products/03f0dffb-c673-4200-81bc-5a5ac714a89c_payung.png'),
(6, '14eb88aa-523c-4c4e-b4e9-181465a95379', 'Mie Sedap Goreng', 3500, 16, 'Makanan', 'Mie Sedap Goreng', 'sources/images/products/eeacea1f-6f52-467e-86ba-80d62b045b07_mie_sedap_goreng.jpg');

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
  `kode_promo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_pembayaran` tinyint NOT NULL DEFAULT '0',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Menunggu Pembayaran',
  `total_harga` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id`, `pembeli_id`, `tanggal`, `metode`, `kode_promo`, `status_pembayaran`, `status`, `total_harga`) VALUES
(1, '0889a465-7711-4539-ad84-1abe6ad6c20b', '2026-06-20 21:39:43', 'Transfer Bank', NULL, 1, 'Selesai', 1150000),
(2, '0889a465-7711-4539-ad84-1abe6ad6c20b', '2026-06-20 21:40:36', 'Transfer Bank', NULL, 1, 'Diproses', 3650000),
(3, '0889a465-7711-4539-ad84-1abe6ad6c20b', '2026-06-20 21:41:05', 'Transfer Bank', NULL, 1, 'Dikirim', 124000),
(4, '0889a465-7711-4539-ad84-1abe6ad6c20b', '2026-06-20 21:41:15', 'Transfer Bank', NULL, 1, 'Dibayar', 800000),
(5, '0889a465-7711-4539-ad84-1abe6ad6c20b', '2026-06-20 21:41:26', 'Transfer Bank', NULL, 0, 'Menunggu Pembayaran', 10500),
(6, '0889a465-7711-4539-ad84-1abe6ad6c20b', '2026-06-20 21:41:59', 'Transfer Bank', 'LAUNCH', 1, 'Selesai', 575000),
(7, '0889a465-7711-4539-ad84-1abe6ad6c20b', '2026-06-20 21:42:44', 'Transfer Bank', NULL, 1, 'Selesai', 750000);

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
(1, 1, 1, 'Air Jordan', 1150000, 1),
(2, 2, 1, 'Air Jordan', 1150000, 1),
(3, 2, 3, 'Rolex Watches', 2500000, 1),
(4, 3, 6, 'Mie Sedap Goreng', 3500, 4),
(5, 3, 5, 'Payung Portable', 55000, 2),
(6, 4, 4, 'Razer Blackshark v3 Pro', 800000, 1),
(7, 5, 6, 'Mie Sedap Goreng', 3500, 3),
(8, 6, 1, 'Air Jordan', 1150000, 1),
(9, 7, 2, 'Frieren Figure', 750000, 1);

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

-- --------------------------------------------------------

--
-- Table structure for table `ulasan`
--

DROP TABLE IF EXISTS `ulasan`;
CREATE TABLE `ulasan` (
  `id` int NOT NULL,
  `produk_id` int NOT NULL,
  `transaksi_id` int NOT NULL,
  `rating` int NOT NULL DEFAULT '5',
  `nama_pembeli` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal` date DEFAULT NULL,
  `komentar` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `seller_reply` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ulasan`
--

INSERT INTO `ulasan` (`id`, `produk_id`, `transaksi_id`, `rating`, `nama_pembeli`, `tanggal`, `komentar`, `seller_reply`) VALUES
(1, 1, 1, 5, 'xiao_shogun', '2026-06-20', 'barang bagus', NULL),
(2, 1, 6, 5, 'xiao_shogun', '2026-06-20', 'pembelian kedua, mantap', NULL);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `ewallet`
--
ALTER TABLE `ewallet`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `keranjang`
--
ALTER TABLE `keranjang`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `transaksi_item`
--
ALTER TABLE `transaksi_item`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `transfer_bank`
--
ALTER TABLE `transfer_bank`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ulasan`
--
ALTER TABLE `ulasan`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
