Letakkan file gambar produk di folder ini.

Path pada kolom `gambar` di tabel `produk` relatif terhadap context root,
contoh nilai di database: "sources/images/products/headphone.png"
-> file fisik: web/sources/images/products/headphone.png

Nama file yang dipakai oleh produk.sql:
  - headphone.png
  - tas-ransel.png
  - sneakers.png
  - jam-tangan.png
  - powerbank.png
  - mie-instan.png
  - serum.png
  - payung.png

Jika file gambar belum ada, katalog otomatis menampilkan ikon placeholder
(lihat onerror pada <img> di web/buyer/index.jsp).
