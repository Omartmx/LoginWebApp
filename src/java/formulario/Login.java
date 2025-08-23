package formulario;

import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Login {
    public boolean autenticar(String email, String password) {
    boolean ok = false;
    try {
        Conexion con = new Conexion();
        Connection cn = Conexion.getConexion();

        String sql = "SELECT * FROM usuarios WHERE email=? AND password=?";
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setString(1, email);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            ok = true;
        }

        cn.close();
    } catch (Exception e) {
        System.out.println("Error en login: " + e.getMessage());
    }
    return ok;
    }
}
