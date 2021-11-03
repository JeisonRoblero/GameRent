package com.project.gamerent;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("usuario");
        response.sendRedirect("login.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");
        DBConnection dbConnection = new DBConnection();

        try {
            ResultSet resultSet = dbConnection.selectQuery("SELECT COUNT(*) resultado FROM usuario WHERE usuario = '"+usuario+"' AND clave = '"+clave+"'");
            resultSet.next();
            if (resultSet.getInt("resultado") == 1) {
                HttpSession session = request.getSession();
                session.setAttribute("usuario", usuario);
                response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("login.jsp?error");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
