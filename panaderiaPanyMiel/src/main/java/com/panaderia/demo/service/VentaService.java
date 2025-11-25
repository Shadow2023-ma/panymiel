package com.panaderia.demo.service;

import com.panaderia.demo.model.Venta;
import com.panaderia.demo.model.Pedido;
import com.panaderia.demo.repository.VentaRepository;
import com.panaderia.demo.repository.PedidoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class VentaService {

    @Autowired
    private VentaRepository ventaRepository;

    @Autowired
    private PedidoRepository pedidoRepository;

    // Registrar venta
    public Venta registrarVenta(Integer idPedido, Venta.MetodoPago metodoPago, 
                                 Venta.TipoComprobante tipoComprobante, 
                                 String numeroComprobante) {
        
        // Validar que el pedido exista
        Pedido pedido = pedidoRepository.findById(idPedido)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));

        // Validar que no exista ya una venta para este pedido
        if (ventaRepository.findByPedidoIdPedido(idPedido).isPresent()) {
            throw new RuntimeException("Ya existe una venta registrada para este pedido");
        }

        // Crear venta
        Venta venta = new Venta();
        venta.setPedido(pedido);
        venta.setMontoPagado(pedido.getTotal());
        venta.setMetodoPago(metodoPago);
        venta.setTipoComprobante(tipoComprobante);
        venta.setNumeroComprobante(numeroComprobante);
        venta.setEstado(Venta.EstadoVenta.PAGADO);

        return ventaRepository.save(venta);
    }

    // Buscar venta por ID
    public Optional<Venta> buscarPorId(Integer id) {
        return ventaRepository.findById(id);
    }

    // Buscar venta por pedido
    public Optional<Venta> buscarPorPedido(Integer idPedido) {
        return ventaRepository.findByPedidoIdPedido(idPedido);
    }

    // Listar todas las ventas
    public List<Venta> listarTodas() {
        return ventaRepository.findAll();
    }

    // Listar ventas por estado
    public List<Venta> listarPorEstado(Venta.EstadoVenta estado) {
        return ventaRepository.findByEstado(estado);
    }

    // Listar ventas por método de pago
    public List<Venta> listarPorMetodoPago(Venta.MetodoPago metodoPago) {
        return ventaRepository.findByMetodoPago(metodoPago);
    }

    // Listar ventas por rango de fechas
    public List<Venta> listarPorRangoFechas(LocalDateTime inicio, LocalDateTime fin) {
        return ventaRepository.findByFechaVentaBetween(inicio, fin);
    }

    // Anular venta
    public void anularVenta(Integer idVenta, String motivo) {
        Venta venta = ventaRepository.findById(idVenta)
                .orElseThrow(() -> new RuntimeException("Venta no encontrada"));

        if (venta.getEstado() == Venta.EstadoVenta.ANULADO) {
            throw new RuntimeException("La venta ya está anulada");
        }

        venta.setEstado(Venta.EstadoVenta.ANULADO);
        ventaRepository.save(venta);
    }

    // Obtener total de ventas del día
    public BigDecimal obtenerTotalVentasDelDia() {
        BigDecimal total = ventaRepository.totalVentasDelDia();
        return total != null ? total : BigDecimal.ZERO;
    }

    // Obtener total de ventas por método de pago en un rango
    public List<Object[]> obtenerTotalPorMetodoPago(LocalDateTime inicio, LocalDateTime fin) {
        return ventaRepository.totalVentasPorMetodoPago(inicio, fin);
    }

    // Calcular total de ventas en un periodo
    public BigDecimal calcularTotalVentas(LocalDateTime inicio, LocalDateTime fin) {
        List<Venta> ventas = ventaRepository.findByFechaVentaBetween(inicio, fin);
        
        return ventas.stream()
                .filter(v -> v.getEstado() == Venta.EstadoVenta.PAGADO)
                .map(Venta::getMontoPagado)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Contar ventas del día
    public long contarVentasDelDia() {
        LocalDateTime inicioDia = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        LocalDateTime finDia = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);
        
        return ventaRepository.findByFechaVentaBetween(inicioDia, finDia).stream()
                .filter(v -> v.getEstado() == Venta.EstadoVenta.PAGADO)
                .count();
    }
}