package com.project.gamerent;

import com.google.common.base.Splitter;


import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ClienteServlet", value = "/ClienteServlet")
public class ClienteServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String fechaNacimiento = request.getParameter("fecha_nacimiento");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String correo = request.getParameter("correo");
        DBConnection dbConnection = new DBConnection();
        String insertQuery = "INSERT INTO cliente (nombre, fecha_nacimiento, telefono, direccion, correo) " +
                "VALUES ('" + nombre + "', '" + fechaNacimiento + "', '" + telefono + "', '" + direccion + "', '" + correo + "')";
        dbConnection.executeInsertDeleteQuery(insertQuery);
        response.sendRedirect("cliente.jsp");
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clienteId = request.getParameter("cliente_id");
        DBConnection dbConnection = new DBConnection();
        String insertQuery = "DELETE FROM cliente WHERE cliente_id = " + clienteId;
        dbConnection.executeInsertDeleteQuery(insertQuery);
    }

    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, String> paramMap = getParameterMap(request);
        String clienteId = paramMap.get("cliente_id");
        String nombre = paramMap.get("nombre");
        String fechaNacimiento = paramMap.get("fecha_nacimiento");
        String telefono = paramMap.get("telefono");
        String direccion = paramMap.get("direccion");
        String correo = paramMap.get("correo");
        DBConnection dbConnection = new DBConnection();
        String updateQuery = "UPDATE cliente " +
                "SET nombre = '"+nombre+"', " +
                "telefono = '"+telefono+"', " +
                "fecha_nacimiento = '"+fechaNacimiento+"', " +
                "direccion = '"+direccion+"', " +
                "correo = '"+correo+"' " +
                "WHERE cliente_id = " + clienteId;
        dbConnection.executeUpdateQuery(updateQuery);
    }

    public static Map<String, String> getParameterMap(HttpServletRequest request) {

        BufferedReader br = null;
        Map<String, String> dataMap = new HashMap<>();

        try {

            InputStreamReader reader = new InputStreamReader(
                    request.getInputStream());
            br = new BufferedReader(reader);

            String data = br.readLine();

            String[] params = data.split("&");
            for (String param : params) {
                String[] values = param.split("=");
                dataMap.put(values[0], decode(values[1]));
            }
            br.close();

            return dataMap;
        } catch (IOException ex) {
            ex.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
        }

        return dataMap;
    }

    private static String decode(String value) {
        try {
            return URLDecoder.decode(value, StandardCharsets.UTF_8.toString());
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return value;
    }
}
