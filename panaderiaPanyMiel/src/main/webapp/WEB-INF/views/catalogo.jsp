<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Pan y Miel - Catálogo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://kit.fontawesome.com/d9cdfd874a.js" crossorigin="anonymous"></script>
</head>
<body>

<header class="header">
    <div class="menu container">
        <a href="${pageContext.request.contextPath}/index" class="logo">Pan y Miel</a>
        <input type="checkbox" id="menu"/>
        <label for="menu">
            <img src="${pageContext.request.contextPath}/img/menu.png" class="menu-icono" alt="menú"/>
        </label>
        <nav class="navbar">
            <ul>
                <li><a href="${pageContext.request.contextPath}/index">Inicio</a></li>
                <li><a href="${pageContext.request.contextPath}/servicios">Servicios</a></li>
                <li><a href="${pageContext.request.contextPath}/catalogo">Catálogo</a></li>
                <li><a href="${pageContext.request.contextPath}/producto">Producto</a></li>
                <li><a href="${pageContext.request.contextPath}/publicidad">Publicidad</a></li>
                <li><a href="${pageContext.request.contextPath}/contactanos">Contáctenos</a></li>
            </ul>
        </nav>
    </div>
</header>

<main class="products container">
    <h2>Catálogo de Productos</h2>
    <div class="box-container" id="lista-1">
        <c:forEach var="producto" items="${productos}">
            <div class="box" data-categoria="${producto.categoria.nombre}" style="display: inline-block;">
                <img src="${producto.imagenUrl}" alt="${producto.nombre}" />
                <div class="product-txt">
                    <h3>${producto.nombre}</h3>
                    <p class="precio">S/ ${producto.precio}</p>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="btn-2" id="load-more">Cargar Más</div>
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
                    <li>Av. sin número 555<br/>Junín - Perú</li>
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

<script src="${pageContext.request.contextPath}/js/catalogo.js"></script>
</body>
</html>