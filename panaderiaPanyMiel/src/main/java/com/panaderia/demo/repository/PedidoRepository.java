package com.panaderia.demo.repository;

import com.panaderia.demo.model.Pedido;
import com.panaderia.demo.model.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface PedidoRepository extends JpaRepository<Pedido, Integer> {
    
    // Buscar pedidos por cliente
    List<Pedido> findByCliente(Cliente cliente);
    
    // Buscar pedidos por cliente ID
    List<Pedido> findByClienteIdCliente(Integer idCliente);
    
    // Buscar pedidos por estado
    List<Pedido> findByEstado(Pedido.EstadoPedido estado);
    
    // Buscar pedidos por tipo de entrega
    List<Pedido> findByTipoEntrega(Pedido.TipoEntrega tipoEntrega);
    
    // Buscar pedidos por rango de fechas
    List<Pedido> findByFechaPedidoBetween(LocalDateTime inicio, LocalDateTime fin);
    
    // Buscar pedidos pendientes
    @Query("SELECT p FROM Pedido p WHERE p.estado = 'PENDIENTE' OR p.estado = 'CONFIRMADO'")
    List<Pedido> findPedidosPendientes();
    
    // Buscar pedidos recientes de un cliente (últimos 10)
    @Query("SELECT p FROM Pedido p WHERE p.cliente.idCliente = :idCliente ORDER BY p.fechaPedido DESC")
    List<Pedido> findUltimosPedidosCliente(Integer idCliente);
}