<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cliente - GameRent</title>
    <%@include file="includes/head.jsp"%>
</head>
<body>
<%@include file="includes/header.jsp" %>
<div class="container">
    <h3>
        <i class="material-icons left">picture_as_pdf</i> Reportes
    </h3>

    <div class="row">
        <div class="col s12">
            <ul class="collapsible">
                <li>
                    <div class="collapsible-header"><i class="material-icons">videogame_asset</i>Reporte de Juegos</div>
                    <div class="collapsible-body">
                        <div class="row">
                            <form class="col s12" target="_blank" action="ReporteServlet" method="get">
                                <div class="row">
                                    <div class="input-field col s6">
                                        <input type="hidden" name="no_reporte" value="1">
                                        <input id="nombre" name="nombre" type="text" class="validate">
                                        <label for="nombre">Nombre del Juego</label>
                                    </div>
                                    <div class="input-field col s6">
                                        <select id="categoria" name="categoria" class="white-text">
                                            <option value="1,2,3,4,5,6,7" selected>Seleccione una Categoria</option>
                                            <% ResultSet categoriasList = dbConnection.selectQuery("SELECT categoria_id, nombre FROM categoria");
                                                while (categoriasList.next()) { %>
                                            <option value="<%=categoriasList.getInt("categoria_id")%>"><%=categoriasList.getString("nombre")%></option>
                                            <% } %>
                                        </select>
                                        <label for="categoria">Categoria</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="input-field col s12 right-align">
                                        <button type="submit" class="waves-effect waves-green btn-flat teal-text text-lighten-3">Generar Reporte</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="collapsible-header"><i class="material-icons">attach_money</i>Reporte de Retnas</div>
                    <div class="collapsible-body">
                        <div class="row">
                            <form class="col s12" target="_blank" action="ReporteServlet" method="get">
                                <div class="row">
                                    <div class="input-field col s12">
                                        <input type="hidden" name="no_reporte" value="2">
                                        <input id="nombreCliente" name="nombre" type="text" class="validate">
                                        <label for="nombre">Nombre del Cliente</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="input-field col s12 right-align">
                                        <button type="submit" class="waves-effect waves-green btn-flat teal-text text-lighten-3">Generar Reporte</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="collapsible-header"><i class="material-icons">group</i>Top 10 Clientes Con Multas</div>
                    <div class="collapsible-body">
                        <a href="ReporteServlet?no_reporte=3" target="_blank" class="waves-effect waves-green btn-flat teal-text text-lighten-3">Generar Reporte</a>
                    </div>
                </li>
                <li>
                    <div class="collapsible-header"><i class="material-icons">videogame_asset</i>Top 10 Juegos Mas Alquilados Por Mes</div>
                    <div class="collapsible-body">
                        <div class="row">
                            <form class="col s12" target="_blank" action="ReporteServlet" method="get">
                                <div class="row">
                                    <div class="input-field col s6">
                                        <input type="hidden" name="no_reporte" value="4">
                                        <select id="mes" name="mes" class="white-text">
                                            <option value="1" selected>Enero</option>
                                            <option value="2">Febrero</option>
                                            <option value="3">Marzo</option>
                                            <option value="4">Abril</option>
                                            <option value="5">Mayo</option>
                                            <option value="6">Junio</option>
                                            <option value="7">Julio</option>
                                            <option value="8">Agosto</option>
                                            <option value="9">Septiembre</option>
                                            <option value="10">Octubre</option>
                                            <option value="11">Noviembre</option>
                                            <option value="12">Diciembre</option>
                                        </select>
                                        <label for="categoria">Mes</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="input-field col s12 right-align">
                                        <button type="submit" class="waves-effect waves-green btn-flat teal-text text-lighten-3">Generar Reporte</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="collapsible-header"><i class="material-icons">videogame_asset</i>Top 10 Juegos Mas Alquilados</div>
                    <div class="collapsible-body">
                        <a href="ReporteServlet?no_reporte=5" target="_blank" class="waves-effect waves-green btn-flat teal-text text-lighten-3">Generar Reporte</a>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>

<%@include file="includes/footer.jsp" %>
</body>
</html>