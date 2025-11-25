package com.panaderia.demo.service;

import com.panaderia.demo.model.*;
import com.panaderia.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class PedidoService {

    @Autowired
    private PedidoRepository pedidoRepository;

    @Autowired
    private DetallePedidoRepository detallePedidoRepository;

    @Autowired
    private ClienteRepository clienteRepository;

    @Autowired
    private ProductoRepository productoRepository;

    @Autowired
    private ProductoService productoService;

    @Autowired
    private EstadoPedidoHistorialRepository estadoPedidoHistorialRepository;

    // Crear pedido completo
    // Crear pedido completo
    public Pedido crearPedido(Integer idCliente, List<DetallePedido> detalles, 
                           Pedido.TipoEntrega tipoEntrega, String direccionEntrega, 
                           String observaciones) {
        
        // Validar cliente
        Cliente cliente = clienteRepository.findById(idCliente)
                .orElseThrow(() -> new RuntimeException("Cliente no encontrado"));

        // Crear pedido
        Pedido pedido = new Pedido();
        pedido.setCliente(cliente);
        pedido.setTipoEntrega(tipoEntrega);
        pedido.setDireccionEntrega(direccionEntrega);
        pedido.setObservaciones(observaciones);
        pedido.setEstado(Pedido.EstadoPedido.PENDIENTE);

        // Calcular totales
        BigDecimal subtotal = BigDecimal.ZERO;

        for (DetallePedido detalle : detalles) {
            // Validar producto y stock
            Producto producto = productoRepository.findById(detalle.getProducto().getIdProducto())
                    .orElseThrow(() -> new RuntimeException("Producto no encontrado"));

            if (producto.getStock() < detalle.getCantidad()) {
                throw new RuntimeException("Stock insuficiente para: " + producto.getNombre());
            }

            // Establecer precio unitario actual
            detalle.setPrecioUnitario(producto.getPrecio());
            detalle.calcularSubtotal();
            detalle.setPedido(pedido);

            subtotal = subtotal.add(detalle.getSubtotal());

            // Reducir stock del producto
            productoService.reducirStock(producto.getIdProducto(), detalle.getCantidad());
        }

        // 🔥 SIN IGV - El total es igual al subtotal
        pedido.setSubtotal(subtotal);
    
        pedido.setTotal(subtotal); // Total = Subtotal
        pedido.setDetalles(detalles);

        // Guardar pedido
        Pedido pedidoGuardado = pedidoRepository.save(pedido);

        // Registrar cambio de estado inicial
        registrarCambioEstado(pedidoGuardado, Pedido.EstadoPedido.PENDIENTE, "Pedido creado");

        return pedidoGuardado;
    }

    // Buscar pedido por ID
    public Optional<Pedido> buscarPorId(Integer id) {
        return pedidoRepository.findById(id);
    }

    // Listar todos los pedidos
    public List<Pedido> listarTodos() {
        return pedidoRepository.findAll();
    }

    // Listar pedidos por cliente
    public List<Pedido> listarPorCliente(Integer idCliente) {
        return pedidoRepository.findByClienteIdCliente(idCliente);
    }

    // Listar pedidos por estado
    public List<Pedido> listarPorEstado(Pedido.EstadoPedido estado) {
        return pedidoRepository.findByEstado(estado);
    }

    // Listar pedidos pendientes
    public List<Pedido> listarPendientes() {
        return pedidoRepository.findPedidosPendientes();
    }

    // Listar últimos pedidos de un cliente
    public List<Pedido> listarUltimosPedidos(Integer idCliente) {
        return pedidoRepository.findUltimosPedidosCliente(idCliente);
    }

    // Cambiar estado del pedido
    public void cambiarEstado(Integer idPedido, Pedido.EstadoPedido nuevoEstado, String observaciones) {
        Pedido pedido = pedidoRepository.findById(idPedido)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));

        pedido.setEstado(nuevoEstado);
        pedidoRepository.save(pedido);

        // Registrar cambio en el historial
        registrarCambioEstado(pedido, nuevoEstado, observaciones);
    }

    // Confirmar pedido
    public void confirmarPedido(Integer idPedido) {
        cambiarEstado(idPedido, Pedido.EstadoPedido.CONFIRMADO, "Pedido confirmado");
    }

    // Marcar como en preparación
    public void marcarEnPreparacion(Integer idPedido) {
        cambiarEstado(idPedido, Pedido.EstadoPedido.EN_PREPARACION, "Pedido en preparación");
    }

    // Marcar como listo para recojo
    public void marcarListoRecojo(Integer idPedido) {
        cambiarEstado(idPedido, Pedido.EstadoPedido.LISTO_RECOJO, "Pedido listo para recoger");
    }

    // Marcar como entregado
    public void marcarEntregado(Integer idPedido) {
        Pedido pedido = pedidoRepository.findById(idPedido)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));

        pedido.setEstado(Pedido.EstadoPedido.ENTREGADO);
        pedido.setFechaEntrega(LocalDateTime.now());
        pedidoRepository.save(pedido);

        registrarCambioEstado(pedido, Pedido.EstadoPedido.ENTREGADO, "Pedido entregado al cliente");
    }

    // Cancelar pedido
    public void cancelarPedido(Integer idPedido, String motivo) {
        Pedido pedido = pedidoRepository.findById(idPedido)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));

        // Devolver stock de los productos
        for (DetallePedido detalle : pedido.getDetalles()) {
            productoService.aumentarStock(detalle.getProducto().getIdProducto(), detalle.getCantidad());
        }

        pedido.setEstado(Pedido.EstadoPedido.CANCELADO);
        pedidoRepository.save(pedido);

        registrarCambioEstado(pedido, Pedido.EstadoPedido.CANCELADO, "Pedido cancelado: " + motivo);
    }

    // Obtener detalles de un pedido
    public List<DetallePedido> obtenerDetalles(Integer idPedido) {
        return detallePedidoRepository.findByPedidoIdPedido(idPedido);
    }

    // Registrar cambio de estado en el historial
    private void registrarCambioEstado(Pedido pedido, Pedido.EstadoPedido estado, String observaciones) {
        EstadoPedidoHistorial historial = new EstadoPedidoHistorial();
        historial.setPedido(pedido);
        historial.setEstado(estado);
        historial.setObservaciones(observaciones);
        estadoPedidoHistorialRepository.save(historial);
    }

    // Obtener historial de estados de un pedido
    public List<EstadoPedidoHistorial> obtenerHistorialEstados(Integer idPedido) {
        return estadoPedidoHistorialRepository.findByPedidoIdPedidoOrderByFechaCambioDesc(idPedido);
    }
}