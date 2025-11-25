<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Pan y Miel - Contacto</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://kit.fontawesome.com/d9cdfd874a.js" crossorigin="anonymous"></script>
</head>
<body>

<header class="header">
    <div class="menu container">
        <a href="${pageContext.request.contextPath}/index" class="logo">Pan y Miel</a>
        <input type="checkbox" id="menu" />
        <label for="menu">
            <img src="${pageContext.request.contextPath}/img/menu.png" class="menu-icono" alt="menú" />
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

<section id="contactenos" class="seccion container">
    <div style="margin-bottom: 20px;">
        <iframe
            width="520"
            height="400"
            frameborder="0"
            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d290.25878373724305!2d-75.45291548514854!3d-11.81837814901919!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x910ecf6080a9f3e7%3A0x3d5bbf4d45854e38!2sPanader%C3%ADa%20y%20Pasteler%C3%ADa%20MAFI!5e0!3m2!1ses-419!2spe!4v1714672771600!5m2!1ses-419!2spe"
            style="border: 0" allowfullscreen="" loading="lazy">
        </iframe>
    </div>

    <div class="contacto-form">
        <h3>Contáctenos</h3>
        <form id="formContacto">
            <input type="text" id="nombre" placeholder="Nombre" required />
            <input type="email" id="email" placeholder="Email" required />
            <textarea id="mensaje" placeholder="Mensaje" required></textarea>
            <input type="submit" class="boton boton-negro" value="Enviar" />
            <p id="estado" style="color: red"></p>
        </form>
    </div>
</section>

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
                    <li>Jr. Marcavalle 555<br/>Junín - Perú</li>
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

<script src="${pageContext.request.contextPath}/js/contactanos.js"></script>
</body>
</html>
