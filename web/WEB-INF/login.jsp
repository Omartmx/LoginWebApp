<%-- 
    Document   : login
    Created on : 21/08/2025, 12:37:32 a. m.
    Author     : omarf
--%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Libreria Hogwarts</title>
    <style>
        /* Estilos mejorados (se mantienen similares a los tuyos) */
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
        }

        .container {
            width: 100%;
            max-width: 450px;
            background-color: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
        }

        .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo h1 {
            color: #d3a625;
            font-size: 2.5rem;
            text-shadow: 0 0 10px rgba(211, 166, 37, 0.5);
            letter-spacing: 2px;
            margin-bottom: 5px;
        }

        .logo h2 {
            color: #fff;
            font-size: 1.8rem;
            font-weight: 400;
            letter-spacing: 3px;
        }

        .login-form {
            width: 100%;
        }

        .form-group {
            margin-bottom: 25px;
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

        .btn-login {
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
        }

        .btn-login:hover {
            background-color: #c6950c;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(211, 166, 37, 0.4);
        }

        .register-link {
            text-align: center;
            margin-top: 25px;
            color: rgba(255, 255, 255, 0.7);
        }

        .register-link a {
            color: #d3a625;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .register-link a:hover {
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
            animation: fadeIn 0.5s ease;
        }

        .error-message.show {
            display: block;
        }

        .input-error {
            border-color: #ff4d4d !important;
            box-shadow: 0 0 10px rgba(255, 77, 77, 0.3) !important;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }

        .shake {
            animation: shake 0.5s ease;
        }

        @media (max-width: 576px) {
            .container {
                padding: 30px 20px;
            }

            .logo h1 {
                font-size: 2rem;
            }

            .logo h2 {
                font-size: 1.5rem;
            }
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
            animation: fadeIn 0.5s ease;
        }

        .success-message.show {
            display: block;
        }
    </style>
</head>
<body>
    <div class="decoration"></div>
    <div class="decoration"></div>

    <div class="container">
        <div class="logo">
            <h1>LOGIN</h1>
            <h2>LIBRERIA HOGWARTS</h2>
        </div>

        <!-- Mensajes de estado -->
        <div id="errorMessage" class="error-message"></div>
        <div id="successMessage" class="success-message"></div>

        <form class="login-form" action="LoginServlet" method="POST" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="usuario">EMAIL</label>
                <input type="email" id="usuario" name="usuario" required>
            </div>

            <div class="form-group">
                <label for="password">PASSWORD</label>
                <input type="password" id="password" name="password" required>
            </div>

            <button type="submit" class="btn-login">Iniciar sesión</button>
        </form>

        <div class="register-link">
            <p>No tiene una cuenta? <a href="registro.jsp">Cree una.</a></p>
        </div>
    </div>

    <script>
        // Función para validar el formulario antes de enviar
        function validateForm() {
            const email = document.getElementById('usuario').value;
            const password = document.getElementById('password').value;
            const errorDiv = document.getElementById('errorMessage');
            
            // Resetear mensajes
            errorDiv.classList.remove('show');
            
            // Validar email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showError('Por favor, ingrese un email válido');
                return false;
            }
            
            // Validar contraseña
            if (password.length < 6) {
                showError('La contraseña debe tener al menos 6 caracteres');
                return false;
            }
            
            return true;
        }
        
        // Función para mostrar errores
        function showError(message) {
            const errorDiv = document.getElementById('errorMessage');
            errorDiv.textContent = message;
            errorDiv.classList.add('show');
            
            // Efecto de sacudida
            const container = document.querySelector('.container');
            container.classList.add('shake');
            setTimeout(() => {
                container.classList.remove('shake');
            }, 500);
        }
        
        // Función para mostrar mensajes de éxito
        function showSuccess(message) {
            const successDiv = document.getElementById('successMessage');
            successDiv.textContent = message;
            successDiv.classList.add('show');
        }
        
        // Verificar si hay parámetros de URL para mostrar mensajes
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            
            if (urlParams.has('error')) {
                showError('Credenciales incorrectas. Intente nuevamente.');
            }
            
            if (urlParams.has('success')) {
                showSuccess('Registro exitoso. Ahora puede iniciar sesión.');
            }
            
            if (urlParams.has('logout')) {
                showSuccess('Ha cerrado sesión correctamente.');
            }
        });
    </script>
</body>
</html>