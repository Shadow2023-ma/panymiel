<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Pan y Miel - Servicios</title>
    <link rel="stylesheet" href="/css/style.css">
    <script src="https://kit.fontawesome.com/d9cdfd874a.js" crossorigin="anonymous"></script>
</head>

<body>
<header class="header">
    <div class="menu container">
        <a href="#" class="logo">Pan y Miel</a>
        <input type="checkbox" id="menu" />
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

<section id="servicios" class="servicios container">
    <h2 class="titulo-servicios">Nuestros Servicios</h2>
    <p class="descripcion-servicios">
        En <strong>Pan y Miel</strong> no solo horneamos pan, también te ofrecemos experiencias dulces y momentos inolvidables.
    </p>

    <div class="servicios-grid">
        <div class="servicio-card">
            <i class="fas fa-bread-slice icono-servicio"></i>
            <h3>Panadería Artesanal</h3>
            <p>Elaboramos panes frescos todos los días con ingredientes naturales y recetas tradicionales.</p>
        </div>

        <div class="servicio-card">
            <i class="fas fa-birthday-cake icono-servicio"></i>
            <h3>Pastelería Personalizada</h3>
            <p>Diseñamos tortas y postres para cumpleaños, bodas y toda ocasión especial.</p>
        </div>

        <div class="servicio-card">
            <i class="fas fa-truck icono-servicio"></i>
            <h3>Delivery Rápido</h3>
            <p>Recibe tus pedidos en casa de forma segura y en el menor tiempo posible.</p>
        </div>

        <div class="servicio-card">
            <i class="fas fa-mug-hot icono-servicio"></i>
            <h3>Cafetería & Desayunos</h3>
            <p>Disfruta un café caliente con nuestros productos recién salidos del horno.</p>
        </div>
    </div>
</section>

<footer>
    <div class="barra-footer">
        <div class="footer-container">
            <div class="footer-logo">
                <img src="img/logo pan.webp" class="logo-footer" alt="Logo" />
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
