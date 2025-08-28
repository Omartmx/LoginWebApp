package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    public static Connection getConexion() {
        Connection conn = null;
        try {
            // Lee las variables de entorno de Railway
            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");
            String db   = System.getenv("MYSQLDATABASE");
            String user = System.getenv("MYSQLUSER");
            String pass = System.getenv("MYSQLPASSWORD");
            
            System.out.println("Connecting to: " + host + ":" + port + "/" + db);

            
            String url = "jdbc:mysql://" + host + ":" + port + "/" + db + "?useSSL=true&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("✅ Conexión exitosa a Railway MySQL");
        } catch (SQLException e) {
            System.err.println("❌ Error en la conexión: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}