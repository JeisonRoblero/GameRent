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
            <i class="material-icons left">people</i> Clientes
            <button class="purple darken-3 waves-effect waves-light btn-large right show_new_form"><i class="material-icons left">person_add</i>Crear Cliente</button>
        </h3>

        <!-- Modal Structure Editar Cliente -->
        <div id="editarClienteModal" class="modal bottom-sheet">
            <div class="modal-content">
                <h5 class=""><i class="material-icons left">edit</i> Editar Cliente</h5>
                <div class="row">
                    <form id="editClienteForm" class="col s12">
                        <div class="row">
                            <div class="input-field col s6">
                                <input type="hidden" id="editarModalClienteId" name="cliente_id" value="0">
                                <input id="nombre_e" name="nombre" type="text" class="validate" required>
                                <label for="nombre_e">Nombre</label>
                            </div>
                            <div class="input-field col s6">
                                <input id="fecha_nacimiento_e" name="fecha_nacimiento" type="text" class="datepicker today validate" required>
                                <label for="fecha_nacimiento_e">Fecha De Nacimiento</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="input-field col s6">
                                <input id="telefono_e" name="telefono" type="tel" class="validate" required>
                                <label for="telefono_e">Telefono</label>
                            </div>
                            <div class="input-field col s6">
                                <input id="correo_e" name="correo" type="email" class="validate" required>
                                <label for="correo_e">Correo Electronico</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="input-field col s12">
                                <textarea id="direccion_e" name="direccion" class="materialize-textarea" required></textarea>
                                <label for="direccion_e">Direccion</label>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="modal-close waves-effect waves-green btn-flat red-text text-lighten-3">Cancelar</button>
                <button type="button" class="waves-effect waves-green btn-flat teal-text text-lighten-3" onclick="editarCliente()">Guardar</button>
            </div>
        </div>

        <div class="row add_new_form" style="display: none">
            <div class="col s12 purple darken-3">
                <h5 class="white-text"><i class="material-icons left">person_add</i> Crear Cliente</h5>
                <div class="row">
                    <form class="col s12" action="ClienteServlet" method="post">
                        <div class="row">
                            <div class="input-field col s6">
                                <input id="nombre" name="nombre" type="text" class="validate white-text" required>
                                <label for="nombre">Nombre</label>
                            </div>
                            <div class="input-field col s6">
                                <input id="fecha_nacimiento_c" name="fecha_nacimiento" type="text" class="datepicker today validate white-text" required>
                                <label for="fecha_nacimiento_c">Fecha De Nacimiento</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="input-field col s6">
                                <input id="telefono" name="telefono" type="tel" class="validate white-text" required>
                                <label for="telefono">Telefono</label>
                            </div>
                            <div class="input-field col s6">
                                <input id="correo" name="correo" type="email" class="validate white-text" required>
                                <label for="correo">Correo Electronico</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="input-field col s12">
                                <textarea id="direccion" name="direccion" class="materialize-textarea white-text" required></textarea>
                                <label for="direccion">Direccion</label>
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
            ResultSet clientesList = dbConnection.selectQuery("SELECT cliente_id, nombre, fecha_nacimiento, telefono, direccion, correo FROM cliente");
        %>
        <div class="row">
            <table class="striped col s12">
                <thead>
                    <tr>
                        <th>No. Cliente</th>
                        <th>Nombre</th>
                        <th>Fecha Nacimiento</th>
                        <th>Telefono</th>
                        <th>Direccion</th>
                        <th>Correo</th>
                        <th>Opciones</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        while (clientesList.next()) {
                            String lineaCliente = "<tr>" +
                                    "   <td>" + clientesList.getInt("cliente_id") + "</td>" +
                                    "   <td>" + clientesList.getString("nombre") + "</td>" +
                                    "   <td>" + clientesList.getDate("fecha_nacimiento") + "</td>" +
                                    "   <td>" + clientesList.getString("telefono") + "</td>" +
                                    "   <td>" + clientesList.getString("direccion") + "</td>" +
                                    "   <td>" + clientesList.getString("correo") + "</td>" +
                                    "   <td>" +
                                    "         <!-- <a class='btn-floating btn-small waves-effect waves-light red'><i class='material-icons' onclick='eliminarClienteModal("+clientesList.getInt("cliente_id")+", \""+clientesList.getString("nombre")+"\")'>delete</i></a> -->" +
                                    "         <a class='btn-floating btn-small waves-effect waves-light blue'><i class='material-icons' " +
                                    "           onclick='editarClienteModal("+clientesList.getInt("cliente_id")+", \""+clientesList.getString("nombre")+"\", \""+clientesList.getString("fecha_nacimiento")+"\", \""+clientesList.getString("telefono")+"\", \""+clientesList.getString("direccion")+"\", \""+clientesList.getString("correo")+"\")'>edit</i></a>" +
                                    "   </td>" +
                                    "</tr>";
                            out.println(lineaCliente);
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <div id="modalDelete" class="modal">
        <div class="modal-content">
            <h5><i class="material-icons left">delete</i> Eliminar Cliente</h5>
            <p id="modalDeleteMessage"></p>
        </div>
        <div class="modal-footer">
            <button class="modal-close waves-effect waves-green btn-flat teal-text text-lighten-3">Cancelar</button>
            <button class="waves-effect waves-green btn-flat red-text text-lighten-3" onclick="eliminarCliente()">Eliminar</button>
        </div>
    </div>


    <%@include file="includes/footer.jsp" %>
</body>
</html>