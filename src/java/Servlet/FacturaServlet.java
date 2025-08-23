/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlet;

import conexion.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "FacturaServlet", urlPatterns = {"/FacturaServlet"})
public class FacturaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // DEBUG: Imprimir todos los parámetros recibidos
        System.out.println("Parámetros recibidos:");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println(paramName + " = " + paramValue);
        }
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            Integer idUsuario = (Integer) session.getAttribute("id_usuario");

            if (idUsuario == null) {
                out.print("{\"success\": false, \"error\": \"Usuario no autenticado\"}");
                return;
            }

            String action = request.getParameter("action");

            if ("guardar".equals(action)) {
                guardarFactura(request, response, idUsuario, session);
            } else if ("cancelar".equals(action)) {
                cancelarFactura(request, response, session);
            } else {
                out.print("{\"success\": false, \"error\": \"Acción no válida\"}");
            }
        }
    }

    private void guardarFactura(HttpServletRequest request, HttpServletResponse response,
            Integer idUsuario, HttpSession session) throws IOException {

        try (PrintWriter out = response.getWriter()) {
            Connection conn = Conexion.conectar();

            // Insertar nueva factura
            String sql = "INSERT INTO facturas (id_usuario, tipo_documento, numero_documento, ocupacion, "
                    + "libro, libro_id, precio_dia, dias_alquiler, descuento, fecha_inicio, "
                    + "fecha_entrega, dias_retraso, total_pagar) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, idUsuario);
            ps.setString(2, request.getParameter("tipoDocumento"));
            ps.setString(3, request.getParameter("numeroDocumento"));
            ps.setString(4, request.getParameter("ocupacion"));
            ps.setString(5, request.getParameter("libro"));
            ps.setInt(6, Integer.parseInt(request.getParameter("libroId")));
            ps.setDouble(7, Double.parseDouble(request.getParameter("precio")));
            ps.setInt(8, Integer.parseInt(request.getParameter("dias")));
            ps.setString(9, request.getParameter("descuento"));
            ps.setString(10, request.getParameter("fechaInicio"));
            ps.setString(11, request.getParameter("fechaEntrega"));
            ps.setString(12, request.getParameter("diasRetraso"));
            ps.setDouble(13, Double.parseDouble(request.getParameter("total")));

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                // Obtener el ID de la factura recién creada
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int idFactura = generatedKeys.getInt(1);
                    session.setAttribute("factura_activa", true);
                    session.setAttribute("id_factura", idFactura);
                }
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"error\": \"No se pudo guardar la factura\"}");
            }

            conn.close();
        } catch (Exception e) {
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
            }
        }
    }

    private void cancelarFactura(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {

        try (PrintWriter out = response.getWriter()) {
            Integer idFactura = (Integer) session.getAttribute("id_factura");
            if (idFactura != null) {
                Connection conn = Conexion.conectar();

                // Marcar factura como inactiva
                String sql = "UPDATE facturas SET activa = FALSE WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, idFactura);
                ps.executeUpdate();

                session.setAttribute("factura_activa", false);
                session.removeAttribute("id_factura");

                out.print("{\"success\": true}");
                conn.close();
            } else {
                out.print("{\"success\": false, \"error\": \"No hay factura activa\"}");
            }
        } catch (Exception e) {
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            Integer idFactura = (Integer) session.getAttribute("id_factura");

            if (idFactura != null) {
                cargarFactura(idFactura, out);
            } else {
                out.print("{\"success\": false, \"error\": \"No hay factura activa\"}");
            }
        }
    }

    private void cargarFactura(Integer idFactura, PrintWriter out) {
        try {
            Connection conn = Conexion.conectar();

            String sql = "SELECT * FROM facturas WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idFactura);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                StringBuilder json = new StringBuilder();
                json.append("{")
                        .append("\"success\": true, ")
                        .append("\"factura\": {")
                        .append("\"tipoDocumento\": \"").append(rs.getString("tipo_documento")).append("\", ")
                        .append("\"numeroDocumento\": \"").append(rs.getString("numero_documento")).append("\", ")
                        .append("\"ocupacion\": \"").append(rs.getString("ocupacion")).append("\", ")
                        .append("\"libro\": \"").append(rs.getString("libro")).append("\", ")
                        .append("\"libroId\": ").append(rs.getInt("libro_id")).append(", ")
                        .append("\"precio\": ").append(rs.getDouble("precio_dia")).append(", ")
                        .append("\"dias\": ").append(rs.getInt("dias_alquiler")).append(", ")
                        .append("\"descuento\": \"").append(rs.getString("descuento")).append("\", ")
                        .append("\"fechaInicio\": \"").append(rs.getDate("fecha_inicio")).append("\", ")
                        .append("\"fechaEntrega\": \"").append(rs.getDate("fecha_entrega")).append("\", ")
                        .append("\"diasRetraso\": \"").append(rs.getString("dias_retraso")).append("\", ")
                        .append("\"total\": ").append(rs.getDouble("total_pagar"))
                        .append("}")
                        .append("}");

                out.print(json.toString());
            } else {
                out.print("{\"success\": false, \"error\": \"Factura no encontrada\"}");
            }

            conn.close();
        } catch (Exception e) {
            out.print("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}
