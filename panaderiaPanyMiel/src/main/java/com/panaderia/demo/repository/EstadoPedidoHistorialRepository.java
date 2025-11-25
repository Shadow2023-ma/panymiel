package com.panaderia.demo.repository;

import com.panaderia.demo.model.EstadoPedidoHistorial;
import com.panaderia.demo.model.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EstadoPedidoHistorialRepository extends JpaRepository<EstadoPedidoHistorial, Integer> {
    
    // Buscar historial de estados por pedido
    List<EstadoPedidoHistorial> findByPedido(Pedido pedido);
    
    // Buscar historial de estados por pedido ID, ordenado por fecha
    List<EstadoPedidoHistorial> findByPedidoIdPedidoOrderByFechaCambioDesc(Integer idPedido);
    
    // Buscar último estado de un pedido
    EstadoPedidoHistorial findFirstByPedidoIdPedidoOrderByFechaCambioDesc(Integer idPedido);
}