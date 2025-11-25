let pedidosGlobal = [];
let estadoActual = 'TODOS';

// Cargar pedidos al iniciar
document.addEventListener('DOMContentLoaded', () => {
  cargarPedidos();
});

// Cargar pedidos desde el backend
async function cargarPedidos() {
  try {
    const response = await fetch('/gestion/pedidos');
    const pedidos = await response.json();
    pedidosGlobal = pedidos;
    actualizarContadores();
    renderizarPedidos(pedidos);
  } catch (error) {
    console.error('Error al cargar pedidos:', error);
    alert('Error al cargar los pedidos');
  }
}

// Actualizar contadores
function actualizarContadores() {
  const contadores = {
    PENDIENTE: 0,
    CONFIRMADO: 0,
    EN_PREPARACION: 0,
    LISTO_RECOJO: 0,
    ENTREGADO: 0,
    CANCELADO: 0
  };

  pedidosGlobal.forEach(p => {
    contadores[p.estado]++;
  });

  document.getElementById('count-todos').textContent = pedidosGlobal.length;
  document.getElementById('count-pendiente').textContent = contadores.PENDIENTE;
  document.getElementById('count-confirmado').textContent = contadores.CONFIRMADO;
  document.getElementById('count-preparacion').textContent = contadores.EN_PREPARACION;
  document.getElementById('count-listo').textContent = contadores.LISTO_RECOJO;
  document.getElementById('count-entregado').textContent = contadores.ENTREGADO;
  document.getElementById('count-cancelado').textContent = contadores.CANCELADO;
}

// Renderizar tabla de pedidos
function renderizarPedidos(pedidos) {
  const tbody = document.getElementById('tablaPedidos');
  const emptyState = document.getElementById('emptyState');

  if (pedidos.length === 0) {
    tbody.innerHTML = '';
    emptyState.style.display = 'block';
    return;
  }

  emptyState.style.display = 'none';
  
  tbody.innerHTML = pedidos.map(p => `
    <tr>
      <td>#${p.idPedido}</td>
      <td>${p.cliente.nombres} ${p.cliente.apellidos}</td>
      <td>${new Date(p.fechaPedido).toLocaleDateString('es-PE')}</td>
      <td>S/ ${p.total.toFixed(2)}</td>
      <td>${p.tipoEntrega === 'DELIVERY' ? '🚚 Delivery' : '🏪 Recojo'}</td>
      <td><span class="estado-badge estado-${p.estado}">${formatearEstado(p.estado)}</span></td>
      <td>
        <button class="btn-accion btn-ver" onclick="verDetalle(${p.idPedido})">
          <i class="fas fa-eye"></i> Ver
        </button>
        ${generarBotonesAccion(p)}
      </td>
    </tr>
  `).join('');
}

// Formatear estado para mostrar
function formatearEstado(estado) {
  const estados = {
    'PENDIENTE': 'Pendiente',
    'CONFIRMADO': 'Confirmado',
    'EN_PREPARACION': 'En Preparación',
    'LISTO_RECOJO': 'Listo',
    'ENTREGADO': 'Entregado',
    'CANCELADO': 'Cancelado'
  };
  return estados[estado] || estado;
}

// Generar botones de acción según el estado
function generarBotonesAccion(pedido) {
  let botones = '';

  if (pedido.estado === 'PENDIENTE') {
    botones += `<button class="btn-accion btn-confirmar" onclick="confirmarPedido(${pedido.idPedido})">Confirmar</button>`;
  }
  
  if (pedido.estado === 'CONFIRMADO') {
    botones += `<button class="btn-accion btn-preparar" onclick="marcarPreparacion(${pedido.idPedido})">Preparar</button>`;
  }
  
  if (pedido.estado === 'EN_PREPARACION') {
    botones += `<button class="btn-accion btn-listo" onclick="marcarListo(${pedido.idPedido})">Listo</button>`;
  }
  
  if (pedido.estado === 'LISTO_RECOJO') {
    botones += `<button class="btn-accion btn-entregar" onclick="marcarEntregado(${pedido.idPedido})">Entregar</button>`;
  }

  if (!['ENTREGADO', 'CANCELADO'].includes(pedido.estado)) {
    botones += `<button class="btn-accion btn-cancelar" onclick="cancelarPedido(${pedido.idPedido})">Cancelar</button>`;
  }

  return botones;
}

// Filtrar por estado
function filtrarPorEstado(estado) {
  estadoActual = estado;
  
  // Actualizar botón activo
  document.querySelectorAll('.filtros-pedidos button').forEach(btn => {
    btn.classList.toggle('activo', btn.dataset.estado === estado);
  });

  // Filtrar pedidos
  let pedidosFiltrados;
  if (estado === 'TODOS') {
    pedidosFiltrados = pedidosGlobal;
  } else {
    pedidosFiltrados = pedidosGlobal.filter(p => p.estado === estado);
  }

  renderizarPedidos(pedidosFiltrados);
}

