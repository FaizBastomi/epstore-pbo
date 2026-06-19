# EpStore - E-Commerce Web Application

EpStore is a Java-based web application featuring double-portal architecture (Buyer and Seller portals) built using JSP, Java Servlets (Jakarta EE 11), and MySQL database.

---

## 🛠️ Prerequisites

To run this project locally, ensure you have the following installed on your machine:

1. **Java Development Kit (JDK)**: JDK 17 or higher.
2. **Web Server**: Apache Tomcat 10.x or higher (required for compatibility with the `jakarta.servlet` namespace).
3. **Database**: MySQL Server (e.g., via XAMPP, Laragon, or standalone MySQL).
4. **JDBC Driver**: MySQL Connector/J (e.g., `mysql-connector-j-9.1.0.jar` or similar version 8.0/9.x).
5. **IDE**: NetBeans IDE 17+, VS Code (with Extension Pack for Java), or IntelliJ IDEA.

---

## 🗄️ Database Setup

1. Open your MySQL client (e.g., phpMyAdmin, DBeaver, or MySQL Workbench).
2. Create a new database named `epstore`:
   ```sql
   CREATE DATABASE epstore;
   ```
3. Import the SQL database dump:
   - **Recommended (with sample products & user data)**: Import [epstore-with-data.sql](epstore-with-data.sql).
   - **Clean database (schema only)**: Import [epstore-schema-only.sql](epstore-schema-only.sql).
4. Verify your local database credentials inside the model base class:
   - File location: [Model.java](src/java/models/Model.java#L30-L40)
   - Update the database connection line if your MySQL root credentials or port differ:
     ```java
     con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbname, "root", "");
     ```

---

## 🚀 Running the Project

### Using NetBeans IDE (Recommended)
1. Open NetBeans IDE and select **Open Project** -> select the `EpStore` directory.
2. If NetBeans shows library reference errors:
   - Right-click the `EpStore` project, choose **Properties**, and go to **Libraries**.
   - Ensure the server is set to **Apache Tomcat 10** (or similar compatible Jakarta EE 11 container).
   - Add/resolve the JDBC driver: Download the [MySQL Connector/J JAR](https://dev.mysql.com/downloads/connector/j/) and add it to your project compile libraries, or place it under `web/WEB-INF/lib/`.
3. Right-click the project and click **Clean and Build**.
4. Right-click the project and click **Run**.
5. The application will be deployed and should automatically open in your default browser at `http://localhost:8080/EpStore/` (or your configured local server port).

### Default Logins (from `epstore-with-data.sql`)
You can use the following default credentials to test the portals:
- **Buyer Account**: Username: `xiao_shogun` / Password: `xiao_shogun`
- **Seller Account**: Username: `silver_kafka` / Password: `silver_kafka`
