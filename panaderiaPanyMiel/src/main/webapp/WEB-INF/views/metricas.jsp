<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Pan y Miel - Métricas del Negocio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://kit.fontawesome.com/d9cdfd874a.js" crossorigin="anonymous"></script>
    
</head>
<body>

<header class="header">
    <div class="menu container">
        <a href="${pageContext.request.contextPath}/index" class="logo">Pan y Miel</a>
        <nav class="navbar">
            <ul>
                <li><a href="${pageContext.request.contextPath}/index">Inicio</a></li>
                <li><a href="${pageContext.request.contextPath}/servicios">Servicios</a></li>
                <li><a href="${pageContext.request.contextPath}/catalogo">Catálogo</a></li>
                <li><a href="${pageContext.request.contextPath}/producto">Producto</a></li>
                <li><a href="${pageContext.request.contextPath}/publicidad">Publicidad</a></li>
                <li><a href="${pageContext.request.contextPath}/metricas">Métricas</a></li>
                <li><a href="${pageContext.request.contextPath}/gestion">Gestión</a></li>
                <li><a href="${pageContext.request.contextPath}/modificar">Modificar</a></li>
                <li><a href="${pageContext.request.contextPath}/contactanos">Contáctenos</a></li>
            </ul>
        </nav>
    </div>
</header>

<main class="products container" style="padding: 40px 20px;">
    <h2 style="text-align: center; color: #ffc107; margin-bottom: 10px;">
        📊 Dashboard de Métricas
    </h2>
    <p style="text-align: center; color: #666; margin-bottom: 40px;">
        Análisis en tiempo real del rendimiento de tu negocio
    </p>

    <!-- Filtros de Fecha -->
    <div class="filtros-fecha">
        <label style="font-weight: 600;">Período:</label>
        <select id="periodoSelect">
            <option value="hoy">Hoy</option>
            <option value="semana">Esta Semana</option>
            <option value="mes" selected>Este Mes</option>
            <option value="anio">Este Año</option>
            <option value="personalizado">Personalizado</option>
        </select>

        <input type="date" id="fechaInicio" style="display: none;">
        <input type="date" id="fechaFin" style="display: none;">

        <button class="btn-actualizar" onclick="cargarMetricas()">
            <i class="fas fa-sync-alt"></i> Actualizar
        </button>
    </div>

    <!-- Métricas Principales -->
    <div class="metricas-grid">
        <!-- Total Ventas -->
        <div class="metrica-card">
            <i class="fas fa-dollar-sign metrica-icono"></i>
            <h3 class="metrica-titulo">Ingresos Totales</h3>
            <div class="metrica-valor" id="totalVentas">S/ 0.00</div>
            <p class="metrica-descripcion">Ventas completadas</p>
        </div>

        <!-- Total Pedidos -->
        <div class="metrica-card">
            <i class="fas fa-shopping-cart metrica-icono"></i>
            <h3 class="metrica-titulo">Total Pedidos</h3>
            <div class="metrica-valor" id="totalPedidos">0</div>
            <p class="metrica-descripcion">Órdenes procesadas</p>
        </div>

        <!-- Clientes Registrados -->
        <div class="metrica-card">
            <i class="fas fa-users metrica-icono"></i>
            <h3 class="metrica-titulo">Clientes Activos</h3>
            <div class="metrica-valor" id="totalClientes">0</div>
            <p class="metrica-descripcion">Usuarios registrados</p>
        </div>

        <!-- Productos Vendidos -->
        <div class="metrica-card">
            <i class="fas fa-box metrica-icono"></i>
            <h3 class="metrica-titulo">Productos Vendidos</h3>
            <div class="metrica-valor" id="productosVendidos">0</div>
            <p class="metrica-descripcion">Unidades totales</p>
        </div>

        <!-- Ticket Promedio -->
        <div class="metrica-card">
            <i class="fas fa-receipt metrica-icono"></i>
            <h3 class="metrica-titulo">Ticket Promedio</h3>
            <div class="metrica-valor" id="ticketPromedio">S/ 0.00</div>
            <p class="metrica-descripcion">Por pedido</p>
        </div>

        <!-- Pedidos Pendientes -->
        <div class="metrica-card">
            <i class="fas fa-clock metrica-icono" style="color: #ffc107;"></i>
            <h3 class="metrica-titulo">Pedidos Pendientes</h3>
            <div class="metrica-valor" id="pedidosPendientes">0</div>
            <p class="metrica-descripcion">Requieren atención</p>
        </div>
    </div>

    <!-- Top 5 Productos Más Vendidos -->
    <div class="grafico-container">
        <h3 style="color: #ffc107; margin-bottom: 20px;">
            <i class="fas fa-trophy"></i> Top 5 Productos Más Vendidos
        </h3>
        <ul class="top-productos" id="topProductos">
            <li>Cargando datos...</li>
        </ul>
    </div>

    <!-- Ventas por Método de Pago -->
    <div class="grafico-container">
        <h3 style="color: #ffc107; margin-bottom: 20px;">
            <i class="fas fa-credit-card"></i> Ventas por Método de Pago
        </h3>
        <div id="metodosPago" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
            <p>Cargando datos...</p>
        </div>
    </div>

    <!-- Estado de Pedidos -->
    <div class="grafico-container">
        <h3 style="color: #ffc107; margin-bottom: 20px;">
            <i class="fas fa-chart-pie"></i> Distribución de Pedidos por Estado
        </h3>
        <div id="estadosPedidos" style="display: flex; flex-wrap: wrap; gap: 15px; justify-content: center;">
            <p>Cargando datos...</p>
        </div>
    </div>

    <!-- Productos con Stock Bajo -->
    <div class="grafico-container">
        <h3 style="color: #ff6b6b; margin-bottom: 20px;">
            <i class="fas fa-exclamation-triangle"></i> Alertas de Stock Bajo
        </h3>
        <div id="stockBajo">
            <p>Cargando datos...</p>
        </div>
    </div>

