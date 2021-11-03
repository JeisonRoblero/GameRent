<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!-- Compiled and minified JavaScript -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
<script>

    $(document).ready(function(){
        const today = new Date();
        $(".dropdown-trigger").dropdown();
        $('.sidenav').sidenav();
        $('.modal').modal();
        $('.tooltipped').tooltip();
        $('select').formSelect();
        $('.collapsible').collapsible();
        $('.datepicker.today').datepicker({yearRange:[1921,2021],maxDate: today,format:'yyyy-mm-dd', setDefaultDate:true, i18n: {
            months: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
            monthsShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
            weekdays: ['Domingo', 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado'],
            weekdaysShort: ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'],
            weekdaysAbbrev: ['Do','Lu','Ma','Mi','Ju','Vi','Sa'],
            cancel: 'Cancelar',
            clear: 'Limpiar'
        }});
        $('.show_new_form').click(function (){
            if ($('.add_new_form').css('display') == 'none') {
                $('.add_new_form').show('fast');
            } else {
                $('.add_new_form').hide('fast');
            }
        });

    });

    // MANEJO DE CLIENTES
    function eliminarClienteModal(clienteId, nombre) {
        var modalDeleteEl = $("#modalDelete");
        var instance = M.Modal.getInstance(modalDeleteEl);
        $("#modalDeleteMessage").html("Esta seguro que desea eliminar a <b>" + nombre + "</b>?");
        modalDeleteEl.attr("clienteid", clienteId);
        instance.open();
    }

    function eliminarCliente(){
        var modalDeleteEl = $("#modalDelete");
        var clienteId = modalDeleteEl.attr("clienteid");
        $.ajax("ClienteServlet?cliente_id="+clienteId, {type:"DELETE", success: function (){
            window.location.reload(false);
        }});
    }

    function editarClienteModal(clienteId, nombre, fechaNacimiento, telefono, direccion, correo){
        var editarClienteModal = $("#editarClienteModal");
        var instance = M.Modal.getInstance(editarClienteModal);
        $("#nombre_e").val(nombre);
        $("#fecha_nacimiento_e").val(fechaNacimiento);
        $("#telefono_e").val(telefono);
        $("#direccion_e").val(direccion);
        $("#correo_e").val(correo);
        $("#editarModalClienteId").val(clienteId);
        M.updateTextFields();
        instance.open();
    }

    function editarCliente() {
        var editClienteForm = $("#editClienteForm");
        $.ajax({
            type:"PUT",
            url:"ClienteServlet",
            data:editClienteForm.serialize(),
            success: function(){
                window.location.reload(false);
            }
        });
    }

    //MANEJO DE JUEGOS
    function cambiarEstadoJuego(clienteId, nuevoEstado){
        $.ajax("JuegoServlet?juego_id="+clienteId+"&nuevo_estado="+nuevoEstado, {type:"DELETE", success: function (){
            window.location.reload(false);
        }});
    }

    function editarJuegoModal(juegoId, nombre, descripcion, precio, imagen, categoria){
        var editarJuegoModalEl = $("#editarJuegoModal");
        var instance = M.Modal.getInstance(editarJuegoModalEl);
        $("#nombre_e").val(nombre);
        $("#descripcion_e").val(descripcion);
        $("#precio_e").val(precio);
        $("#imagen_e").val(imagen);
        $("#categoria_e").val(categoria);
        $("#categoria_e").formSelect();
        $("#editarModalJuegoId").val(juegoId);
        M.updateTextFields();
        instance.open();
    }

    function editarJuego() {
        var editJuegoForm = $("#editJuegoForm");
        $.ajax({
            type:"PUT",
            url:"JuegoServlet",
            data:editJuegoForm.serialize(),
            success: function(){
                window.location.reload(false);
            }
        });
    }

    // MANEJO DE RENTAS
    function mostrarDetalle(rentaId) {
        var modalDetalleJuegos = $("#modalDetalleJuegos");
        var instance = M.Modal.getInstance(modalDetalleJuegos);
        $("#detRentaID").html(rentaId);
        $.get('RentasServlet?detalles='+rentaId, function (result) {
            $("#modalDetalleContent").html(result);
        });
        instance.open();
    }

    function solicitarExtension(rentaId, fechaExtension) {
        var modalExtension = $("#modalExtension");
        var instance = M.Modal.getInstance(modalExtension);
        $("#modalExtensionMensaje").html("Se realizara una extension hasta <b>" + fechaExtension + "</b>");
        $("#modalExtensionMensaje").attr("fechaext", fechaExtension);
        $("#modalExtensionMensaje").attr("rentaid", rentaId);
        instance.open();
    }

    function extenderFecha(){
        var fechaExt = $("#modalExtensionMensaje").attr("fechaext");
        var rentaId = $("#modalExtensionMensaje").attr("rentaid");
        $.get('RentasServlet?extension='+rentaId+'&fechaext='+fechaExt, function (result) {
            window.location.reload(false);
        });
    }

    function guardarRenta(){
        var clienteId = $("#cliente").val();
        var juegosIds = $("#juegos").val();
        var juegosIdsString = ""
        for(var i = 0; i < juegosIds.length; i++) {
            if(i > 0) { juegosIdsString += ","; }
            juegosIdsString += juegosIds[i];
        }
        if (clienteId && juegosIdsString){
            $.get('RentasServlet?guardar='+clienteId+'&juegos='+juegosIdsString, function () {
                window.location.reload(false);
            });
        } else {
            console.log("Error");
        }
    }

    function mostrarCerrarRenta(rentaId, cliente, fRenta, fLimite, dateToday, dias, totalAlquiler, totalMultas){
        var modalCerrarRenta = $("#modalCerrarRenta");
        var instance = M.Modal.getInstance(modalCerrarRenta);
        $("#cerrarRentaID").html(rentaId);
        $("#cerrarRentaCliente").html(cliente);
        $("#cerrarRentaFechaRenta").html(fRenta);
        $("#cerrarRentaFechaLimite").html(fLimite);
        $("#cerrarRentaFechaActual").html(dateToday);
        $("#diasCounter").html(dias);
        $("#cr_totalAqluiler").html(totalAlquiler);
        $("#cr_totalMultas").html(totalMultas);
        $("#cr_totalPagar").html(totalMultas + totalAlquiler);
        $.get('RentasServlet?detalles='+rentaId, function (result) {
            $("#detalleJuegosCerrarRenta").html(result);
        });
        if (dias < 0) {
            $("#diasMensaje").html("Dias pendientes");
            $("#diasCounter").html(dias * -1);
        } else {
            $("#diasMensaje").html("Dias de retraso (Q.5 por dia de retraso por juego)");
        }
        instance.open();
    }
    function cerrarRenta() {
        var rentaId = $("#cerrarRentaID").html();
        var total = $("#cr_totalPagar").html();
        var totalMultas = $("#cr_totalMultas").html();
        $.get('RentasServlet?cerrar='+rentaId+'&total='+total+"&multa="+totalMultas, function (result) {
            window.location.reload(false);
        });
    }
</script>