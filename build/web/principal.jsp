<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%
    // Recuperar datos de usuario de la sesión
    String nombreUsuario = (String) session.getAttribute("usuario");
    String email = (String) session.getAttribute("email");
    Integer idUsuario = (Integer) session.getAttribute("id_usuario");
    
    // Recuperar estado de la factura
    Boolean facturaActiva = (Boolean) session.getAttribute("factura_activa");
    if (facturaActiva == null) {
        facturaActiva = false;
    }
    
    // Si no hay usuario en sesión, redirigir al login
    if (nombreUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    if (email == null) {
        email = "No especificado";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Datos Personales - Alquiler de Libros</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            padding: 20px;
            color: white;
            position: relative;
        }

        .container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            background-color: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            z-index: 1;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #d3a625;
            padding-bottom: 20px;
        }

        .header h1 {
            color: #d3a625;
            font-size: 2.2rem;
            text-shadow: 0 0 10px rgba(211, 166, 37, 0.5);
            letter-spacing: 1px;
            margin-bottom: 10px;
        }

        .user-info {
            position: fixed;
            top: 20px;
            right: 20px;
            background: rgba(211, 166, 37, 0.2);
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px solid #d3a625;
            z-index: 1000;
            backdrop-filter: blur(5px);
        }

        .user-info p {
            margin: 5px 0;
            font-size: 0.9rem;
        }

        .user-info a {
            color: #d3a625;
            font-size: 0.8rem;
            text-decoration: none;
            display: block;
            text-align: center;
            margin-top: 5px;
        }

        .user-info a:hover {
            text-decoration: underline;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            color: #d3a625;
            margin-bottom: 8px;
            font-size: 1rem;
            font-weight: bold;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 12px;
            border: none;
            background-color: rgba(0, 0, 0, 0.3);
            border-radius: 8px;
            color: #fff;
            font-size: 1rem;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #d3a625;
            box-shadow: 0 0 10px rgba(211, 166, 37, 0.3);
        }

        .form-group select option {
            background-color: #1a1a2e;
            color: white;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .separator {
            height: 2px;
            background: linear-gradient(90deg, transparent, #d3a625, transparent);
            margin: 30px 0;
        }

        .books-section {
            margin-bottom: 30px;
        }

        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .book-card {
            background-color: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            padding: 15px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
        }

        .book-card.selected {
            border: 2px solid #d3a625;
            box-shadow: 0 0 15px rgba(211, 166, 37, 0.5);
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .book-card h3 {
            color: #d3a625;
            margin-bottom: 10px;
            font-size: 1.2rem;
        }

        .book-card p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        .book-card .price {
            color: #d3a625;
            font-weight: bold;
            font-size: 1.1rem;
            margin-top: 10px;
        }

        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 120px;
        }

        .btn-clear {
            background-color: #6c757d;
            color: white;
        }

        .btn-modify {
            background-color: #17a2b8;
            color: white;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-rent {
            background-color: #d3a625;
            color: #1a1a2e;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }

        .btn-clear:hover {
            background-color: #5a6268;
        }

        .btn-modify:hover {
            background-color: #138496;
        }

        .btn-delete:hover {
            background-color: #c82333;
        }

        .btn-rent:hover {
            background-color: #c6950c;
        }

        .invoice-section {
            margin-top: 40px;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            display: none;
        }

        .invoice-section h2 {
            color: #d3a625;
            margin-bottom: 20px;
            text-align: center;
        }

        .invoice-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .invoice-item {
            margin-bottom: 10px;
        }

        .invoice-item strong {
            color: #d3a625;
        }

        .decoration {
            position: fixed;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(211, 166, 37, 0.2) 0%, transparent 70%);
            border-radius: 50%;
            z-index: 0;
        }

        .decoration:nth-child(1) {
            top: 10%;
            left: 10%;
        }

        .decoration:nth-child(2) {
            bottom: 10%;
            right: 10%;
        }

        .notification {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 15px 20px;
            border-radius: 8px;
            background-color: #d3a625;
            color: #1a1a2e;
            font-weight: bold;
            z-index: 2000;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            display: none;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .books-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 250px;
            }

            .invoice-details {
                grid-template-columns: 1fr;
            }

            .user-info {
                position: relative;
                top: 0;
                right: 0;
                margin-bottom: 20px;
                text-align: center;
                width: 100%;
            }
        }

        @media print {
            body * {
                visibility: hidden;
            }
            .invoice-section, .invoice-section * {
                visibility: visible;
            }
            .invoice-section {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
                background-color: white;
                color: black;
            }
            .btn {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="decoration"></div>
    <div class="decoration"></div>

    <div class="notification" id="notification"></div>

    <!-- Información del usuario - FIXED y con z-index alto -->
    <div class="user-info">
        <p><strong>Usuario:</strong> <%= nombreUsuario%></p>
        <p><strong>Email:</strong> <%= email%></p>
        <a href="login.jsp?logout=true">Cerrar sesión</a>
    </div>

    <div class="container">
        <div class="header">
            <h1>DATOS PERSONALES ALQUILER DE LIBROS</h1>
        </div>

        <div class="form-section">
            <div class="form-grid">
                <div class="form-group">
                    <label for="tipoDocumento">Tipo Documento</label>
                    <select id="tipoDocumento" name="tipoDocumento">
                        <option value="">Seleccione...</option>
                        <option value="registroCivil">Registro Civil</option>
                        <option value="tarjetaIdentidad">Tarjeta de Identidad</option>
                        <option value="cedula">Cédula</option>
                        <option value="pasaporte">Pasaporte</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="numeroDocumento">Número de Documento</label>
                    <input type="text" id="numeroDocumento" name="numeroDocumento" placeholder="Ingrese su número de documento">
                </div>

                <div class="form-group">
                    <label for="ocupacion">Ocupación</label>
                    <select id="ocupacion" name="ocupacion">
                        <option value="">Seleccione...</option>
                        <option value="empleado">Empleado</option>
                        <option value="estudiante">Estudiante</option>
                        <option value="independiente">Independiente</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="reduccionAlquiler">Reducción de Alquiler</label>
                    <input type="text" id="reduccionAlquiler" name="reduccionAlquiler" readonly>
                </div>

                <div class="form-group">
                    <label for="fechaInicio">Fecha de Inicio</label>
                    <input type="date" id="fechaInicio" name="fechaInicio">
                </div>

                <div class="form-group">
                    <label for="diasAlquiler">Días de Alquiler</label>
                    <input type="number" id="diasAlquiler" name="diasAlquiler" min="1" value="7">
                </div>

                <div class="form-group">
                    <label for="diasRetraso">Días de Retraso Permitidos</label>
                    <input type="text" id="diasRetraso" name="diasRetraso" readonly>
                </div>
            </div>
        </div>

        <div class="separator"></div>

        <div class="books-section">
            <h2 style="color: #d3a625; margin-bottom: 20px; text-align: center;">Libros Disponibles</h2>

            <div class="books-grid">
                <div class="book-card" data-precio="15000" data-id="1">
                    <h3>Luces de Bohemia</h3>
                    <p><strong>Autor:</strong> Ramón María del Valle-Inclán</p>
                    <p><strong>Género:</strong> Teatro</p>
                    <p><strong>Disponibilidad:</strong> Sí</p>
                    <p class="price">$15.000</p>
                </div>

                <div class="book-card" data-precio="25000" data-id="2">
                    <h3>Cien Anos de Soledad</h3>
                    <p><strong>Autor:</strong> Gabriel García Márquez</p>
                    <p><strong>Género:</strong> Novela</p>
                    <p><strong>Disponibilidad:</strong> Sí</p>
                    <p class="price">$25.000</p>
                </div>

                <div class="book-card" data-precio="18000" data-id="3">
                    <h3>Don Quijote de la Mancha</h3>
                    <p><strong>Autor:</strong> Miguel de Cervantes</p>
                    <p><strong>Género:</strong> Novela</p>
                    <p><strong>Disponibilidad:</strong> No</p>
                    <p class="price">$18.000</p>
                </div>

                <div class="book-card" data-precio="22000" data-id="4">
                    <h3>La Sombra del Viento</h3>
                    <p><strong>Autor:</strong> Carlos Ruiz Zafón</p>
                    <p><strong>Género:</strong> Novela</p>
                    <p><strong>Disponibilidad:</strong> Sí</p>
                    <p class="price">$22.000</p>
                </div>
            </div>
        </div>

        <div class="separator"></div>

        <div class="action-buttons">
            <button type="button" class="btn btn-clear" onclick="clearForm()">Limpiar</button>
            <button type="button" class="btn btn-modify" onclick="modifyRental()">Modificar</button>
            <button type="button" class="btn btn-delete" onclick="deleteRental()">Eliminar</button>
            <button type="button" class="btn btn-rent" onclick="rentBook()">Alquilar</button>
        </div>

        <div id="invoice" class="invoice-section" style="display: <%= facturaActiva ? "block" : "none"%>;">
            <h2>Factura de Alquiler</h2>
            <div class="invoice-details">
                <div class="invoice-item"><strong>Cliente:</strong> <span id="invoice-client"><%= nombreUsuario%></span></div>
                <div class="invoice-item"><strong>Email:</strong> <span id="invoice-email"><%= email%></span></div>
                <div class="invoice-item"><strong>Documento:</strong> <span id="invoice-document"></span></div>
                <div class="invoice-item"><strong>Libro:</strong> <span id="invoice-book"></span></div>
                <div class="invoice-item"><strong>Precio por día:</strong> $<span id="invoice-price"></span></div>
                <div class="invoice-item"><strong>Días de alquiler:</strong> <span id="invoice-days"></span></div>
                <div class="invoice-item"><strong>Reducción aplicada:</strong> <span id="invoice-discount"></span></div>
                <div class="invoice-item"><strong>Fecha de inicio:</strong> <span id="invoice-start"></span></div>
                <div class="invoice-item"><strong>Fecha de entrega:</strong> <span id="invoice-end"></span></div>
                <div class="invoice-item"><strong>Días de retraso permitidos:</strong> <span id="invoice-delay"></span></div>
                <div class="invoice-item"><strong>Total a pagar:</strong> $<span id="invoice-total"></span></div>
            </div>
            <div class="action-buttons" style="margin-top: 20px;">
                <button type="button" class="btn btn-delete" onclick="cancelRental()">Cancelar Alquiler</button>
                <button type="button" class="btn btn-rent" onclick="printInvoice()">Imprimir Factura</button>
            </div>
        </div>
    </div>

    <script>
        // Variables globales
        let selectedBook = null;
        let currentRental = null;

        // Función para mostrar notificaciones
        function showNotification(message, isSuccess = true) {
            const notification = document.getElementById('notification');
            notification.textContent = message;
            notification.style.backgroundColor = isSuccess ? '#d3a625' : '#dc3545';
            notification.style.display = 'block';
            
            setTimeout(() => {
                notification.style.display = 'none';
            }, 3000);
        }

        // Cargar factura existente si hay una activa
        document.addEventListener('DOMContentLoaded', function () {
            <% if (facturaActiva) { %>
                cargarFacturaDesdeBD();
            <% }%>

            // Configurar event listeners
            configurarEventListeners();

            // Establecer fecha mínima como hoy
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('fechaInicio').setAttribute('min', today);
        });

        function configurarEventListeners() {
            // Actualizar campos según la ocupación seleccionada
            const ocupacionSelect = document.getElementById('ocupacion');
            const reduccionAlquiler = document.getElementById('reduccionAlquiler');
            const diasRetraso = document.getElementById('diasRetraso');

            ocupacionSelect.addEventListener('change', function () {
                switch (this.value) {
                    case 'empleado':
                        reduccionAlquiler.value = '10%';
                        diasRetraso.value = '5 dias maximo';
                        break;
                    case 'estudiante':
                        reduccionAlquiler.value = '15%';
                        diasRetraso.value = '7 dias maximo';
                        break;
                    case 'independiente':
                        reduccionAlquiler.value = '5%';
                        diasRetraso.value = '3 dias maximo';
                        break;
                    default:
                        reduccionAlquiler.value = '';
                        diasRetraso.value = '';
                }
            });

            // Selección de libros
            const bookCards = document.querySelectorAll('.book-card');
            bookCards.forEach(card => {
                card.addEventListener('click', function () {
                    // No seleccionar si no está disponible
                    if (this.querySelector('p:last-child').textContent.includes('No')) {
                        showNotification('Este libro no está disponible para alquiler.', false);
                        return;
                    }

                    // Quitar selección anterior
                    bookCards.forEach(c => c.classList.remove('selected'));

                    // Marcar como seleccionado
                    this.classList.add('selected');
                    selectedBook = this;
                });
            });
        }

        function cargarFacturaDesdeBD() {
            fetch('FacturaServlet')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Error en la respuesta del servidor');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        const factura = data.factura;
                        
                        // Llenar el formulario con los datos de la factura
                        document.getElementById('tipoDocumento').value = factura.tipoDocumento;
                        document.getElementById('numeroDocumento').value = factura.numeroDocumento;
                        document.getElementById('ocupacion').value = factura.ocupacion;
                        document.getElementById('fechaInicio').value = factura.fechaInicio;
                        document.getElementById('diasAlquiler').value = factura.dias;

                        // Seleccionar el libro
                        const bookCard = document.querySelector(`.book-card[data-id="${factura.libroId}"]`);
                        if (bookCard) {
                            bookCard.classList.add('selected');
                            selectedBook = bookCard;
                        }

                        // Actualizar campos calculados
                        if (factura.ocupacion) {
                            document.getElementById('ocupacion').dispatchEvent(new Event('change'));
                        }

                        // Mostrar factura
                        mostrarFactura(factura);
                    } else {
                        showNotification('Error al cargar factura: ' + data.error, false);
                    }
                })
                .catch(error => {
                    console.error('Error al cargar factura:', error);
                    showNotification('Error al cargar factura. Verifica la conexión.', false);
                });
        }

        function mostrarFactura(factura) {
            document.getElementById('invoice-document').textContent = factura.tipoDocumento + ": " + factura.numeroDocumento;
            document.getElementById('invoice-book').textContent = factura.libro;
            document.getElementById('invoice-price').textContent = factura.precio.toLocaleString();
            document.getElementById('invoice-days').textContent = factura.dias;
            document.getElementById('invoice-discount').textContent = factura.descuento;
            document.getElementById('invoice-start').textContent = factura.fechaInicio;
            document.getElementById('invoice-end').textContent = factura.fechaEntrega;
            document.getElementById('invoice-delay').textContent = factura.diasRetraso;
            document.getElementById('invoice-total').textContent = factura.total.toLocaleString();

            document.getElementById('invoice').style.display = 'block';
            currentRental = factura;
        }

        function clearForm() {
            document.querySelectorAll('input, select').forEach(element => {
                if (element.type !== 'button' && !element.readOnly) {
                    element.value = '';
                }
            });

            document.querySelectorAll('.book-card').forEach(card => {
                card.classList.remove('selected');
            });

            selectedBook = null;
            document.getElementById('invoice').style.display = 'none';

            // Restablecer días de alquiler a valor por defecto
            document.getElementById('diasAlquiler').value = 7;
        }

        function rentBook() {
            // Validaciones
            const tipoDocumento = document.getElementById('tipoDocumento').value;
            const numeroDocumento = document.getElementById('numeroDocumento').value;
            const ocupacion = document.getElementById('ocupacion').value;
            const fechaInicio = document.getElementById('fechaInicio').value;
            const diasAlquiler = document.getElementById('diasAlquiler').value;

            if (!tipoDocumento || !numeroDocumento || !ocupacion || !fechaInicio || !diasAlquiler) {
                showNotification('Por favor, complete todos los campos obligatorios.', false);
                return;
            }

            if (!selectedBook) {
                showNotification('Por favor, seleccione un libro para alquilar.', false);
                return;
            }

            // Calcular fechas y precios
            const startDate = new Date(fechaInicio);
            const endDate = new Date(startDate);
            endDate.setDate(startDate.getDate() + parseInt(diasAlquiler));

            const bookPrice = parseInt(selectedBook.dataset.precio);
            const discount = parseInt(document.getElementById('reduccionAlquiler').value) || 0;
            const discountMultiplier = (100 - discount) / 100;
            const total = bookPrice * parseInt(diasAlquiler) * discountMultiplier;

            // Obtener el texto del tipo de documento (no solo el valor)
            const tipoDocumentoSelect = document.getElementById('tipoDocumento');
            const tipoDocumentoText = tipoDocumentoSelect.options[tipoDocumentoSelect.selectedIndex].text;

            // Guardar información del alquiler COMPLETA
            currentRental = {
                tipoDocumento: tipoDocumento, // valor
                tipoDocumentoText: tipoDocumentoText, // texto
                numeroDocumento: numeroDocumento,
                ocupacion: ocupacion,
                libro: selectedBook.querySelector('h3').textContent,
                libroId: selectedBook.dataset.id,
                precio: bookPrice,
                dias: diasAlquiler,
                descuento: discount + '%',
                fechaInicio: fechaInicio,
                fechaEntrega: endDate.toISOString().split('T')[0],
                diasRetraso: document.getElementById('diasRetraso').value,
                total: total
            };

            // Guardar factura en la base de datos
            guardarFacturaEnBD();
        }

        function guardarFacturaEnBD() {
            const params = new URLSearchParams();
            params.append("action", "guardar");
            params.append("tipoDocumento", currentRental.tipoDocumento);
            params.append("numeroDocumento", currentRental.numeroDocumento);
            params.append("ocupacion", currentRental.ocupacion);
            params.append("libro", currentRental.libro);
            params.append("libroId", currentRental.libroId);
            params.append("precio", currentRental.precio);
            params.append("dias", currentRental.dias);
            params.append("descuento", currentRental.descuento);
            params.append("fechaInicio", currentRental.fechaInicio);
            params.append("fechaEntrega", currentRental.fechaEntrega);
            params.append("diasRetraso", currentRental.diasRetraso);
            params.append("total", currentRental.total);

            fetch('FacturaServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error en la respuesta del servidor');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    // Mostrar la factura con los datos actuales
                    mostrarFactura(currentRental);
                    showNotification('Factura guardada correctamente en la base de datos.');
                    
                    // Recargar la página para actualizar el estado de la sesión
                    setTimeout(() => {
                        location.reload();
                    }, 1500);
                } else {
                    showNotification('Error al guardar la factura: ' + data.error, false);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Error al guardar la factura. Verifica la consola para más detalles.', false);
            });
        }

        function modifyRental() {
            if (currentRental) {
                // Habilitar edición de campos
                const editableFields = ['diasAlquiler', 'fechaInicio'];
                editableFields.forEach(field => {
                    document.getElementById(field).removeAttribute('readonly');
                });

                showNotification('Puede modificar los días de alquiler y la fecha de inicio.');
            } else {
                showNotification('No hay ningún alquiler activo para modificar.', false);
            }
        }

        function deleteRental() {
            if (currentRental) {
                cancelRental();
            } else {
                showNotification('No hay ningún alquiler activo para eliminar.', false);
            }
        }

        function cancelRental() {
            if (confirm('¿Está seguro de que desea cancelar este alquiler?')) {
                // Usar POST en lugar de GET para cancelar
                const params = new URLSearchParams();
                params.append("action", "cancelar");

                fetch('FacturaServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: params.toString()
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Error en la respuesta del servidor');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        currentRental = null;
                        document.getElementById('invoice').style.display = 'none';
                        clearForm();
                        showNotification('Alquiler cancelado exitosamente.');
                        
                        // Recargar la página para actualizar el estado de la sesión
                        setTimeout(() => {
                            location.reload();
                        }, 1500);
                    } else {
                        showNotification('Error al cancelar la factura: ' + data.error, false);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Error al cancelar la factura', false);
                });
            }
        }

        function printInvoice() {
            window.print();
        }
    </script>
</body>
</html>