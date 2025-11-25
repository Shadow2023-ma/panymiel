// ==================== GESTIÓN INICIO / CIERRE DE SESIÓN ====================
document.addEventListener("DOMContentLoaded", () => {
    const loginBtn = document.getElementById("login-btn");
    const logoutBtn = document.getElementById("logout-btn");

    // Verificar si está logueado (variable viene del JSP)
    const estaLogueado = typeof usuarioLogueado !== 'undefined' && usuarioLogueado === "true";

    if (estaLogueado) {
        if (loginBtn) loginBtn.style.display = "none";
        if (logoutBtn) logoutBtn.style.display = "block";
    } else {
        if (loginBtn) loginBtn.style.display = "block";
        if (logoutBtn) logoutBtn.style.display = "none";
    }

    if (logoutBtn) {
        logoutBtn.addEventListener("click", () => {
            window.location.href = "/auth/logout";
        });
    }

    // Inicializar funcionalidades
    inicializarFiltros();
    inicializarCarrito();
    inicializarModal();
    cargarCarritoDesdeLocalStorage();
});

// ==================== MENSAJE AL AGREGAR ====================
function mostrarMensaje(mensaje) {
    const mensajeDiv = document.getElementById('mensaje-carrito');
    if (!mensajeDiv) {
        console.warn('No se encontró el elemento #mensaje-carrito');
        return;
    }
    
    mensajeDiv.textContent = mensaje;
    mensajeDiv.style.display = 'block';
    mensajeDiv.style.opacity = '1';

    setTimeout(() => {
        mensajeDiv.style.opacity = '0';
        setTimeout(() => {
            mensajeDiv.style.display = 'none';
        }, 300);
    }, 2500);
}

// ==================== FILTROS Y BÚSQUEDA ====================
function inicializarFiltros() {
    const filtroBtns = document.querySelectorAll('.filtro-btn');
    const cajas = document.querySelectorAll('.box');
    const buscarInput = document.getElementById('buscarProducto');

    function aplicarFiltro(cat) {
        filtroBtns.forEach(b => b.classList.toggle('activo', b.dataset.categoria === cat));
        const textoBusqueda = buscarInput ? buscarInput.value.trim().toLowerCase() : '';

        cajas.forEach(box => {
            const categoria = box.dataset.categoria || '';
            const nombre = (box.dataset.nombre || box.querySelector('h3')?.textContent || '').toLowerCase();
            const descripcion = (box.querySelector('p')?.textContent || '').toLowerCase();

            const coincideCategoria = (cat === 'todos') || (categoria === cat);
            const coincideTexto = !textoBusqueda || nombre.includes(textoBusqueda) || descripcion.includes(textoBusqueda);

            box.style.display = (coincideCategoria && coincideTexto) ? '' : 'none';
        });
    }

    filtroBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            aplicarFiltro(btn.dataset.categoria);
        });
    });

    if (buscarInput) {
        buscarInput.addEventListener('input', () => {
            const activo = document.querySelector('.filtro-btn.activo')?.dataset.categoria || 'todos';
            aplicarFiltro(activo);
        });
    }

    // Aplicar filtro inicial
    aplicarFiltro('todos');
}

// ==================== CARRITO ====================
let carritoItems = [];

function inicializarCarrito() {
    const imgCarrito = document.getElementById('img-carrito');
    const carritoDiv = document.getElementById('carrito');
    const vaciarCarritoBtn = document.getElementById('vaciar-carrito');
    const comprarAhoraBtn = document.getElementById('comprar-ahora');
    const elementos1 = document.getElementById('lista-1');

    // Toggle del carrito
    if (imgCarrito && carritoDiv) {
        imgCarrito.addEventListener('click', () => {
            carritoDiv.style.display = carritoDiv.style.display === 'block' ? 'none' : 'block';
        });

        // Cerrar al hacer clic fuera
        document.addEventListener('click', (e) => {
            if (!carritoDiv.contains(e.target) && e.target !== imgCarrito) {
                carritoDiv.style.display = 'none';
            }
        });
    }

    // Vaciar carrito
    if (vaciarCarritoBtn) {
        vaciarCarritoBtn.addEventListener('click', vaciarCarrito);
    }

    // Ir a comprar
    if (comprarAhoraBtn) {
        comprarAhoraBtn.addEventListener('click', () => {
            guardarCarrito();
            const estaLogueado = typeof usuarioLogueado !== 'undefined' && usuarioLogueado === "true";

            if (estaLogueado) {
                window.location.href = "/resumencompra";
            } else {
                alert("Debes iniciar sesión para realizar una compra");
                window.location.href = "/login";
            }
        });
    }

    // Agregar productos al carrito
    if (elementos1) {
        elementos1.addEventListener('click', (e) => {
            if (e.target.classList.contains('agregar-carrito')) {
                e.preventDefault();
                const box = e.target.closest('.box');
                agregarAlCarritoRapido(box);
            }
        });
    }

    // Eliminar del carrito
    if (carritoDiv) {
        carritoDiv.addEventListener('click', (e) => {
            if (e.target.classList.contains('borrar')) {
                e.preventDefault();
                const id = e.target.dataset.id;
                eliminarDelCarrito(id);
            }
        });
    }
}

