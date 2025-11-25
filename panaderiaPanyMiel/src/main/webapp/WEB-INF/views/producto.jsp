<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Pan y Miel - Productos</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://kit.fontawesome.com/d9cdfd874a.js" crossorigin="anonymous"></script>
</head>
<body>
<header class="header">
    <div class="menu container" style="position:fixed;">
        <a href="${pageContext.request.contextPath}/index" class="logo">Pan y Miel</a>

        <input type="checkbox" id="menu" />
        <label for="menu">
            <img src="${pageContext.request.contextPath}/img/menu.png" class="menu-icono" alt="menú" />
        </label>

        <nav class="navbar" aria-label="Navegación principal">
            <ul>
                <li><a href="${pageContext.request.contextPath}/index">Inicio</a></li>
                <li><a href="${pageContext.request.contextPath}/servicios">Servicios</a></li>
                <li><a href="${pageContext.request.contextPath}/catalogo">Catálogo</a></li>
                <li><a href="${pageContext.request.contextPath}/producto">Producto</a></li>
                <li><a href="${pageContext.request.contextPath}/publicidad">Publicidad</a></li>
                <li><a href="${pageContext.request.contextPath}/contactanos">Contáctenos</a></li>
            </ul>
        </nav>

        <div style="display:flex; align-items:center; gap:12px;">
            <!-- CARRITO -->
            <div class="submenu" style="position:relative;">
                <img id="img-carrito" src="${pageContext.request.contextPath}/img/car.svg" alt="carrito" aria-haspopup="true" aria-controls="carrito" />

                <div id="carrito" role="dialog" aria-label="Carrito de compras">
                    <table id="lista-carrito" style="width:100%;">
                        <thead>
                            <tr>
                                <th>Imagen</th>
                                <th>Nombre</th>
                                <th>Precio</th>
                                <th>Cantidad</th>
                                <th>Eliminar</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- productos  -->
                        </tbody>
                    </table>

                    <div class="carrito-total" style="display:flex; justify-content:space-between; align-items:center; margin-top:10px;">
                        <strong>Total:</strong><span id="total-carrito">S/ 0.00</span>
                    </div>

                    <div style="display:flex; gap:8px; margin-top:12px;">
                        <button class="btn-1" id="vaciar-carrito">Vaciar Carrito</button>
                        <button class="btn-1" id="comprar-ahora">Ir a comprar</button>
                    </div>
                </div>
            </div>

            <!-- LOGIN / LOGOUT -->
            <div>
                <a href="${pageContext.request.contextPath}/login" class="btn-1" id="login-btn">Iniciar Sesión</a>
                <button id="logout-btn" class="btn-1" style="display:none;">Cerrar Sesión</button>
            </div>
        </div>
    </div>
</header>

<main class="products container" style="padding: 28px 12px;">
    <h2 style="text-align:center; margin-bottom:18px;">Nuestros Productos</h2>

    <!-- BARRA DE FILTROS (dinámica si envías 'categorias' desde controller) -->
    <div style="display:flex; gap:12px; justify-content:center; align-items:center; margin-bottom:18px; flex-wrap:wrap;">
        <input id="buscarProducto" type="search" placeholder="Buscar producto..." style="padding:10px; width:260px; border-radius:6px; border:1px solid #ddd;" aria-label="Buscar producto">

        <div class="filtro-productos" role="toolbar" aria-label="Filtrar por categoría">
            <c:choose>
                <c:when test="${not empty categorias}">
                    <button class="btn-1 filtro-btn activo" data-categoria="todos">Todos</button>
                    <c:forEach var="cat" items="${categorias}">
                        <button class="btn-1 filtro-btn" data-categoria="${fn:toLowerCase(cat.nombre)}">${cat.nombre}</button>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Fallback a botones estáticos si no envías categorias -->
                    <button class="btn-1 filtro-btn activo" data-categoria="todos">Todos</button>
                    <button class="btn-1 filtro-btn" data-categoria="pan">Panes</button>
                    <button class="btn-1 filtro-btn" data-categoria="pastel">Tortas</button>
                    <button class="btn-1 filtro-btn" data-categoria="bebidas">Bebidas</button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="box-container" id="lista-1" style="gap:18px;">
        <c:forEach var="p" items="${productos}">
            <div class="box" role="article"
                 data-categoria="${fn:toLowerCase(p.categoria.nombre)}"
                 data-id="${p.idProducto}"
                 data-nombre="${p.nombre}"
                 data-precio="${p.precio}"
                 data-imagen="${p.imagenUrl}">
                 
                <img src="${p.imagenUrl}" alt="${p.nombre}" loading="lazy" />

                <h3>${p.nombre}</h3>

                <p>${p.descripcion}</p>

                <span class="precio">S/ ${p.precio}</span>

                <button class="btn-1 agregar-carrito"
                    data-id="${p.idProducto}"
                    data-nombre="${p.nombre}"
                    data-precio="${p.precio}"
                    data-imagen="${p.imagenUrl}"
                    aria-label="Agregar ${p.nombre} al carrito">
                    Agregar
                </button>

                <button class="btn-1 ver-detalle" style="margin-top:8px; background:#333;" 
                        data-id="${p.idProducto}"
                        data-nombre="${p.nombre}"
                        data-precio="${p.precio}"
                        data-descripcion="${fn:escapeXml(p.descripcion)}"
                        data-imagen="${p.imagenUrl}">
                    Ver
                </button>
            </div>
        </c:forEach>
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

<!-- Mensaje flotante -->
<div id="mensaje-carrito" aria-live="polite" ></div>

<!-- Modal accesible -->
<div id="modal" class="modal" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal-titulo">
    <div class="modal-content">
        <button class="close" aria-label="Cerrar modal">&times;</button>
        <img id="modal-imagen" src="" alt="" style="max-width: 100%; height: auto; margin-bottom: 15px;" />
        <h3 id="modal-titulo"></h3>
        <p id="modal-descripcion" style="margin-bottom: 10px;"></p>
        <p id="modal-precio" style="font-weight: 700; color: #fb9c15; margin-bottom: 15px;"></p>
        <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 20px;">
            <button id="menos" class="btn-1" style="padding: 8px 12px;">-</button>
            <span id="cantidad" style="font-size: 18px; min-width: 30px; text-align: center;">1</span>
            <button id="mas" class="btn-1" style="padding: 8px 12px;">+</button>
        </div>
        <button id="agregar" class="btn-1" style="width: 100%;">Agregar al carrito</button>
    </div>
</div>

<!-- PASAR VARIABLE DE SESIÓN A JAVASCRIPT -->
<script>
    // Variable global que producto.js usará para verificar si está logueado
    var usuarioLogueado = "${usuarioLogueado}";
    console.log("Usuario logueado:", usuarioLogueado); // Para debug
</script>

<!-- JS principal -->
<script src="${pageContext.request.contextPath}/js/producto.js"></script>



</body>
</html>