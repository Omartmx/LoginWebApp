package conexion;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection conn = null;
        try {
            // ✅ Usa System.getenv() para acceder a las variables de entorno
            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");
            String db   = System.getenv("MYSQLDATABASE");
            String user = System.getenv("MYSQLUSER");
            String pass = System.getenv("MYSQLPASSWORD");
            
            String url = "jdbc:mysql://" + host + ":" + port + "/" + db +
                         "?useSSL=true&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("✅ Conexión exitosa a Railway MySQL");
        } catch (Exception e) {
            System.out.println("❌ Error en la conexión: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}