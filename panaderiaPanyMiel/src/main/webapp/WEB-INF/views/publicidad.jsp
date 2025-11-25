<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Pan y Miel - Publicidad</title>
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

<section class="publicidad">
    <div class="container">
        <h2>Publicidad</h2>
        <div class="oferts"> 
            <div class="ofert-1 b1"> 
                <div class="ofert-txt">
                    <h3>¡Oferta Especial!</h3>
                    <p>Descubre nuestras promociones exclusivas en productos seleccionados.</p>
                    <a href="#" class="btn-1">Ver Más</a> 
                </div>
                <div class="ofert-img">
                    <img src="https://plus.unsplash.com/premium_photo-1665669263531-cdcbe18e7fe4?ixlib=rb-4.1.0&auto=format&fit=crop&q=80&w=2125" 
                         alt="Panadería" style="width:100%; border-radius:10px;">
                </div>
            </div>
         
            <div class="ofert-1 b2"> 
                <div class="ofert-txt">
                    <h3>Nueva Colección</h3>
                    <p>Explora lo último en tendencias con descuentos increíbles.</p>
                    <a href="#" class="btn-1">Comprar Ahora</a>
                </div>
                <div class="ofert-img">
                    <img src="https://images.unsplash.com/photo-1568254183919-78a4f43a2877?ixlib=rb-4.1.0&auto=format&fit=crop&q=80&w=1469" 
                         alt="Panadería" style="width:100%; height:auto;">
                </div>
            </div>
            
            <div class="ofert-1 b3"> 
                <div class="ofert-txt">
                    <h3>Publicidad Partner</h3>
                    <p>Colabora con nosotros y alcanza a miles de clientes.</p>
                    <a href="#" class="boton-negro">Contactar</a> 
                </div>
                <div class="ofert-img">
                    <img src="https://images.unsplash.com/photo-1556740749-887f6717d7e4?ixlib=rb-4.1.0&auto=format&fit=crop&q=80&w=1471" 
                         alt="Panadería" style="width:100%; height:auto;">
                </div>
            </div>
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
