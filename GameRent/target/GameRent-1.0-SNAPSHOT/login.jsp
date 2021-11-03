<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page session="true" %>
<%
    HttpSession sessionValidation = request.getSession();
    if (sessionValidation.getAttribute("usuario") != null) {
        response.sendRedirect("index.jsp");
    }
%>
<html>
<head>
    <title>Login - GameRent</title>
    <%@include file="includes/head.jsp"%>
</head>
<body>

    <div class="row">
        <div class="col s12 m6 offset-m3">
            <div class="card purple darken-1">
                <div class="card-content white-text">
                    <span class="card-title">
                        Iniciar Sesión
                        <img src="images/logo.png" class="logo-login-image" alt="">
                    </span>
                    <div class="row">
                        <form class="col s12" action="LoginServlet"  method="post">
                            <div class="row">
                                <div class="input-field col s12">
                                    <i class="material-icons prefix">account_circle</i>
                                    <input type="text" required class="validate" name="usuario" id="usuario">
                                    <label for="usuario">Usuario</label>
                                </div>
                                <div class="input-field col s12">
                                    <i class="material-icons prefix">lock</i>
                                    <input id="clave" name="clave" type="password" required class="validate">
                                    <label for="clave">Clave</label>
                                </div>
                                <div class="input-field col s12">
                                    <button class="waves-effect waves-light btn" type="submit">Iniciar</button>
                                </div>
                                <%
                                    boolean error = request.getParameterMap().containsKey("error");
                                    if (error) {
                                        out.println("<div class='col s12'>Error en el usuario o la clave</div>");
                                    }
                                %>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Compiled and minified JavaScript -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</body>
</html>
