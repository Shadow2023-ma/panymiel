package com.panaderia.demo.service;

import com.panaderia.demo.model.CategoriaProducto;
import com.panaderia.demo.repository.CategoriaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CategoriaService {

    @Autowired
    private CategoriaRepository categoriaRepository;

    // Crear categoría
    public CategoriaProducto crear(CategoriaProducto categoria) {
        if (categoriaRepository.existsByNombre(categoria.getNombre())) {
            throw new RuntimeException("La categoría ya existe");
        }
        
        categoria.setEstado(CategoriaProducto.EstadoCategoria.ACTIVO);
        return categoriaRepository.save(categoria);
    }

    // Buscar categoría por ID
    public Optional<CategoriaProducto> buscarPorId(Integer id) {
        return categoriaRepository.findById(id);
    }

    // Buscar categoría por nombre
    public Optional<CategoriaProducto> buscarPorNombre(String nombre) {
        return categoriaRepository.findByNombre(nombre);
    }

    // Listar todas las categorías
    public List<CategoriaProducto> listarTodas() {
        return categoriaRepository.findAll();
    }

    // Listar categorías activas
    public List<CategoriaProducto> listarActivas() {
        return categoriaRepository.findByEstado(CategoriaProducto.EstadoCategoria.ACTIVO);
    }

    // Actualizar categoría
    public CategoriaProducto actualizar(CategoriaProducto categoria) {
        if (!categoriaRepository.existsById(categoria.getIdCategoria())) {
            throw new RuntimeException("Categoría no encontrada");
        }
        return categoriaRepository.save(categoria);
    }

    // Desactivar categoría
    public void desactivar(Integer idCategoria) {
        CategoriaProducto categoria = categoriaRepository.findById(idCategoria)
                .orElseThrow(() -> new RuntimeException("Categoría no encontrada"));
        
        categoria.setEstado(CategoriaProducto.EstadoCategoria.INACTIVO);
        categoriaRepository.save(categoria);
    }

    // Activar categoría
    public void activar(Integer idCategoria) {
        CategoriaProducto categoria = categoriaRepository.findById(idCategoria)
                .orElseThrow(() -> new RuntimeException("Categoría no encontrada"));
        
        categoria.setEstado(CategoriaProducto.EstadoCategoria.ACTIVO);
        categoriaRepository.save(categoria);
    }

    // Eliminar categoría
    public void eliminar(Integer idCategoria) {
        if (!categoriaRepository.existsById(idCategoria)) {
            throw new RuntimeException("Categoría no encontrada");
        }
        categoriaRepository.deleteById(idCategoria);
    }

    // Verificar si existe por nombre
    public boolean existePorNombre(String nombre) {
        return categoriaRepository.existsByNombre(nombre);
    }
}