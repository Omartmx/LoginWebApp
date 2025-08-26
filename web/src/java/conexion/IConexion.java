package conexion;
import java.sql.Connection;

public interface IConexion {
    Connection getConnection();
    void desconectar();
}