// Ver detalle del pedido
async function verDetalle(idPedido) {
  try {
    const response = await fetch(`/gestion/pedidos/${idPedido}`);
    const data = await response.json();

    const pedido = data.pedido;
    const detalles = data.detalles;

    const contenido = document.getElementById('detalleContenido');
    contenido.innerHTML = `
      <div class="detalle-pedido">
        <p><strong>ID Pedido:</strong> #${pedido.idPedido}</p>
        <p><strong>Cliente:</strong> ${pedido.cliente.nombres} ${pedido.cliente.apellidos}</p>
        <p><strong>DNI:</strong> ${pedido.cliente.dni}</p>
        <p><strong>Teléfono:</strong> ${pedido.cliente.telefono || 'No proporcionado'}</p>
        <p><strong>Email:</strong> ${pedido.cliente.email || 'No proporcionado'}</p>
        <p><strong>Fecha Pedido:</strong> ${new Date(pedido.fechaPedido).toLocaleString('es-PE')}</p>
        <p><strong>Tipo Entrega:</strong> ${pedido.tipoEntrega === 'DELIVERY' ? 'Delivery' : 'Recojo en tienda'}</p>
        ${pedido.direccionEntrega ? `<p><strong>Dirección:</strong> ${pedido.direccionEntrega}</p>` : ''}
        <p><strong>Estado:</strong> <span class="estado-badge estado-${pedido.estado}">${formatearEstado(pedido.estado)}</span></p>
        ${pedido.observaciones ? `<p><strong>Observaciones:</strong> ${pedido.observaciones}</p>` : ''}

        <div class="productos-detalle">
          <h4>Productos:</h4>
          <table>
            <thead>
              <tr>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Precio Unit.</th>
                <th>Subtotal</th>
              </tr>
            </thead>
            <tbody>
              ${detalles.map(d => `
                <tr>
                  <td>${d.producto.nombre}</td>
                  <td>${d.cantidad}</td>
                  <td>S/ ${d.precioUnitario.toFixed(2)}</td>
                  <td>S/ ${d.subtotal.toFixed(2)}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>

        <div style="margin-top: 20px; padding: 15px; background: #f1f1f1; border-radius: 6px;">
          <p><strong>Subtotal:</strong> S/ ${pedido.subtotal.toFixed(2)}</p>
      
          <h3 style="color: #ffc107;"><strong>Total:</strong> S/ ${pedido.total.toFixed(2)}</h3>
        </div>
      </div>
    `;

    document.getElementById('modalDetalle').style.display = 'flex';
  } catch (error) {
    console.error('Error:', error);
    alert('Error al cargar el detalle del pedido');
  }
}

// Confirmar pedido
async function confirmarPedido(idPedido) {
  if (!confirm('¿Confirmar este pedido?')) return;
  await cambiarEstadoPedido(idPedido, '/gestion/pedidos/' + idPedido + '/confirmar', {}, 'Pedido confirmado');
}

// Marcar en preparación
async function marcarPreparacion(idPedido) {
  await cambiarEstadoPedido(idPedido, '/gestion/pedidos/' + idPedido + '/preparacion', {}, 'Pedido en preparación');
}

// Marcar listo
async function marcarListo(idPedido) {
  await cambiarEstadoPedido(idPedido, '/gestion/pedidos/' + idPedido + '/listo', {}, 'Pedido listo para recojo');
}

// Marcar entregado
async function marcarEntregado(idPedido) {
  if (!confirm('¿Marcar como entregado?')) return;
  await cambiarEstadoPedido(idPedido, '/gestion/pedidos/' + idPedido + '/entregar', {}, 'Pedido entregado');
}

// Cancelar pedido
async function cancelarPedido(idPedido) {
  const motivo = prompt('Ingrese el motivo de cancelación:');
  if (!motivo) return;

  await cambiarEstadoPedido(
    idPedido,
    `/gestion/pedidos/${idPedido}/cancelar?motivo=${encodeURIComponent(motivo)}`,
    {},
    'Pedido cancelado'
  );
}

// Función genérica para cambiar estado
async function cambiarEstadoPedido(idPedido, url, data, mensajeExito) {
  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });

    const result = await response.json();

    if (result.success) {
      alert(mensajeExito);
      cargarPedidos(); // Recargar lista
    } else {
      alert('Error: ' + (result.error || 'Error desconocido'));
    }
  } catch (error) {
    console.error('Error:', error);
    alert('Error de conexión');
  }
}

// Cerrar modal
function cerrarModal() {
  document.getElementById('modalDetalle').style.display = 'none';
}

window.onclick = function(event) {
  const modal = document.getElementById('modalDetalle');
  if (event.target === modal) cerrarModal();
};