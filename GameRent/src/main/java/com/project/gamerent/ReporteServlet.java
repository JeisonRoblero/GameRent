package com.project.gamerent;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;

@WebServlet(name = "ReporteServlet", value = "/ReporteServlet")
public class ReporteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServletOutputStream os = response.getOutputStream();
        response.setContentType("application/pdf");
        Document documento = new Document();
        String query = "SELECT 1 test";
        String titulos = "test";
        String columnas = "test";
        String nombreReporte = "Reporte de Juegos";
        String noReporte = request.getParameter("no_reporte");

        if (noReporte != null && noReporte.equals("1")){
            String nombreJuego = request.getParameter("nombre");
            String categoriaJuego = request.getParameter("categoria");
            categoriaJuego = categoriaJuego != null ? categoriaJuego : "1,2,3,4,5,6,7";
            query = "SELECT j.nombre, j.precio_dia precio, c.nombre categoria, ej.nombre estado " +
                    "FROM juego j " +
                    "INNER JOIN categoria c ON c.categoria_id = j.categoria_id " +
                    "INNER JOIN estado_juego ej ON ej.estado_juego_id = j.estado_juego_id " +
                    "WHERE j.nombre LIKE '%"+nombreJuego+"%' " +
                    "AND j.categoria_id IN ("+categoriaJuego+")";
            titulos = "Juego,Precio,Categoria,Estado";
            columnas = "nombre,precio,categoria,estado";
            nombreReporte = "Reporte de Juegos";
        } else if (noReporte != null && noReporte.equals("2")){
            String nombreCliente = request.getParameter("nombre");
            query = "SELECT c.nombre cliente, r.fecha_renta, r.fecha_limite, r.no_extensiones, r.fecha_devolucion, " +
                    "er.nombre estado, c.no_incidentes " +
                    ",IF(DATEDIFF(IF(r.estado_renta_id = 1, CURDATE(), r.fecha_devolucion),r.fecha_limite) < 0, 0, DATEDIFF(IF(r.estado_renta_id = 1, CURDATE(), r.fecha_devolucion),r.fecha_limite)) dias_retraso " +
                    ",CURDATE() today, COUNT(rj.renta_juego_id) no_juegos, SUM(j.precio_dia) total_alquiler " +
                    ",(IF(DATEDIFF(CURDATE(),r.fecha_limite) > 0,(DATEDIFF(CURDATE(),r.fecha_limite) * COUNT(rj.renta_juego_id) * 5), 0)) multa " +
                    "FROM renta r " +
                    "INNER JOIN cliente c ON r.cliente_id = c.cliente_id " +
                    "INNER JOIN estado_renta er ON er.estado_renta_id = r.estado_renta_id " +
                    "INNER JOIN renta_juego rj ON rj.renta_id = r.renta_id " +
                    "INNER JOIN juego j ON j.juego_id = rj.juego_id " +
                    "WHERE c.nombre LIKE '%"+nombreCliente+"%' " +
                    "GROUP BY c.nombre, r.fecha_renta, r.fecha_limite, r.no_extensiones, r.fecha_devolucion, " +
                    "er.nombre, c.no_incidentes, r.estado_renta_id " +
                    "ORDER BY r.fecha_limite ASC ";
            titulos = "Cliente,Incidentes,Renta,Limite,Extensiones,Devolucion,Estado,Retraso,Alquiler,Multa";
            columnas = "cliente,no_incidentes,fecha_renta,fecha_limite,no_extensiones,fecha_devolucion,estado,dias_retraso,total_alquiler,multa";
            nombreReporte = "Reporte de Rentas";
        } else if (noReporte != null && noReporte.equals("3")){
            query = "SELECT c.nombre, c.telefono, TIMESTAMPDIFF(YEAR, c.fecha_nacimiento, CURDATE()) edad, c.no_incidentes incidentes, " +
                    "  (IF(DATEDIFF(CURDATE(),r.fecha_limite) > 0,(DATEDIFF(CURDATE(),r.fecha_limite) * COUNT(rj.renta_juego_id) * 5), 0)) multa " +
                    "FROM cliente c " +
                    "INNER JOIN renta r ON r.cliente_id = c.cliente_id " +
                    "INNER JOIN renta_juego rj ON rj.renta_id = r.renta_id " +
                    "GROUP BY c.nombre, c.telefono, c.fecha_nacimiento, c.no_incidentes " +
                    "ORDER BY 5 DESC " +
                    "LIMIT 10";
            titulos = "Cliente,Telefono,Edad,Incidentes,Multas";
            columnas = "nombre,telefono,edad,incidentes,multa";
            nombreReporte = "TOP 10 Clientes Con Multa";
        } else if (noReporte != null && noReporte.equals("4")){
            String mes = request.getParameter("mes");
            query = "SELECT j.nombre, c.nombre categoria, CONCAT('Q.', j.precio_dia) precio, " +
                    " MONTHNAME(r.fecha_renta) mes, COUNT(rj.renta_juego_id) rentas " +
                    "FROM juego j " +
                    "INNER JOIN categoria c ON c.categoria_id = j.categoria_id " +
                    "INNER JOIN renta_juego rj ON rj.juego_id = j.juego_id " +
                    "INNER JOIN renta r ON r.renta_id = rj.renta_id " +
                    "WHERE MONTH(r.fecha_renta) = " + mes +
                    " GROUP BY j.nombre, c.nombre, j.precio_dia,MONTHNAME(r.fecha_renta) " +
                    "ORDER BY 5 DESC " +
                    "LIMIT 10";
            titulos = "Juego,Categoria,Precio,Mes,Rentas";
            columnas = "nombre,categoria,precio,mes,rentas";
            nombreReporte = "TOP 10 Juegos Mas Rentados Por Mes";
        } else if (noReporte != null && noReporte.equals("5")){
            query = "SELECT j.nombre, c.nombre categoria, CONCAT('Q.', j.precio_dia) precio,COUNT(rj.renta_juego_id) rentas " +
                    "FROM juego j " +
                    "INNER JOIN categoria c ON c.categoria_id = j.categoria_id " +
                    "INNER JOIN renta_juego rj ON rj.juego_id = j.juego_id " +
                    "INNER JOIN renta r ON r.renta_id = rj.renta_id " +
                    " GROUP BY j.nombre, c.nombre, j.precio_dia " +
                    "ORDER BY 4 DESC " +
                    "LIMIT 10";
            titulos = "Juego,Categoria,Precio,Rentas";
            columnas = "nombre,categoria,precio,rentas";
            nombreReporte = "TOP 10 Juegos Mas Rentados";
        }

        try {
            PdfWriter.getInstance(documento, os);
            documento.open();
            Paragraph titulo = new Paragraph(nombreReporte,
                    FontFactory.getFont("arial",   // fuente
                            20,                        // tamaño
                            Font.ITALIC,                   // estilo
                            BaseColor.RED));             // color
            titulo.setAlignment(Element.ALIGN_CENTER);
            documento.add(titulo);
            documento.add( Chunk.NEWLINE );
            documento.add(new LineSeparator());
            documento.add( Chunk.NEWLINE );
            generarReporete(documento, query, titulos, columnas);
            documento.close();
        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }

    private void generarReporete(Document documento, String reporteQuery, String titulos, String columnas) {

        DBConnection dbConnection = new DBConnection();
        ResultSet resultSet = dbConnection.selectQuery(reporteQuery);
        String[] columnasSplit = columnas.split(",");
        String[] titulosSplit = titulos.split(",");
        PdfPTable tabla = new PdfPTable(columnasSplit.length);
        for (String titulo : titulosSplit) {
            agregarHeader(tabla, titulo);
        }
        try {
            while (resultSet.next()) {
                for (String columna : columnasSplit) {
                    tabla.addCell(resultSet.getString(columna));
                }
            }
            documento.add(tabla);
        } catch (SQLException | DocumentException throwables) {
            throwables.printStackTrace();
        }
    }

    private void agregarHeader(PdfPTable table, String text){
        Font bfBold12 = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD, new BaseColor(0, 0, 0));
        Font bf12 = new Font(Font.FontFamily.TIMES_ROMAN, 12);
        //create a new cell with the specified Text and Font
        PdfPCell cell = new PdfPCell(new Phrase(text.trim(), bfBold12));
        //set the cell alignment
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);

        //in case there is no text and you wan to create an empty row
        if(text.trim().equalsIgnoreCase("")){
            cell.setMinimumHeight(10f);
        }
        //add the call to the table
        table.addCell(cell);
    }
}
