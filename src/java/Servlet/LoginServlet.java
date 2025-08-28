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

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            String email = request.getParameter("usuario");
            String password = request.getParameter("password");

            System.out.println("Intento de login: " + email); // ← Para debug

            try {
                Connection conn = Conexion.getConexion();

                // Consulta para autenticar usuario
                String sql = "SELECT * FROM usuarios WHERE email=? AND password=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, email);
                ps.setString(2, password);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    // ✅ Usuario autenticado
                    HttpSession session = request.getSession();
                    session.setAttribute("usuario", rs.getString("nombre"));
                    session.setAttribute("email", rs.getString("email"));
                    session.setAttribute("id_usuario", rs.getInt("id"));

                    response.sendRedirect("principal.jsp");
                } else {
                    // ❌ Credenciales incorrectas
                    response.sendRedirect("login.jsp?error=Email o contraseña incorrectos");
                }

                conn.close();
            } catch (Exception e) {
                // ❌ Error de servidor
                response.sendRedirect("login.jsp?error=Error del servidor: " + e.getMessage());
            }
        }
    }
}
