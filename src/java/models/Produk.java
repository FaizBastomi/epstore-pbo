package models;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

public class Produk extends Model<Produk> {

    private int id, stok;
    private String nama, deskripsi, kategori, gambar, penjual_id;
    private double harga;

    public Produk() {
        this.table = "produk";
        this.primaryKey = "id";
    }

    public String uploadGambar(Part filePart, String deployPath, String sourcePath) throws Exception {
        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = filePart.getSubmittedFileName();
            if (submittedFileName != null && !submittedFileName.trim().isEmpty()) {
                String fileName = java.nio.file.Paths.get(submittedFileName).getFileName().toString();
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;

                // Save to Source Directory (Persistent)
                File sourceDir = new File(sourcePath);
                if (!sourceDir.exists()) {
                    sourceDir.mkdirs();
                }
                File sourceFile = new File(sourceDir, uniqueFileName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, sourceFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }

                // Save to Deploy Directory (Immediate availability)
                File deployDir = new File(deployPath);
                if (!deployDir.exists()) {
                    deployDir.mkdirs();
                }
                File deployFile = new File(deployDir, uniqueFileName);
                Files.copy(sourceFile.toPath(), deployFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

                return "sources/images/products/" + uniqueFileName;
            }
        }
        return null;
    }

    public void deleteGambar(String deployBasePath) {
        if (this.gambar != null && !this.gambar.trim().isEmpty()) {
            String sourceBasePath = deployBasePath.replace(File.separator + "build" + File.separator + "web", File.separator + "web");
            File deployFile = new File(deployBasePath, this.gambar);
            File sourceFile = new File(sourceBasePath, this.gambar);

            if (deployFile.exists() && deployFile.isFile()) {
                deployFile.delete();
            }
            if (sourceFile.exists() && sourceFile.isFile()) {
                sourceFile.delete();
            }
        }
    }

    public int getId() {
        return id;
    }

    public int getStok() {
        return stok;
    }

    public String getNama() {
        return nama;
    }

    public String getDeskripsi() {
        return deskripsi;
    }

    public double getHarga() {
        return harga;
    }

    public String getKategori() {
        return kategori;
    }

    public String getGambar() {
        return gambar;
    }

    public String getPenjualId() {
        return penjual_id;
    }

    public void setStok(int stok) {
        this.stok = stok;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public void setDeskripsi(String deskripsi) {
        this.deskripsi = deskripsi;
    }

    public void setHarga(double harga) {
        this.harga = harga;
    }

    public void setKategori(String kategori) {
        this.kategori = kategori;
    }

    public void setGambar(String gambar) {
        this.gambar = gambar;
    }

    public void setPenjualId(String penjual_id) {
        this.penjual_id = penjual_id;
    }
}
