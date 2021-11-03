package com.project.gamerent;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "RentasServlet", value = "/RentasServlet")
public class RentasServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String detalles = request.getParameter("detalles");

        String extension = request.getParameter("extension");
        String fechaext = request.getParameter("fechaext");

        String guardar = request.getParameter("guardar");
        String juegos = request.getParameter("juegos");

        String cerrar = request.getParameter("cerrar");
        String total = request.getParameter("total");
        String multa = request.getParameter("multa");

        DBConnection dbConnection = new DBConnection();
        PrintWriter out = response.getWriter();
        if (detalles != null) {
            String querySelect = "SELECT j.nombre, j.precio_dia " +
                    "FROM renta_juego rj " +
                    "INNER JOIN juego j ON j.juego_id = rj.juego_id " +
                    "WHERE rj.renta_id = " + detalles;
            ResultSet resultSet = dbConnection.selectQuery(querySelect);
            String result = "<table class='striped'><thead><tr><th>Juego</th><th>Precio</th></tr></thead><tbody>";
            try {
                while (resultSet.next()){
                    result += "<tr>" +
                            "   <td>"+resultSet.getString("nombre")+"</td>" +
                            "   <td>"+resultSet.getString("precio_dia")+"</td>" +
                            "</tr>";
                }
                result += "</tbody></table>";
            } catch (SQLException e) {
                e.printStackTrace();
            }
            out.println(result);
        } else if (extension != null) {
            String queryUpdate = "UPDATE renta SET fecha_limite = '"+fechaext+"', no_extensiones = (no_extensiones + 1) " +
                    "WHERE renta_id = " + extension;
            dbConnection.executeUpdateQuery(queryUpdate);
        } else if (guardar != null) {
            String insertQuery = "INSERT INTO renta (usuario_id, estado_renta_id, fecha_renta, fecha_limite, no_extensiones , cliente_id) \n" +
                    "VALUES (1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 0, "+guardar+")";
            dbConnection.executeInsertDeleteQuery(insertQuery);
            String lastIdQuery = "SELECT LAST_INSERT_ID() lastid";
            ResultSet lastIdRS = dbConnection.selectQuery(lastIdQuery);
            try {
                String[] juegosIds = juegos.split(",");
                lastIdRS.next();
                int lastId = lastIdRS.getInt("lastid");
                for (String id : juegosIds) {
                    String insertJuego = "INSERT INTO renta_juego (renta_id, juego_id) VALUES ("+lastId+", "+id+")";
                    dbConnection.executeInsertDeleteQuery(insertJuego);

                    String updateJuego = "UPDATE juego SET estado_juego_id = 2 WHERE juego_id  = "+id;
                    dbConnection.executeInsertDeleteQuery(updateJuego);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else if (cerrar != null) {
            String updateJuegos = "UPDATE juego SET estado_juego_id = 1 WHERE juego_id IN (SELECT juego_id FROM renta_juego WHERE renta_id = "+cerrar+")";
            String updateRenta = "UPDATE renta SET estado_renta_id = 2, fecha_devolucion = CURDATE(), total = "+ total +" WHERE renta_id = "+cerrar;
            String updateCliente = "UPDATE cliente SET no_incidentes = (no_incidentes + 1) WHERE cliente_id IN (SELECT cliente_id FROM renta_juego WHERE renta_id = "+cerrar+")";
            if (!multa.equals("0")) {
                dbConnection.executeUpdateQuery(updateCliente);
            }
            dbConnection.executeUpdateQuery(updateJuegos);
            dbConnection.executeUpdateQuery(updateRenta);
        }
    }
}
