<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Pan y Miel - Gestión de Pedidos</title>
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

<div class="admin-container">
  <h2 style="text-align: center; color: #ffc107; margin-bottom: 30px;">📋 Gestión de Pedidos</h2>

  <div class="filtros-pedidos">
    <button class="activo" data-estado="TODOS" onclick="filtrarPorEstado('TODOS')">
      Todos (<span id="count-todos">0</span>)
    </button>
    <button data-estado="PENDIENTE" onclick="filtrarPorEstado('PENDIENTE')">
      Pendientes (<span id="count-pendiente">0</span>)
    </button>
    <button data-estado="CONFIRMADO" onclick="filtrarPorEstado('CONFIRMADO')">
      Confirmados (<span id="count-confirmado">0</span>)
    </button>
    <button data-estado="EN_PREPARACION" onclick="filtrarPorEstado('EN_PREPARACION')">
      En Preparación (<span id="count-preparacion">0</span>)
    </button>
    <button data-estado="LISTO_RECOJO" onclick="filtrarPorEstado('LISTO_RECOJO')">
      Listos (<span id="count-listo">0</span>)
    </button>
    <button data-estado="ENTREGADO" onclick="filtrarPorEstado('ENTREGADO')">
      Entregados (<span id="count-entregado">0</span>)
    </button>
    <button data-estado="CANCELADO" onclick="filtrarPorEstado('CANCELADO')">
      Cancelados (<span id="count-cancelado">0</span>)
    </button>
  </div>

  <table class="tabla-pedidos">
    <thead>
      <tr>
        <th>ID</th>
        <th>Cliente</th>
        <th>Fecha</th>
        <th>Total</th>
        <th>Tipo Entrega</th>
        <th>Estado</th>
        <th>Acciones</th>
      </tr>
    </thead>
    <tbody id="tablaPedidos"></tbody>
  </table>

  <div id="emptyState" class="empty-state" style="display: none;">
    <i class="fas fa-box-open"></i>
    <h3>No hay pedidos</h3>
    <p>No se encontraron pedidos con el filtro seleccionado</p>
  </div>
</div>

<div class="modal" id="modalDetalle">
  <div class="modal-content">
    <span class="close" onclick="cerrarModal()">&times;</span>
    <h3>📦 Detalle del Pedido</h3>
    <div id="detalleContenido"></div>
  </div>
</div>

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

<script src="${pageContext.request.contextPath}/js/gestion.js"></script>
</body>
</html>