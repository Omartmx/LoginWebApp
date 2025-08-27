
package conexion;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection conn = null;
        try {
            // CAMBIA getenv() por getProperty()
            String host = System.getProperty("MYSQLHOST");        // ← CAMBIADO
            String port = System.getProperty("MYSQLPORT");        // ← CAMBIADO
            String db   = System.getProperty("MYSQLDATABASE");    // ← CAMBIADO
            String user = System.getProperty("MYSQLUSER");        // ← CAMBIADO
            String pass = System.getProperty("MYSQLPASSWORD");    // ← CAMBIADO
            
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