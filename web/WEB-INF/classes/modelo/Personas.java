package modelo;

public class Personas implements IPersona {
    private String nombre;
    private String apellido;
    private String email;
    private String Password;

    @Override
    public String getNombre() { return nombre; }
    @Override
    public void setNombre(String nombre) { this.nombre = nombre; }

    @Override
    public String getApellido() { return apellido; }
    @Override
    public void setApellido(String apellido) { this.apellido = apellido; }

    @Override
    public String getEmail() { return email; }
    @Override
    public void setEmail(String email) { this.email = email; }

    @Override
    public String getPassword() { return Password; }
    @Override
    public void setPassword(String contraseña) { this.Password = contraseña; }
}
