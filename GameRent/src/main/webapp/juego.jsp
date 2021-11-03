<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page session="true" %>
<!DOCTYPE html>
<html>
<head>
  <title>Juego - GameRent</title>
  <%@include file="includes/head.jsp"%>
</head>
<body>
  <%@include file="includes/header.jsp" %>

  <div class="container">
    <h3>
      Juegos
      <a class="purple darken-3 waves-effect waves-light btn-large right show_new_form"><i class="material-icons left">videogame_asset</i>Crear Juego</a>
    </h3>

    <div class="row add_new_form" style="display: none">
      <div class="col s12 purple darken-3">
        <h5 class="white-text"><i class="material-icons left">note_add</i> Crear Juego</h5>
        <div class="row">
          <form class="col s12" action="JuegoServlet" method="post">
            <div class="row">
              <div class="input-field col s6">
                <input id="nombre" name="nombre" type="text" class="validate white-text" required>
                <label for="nombre">Nombre del Juego</label>
              </div>
              <div class="input-field col s6">
                <textarea id="descripcion" name="descripcion" class="materialize-textarea white-text" required></textarea>
                <label for="descripcion">Descripcion</label>
              </div>
            </div>
            <div class="row">
              <div class="input-field col s6">
                <input id="precio" name="precio" type="number" class="validate white-text" required>
                <label for="precio">Precio</label>
              </div>
              <div class="input-field col s6">
                <input id="imagen" name="imagen" type="text" class="validate white-text" required>
                <label for="imagen">Imagen Url</label>
              </div>
            </div>
            <div class="row">
              <div class="input-field col s12">
                <select id="categoria" name="categoria" class="white-text">
                  <option value="1" disabled selected>Seleccione una Categoria</option>
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
                <button class="waves-effect waves-green btn-flat red-text text-lighten-3 show_new_form">Cancelar</button>
                <button type="submit" class="waves-effect waves-green btn-flat teal-text text-lighten-3">Guardar</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>

    <%
      ResultSet juegosList = dbConnection.selectQuery("SELECT j.juego_id, j.categoria_id, j.estado_juego_id, j.nombre, \n" +
              "j.descripcion, j.precio_dia, j.imagen_url, c.nombre categoria, ej.nombre estado\n" +
              "FROM juego j\n" +
              "INNER JOIN categoria c ON j.categoria_id = c.categoria_id \n" +
              "INNER JOIN estado_juego ej ON ej.estado_juego_id = j.estado_juego_id ORDER BY juego_id ");
    %>
    <div class="row">
      <%
        while (juegosList.next()) {
          %>
          <div class="col s6 m4">
            <div class="card">
              <div class="card-image">
                <img class="activator juego-image" src="<%=juegosList.getString("imagen_url")%>">
                <a class="activator btn-floating btn-medium halfway-fab waves-effect waves-light gray" style="right: 116px;"><i class="material-icons">more_vert</i></a>
                <a class="btn-floating btn-medium halfway-fab waves-effect waves-light blue" style="right: 70px;"
                   onclick="editarJuegoModal(<%=juegosList.getString("juego_id")%>, '<%=juegosList.getString("nombre")%>', '<%=juegosList.getString("descripcion")%>', '<%=juegosList.getString("precio_dia")%>', '<%=juegosList.getString("imagen_url")%>', <%=juegosList.getString("categoria_id")%>)"><i class="material-icons">edit</i></a>
                <% if(juegosList.getInt("estado_juego_id") == 1) { %>
                  <a class="btn-floating btn-medium halfway-fab waves-effect waves-light red tooltipped" onclick="cambiarEstadoJuego(<%=juegosList.getString("juego_id")%>, 3)" data-position="bottom" data-tooltip="Deshabilitar Juego"><i class="material-icons">delete</i></a>
                <% } else if(juegosList.getInt("estado_juego_id") == 3) { %>
                  <a class="btn-floating btn-medium halfway-fab waves-effect waves-light green tooltipped" onclick="cambiarEstadoJuego(<%=juegosList.getString("juego_id")%>, 1)" data-position="bottom" data-tooltip="Habilitar Juego"><i class="material-icons">publish</i></a>
                <% } %>
              </div>
              <div class="card-content">
                <span class="card-title activator grey-text text-darken-4"><%=juegosList.getString("nombre")%></span>
                <p><b>Q.<%=juegosList.getString("precio_dia")%></b></p>
              </div>

              <% switch (juegosList.getInt("estado_juego_id")) {
                case 1:
                  %><div class="card-action green white-text valign-wrapper">
                    <i class="material-icons" style="margin-left: 0.5rem;margin-right: 0.5rem;">event_available</i>
                    <%=juegosList.getString("estado")%>
                  </div><%
                  break;
                case 2:
                  %><div class="card-action blue white-text valign-wrapper">
                    <i class="material-icons" style="margin-left: 0.5rem;margin-right: 0.5rem;">event_busy</i>
                    <%=juegosList.getString("estado")%>
                  </div><%
                  break;
                case 3:
                  %><div class="card-action red white-text valign-wrapper">
                    <i class="material-icons" style="margin-left: 0.5rem;margin-right: 0.5rem;">highlight_off</i>
                    <%=juegosList.getString("estado")%>
                  </div><%
                  break;
              } %>

              <div class="card-reveal">
                <span class="card-title grey-text text-darken-4"><%=juegosList.getString("nombre")%><i class="material-icons right">close</i></span>
                <p><%=juegosList.getString("descripcion")%></p>
                <p>
                  <b>Precio:</b> Q.<%=juegosList.getString("precio_dia")%> <br>
                  <b>Categoria:</b> <%=juegosList.getString("categoria")%> <br>
                  <b>Estado:</b> <%=juegosList.getString("estado")%> <br>
                </p>
              </div>
            </div>
          </div>
          <%
        }
      %>
    </div>

    <!-- Modal Structure Editar Juego -->
    <div id="editarJuegoModal" class="modal bottom-sheet">
      <div class="modal-content">
        <h5 class=""><i class="material-icons left">edit</i> Editar Juego</h5>
        <div class="row">
          <form id="editJuegoForm" class="col s12">
            <div class="row">
              <div class="input-field col s6">
                <input type="hidden" id="editarModalJuegoId" name="juego_id" value="0">
                <input id="nombre_e" name="nombre" type="text" class="validate" required>
                <label for="nombre_e">Nombre del Juego</label>
              </div>
              <div class="input-field col s6">
                <textarea id="descripcion_e" name="descripcion" class="materialize-textarea" required></textarea>
                <label for="descripcion_e">Descripcion</label>
              </div>
            </div>
            <div class="row">
              <div class="input-field col s6">
                <input id="precio_e" name="precio" type="number" class="validate" required>
                <label for="precio_e">Precio</label>
              </div>
              <div class="input-field col s6">
                <input id="imagen_e" name="imagen" type="text" class="validate" required>
                <label for="imagen_e">Imagen Url</label>
              </div>
            </div>
            <div class="row">
              <div class="input-field col s12">
                <select id="categoria_e" name="categoria">
                  <%
                    ResultSet categoriasEditList = dbConnection.selectQuery("SELECT categoria_id, nombre FROM categoria");
                    while (categoriasEditList.next()) { %>
                  <option value="<%=categoriasEditList.getInt("categoria_id")%>"><%=categoriasEditList.getString("nombre")%></option>
                  <% } %>
                </select>
                <label for="categoria_e">Categoria</label>
              </div>
            </div>
          </form>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="modal-close waves-effect waves-green btn-flat red-text text-lighten-3">Cancelar</button>
        <button type="button" class="waves-effect waves-green btn-flat teal-text text-lighten-3" onclick="editarJuego()">Guardar</button>
      </div>
    </div>

  </div>

  <%@include file="includes/footer.jsp" %>
</body>
</html>