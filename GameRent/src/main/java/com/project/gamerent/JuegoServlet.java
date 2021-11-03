package com.project.gamerent;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "JuegoServlet", value = "/JuegoServlet")
public class JuegoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String precio = request.getParameter("precio");
        String imagen = request.getParameter("imagen");
        String categoria = request.getParameter("categoria");
        DBConnection dbConnection = new DBConnection();
        String insertQuery = "INSERT INTO juego (nombre, descripcion, precio_dia, imagen_url, categoria_id, estado_juego_id) " +
                "VALUES ('" + nombre + "', '" + descripcion + "', " + precio + ", '" + imagen + "', " + categoria + ", 1)";
        dbConnection.executeInsertDeleteQuery(insertQuery);
        response.sendRedirect("juego.jsp");
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String juegoId = request.getParameter("juego_id");
        String nuevoEstado = request.getParameter("nuevo_estado");
        DBConnection dbConnection = new DBConnection();
        String insertQuery = "UPDATE juego SET estado_juego_id = "+ nuevoEstado +" WHERE juego_id = " + juegoId;
        dbConnection.executeInsertDeleteQuery(insertQuery);
    }

    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, String> paramMap = getParameterMap(request);
        String juegoId = paramMap.get("juego_id");
        String nombre = paramMap.get("nombre");
        String descripcion = paramMap.get("descripcion");
        String precio = paramMap.get("precio");
        String imagen = paramMap.get("imagen");
        String categoria = paramMap.get("categoria");
        DBConnection dbConnection = new DBConnection();
        String updateQuery = "UPDATE juego " +
                "SET nombre = '"+nombre+"', " +
                "descripcion = '"+descripcion+"', " +
                "precio_dia = '"+precio+"', " +
                "imagen_url = '"+imagen+"', " +
                "categoria_id = '"+categoria+"' " +
                "WHERE juego_id = " + juegoId;
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
