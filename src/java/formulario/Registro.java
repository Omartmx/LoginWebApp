package formulario;

import conexion.Conexion;
import modelo.IPersona;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class Registro extends Formulario implements IRegistro {

    @Override
    public void mostrarFormulario() {
        System.out.println("Mostrando formulario de registro...");
    }

    @Override
    public boolean validarDatos() {
        return persona != null &&
               persona.getNombre() != null &&
               persona.getEmail() != null &&
               persona.getPassword() != null;
    }

    @Override
    public void registrarUsuario() {
        if (persona != null) {
            try {
                Connection cn = Conexion.conectar();

                String sql = "INSERT INTO usuarios (nombre, apellido, email, password) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = cn.prepareStatement(sql);
                ps.setString(1, persona.getNombre());
                ps.setString(2, persona.getApellido());
                ps.setString(3, persona.getEmail());
                ps.setString(4, persona.getPassword());

                ps.executeUpdate();
                cn.close();

                System.out.println("✅ Usuario registrado en BD: " + persona.getNombre());
            } catch (Exception e) {
                System.out.println("❌ Error al registrar usuario: " + e.getMessage());
            }
        }
    }

    @Override
    public boolean validarUsuario() {
        return persona != null;
    }

    @Override
    public void crearUsuario(IPersona persona) {
        this.persona = persona;
        System.out.println("Usuario creado (en objeto): " + persona.getNombre());
    }

    @Override
    public void mostrarRegistro() {
        System.out.println("Mostrando pantalla de registro");
    }
}