<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Gestión de Productos - Pan y Miel</title>
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
    <h1 style="text-align: center; color: #ffc107; margin-bottom: 30px;">
        🛠️ Gestión de Productos
    </h1>

    <!-- Mensajes de éxito/error -->
    <c:if test="${not empty mensaje}">
        <div class="alert alert-success">${mensaje}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <!-- Pestañas -->
    <div class="tabs">
        <button class="tab-btn active" onclick="mostrarTab('crear')">➕ Crear Producto</button>
        <button class="tab-btn" onclick="mostrarTab('listar')">📋 Listar Productos</button>
        <button class="tab-btn" onclick="mostrarTab('modificar')">✏️ Modificar Producto</button>
    </div>

    <!-- TAB: CREAR PRODUCTO -->
    <div id="tab-crear" class="tab-content active">
        <h2>Crear Nuevo Producto</h2>
        <form action="${pageContext.request.contextPath}/admin/productos/crear" method="POST" enctype="multipart/form-data">
            <div class="form-grid">
                <div class="form-group">
                    <label for="nombre">Nombre del Producto *</label>
                    <input type="text" id="nombre" name="nombre" required placeholder="Ej: Pan de Yema">
                </div>

                <div class="form-group">
                    <label for="categoria">Categoría *</label>
                    <select id="categoria" name="idCategoria" required>
                        <option value="">Seleccione una categoría</option>
                        <c:forEach var="cat" items="${categorias}">
                            <option value="${cat.idCategoria}">${cat.nombre}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="precio">Precio (S/) *</label>
                    <input type="number" step="0.01" id="precio" name="precio" required placeholder="Ej: 5.50">
                </div>

                <div class="form-group">
                    <label for="stock">Stock Inicial *</label>
                    <input type="number" id="stock" name="stock" required placeholder="Ej: 100">
                </div>

                <div class="form-group full-width">
                    <label for="descripcion">Descripción</label>
                    <textarea id="descripcion" name="descripcion" placeholder="Descripción del producto..."></textarea>
                </div>

                <div class="form-group">
                    <label for="imagen">Imagen del Producto *</label>
                    <input type="file" id="imagen" name="imagen" accept="image/*" required onchange="previsualizarImagen(event)">
                    <img id="preview" class="preview-imagen" alt="Vista previa">
                </div>

                <div class="form-group">
                    <label for="estado">Estado *</label>
                    <select id="estado" name="estado" required>
                        <option value="DISPONIBLE">Disponible</option>
                        <option value="AGOTADO">Agotado</option>
                        <option value="INACTIVO">Inactivo</option>
                    </select>
                </div>
            </div>

            <button type="submit" class="btn-1" style="width: 100%; padding: 15px; font-size: 16px;">
                ➕ Crear Producto
            </button>
        </form>
    </div>

    <!-- TAB: LISTAR PRODUCTOS -->
    <div id="tab-listar" class="tab-content">
        <h2>Lista de Productos</h2>
        
        <div style="margin-bottom: 20px; display: flex; gap: 10px;">
            <input type="text" id="buscarProducto" placeholder="Buscar por nombre..." 
                   style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 6px;">
            <select id="filtroCategoria" style="padding: 10px; border: 1px solid #ddd; border-radius: 6px;">
                <option value="">Todas las categorías</option>
                <c:forEach var="cat" items="${categorias}">
                    <option value="${cat.idCategoria}">${cat.nombre}</option>
                </c:forEach>
            </select>
        </div>

        <table class="tabla-productos">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Imagen</th>
                    <th>Nombre</th>
                    <th>Categoría</th>
                    <th>Precio</th>
                    <th>Stock</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody id="tablaProductosBody">
                <c:forEach var="prod" items="${productos}">
                    <tr>
                        <td>${prod.idProducto}</td>
                        <td><img src="${prod.imagenUrl}" alt="${prod.nombre}"></td>
                        <td>${prod.nombre}</td>
                        <td>${prod.categoria.nombre}</td>
                        <td>S/ ${prod.precio}</td>
                        <td>${prod.stock}</td>
                        <td>
                            <c:choose>
                                <c:when test="${prod.estado == 'DISPONIBLE'}">
                                    <span class="estado-badge estado-disponible">Disponible</span>
                                </c:when>
                                <c:when test="${prod.estado == 'AGOTADO'}">
                                    <span class="estado-badge estado-agotado">Agotado</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="estado-badge estado-inactivo">Inactivo</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <button class="btn-accion btn-editar" onclick="editarProducto(${prod.idProducto})">
                                <i class="fas fa-edit"></i> Editar
                            </button>
                            <button class="btn-accion btn-eliminar" onclick="eliminarProducto(${prod.idProducto}, '${prod.nombre}')">
                                <i class="fas fa-trash"></i> Eliminar
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- TAB: MODIFICAR PRODUCTO -->
    <div id="tab-modificar" class="tab-content">
        <h2>Modificar Producto Existente</h2>
        
        <div class="form-group" style="margin-bottom: 30px;">
            <label for="selectProductoModificar">Selecciona el producto a modificar:</label>
            <select id="selectProductoModificar" onchange="cargarDatosProducto()" style="padding: 12px; border: 1px solid #ddd; border-radius: 6px;">
                <option value="">Seleccione un producto</option>
                <c:forEach var="prod" items="${productos}">
                    <option value="${prod.idProducto}">${prod.nombre}</option>
                </c:forEach>
            </select>
        </div>

        <form id="formModificar" action="${pageContext.request.contextPath}/admin/productos/modificar" method="POST" enctype="multipart/form-data" style="display: none;">
            <input type="hidden" id="mod_idProducto" name="idProducto">
            
            <div class="form-grid">
                <div class="form-group">
                    <label for="mod_nombre">Nombre del Producto *</label>
                    <input type="text" id="mod_nombre" name="nombre" required>
                </div>

                <div class="form-group">
                    <label for="mod_categoria">Categoría *</label>
                    <select id="mod_categoria" name="idCategoria" required>
                        <c:forEach var="cat" items="${categorias}">
                            <option value="${cat.idCategoria}">${cat.nombre}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="mod_precio">Precio (S/) *</label>
                    <input type="number" step="0.01" id="mod_precio" name="precio" required>
                </div>

                <div class="form-group">
                    <label for="mod_stock">Stock *</label>
                    <input type="number" id="mod_stock" name="stock" required>
                </div>

                <div class="form-group full-width">
                    <label for="mod_descripcion">Descripción</label>
                    <textarea id="mod_descripcion" name="descripcion"></textarea>
                </div>

                <div class="form-group">
                    <label for="mod_imagen">Cambiar Imagen (opcional)</label>
                    <input type="file" id="mod_imagen" name="imagen" accept="image/*" onchange="previsualizarImagenModificar(event)">
                    <img id="mod_preview" class="preview-imagen" alt="Vista previa actual">
                </div>

                <div class="form-group">
                    <label for="mod_estado">Estado *</label>
                    <select id="mod_estado" name="estado" required>
                        <option value="DISPONIBLE">Disponible</option>
                        <option value="AGOTADO">Agotado</option>
                        <option value="INACTIVO">Inactivo</option>
                    </select>
                </div>
            </div>

            <button type="submit" class="btn-1" style="width: 100%; padding: 15px; font-size: 16px;">
                💾 Guardar Cambios
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