</main>

<footer>
    <div class="barra-footer">
        <div class="footer-container">
            <div class="footer-logo">
                <img src="${pageContext.request.contextPath}/img/logo pan.webp" class="logo-footer" alt="Logo" />
                <p>Pan y Miel, saborea el buen saber jaujino</p>
            </div>
            <div>
                <h4>VENTAS</h4>
                <ul>
                    <li>Panadería</li>
                    <li>Tortas</li>
                    <li>Miel</li>
                </ul>
            </div>
            <div>
                <h4>Datos de contacto</h4>
                <ul>
                    <li>panymielp@gmail.com</li>
                    <li>924606154</li>
                    <li>Av. sin número 555<br />Junín - Perú</li>
                </ul>
            </div>
            <div>
                <h4>Redes Sociales</h4>
                <div class="redes">
                    <a href="#"><i class="fab fa-facebook"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
    </div>
    <div class="footer-copy">© PAN Y MIEL - 2025</div>
</footer>

<script>
document.addEventListener('DOMContentLoaded', function() {
    cargarMetricas();

    document.getElementById('periodoSelect').addEventListener('change', function() {
        var inputs = document.querySelectorAll('#fechaInicio, #fechaFin');
        var mostrar = this.value === 'personalizado';
        inputs.forEach(function(input) {
            input.style.display = mostrar ? 'block' : 'none';
        });
    });
});

