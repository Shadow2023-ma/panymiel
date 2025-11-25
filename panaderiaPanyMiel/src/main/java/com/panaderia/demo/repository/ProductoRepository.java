package com.panaderia.demo.repository;

import com.panaderia.demo.model.Producto;
import com.panaderia.demo.model.CategoriaProducto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductoRepository extends JpaRepository<Producto, Integer> {
    
    // Buscar productos por estado
    List<Producto> findByEstado(Producto.EstadoProducto estado);
    
    // Buscar productos disponibles
    @Query("SELECT p FROM Producto p WHERE p.estado = 'DISPONIBLE'")
    List<Producto> findProductosDisponibles();
    
    // Buscar productos por categoría
    List<Producto> findByCategoria(CategoriaProducto categoria);
    
    // Buscar productos por categoría ID
    List<Producto> findByCategoriaIdCategoria(Integer idCategoria);
    
    // Buscar productos por nombre (búsqueda parcial)
    List<Producto> findByNombreContainingIgnoreCase(String nombre);
    
    // Buscar productos con stock bajo
    @Query("SELECT p FROM Producto p WHERE p.stock <= :stockMinimo")
    List<Producto> findProductosConStockBajo(Integer stockMinimo);
}