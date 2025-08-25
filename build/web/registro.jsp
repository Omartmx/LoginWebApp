<%-- 
    Document   : registro
    Created on : 21/08/2025, 12:40:39 a. m.
    Author     : omarf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - LibreBia Hogwarts</title>
    <style>
        /* [Mantén todos tus estilos actuales] */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            color: white;
        }

        .container {
            width: 100%;
            max-width: 600px;
            background-color: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #d3a625;
            padding-bottom: 20px;
        }

        .header h1 {
            color: #d3a625;
            font-size: 2.5rem;
            text-shadow: 0 0 10px rgba(211, 166, 37, 0.5);
            letter-spacing: 2px;
        }

        .form-container {
            width: 100%;
        }

        .form-row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -10px 20px;
        }

        .form-group {
            flex: 1 0 calc(50% - 20px);
            margin: 0 10px 20px;
            min-width: 250px;
        }

        .form-group label {
            display: block;
            color: #d3a625;
            margin-bottom: 8px;
            font-size: 1.1rem;
        }

        .form-group input {
            width: 100%;
            padding: 15px;
            border: none;
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            color: #fff;
            font-size: 1rem;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .form-group input:focus {
            outline: none;
            border-color: #d3a625;
            box-shadow: 0 0 10px rgba(211, 166, 37, 0.3);
        }

        .separator {
            height: 2px;
            background: linear-gradient(90deg, transparent, #d3a625, transparent);
            margin: 30px 0;
        }

        .btn-register {
            width: 100%;
            padding: 15px;
            background-color: #d3a625;
            border: none;
            border-radius: 8px;
            color: #1a1a2e;
            font-size: 1.2rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-register:hover {
            background-color: #c6950c;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(211, 166, 37, 0.4);
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            color: rgba(255, 255, 255, 0.7);
        }

        .login-link a {
            color: #d3a625;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .decoration {
            position: absolute;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(211, 166, 37, 0.2) 0%, transparent 70%);
            border-radius: 50%;
            z-index: -1;
        }

        .decoration:nth-child(1) {
            top: 10%;
            left: 10%;
        }

        .decoration:nth-child(2) {
            bottom: 10%;
            right: 10%;
        }

        .error-message {
            color: #ff4d4d;
            background-color: rgba(255, 77, 77, 0.1);
            border: 1px solid rgba(255, 77, 77, 0.3);
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            display: none;
        }

        .error-message.show {
            display: block;
        }

        .success-message {
            color: #4CAF50;
            background-color: rgba(76, 175, 80, 0.1);
            border: 1px solid rgba(76, 175, 80, 0.3);
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            display: none;
        }

        .success-message.show {
            display: block;
        }

        @media (max-width: 576px) {
            .container {
                padding: 30px 20px;
            }

            .header h1 {
                font-size: 2rem;
            }

            .form-group {
                flex: 1 0 100%;
            }
        }
    </style>
</head>
<body>
    <div class="decoration"></div>
    <div class="decoration"></div>

    <div class="container">
        <div class="header">
            <h1>Registro de Usuarios</h1>
        </div>

        <!-- Mensajes de error o éxito -->
        <div id="errorMessage" class="error-message"></div>
        <div id="successMessage" class="success-message"></div>

        <form class="form-container" action="RegistroServlet" method="POST" onsubmit="return validateForm()">
            <div class="form-row">
                <div class="form-group">
                    <label for="nombre">Nombre</label>
                    <input type="text" id="nombre" name="nombre" required>
                </div>

                <div class="form-group">
                    <label for="apellido">Apellido</label>
                    <input type="text" id="apellido" name="apellido" required>
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <button type="submit" class="btn-register">Registrar Usuario</button>

            <!-- Mensaje del servlet -->
            <%
                String mensaje = (String) request.getAttribute("mensaje");
                if (mensaje != null) {
            %>
            <div style="color:white; text-align:center; margin-top:20px; padding:10px; background-color:rgba(0,0,0,0.3); border-radius:5px;">
                <%= mensaje %>
            </div>
            <%
                }
            %>

            <div class="login-link">
                <p>¿Ya tienes una cuenta? <a href="login.jsp">Inicia sesión</a></p>
            </div>
        </form>
    </div>

    <script>
        // Validación del formulario
        function validateForm() {
            const nombre = document.getElementById('nombre').value;
            const apellido = document.getElementById('apellido').value;
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const errorDiv = document.getElementById('errorMessage');
            const successDiv = document.getElementById('successMessage');
            
            // Ocultar mensajes anteriores
            errorDiv.classList.remove('show');
            successDiv.classList.remove('show');
            
            // Validaciones
            if (nombre.length < 2) {
                showError('El nombre debe tener al menos 2 caracteres');
                return false;
            }
            
            if (apellido.length < 2) {
                showError('El apellido debe tener al menos 2 caracteres');
                return false;
            }
            
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showError('Por favor, ingrese un email válido');
                return false;
            }
            
            if (password.length < 6) {
                showError('La contraseña debe tener al menos 6 caracteres');
                return false;
            }
            
            return true;
        }
        
        function showError(message) {
            const errorDiv = document.getElementById('errorMessage');
            errorDiv.textContent = message;
            errorDiv.classList.add('show');
        }
        
        function showSuccess(message) {
            const successDiv = document.getElementById('successMessage');
            successDiv.textContent = message;
            successDiv.classList.add('show');
        }
        
        // Verificar parámetros de URL para mensajes
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            
            if (urlParams.has('error')) {
                showError('Error en el registro. Intente nuevamente.');
            }
            
            if (urlParams.has('success')) {
                showSuccess('Registro exitoso. Ahora puede iniciar sesión.');
            }
        });
    </script>
</body>
</html>