async function cargarMetricas() {
    try {
        var pedidos = await fetch('/gestion/pedidos').then(function(r) { return r.json(); });
        var ventas = await fetch('/api/ventas').then(function(r) { return r.json(); }).catch(function() { return []; });
        var clientes = await fetch('/api/clientes').then(function(r) { return r.json(); }).catch(function() { return []; });
        var productos = await fetch('/api/metricas/productos').then(function(r) { return r.json(); });

        // 1. Total de Ventas
        var totalVentas = 0;
        for (var i = 0; i < ventas.length; i++) {
            totalVentas += (ventas[i].montoPagado || 0);
        }
        document.getElementById('totalVentas').textContent = 'S/ ' + totalVentas.toFixed(2);

        // 2. Total de Pedidos
        document.getElementById('totalPedidos').textContent = pedidos.length;

        // 3. Total de Clientes
        document.getElementById('totalClientes').textContent = clientes.length;

        // 4. Productos Vendidos
        var productosVendidos = 0;
        for (var i = 0; i < pedidos.length; i++) {
            if (pedidos[i].detalles) {
                for (var j = 0; j < pedidos[i].detalles.length; j++) {
                    productosVendidos += pedidos[i].detalles[j].cantidad;
                }
            }
        }
        document.getElementById('productosVendidos').textContent = productosVendidos;

        // 5. Ticket Promedio
        var ticketPromedio = pedidos.length > 0 ? totalVentas / pedidos.length : 0;
        document.getElementById('ticketPromedio').textContent = 'S/ ' + ticketPromedio.toFixed(2);

        // 6. Pedidos Pendientes
        var pendientes = 0;
        for (var i = 0; i < pedidos.length; i++) {
            if (pedidos[i].estado === 'PENDIENTE' || pedidos[i].estado === 'CONFIRMADO' || pedidos[i].estado === 'EN_PREPARACION') {
                pendientes++;
            }
        }
        document.getElementById('pedidosPendientes').textContent = pendientes;

        // 7. Top Productos
        calcularTopProductos(pedidos);

        // 8. Ventas por Método de Pago
        mostrarMetodosPago(ventas);

        // 9. Estados de Pedidos
        mostrarEstadosPedidos(pedidos);

        // 10. Stock Bajo
        mostrarStockBajo(productos);

    } catch (error) {
        console.error('Error al cargar métricas:', error);
        alert('Error al cargar las métricas. Por favor, recarga la página.');
    }
}

function calcularTopProductos(pedidos) {
    var conteo = {};
    
    for (var i = 0; i < pedidos.length; i++) {
        if (pedidos[i].detalles) {
            for (var j = 0; j < pedidos[i].detalles.length; j++) {
                var nombre = pedidos[i].detalles[j].producto.nombre;
                conteo[nombre] = (conteo[nombre] || 0) + pedidos[i].detalles[j].cantidad;
            }
        }
    }

    var items = Object.keys(conteo).map(function(key) {
        return [key, conteo[key]];
    });

    items.sort(function(a, b) {
        return b[1] - a[1];
    });

    var top = items.slice(0, 5);
    var colores = ['gold', 'silver', '#cd7f32', '#fb9c15', '#fb9c15'];

    var html = '';
    for (var i = 0; i < top.length; i++) {
        html += '<li><span class="producto-nombre"><i class="fas fa-medal" style="color: ' + colores[i] + ';"></i> ' + top[i][0] + '</span><span class="producto-cantidad">' + top[i][1] + ' vendidos</span></li>';
    }

    document.getElementById('topProductos').innerHTML = html || '<p style="text-align:center; color:#999;">No hay datos disponibles</p>';
}

function mostrarMetodosPago(ventas) {
    var conteo = {};
    var total = ventas.length;

    for (var i = 0; i < ventas.length; i++) {
        var metodo = ventas[i].metodoPago;
        conteo[metodo] = (conteo[metodo] || 0) + 1;
    }

    function obtenerIcono(metodo) {
        if (metodo === 'EFECTIVO') return 'money-bill-wave';
        if (metodo === 'TARJETA') return 'credit-card';
        return 'mobile-alt';
    }

    var html = '';
    var keys = Object.keys(conteo);
    for (var i = 0; i < keys.length; i++) {
        var metodo = keys[i];
        var cant = conteo[metodo];
        var porcentaje = total > 0 ? (cant / total * 100).toFixed(1) : 0;
        var icono = obtenerIcono(metodo);
        
        html += '<div style="text-align: center; padding: 15px; background: #f9f9f9; border-radius: 8px;">';
        html += '<i class="fas fa-' + icono + '" style="font-size: 2rem; color: #fb9c15; margin-bottom: 10px;"></i>';
        html += '<p style="font-weight: 600; margin: 5px 0;">' + metodo + '</p>';
        html += '<p style="font-size: 1.5rem; color: #333; margin: 5px 0;">' + cant + '</p>';
        html += '<p style="font-size: 0.9rem; color: #666;">' + porcentaje + '%</p>';
        html += '</div>';
    }

    document.getElementById('metodosPago').innerHTML = html || '<p style="text-align:center; color:#999;">No hay datos</p>';
}

