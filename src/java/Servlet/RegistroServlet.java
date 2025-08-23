/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Servlet;

import java.sql.ResultSet;
import conexion.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroServlet", urlPatterns = {"/RegistroServlet"})
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Capturar datos del formulario
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection conn = Conexion.conectar();

            // 2️⃣ Verificar si el email ya existe
            String checkSql = "SELECT * FROM usuarios WHERE email=?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, email);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // ❌ Usuario ya existe
                request.setAttribute("mensaje", "❌ Usuario ya registrado.");
            } else {
                // 3️⃣ Insertar nuevo usuario
                String insertSql = "INSERT INTO usuarios (nombre, apellido, email, password) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(insertSql);
                ps.setString(1, nombre);
                ps.setString(2, apellido);
                ps.setString(3, email);
                ps.setString(4, password);
                ps.executeUpdate();

                request.setAttribute("mensaje", "✅ Usuario registrado correctamente.");
            }

            conn.close();
        } catch (Exception e) {
            request.setAttribute("mensaje", "⚠️ Error: " + e.getMessage());
        }

        // 4️⃣ Volver a la misma página (registro.jsp) con el mensaje
        request.getRequestDispatcher("registro.jsp").forward(request, response);
    }
}
