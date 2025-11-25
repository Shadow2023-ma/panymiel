<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Resumen de Compra - Pan y Miel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://kit.fontawesome.com/d9cdfd874a.js" crossorigin="anonymous"></script>
</head>
<body>

<header class="header">
    <div class="menu container">
        <a href="${pageContext.request.contextPath}/index" class="logo">Pan y Miel</a>
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

<section class="container" style="padding: 40px 20px; max-width: 900px; margin: 0 auto;">
    <h2 style="text-align: center; color: #ffc107; margin-bottom: 30px;">🛒 Resumen de tu Compra</h2>

    <table class="tabla-resumen">
        <thead>
            <tr>
                <th>Imagen</th>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Subtotal</th>
            </tr>
        </thead>
        <tbody id="lista-resumen">
            <!-- Se llenará con JavaScript -->
        </tbody>
    </table>

    <!-- Totales -->
    <div class="totales-box">
        <div class="row">
            <span>Subtotal:</span>
            <span id="subtotal-resumen">S/ 0.00</span>
        </div>

        <div class="row total">
            <span>Total a Pagar:</span>
            <span id="total-resumen">S/ 0.00</span>
        </div>
    </div>

    <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
        <a href="${pageContext.request.contextPath}/producto" class="btn-1">← Seguir Comprando</a>
        <button class="btn-1" id="btnComprar">Proceder al Pago →</button>
    </div>
</section>

<!-- ========================= -->
<!-- 🔥 MODAL DE COMPRA -->
<!-- ========================= -->

<div id="modalCompra" class="modal">
    <div class="modal-content">
        <span class="close" onclick="cerrarModalCompra()">&times;</span>
        <h2>📦 Datos para la entrega</h2>

        <form id="formCompra">

            <!-- Método de entrega -->
            <label for="metodoEntrega">Método de entrega: *</label>
            <select id="metodoEntrega" required>
                <option value="">Seleccione una opción</option>
                <option value="RECOJO_TIENDA">🏪 Recojo en tienda</option>
                <option value="DELIVERY">🚚 Delivery</option>
            </select>

            <!-- Dirección (solo si Delivery) -->
            <label for="direccion">Dirección de entrega:</label>
            <input type="text" id="direccion" placeholder="Ej: Av. Los Héroes 123, Huancayo">
            <small style="color: #666; display: block; margin-top: 5px;">* Requerido solo para delivery</small>

            <!-- Método de pago -->
            <label for="metodoPago">Método de pago: *</label>
            <select id="metodoPago" required>
                <option value="">Seleccione una opción</option>
                <option value="EFECTIVO">💵 Efectivo (contra entrega)</option>
                <option value="YAPE">📱 Yape</option>
                <option value="PLIN">📱 Plin</option>
                <option value="TARJETA">💳 Tarjeta</option>
            </select>

            <!-- Tipo de comprobante -->
            <label for="tipoComprobante">Tipo de comprobante:</label>
            <select id="tipoComprobante">
                <option value="BOLETA">Boleta</option>
                <option value="FACTURA">Factura</option>
                <option value="NINGUNO">Sin comprobante</option>
            </select>

            <!-- Número de comprobante -->
            <label for="comprobante">Número de comprobante (opcional):</label>
            <input type="text" id="comprobante" placeholder="Ej: B001-00123">

            <!-- Observaciones -->
            <label for="observaciones">Observaciones adicionales:</label>
            <textarea id="observaciones" rows="3" placeholder="Ej: Entregar entre 2-4pm"></textarea>

            <button type="submit" class="btn-1" style="width:100%; margin-top:20px; padding:15px; font-size:16px;">
                ✅ Confirmar Compra
            </button>
        </form>
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

<script src="${pageContext.request.contextPath}/js/resumen.js"></script>

</body>
</html>