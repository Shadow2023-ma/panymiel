package com.panaderia.demo.service;

import com.panaderia.demo.model.Producto;
import com.panaderia.demo.model.CategoriaProducto;
import com.panaderia.demo.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class ProductoService {

    @Autowired
    private ProductoRepository productoRepository;

    // Directorio para guardar imágenes
    private final String UPLOAD_DIR = "src/main/resources/static/img/productos/";

    // Crear producto
    public Producto crear(Producto producto) {
        producto.setEstado(Producto.EstadoProducto.DISPONIBLE);
        return productoRepository.save(producto);
    }

    // Crear producto con imagen
    public Producto crearConImagen(Producto producto, MultipartFile imagen) throws IOException {
        // Guardar imagen y obtener la URL
        String imagenUrl = guardarImagen(imagen);
        producto.setImagenUrl(imagenUrl);
        producto.setEstado(Producto.EstadoProducto.DISPONIBLE);
        
        return productoRepository.save(producto);
    }

    // Buscar producto por ID
    public Optional<Producto> buscarPorId(Integer id) {
        return productoRepository.findById(id);
    }

    // Listar todos los productos
    public List<Producto> listarTodos() {
        return productoRepository.findAll();
    }

    // Listar productos disponibles
    public List<Producto> listarDisponibles() {
        return productoRepository.findProductosDisponibles();
    }

    // Listar productos por categoría
    public List<Producto> listarPorCategoria(Integer idCategoria) {
        return productoRepository.findByCategoriaIdCategoria(idCategoria);
    }

    // Buscar productos por nombre
    public List<Producto> buscarPorNombre(String nombre) {
        return productoRepository.findByNombreContainingIgnoreCase(nombre);
    }

    // Listar productos con stock bajo
    public List<Producto> listarConStockBajo(Integer stockMinimo) {
        return productoRepository.findProductosConStockBajo(stockMinimo);
    }

    // Actualizar producto
    public Producto actualizar(Producto producto) {
        if (!productoRepository.existsById(producto.getIdProducto())) {
            throw new RuntimeException("Producto no encontrado");
        }
        return productoRepository.save(producto);
    }

    // Actualizar producto con imagen
    public Producto actualizarConImagen(Producto producto, MultipartFile imagen) throws IOException {
        if (!productoRepository.existsById(producto.getIdProducto())) {
            throw new RuntimeException("Producto no encontrado");
        }

        // Si hay nueva imagen, guardarla
        if (imagen != null && !imagen.isEmpty()) {
            String imagenUrl = guardarImagen(imagen);
            producto.setImagenUrl(imagenUrl);
        }

        return productoRepository.save(producto);
    }

    // Actualizar stock
    public void actualizarStock(Integer idProducto, Integer cantidad) {
        Producto producto = productoRepository.findById(idProducto)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));
        
        producto.setStock(cantidad);
        
        // Actualizar estado según stock
        if (cantidad <= 0) {
            producto.setEstado(Producto.EstadoProducto.AGOTADO);
        } else {
            producto.setEstado(Producto.EstadoProducto.DISPONIBLE);
        }
        
        productoRepository.save(producto);
    }

    // Reducir stock (al hacer una venta)
    public void reducirStock(Integer idProducto, Integer cantidad) {
        Producto producto = productoRepository.findById(idProducto)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));
        
        if (producto.getStock() < cantidad) {
            throw new RuntimeException("Stock insuficiente para el producto: " + producto.getNombre());
        }
        
        producto.setStock(producto.getStock() - cantidad);
        
        // Actualizar estado si queda sin stock
        if (producto.getStock() <= 0) {
            producto.setEstado(Producto.EstadoProducto.AGOTADO);
        }
        
        productoRepository.save(producto);
    }

    // Aumentar stock
    public void aumentarStock(Integer idProducto, Integer cantidad) {
        Producto producto = productoRepository.findById(idProducto)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));
        
        producto.setStock(producto.getStock() + cantidad);
        
        // Si estaba agotado, volver a disponible
        if (producto.getEstado() == Producto.EstadoProducto.AGOTADO) {
            producto.setEstado(Producto.EstadoProducto.DISPONIBLE);
        }
        
        productoRepository.save(producto);
    }

    // Cambiar estado
    public void cambiarEstado(Integer idProducto, Producto.EstadoProducto nuevoEstado) {
        Producto producto = productoRepository.findById(idProducto)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));
        
        producto.setEstado(nuevoEstado);
        productoRepository.save(producto);
    }

    // Eliminar producto
    public void eliminar(Integer idProducto) {
        if (!productoRepository.existsById(idProducto)) {
            throw new RuntimeException("Producto no encontrado");
        }
        productoRepository.deleteById(idProducto);
    }

    // Guardar imagen en el servidor
    private String guardarImagen(MultipartFile imagen) throws IOException {
        if (imagen.isEmpty()) {
            throw new RuntimeException("La imagen está vacía");
        }

        // Crear directorio si no existe
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Generar nombre único para la imagen
        String nombreOriginal = imagen.getOriginalFilename();
        String extension = nombreOriginal.substring(nombreOriginal.lastIndexOf("."));
        String nombreUnico = UUID.randomUUID().toString() + extension;

        // Guardar archivo
        Path destino = uploadPath.resolve(nombreUnico);
        Files.copy(imagen.getInputStream(), destino, StandardCopyOption.REPLACE_EXISTING);

        // Retornar la URL relativa
        return "/img/productos/" + nombreUnico;
    }
}