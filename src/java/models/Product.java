package models;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Product extends Model<Product> {

    private int id;
    private String name;
    private double price;

    public Product() {
        // (#1.2) 
        // Sesuaikan nilai table dan primaryKey
        this.table = "product";
        this.primaryKey = "id";
    }

    public Product(int id, String name, double price) {
        // (#1.3) Sesuaikan nilai table dan primaryKey 
        // serta konstruktor dari parameter yang telah diberikan
        this.table = "product";
        this.primaryKey = "id";

        this.id = id;
        this.name = name;
        this.price = price;
    }

    @Override
    public Product toModel(ResultSet rs) {
        try {
            return new Product(
                    // (#1.4) 
                    // Lakukan get resultSet dari tiap parameter kolom yang ada
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getDouble("price")
            );
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
            return null;
        }
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
