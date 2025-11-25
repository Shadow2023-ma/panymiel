<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Pan y Miel</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<script src="https://kit.fontawesome.com/d9cdfd874a.js" crossorigin="anonymous"></script>
</head>
<body>
<header class="header">
    <div class="menu container">
        <a href="#" class="logo">Pan y Miel</a>
        <input type="checkbox" id="menu" />
        <label for="menu"><img src="${pageContext.request.contextPath}/img/menu.png" class="menu-icono" alt="menú"></label>
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

    <div class="header-content container">
        <div class="header-txt">
            <span>Bienvenido a la tienda online Pan y Miel</span>
            <h1>Nosotros</h1>
            <p>
                Nos dedicamos a la pastelería y panadería con pasión y dedicación,
                ofreciendo a nuestros clientes una amplia variedad de deliciosos productos horneados.
            </p>
        </div>
        <div class="header-img">
            <img src="${pageContext.request.contextPath}/img/bag.png" alt="Panadería" />
        </div>
    </div>
</header>

<section class="oferts container">
    <div class="ofert-1 b1">
        <div class="ofert-txt">
            <h3>Pan crujiente y suave. Ideal para tus sándwiches.</h3>
        </div>
        <div class="ofert-img">
            <img src="https://images.unsplash.com/photo-1608198093002-ad4e005484ec?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"  alt="Pan crujiente" />
        </div>
    </div>
    <div class="ofert-1 b2">
        <div class="ofert-txt">
            <h3>Dulce, fresca y frutal. El postre perfecto para cualquier momento.</h3>
        </div>
        <div class="ofert-img">
            <img src="https://images.unsplash.com/photo-1627032340427-45a513ff2477?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"  alt="Postre" />
        </div>
    </div>
    <div class="ofert-1 b3">
        <div class="ofert-txt">
            <h3>Rico en fibra y sabor. Perfecto para una dieta saludable.</h3>
        </div>
        <div class="ofert-img">
            <img src="https://images.unsplash.com/photo-1635439953364-355b8c11767b?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"  alt="Pan integral" />
        </div>
    </div>
</section>

<main class="products container">
    <c:forEach var="producto" items="${productos}">
        <div class="product-card">
            <img src="${pageContext.request.contextPath}/img/${producto.imagen}" alt="${producto.nombre}" />
            <h3>${producto.nombre}</h3>
            <p>Precio: $${producto.precio}</p>
            <button class="btn-1">Agregar al carrito</button>
        </div>
    </c:forEach>
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
</body>
</html>
