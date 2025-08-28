package conexion;
import java.sql.Connection;

public interface IConexion {
    Connection getConexion();
    void desconectar();
}