<script>
// Cambiar entre tabs
function mostrarTab(tabName) {
    document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
    
    document.getElementById('tab-' + tabName).classList.add('active');
    event.target.classList.add('active');
}

// Previsualizar imagen al crear
function previsualizarImagen(event) {
    const preview = document.getElementById('preview');
    const file = event.target.files[0];
    
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
        };
        reader.readAsDataURL(file);
    }
}

// Previsualizar imagen al modificar
function previsualizarImagenModificar(event) {
    const preview = document.getElementById('mod_preview');
    const file = event.target.files[0];
    
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
        };
        reader.readAsDataURL(file);
    }
}

// Cargar datos del producto seleccionado para modificar
function cargarDatosProducto() {
    const select = document.getElementById('selectProductoModificar');
    const idProducto = select.value;
    
    if (!idProducto) {
        document.getElementById('formModificar').style.display = 'none';
        return;
    }
    
    fetch('${pageContext.request.contextPath}/admin/productos/' + idProducto)
        .then(response => response.json())
        .then(producto => {
            document.getElementById('mod_idProducto').value = producto.idProducto;
            document.getElementById('mod_nombre').value = producto.nombre;
            document.getElementById('mod_categoria').value = producto.categoria.idCategoria;
            document.getElementById('mod_precio').value = producto.precio;
            document.getElementById('mod_stock').value = producto.stock;
            document.getElementById('mod_descripcion').value = producto.descripcion || '';
            document.getElementById('mod_estado').value = producto.estado;
            
            const preview = document.getElementById('mod_preview');
            preview.src = producto.imagenUrl;
            preview.style.display = 'block';
            
            document.getElementById('formModificar').style.display = 'block';
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error al cargar los datos del producto');
        });
}

// Editar producto desde la tabla
function editarProducto(idProducto) {
    mostrarTab('modificar');
    document.getElementById('selectProductoModificar').value = idProducto;
    cargarDatosProducto();
}

// Eliminar producto
function eliminarProducto(idProducto, nombre) {
    if (confirm('¿Estás seguro de eliminar el producto "' + nombre + '"?')) {
        fetch('${pageContext.request.contextPath}/admin/productos/eliminar/' + idProducto, {
            method: 'DELETE'
        })
        .then(response => {
            if (response.ok) {
                alert('Producto eliminado correctamente');
                location.reload();
            } else {
                alert('Error al eliminar el producto');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error al eliminar el producto');
        });
    }
}

// Buscar productos
document.getElementById('buscarProducto')?.addEventListener('input', function(e) {
    const texto = e.target.value.toLowerCase();
    const filas = document.querySelectorAll('#tablaProductosBody tr');
    
    filas.forEach(fila => {
        const nombre = fila.cells[2].textContent.toLowerCase();
        fila.style.display = nombre.includes(texto) ? '' : 'none';
    });
});

// Filtrar por categoría
document.getElementById('filtroCategoria')?.addEventListener('change', function(e) {
    const categoriaId = e.target.value;
    const filas = document.querySelectorAll('#tablaProductosBody tr');
    
    filas.forEach(fila => {
        if (!categoriaId) {
            fila.style.display = '';
        } else {
            // Aquí necesitarías agregar un data-attribute con el ID de categoría en cada fila
            // Para simplificar, solo mostramos/ocultamos por texto
            const categoria = fila.cells[3].textContent;
            const categoriaSeleccionada = e.target.options[e.target.selectedIndex].text;
            fila.style.display = categoria === categoriaSeleccionada ? '' : 'none';
        }
    });
});

// Auto-cerrar alertas después de 5 segundos
setTimeout(() => {
    document.querySelectorAll('.alert').forEach(alert => {
        alert.style.transition = 'opacity 0.5s';
        alert.style.opacity = '0';
        setTimeout(() => alert.remove(), 500);
    });
}, 5000);
</script>

</body>
</html>