import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class dbInterface {
    
    // Method to establish a database connection
    public static Connection connect() {
        try {
            // Database connection parameters
            String url = "jdbc:mysql://localhost:3306/carsdb"; // Replace with your database name
            String user = "root"; // Replace with your MySQL username
            String password = ""; // Replace with your MySQL password

            // Establish and return the connection
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connection to the database established successfully.");
            return conn;
        } catch (SQLException e) {
            System.out.println("Error connecting to the database: " + e.getMessage());
            return null;
        }
    }

    // Method to close the database connection
    public void disconnect(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Connection to the database closed successfully.");
            } catch (SQLException e) {
                System.out.println("Error closing the database connection: " + e.getMessage());
            }
        }
    }
}