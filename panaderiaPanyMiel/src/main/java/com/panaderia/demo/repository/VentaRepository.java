package com.panaderia.demo.repository;

import com.panaderia.demo.model.Venta;
import com.panaderia.demo.model.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface VentaRepository extends JpaRepository<Venta, Integer> {
    
    // Buscar venta por pedido
    Optional<Venta> findByPedido(Pedido pedido);
    
    // Buscar venta por pedido ID
    Optional<Venta> findByPedidoIdPedido(Integer idPedido);
    
    // Buscar ventas por estado
    List<Venta> findByEstado(Venta.EstadoVenta estado);
    
    // Buscar ventas por método de pago
    List<Venta> findByMetodoPago(Venta.MetodoPago metodoPago);
    
    // Buscar ventas por rango de fechas
    List<Venta> findByFechaVentaBetween(LocalDateTime inicio, LocalDateTime fin);
    
    // Total de ventas del día
    @Query("SELECT SUM(v.montoPagado) FROM Venta v WHERE DATE(v.fechaVenta) = CURRENT_DATE AND v.estado = 'PAGADO'")
    BigDecimal totalVentasDelDia();
    
    // Total de ventas por método de pago en un rango de fechas
    @Query("SELECT v.metodoPago, SUM(v.montoPagado) FROM Venta v WHERE v.fechaVenta BETWEEN :inicio AND :fin GROUP BY v.metodoPago")
    List<Object[]> totalVentasPorMetodoPago(LocalDateTime inicio, LocalDateTime fin);
}