package formulario;
import modelo.IPersona;

public abstract class Formulario implements IFormulario {
    protected IPersona persona;

    public abstract void registrarUsuario();
    public abstract boolean validarUsuario();
}