function agregarAlCarritoRapido(box) {
    const id = box.dataset.id;
    const nombre = box.dataset.nombre || box.querySelector('h3')?.textContent;
    const precio = parseFloat(box.dataset.precio);
    const imagen = box.dataset.imagen || box.querySelector('img')?.src;

    const existe = carritoItems.find(item => item.id === id);

    if (existe) {
        existe.cantidad++;
    } else {
        carritoItems.push({
            id,
            titulo: nombre,
            precio,
            imagen,
            cantidad: 1
        });
    }

    renderizarCarrito();
    guardarCarrito();
    mostrarMensaje(`"${nombre}" añadido al carrito`);
}

function eliminarDelCarrito(id) {
    carritoItems = carritoItems.filter(item => item.id !== id);
    renderizarCarrito();
    guardarCarrito();
}

function vaciarCarrito() {
    carritoItems = [];
    renderizarCarrito();
    guardarCarrito();
}

function renderizarCarrito() {
    const lista = document.querySelector('#lista-carrito tbody');
    const totalCarrito = document.getElementById('total-carrito');

    if (!lista) return;

    lista.innerHTML = '';
    let total = 0;

    carritoItems.forEach(item => {
        const fila = document.createElement('tr');
        const subtotal = item.precio * item.cantidad;

        fila.innerHTML = `
            <td><img src="${item.imagen}" width="60" style="border-radius:6px;"></td>
            <td>${item.titulo}</td>
            <td>S/ ${item.precio.toFixed(2)}</td>
            <td>${item.cantidad}</td>
            <td><a href="#" class="borrar" data-id="${item.id}" style="color:#dc3545; font-weight:bold;">X</a></td>
        `;

        lista.appendChild(fila);
        total += subtotal;
    });

    if (totalCarrito) {
        totalCarrito.textContent = `S/ ${total.toFixed(2)}`;
    }
}

function guardarCarrito() {
    localStorage.setItem("carritoItems", JSON.stringify(carritoItems));
}

function cargarCarritoDesdeLocalStorage() {
    const data = localStorage.getItem("carritoItems");
    carritoItems = data ? JSON.parse(data) : [];
    renderizarCarrito();
}

// ==================== MODAL DE DETALLE ====================
let cantidadModal = 1;
let productoModalActual = null;

function inicializarModal() {
    const modal = document.getElementById('modal');
    const modalImagen = document.getElementById('modal-imagen');
    const modalTitulo = document.getElementById('modal-titulo');
    const modalDescripcion = document.getElementById('modal-descripcion');
    const modalPrecio = document.getElementById('modal-precio');
    const cantidadEl = document.getElementById('cantidad');
    const btnMas = document.getElementById('mas');
    const btnMenos = document.getElementById('menos');
    const btnAgregarModal = document.getElementById('agregar');
    const closeBtn = modal?.querySelector('.close');

    if (!modal) return;

    // Abrir modal desde botones .ver-detalle
    document.querySelectorAll('.ver-detalle').forEach(btn => {
        btn.addEventListener('click', () => {
            const box = btn.closest('.box');
            abrirModal({
                id: box.dataset.id,
                nombre: box.dataset.nombre || box.querySelector('h3')?.textContent,
                precio: parseFloat(box.dataset.precio),
                descripcion: box.dataset.descripcion || box.querySelector('p')?.textContent,
                imagen: box.dataset.imagen || box.querySelector('img')?.src
            });
        });
    });

    function abrirModal(data) {
        productoModalActual = data;
        cantidadModal = 1;

        modalImagen.src = data.imagen || '';
        modalImagen.alt = data.nombre || '';
        modalTitulo.textContent = data.nombre || '';
        modalDescripcion.textContent = data.descripcion || '';
        modalPrecio.textContent = 'S/ ' + (data.precio || 0).toFixed(2);
        cantidadEl.textContent = '1';
        
        modal.style.display = 'flex';
        modal.setAttribute('aria-hidden', 'false');
    }

    function cerrarModal() {
        modal.style.display = 'none';
        modal.setAttribute('aria-hidden', 'true');
    }

    // Botones del modal
    if (closeBtn) closeBtn.addEventListener('click', cerrarModal);
    modal.addEventListener('click', (e) => { if (e.target === modal) cerrarModal(); });

    if (btnMas) {
        btnMas.addEventListener('click', () => {
            cantidadModal++;
            cantidadEl.textContent = String(cantidadModal);
        });
    }

    if (btnMenos) {
        btnMenos.addEventListener('click', () => {
            if (cantidadModal > 1) {
                cantidadModal--;
                cantidadEl.textContent = String(cantidadModal);
            }
        });
    }

    if (btnAgregarModal) {
        btnAgregarModal.addEventListener('click', () => {
            if (!productoModalActual) return;

            const existe = carritoItems.find(item => item.id === productoModalActual.id);

            if (existe) {
                existe.cantidad += cantidadModal;
            } else {
                carritoItems.push({
                    id: productoModalActual.id,
                    titulo: productoModalActual.nombre,
                    precio: productoModalActual.precio,
                    imagen: productoModalActual.imagen,
                    cantidad: cantidadModal
                });
            }

            renderizarCarrito();
            guardarCarrito();
            cerrarModal();
            mostrarMensaje(`"${productoModalActual.nombre}" añadido al carrito`);
        });
    }

    // Cerrar con ESC
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && modal.style.display === 'flex') cerrarModal();
    });
}