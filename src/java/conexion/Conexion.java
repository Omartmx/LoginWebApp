
package conexion;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    private static final String URL = "jdbc:mysql://localhost:3306/loginwebappdb";
    private static final String USER = "root";  // tu usuario MySQL
    private static final String PASS = ""; // tu contraseña MySQL

    public static Connection conectar() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
