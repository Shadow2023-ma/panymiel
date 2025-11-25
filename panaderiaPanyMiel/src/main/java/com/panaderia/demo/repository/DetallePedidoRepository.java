package com.panaderia.demo.repository;

import com.panaderia.demo.model.DetallePedido;
import com.panaderia.demo.model.Pedido;
import com.panaderia.demo.model.Producto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DetallePedidoRepository extends JpaRepository<DetallePedido, Integer> {
    
    // Buscar detalles por pedido
    List<DetallePedido> findByPedido(Pedido pedido);
    
    // Buscar detalles por pedido ID
    List<DetallePedido> findByPedidoIdPedido(Integer idPedido);
    
    // Buscar detalles por producto
    List<DetallePedido> findByProducto(Producto producto);
    
    // Productos más vendidos
    @Query("SELECT dp.producto, SUM(dp.cantidad) as total FROM DetallePedido dp GROUP BY dp.producto ORDER BY total DESC")
    List<Object[]> findProductosMasVendidos();
}