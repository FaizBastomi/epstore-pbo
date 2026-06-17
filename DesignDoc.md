PROPOSAL TUGAS BESAR PEMROGRAMAN

BERBASIS OBJEK

Mata Kuliah : Pemrograman Berbasis Objek

Disusun oleh Kelompok 5:

Achmad Bagus Pratama  103012430063

Fadhlan Anargya Agustian  103012400006

Fagian Anmila Syamsir  103012400058

Gillbrian  103012400221

Hara Akmal Ardhani  103012430031

Muhammad Faiz Fadhlurrohman Bastomi  103012430037

PROGRAM STUDI INFORMATIKA

FAKULTAS INFORMATIKA

UNIVERSITAS TELKOM

2026

Daftar Isi

Daftar Isi.................................................................................................................................. 2
1. Pendahuluan.......................................................................................................................3
2. Deskripsi Fitur dan Pembagian Tugas............................................................................. 4
3. Detail Kelas dan Relasi......................................................................................................5
A. Manajemen Akun......................................................................................................... 5
B. Manajemen Produk dan Inventaris............................................................................ 5
C. Alur Belanja dan Keranjang........................................................................................6
D. Transaksi dan Polimorfisme Pembayaran.................................................................6

1.  Pendahuluan

EpStore  adalah  aplikasi  simulasi  marketplace  yang  dirancang  untuk  mempermudah
melakukan  kegiatan  jual  beli  secara  digital.  Proyek ini bertujuan untuk menerapkan konsep
Inheritance,  dan
dasar  Pemrograman  Berbasis  Objek
Polimorfisme.  Sistem  ini  memungkinkan  pengguna  untuk  berperan  sebagai  penjual  yang
mengelola barang atau pembeli yang melakukan transaksi.

(PBO)  seperti  Enkapsulasi,

Batasan Sistem
Pengguna:

1.  Penjual

Pengguna  yang  memiliki  hak  akses  untuk  mengelola  toko,  menambahkan  daftar
produk baru ke katalog, mengatur stok barang, memantau status pesanan yang masuk.

2.  Pembeli

  Pengguna  yang  memiliki  akses  mencari  produk,  mengelola  keranjang  belanja,
melakukan  pembayaran  melalui  berbagai  metode,  dan  memberikan  ulasan  setelah
transaksi selesai.

Fitur:

1.  Login untuk Penjual dan Pembeli.
2.  Penjual dapat mengelola daftar barang, kategori, stok, dan harga produk.
3.  Pembeli dapat memasukkan beberapa barang kedalam keranjang.
4.  Pembeli  dapat  memberikan  feedback  atau  ulasan  dari  barang  yang sudah dibeli dari

penjual.

2.  Deskripsi Fitur dan Pembagian Tugas

PIC

Class

Fadhlan Anargya Agustian

Akun, Penjual

Hara Akmal Ardhani

Kupon

Muhammad Faiz Fadhlurrohman Bastomi

Keranjang, BarangKeranjang

Achmad Bagus Pratama

IPembayaran, EWallet, TransferBank

Gillbrian

Produk, Transaksi

 Fagian Anmila Syamsir

Ulasan, Pembeli

3.  Detail Kelas dan Relasi

Bagian ini merinci atribut, method, serta keterkaitan antar kelas yang membangun sistem EpStore.

A. Manajemen Akun

Sistem ini menggunakan Inheritance untuk mengelola kredensial pengguna melalui satu induk kelas.

?  Akun (Abstract Class): Merupakan kelas induk yang menyimpan data kredensial dasar.

?  Atribut: id (uuid), username (string), password (string).
?  Method: daftarAkun(), masukAkun(): boolean, gantiPassword(), getPassword():

string, dan abstract method homePage().

?  Pembeli: Kelas turunan dari Akun yang memiliki kemampuan belanja.

?  Relasi: Memiliki hubungan Komposisi (wajik hitam) dengan kelas Keranjang, yang
berarti keberadaan objek keranjang bergantung sepenuhnya pada objek pembeli.

?  Atribut Tambahan: alamat, nomor_telp, email, dan referensi keranjang.
?  Method Tambahan: editUsername(), setAlamat(), setNomor(), setEmail(), dan

setKeranjang().

?  Penjual: Kelas turunan dari Akun yang berwenang mengelola stok.

?  Relasi: Memiliki hubungan Komposisi terhadap kelas Produk. Jika akun penjual

dihapus, maka katalog produk yang ia kelola akan hilang dari sistem.

?  Atribut Tambahan: namaToko dan produk: ArrayList<Produk>.
?  Method Tambahan: aturNamaToko(), tambahProduk(), editProduk(), dan

hapusProduk().

B. Manajemen Produk dan Inventaris

Modul ini mengatur data barang yang tersedia di marketplace.

?  Produk: Bertindak sebagai kerangka dasar untuk informasi barang.

?  Atribut: id (integer), nama, harga (double), stok (integer), deskripsi.
?  Method: Getter dan Setter lengkap, tambahKeKeranjang(), dan produkPage().

?  Ulasan: Kelas yang mencatat feedback pembeli.

?  Relasi: Berhubungan secara Komposisi dengan kelas Transaksi (multiplisitas 0..1 ke

1). Sebuah ulasan hanya valid jika terikat pada satu transaksi.

?  Atribut: rating (integer) dan komentar.

C. Alur Belanja dan Keranjang

Modul ini menggunakan objek perantara untuk efisiensi penyimpanan data belanja.

?  Keranjang: Wadah penampung barang sementara bagi pembeli.

?  Relasi: Memiliki hubungan Komposisi dengan BarangKeranjang.
?  Atribut: id_keranjang (integer), total_harga (double), dan daftarItem:

ArrayList<BarangKeranjang>.

?  Method: tambahItem(), hapusItem(), getDaftarItem(), dan kosongkanKeranjang().

?  BarangKeranjang: Kelas perantara untuk mendefinisikan kuantitas produk di dalam

keranjang.

?  Relasi: Memiliki hubungan Agregasi (wajik putih) dengan Produk. Artinya, jika item

dihapus dari keranjang, objek asli Produk di katalog tidak akan terhapus.

?  Atribut: id (integer), produk (Produk), qty (integer).

D. Transaksi dan Polimorfisme Pembayaran

Bagian ini menangani proses akhir (checkout) dan validasi pembayaran.

?  Transaksi: Mengelola finalisasi pesanan.

?  Relasi: Memiliki hubungan Asosiasi dengan kelas Kupon (0..1 ke 1). Secara internal

mengelola daftar item dari keranjang melalui relasi Komposisi dengan
BarangKeranjang.

?  Atribut: id_transaksi (int), tanggal (date), metode (string), status_pembayaran

(boolean), dan total_harga (double).

?  Method: buatPesanan() dan update_status_pembayaran().

?  Payable (Interface): Kontrak standar untuk semua metode pembayaran.

?

Implementasi: Digunakan oleh kelas EWallet dan TransferBank melalui method
prosesBayar(total: double). Hal ini memungkinkan terjadinya Polymorphism saat
proses pelunasan transaksi.

?  Kupon: Kelas untuk mengelola promo potongan harga.
?  Atribut: kodePromo dan persenDiskon.
?  Method: hitungPotongan() dan cekMasaBerlaku().