function mostrarEstadosPedidos(pedidos) {
    var conteo = {};
    
    for (var i = 0; i < pedidos.length; i++) {
        var estado = pedidos[i].estado;
        conteo[estado] = (conteo[estado] || 0) + 1;
    }

    var colores = {
        'PENDIENTE': '#ffc107',
        'CONFIRMADO': '#17a2b8',
        'EN_PREPARACION': '#007bff',
        'LISTO_RECOJO': '#28a745',
        'ENTREGADO': '#28a745',
        'CANCELADO': '#dc3545'
    };

    function formatearEstado(estado) {
        return estado.replace(/_/g, ' ');
    }

    var html = '';
    var keys = Object.keys(conteo);
    for (var i = 0; i < keys.length; i++) {
        var estado = keys[i];
        var cant = conteo[estado];
        var color = colores[estado];
        
        html += '<div style="display: flex; align-items: center; gap: 10px; background: #f9f9f9; padding: 12px 20px; border-radius: 8px; border-left: 4px solid ' + color + ';">';
        html += '<span style="font-weight: 600; color: #333;">' + formatearEstado(estado) + '</span>';
        html += '<span style="background: ' + color + '; color: white; padding: 4px 12px; border-radius: 15px; font-weight: 600;">' + cant + '</span>';
        html += '</div>';
    }

    document.getElementById('estadosPedidos').innerHTML = html || '<p style="text-align:center; color:#999;">No hay datos</p>';
}

function mostrarStockBajo(productos) {
    var stockBajo = [];
    for (var i = 0; i < productos.length; i++) {
        if (productos[i].stock < 10 && productos[i].estado === 'DISPONIBLE') {
            stockBajo.push(productos[i]);
        }
    }

    var filasHTML = '';
    for (var i = 0; i < stockBajo.length; i++) {
        var p = stockBajo[i];
        filasHTML += '<tr>';
        filasHTML += '<td style="padding: 12px; border-bottom: 1px solid #eee;">' + p.nombre + '</td>';
        filasHTML += '<td style="padding: 12px; text-align: center; border-bottom: 1px solid #eee; color: #ff6b6b; font-weight: 600;">' + p.stock + ' unidades</td>';
        filasHTML += '<td style="padding: 12px; text-align: center; border-bottom: 1px solid #eee;"><span style="background: #ff6b6b; color: white; padding: 5px 12px; border-radius: 15px; font-size: 0.85rem;">⚠️ Bajo</span></td>';
        filasHTML += '</tr>';
    }

    var html = '';
    if (stockBajo.length > 0) {
        html = '<table style="width: 100%; border-collapse: collapse;">';
        html += '<thead style="background: #f1f1f1;"><tr>';
        html += '<th style="padding: 12px; text-align: left;">Producto</th>';
        html += '<th style="padding: 12px; text-align: center;">Stock Actual</th>';
        html += '<th style="padding: 12px; text-align: center;">Estado</th>';
        html += '</tr></thead>';
        html += '<tbody>' + filasHTML + '</tbody>';
        html += '</table>';
    } else {
        html = '<p style="text-align:center; color:#28a745; padding: 20px;"><i class="fas fa-check-circle" style="font-size: 2rem;"></i><br>✅ Todos los productos tienen stock adecuado</p>';
    }

    document.getElementById('stockBajo').innerHTML = html;
}
</script>

</body>
</html>