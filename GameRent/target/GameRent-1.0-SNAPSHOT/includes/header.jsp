<%@ page import="com.project.gamerent.DBConnection" %>
<%@ page import="java.sql.ResultSet" %>
<%@page session="true" %>
<%
    HttpSession sessionValidation = request.getSession();
    String usuario = "";
    String pageName = "";
    String nombreUsuario = "";
    DBConnection dbConnection = new DBConnection();
    if (sessionValidation.getAttribute("usuario") == null) {
        response.sendRedirect("login.jsp");
    } else {
        usuario = sessionValidation.getAttribute("usuario").toString();
        String uri = request.getRequestURI();
        pageName = uri.substring(uri.lastIndexOf("/")+1);
        ResultSet resultSet = dbConnection.selectQuery("SELECT nombre FROM usuario WHERE usuario = '"+usuario+"'");
        resultSet.next();
        nombreUsuario = resultSet.getString("nombre");
    }
%>
<ul id="dropdown1" class="purple darken-4 dropdown-content">
    <li><a href="LoginServlet" class="white-text"><i class="material-icons left">directions_run</i> Salir</a></li>
</ul>
<ul id="dropdown2" class="purple darken-4 dropdown-content">
    <li><a href="LoginServlet"><i class="material-icons left">directions_run</i> Salir</a></li>
</ul>

<nav class="red darken-2 nav-extended">
    <div class="nav-wrapper">
        <a href="index.jsp" class="brand-logo">
            <img class="logo-image" src="images/logo.png">
        </a>
        <a href="#" data-target="mobile-demo" class="sidenav-trigger"><i class="material-icons">menu</i></a>
        <ul id="nav-mobile" class="right hide-on-med-and-down">
            <li class="<%= (pageName.contains("index.jsp") ? "active" : "") %>"><a href="index.jsp"><i class="material-icons left">attach_money</i> Rentas</a></li>
            <li class="<%= (pageName.contains("cliente.jsp") ? "active" : "") %>"><a href="cliente.jsp"><i class="material-icons left">people</i> Clientes</a></li>
            <li class="<%= (pageName.contains("juego.jsp") ? "active" : "") %>"><a href="juego.jsp"><i class="material-icons left">videogame_asset</i> Juegos</a></li>
            <li class="<%= (pageName.contains("reporte.jsp") ? "active" : "") %>"><a href="reporte.jsp"><i class="material-icons left">picture_as_pdf</i> Reportes</a></li>
            <li>
                <a class="dropdown-trigger" href="#!" data-target="dropdown1">
                    <i class="material-icons left">account_circle</i>
                    <%= nombreUsuario %>
                    <i class="material-icons right">arrow_drop_down</i>
                </a>
            </li>
        </ul>
    </div>
</nav>

<ul class="deep-purple sidenav" id="mobile-demo">
    <li class="<%= (pageName.contains("index.jsp") ? "active" : "") %>"><a href="index.jsp"><i class="material-icons left">attach_money</i> Rentas</a></li>
    <li class="<%= (pageName.contains("cliente.jsp") ? "active" : "") %>"><a href="cliente.jsp"><i class="material-icons left">people</i> Clientes</a></li>
    <li class="<%= (pageName.contains("juego.jsp") ? "active" : "") %>"><a href="juego.jsp"><i class="material-icons left">videogame_asset</i> Juegos</a></li>
    <li class="<%= (pageName.contains("reporte.jsp") ? "active" : "") %>"><a href="reporte.jsp"><i class="material-icons left">picture_as_pdf</i> Reportes</a></li>
    <li>
        <a class="dropdown-trigger" href="#!" data-target="dropdown2">
            <i class="material-icons left">account_circle</i>
            <%= usuario %>
            <i class="material-icons right">arrow_drop_down</i>
        </a>
    </li>
</ul>
