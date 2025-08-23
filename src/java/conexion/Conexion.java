
package conexion;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection conn = null;
        try {
            // Usa estos nombres de variables (Railway los provee así)
            String host = System.getenv("MYSQLHOST");        // "shortline.proxy.rlwy.net"
            String port = System.getenv("MYSQLPORT");        // "13326"
            String db   = System.getenv("MYSQLDATABASE");    // "railway"
            String user = System.getenv("MYSQLUSER");        // "root"
            String pass = System.getenv("MYSQLPASSWORD");    // "jqTNGGgmNMWjDCleorllathSENosCLBY"
            
            // URL corregida - IMPORTANTE: añade allowPublicKeyRetrieval
            String url = "jdbc:mysql://" + host + ":" + port + "/" + db + 
                        "?useSSL=true&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("✅ Conexión exitosa a Railway MySQL");
        } catch (Exception e) {
            System.out.println("❌ Error en la conexión: " + e.getMessage());
            e.printStackTrace(); // Para más detalles del error
        }
        return conn;
    }
}