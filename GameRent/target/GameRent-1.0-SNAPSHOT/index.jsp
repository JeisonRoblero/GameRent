<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Renta - GameRent</title>
    <%@include file="includes/head.jsp"%>
</head>
<body>
    <%@include file="includes/header.jsp" %>

    <div class="container">
        <h3>
            Rentas
            <a class="purple darken-3 waves-effect waves-light btn-large right show_new_form"><i class="material-icons left">note_add</i>Crear Renta</a>
        </h3>

        <div class="row add_new_form" style="display: none">
            <div class="col s12 purple darken-3">
                <h5 class="white-text"><i class="material-icons left">note_add</i> Crear Renta</h5>
                <div class="row">
                    <form class="col s12">
                        <div class="row">
                            <div class="input-field col s12">
                                <select id="cliente" name="cliente">
                                    <option value="1" disabled selected>Seleccione un Cliente</option>
                                    <% ResultSet clientesList = dbConnection.selectQuery("SELECT c.cliente_id, c.nombre " +
                                            "FROM cliente c " +
                                            "WHERE c.cliente_id NOT IN (SELECT cliente_id FROM renta WHERE estado_renta_id = 1)");
                                    while (clientesList.next()) { %>
                                        <option value="<%=clientesList.getInt("cliente_id")%>"><%=clientesList.getString("nombre")%></option>
                                    <% } %>
                                </select>
                                <label for="cliente">Cliente</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="input-field col s12">
                                <select id="juegos" name="juegos" multiple>
                                    <option value="1" disabled selected>Seleccione los Juegos a Rentar</option>
                                    <% ResultSet juegosList = dbConnection.selectQuery("SELECT juego_id, nombre, precio_dia, imagen_url FROM juego WHERE estado_juego_id = 1");
                                    while (juegosList.next()) { %>
                                        <option value="<%=juegosList.getInt("juego_id")%>" data-icon="<%=juegosList.getString("imagen_url")%>">Q.<%=juegosList.getFloat("precio_dia")%> - <%=juegosList.getString("nombre")%></option>
                                    <% } %>
                                </select>
                                <label for="juegos">Juegos</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="input-field col s12 right-align">
                                <button type="button" class="waves-effect waves-green btn-flat red-text text-lighten-3 show_new_form">Cancelar</button>
                                <button type="button" class="waves-effect waves-green btn-flat teal-text text-lighten-3" onclick="guardarRenta()">Guardar</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%
            String rentasQuery = "SELECT r.renta_id, r.usuario_id, r.cliente_id, r.estado_renta_id, r.fecha_renta, r.fecha_devolucion, r.fecha_limite, r.no_extensiones, " +
                    "c.nombre cliente, er.nombre estado, c.no_incidentes, DATE_ADD(r.fecha_limite, INTERVAL 3 DAY) fecha_extension, " +
                    "DATEDIFF(CURDATE(),r.fecha_limite) dias_retraso, CURDATE() today, COUNT(rj.renta_juego_id) no_juegos, SUM(j.precio_dia) total_alquiler " +
                    ", (IF(DATEDIFF(CURDATE(),r.fecha_limite) > 0,(DATEDIFF(CURDATE(),r.fecha_limite) * COUNT(rj.renta_juego_id) * 5), 0)) multa " +
                    "FROM renta r  " +
                    "INNER JOIN cliente c ON r.cliente_id = c.cliente_id " +
                    "INNER JOIN estado_renta er ON er.estado_renta_id = r.estado_renta_id  " +
                    "INNER JOIN renta_juego rj ON rj.renta_id = r.renta_id  " +
                    "INNER JOIN juego j ON j.juego_id = rj.juego_id  " +
                    "WHERE r.estado_renta_id = 1  " +
                    "GROUP BY r.renta_id, r.usuario_id, r.cliente_id, r.estado_renta_id, r.fecha_renta, r.fecha_devolucion, r.fecha_limite, r.no_extensiones,c.nombre, er.nombre, c.no_incidentes " +
                    "ORDER BY r.fecha_limite ASC";
            ResultSet rentaLista = dbConnection.selectQuery(rentasQuery);
        %>
        <div class="row">
            <table class="striped col s12">
                <thead>
                <tr>
                    <th>No. Renta</th>
                    <th>Cliente</th>
                    <th>Fecha Renta</th>
                    <th>Fecha Limite</th>
                    <th>No. Extensiones</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <% while (rentaLista.next()) { %>
                    <tr>
                        <td><%=rentaLista.getInt("renta_id")%></td>
                        <td><%=rentaLista.getString("cliente")%></td>
                        <td><%=rentaLista.getString("fecha_renta")%></td>
                        <td><%=rentaLista.getString("fecha_limite")%></td>
                        <td><%=rentaLista.getString("no_extensiones")%></td>
                        <td>
                            <button type="button" class='btn-floating btn-small waves-effect waves-light blue tooltipped' data-position="top" data-tooltip="Ver detalles" onclick="mostrarDetalle(<%=rentaLista.getInt("renta_id")%>)"><i class='material-icons'>format_list_bulleted</i></button>
                            <% if(rentaLista.getInt("no_extensiones") < 2 && rentaLista.getInt("no_incidentes") < 2) { %>
                                <button type="button" class='btn-floating btn-small waves-effect waves-light orange tooltipped' data-position="top" data-tooltip="Solicitar Extension" onclick="solicitarExtension(<%=rentaLista.getInt("renta_id")%>, '<%=rentaLista.getString("fecha_extension")%>')"><i class='material-icons'>date_range</i></button>
                            <% } %>
                            <button type="button" class='btn-floating btn-small waves-effect waves-light green tooltipped' data-position="top" data-tooltip="Cerrar Renta"
                                    onclick="mostrarCerrarRenta(<%=rentaLista.getInt("renta_id")%>, '<%=rentaLista.getString("cliente")%>','<%=rentaLista.getString("fecha_renta")%>',
                                            '<%=rentaLista.getString("fecha_limite")%>', '<%=rentaLista.getString("today")%>', <%=rentaLista.getInt("dias_retraso")%>, <%=rentaLista.getInt("total_alquiler")%>, <%=rentaLista.getInt("multa")%>)">
                                <i class='material-icons'>event_available</i>
                            </button>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div id="modalDetalleJuegos" class="modal">
        <div class="modal-content">
            <h5><i class="material-icons left">format_list_bulleted</i> Detalles juegos de la  Renta No.<span id="detRentaID"></span></h5>
            <div class="card blue-grey darken-1">
                <div class="card-content white-text">
                    <p id="modalDetalleContent"></p>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="modal-close waves-effect waves-green btn-flat teal-text text-lighten-3">Ok</button>
        </div>
    </div>

    <div id="modalExtension" class="modal">
        <div class="modal-content">
            <h5><i class="material-icons left">date_range</i> Extension de Renta</h5>
            <p id="modalExtensionMensaje"></p>
        </div>
        <div class="modal-footer">
            <button class="modal-close waves-effect waves-green btn-flat red-text text-lighten-3">Cancelar</button>
            <button class="modal-close waves-effect waves-green btn-flat teal-text text-lighten-3" onclick="extenderFecha()">Ok</button>
        </div>
    </div>

    <div id="modalCerrarRenta" class="modal modal-fixed-footer">
        <div class="modal-content">
            <h5><i class="material-icons left">event_available</i> Cerrar Renta</h5>
            <div class="row">
                <div class="col s12">
                    <div class="card blue-grey darken-1">
                        <div class="card-content white-text">
                            <span class="card-title"><i class="material-icons left">event_note</i>Detalles de la Renta No. <span id="cerrarRentaID"></span></span>
                            <p>
                                <b>Cliente: </b> <span id="cerrarRentaCliente"></span> <br>
                                <b>Fecha de Renta: </b> <span id="cerrarRentaFechaRenta"></span> <br>
                                <b>Fecha de Limite: </b> <span id="cerrarRentaFechaLimite"></span> <br>
                                <b>Fecha de Actual: </b> <span id="cerrarRentaFechaActual"></span> <br>
                                <b><span id="diasMensaje"></span>: </b> <span id="diasCounter"></span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col s12">
                    <div class="card blue-grey darken-1">
                        <div class="card-content white-text">
                            <span class="card-title"><i class="material-icons left">videogame_asset</i>Detalles de Juegos Aqluilados</span>
                            <p id="detalleJuegosCerrarRenta"></p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col s12">
                    <div class="card blue-grey darken-1">
                        <div class="card-content white-text">
                            <span class="card-title"><i class="material-icons left">payment</i>Detalles de Pago</span>
                            <p class="right-align">
                                <b>Total Alquiler: </b> Q.<span id="cr_totalAqluiler">30.0</span>
                            </p>
                            <p class="right-align">
                                <b>Total Multas: </b> Q.<span id="cr_totalMultas">30.0</span>
                            </p>
                            <hr>
                            <p class="right-align">
                                <b>Total a Pagar: </b> Q.<span id="cr_totalPagar">30.0</span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <p id="modalCerrarRentaMensaje"></p>
        </div>
        <div class="modal-footer">
            <button class="modal-close waves-effect waves-green btn-flat red-text text-lighten-3">Cancelar</button>
            <button class="modal-close waves-effect waves-green btn-flat teal-text text-lighten-3" onclick="cerrarRenta()">Ok</button>
        </div>
    </div>

    <%@include file="includes/footer.jsp" %>
</body>
</html>