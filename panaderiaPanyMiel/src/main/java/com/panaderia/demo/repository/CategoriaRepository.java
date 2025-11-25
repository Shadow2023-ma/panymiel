package com.panaderia.demo.repository;

import com.panaderia.demo.model.CategoriaProducto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoriaRepository extends JpaRepository<CategoriaProducto, Integer> {
    
    // Buscar categoría por nombre
    Optional<CategoriaProducto> findByNombre(String nombre);
    
    // Listar categorías activas
    List<CategoriaProducto> findByEstado(CategoriaProducto.EstadoCategoria estado);
    
    // Verificar si existe una categoría por nombre
    boolean existsByNombre(String nombre);
}