package com.panaderia.demo.controller;

import com.panaderia.demo.dto.ProductoRequest;
import com.panaderia.demo.model.CategoriaProducto;
import com.panaderia.demo.model.Producto;
import com.panaderia.demo.service.CategoriaService;
import com.panaderia.demo.service.ProductoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ProductoService productoService;

    @Autowired
    private CategoriaService categoriaService;

    // Página de gestión de productos
    @GetMapping("/productos")
    public String gestionProductos(Model model) {
        List<Producto> productos = productoService.listarTodos();
        List<CategoriaProducto> categorias = categoriaService.listarActivas();
        
        model.addAttribute("productos", productos);
        model.addAttribute("categorias", categorias);
        
        return "modificar";
    }

    // Crear producto
    @PostMapping("/productos/crear")
    public String crearProducto(@Valid @ModelAttribute ProductoRequest request,
                                 @RequestParam("imagen") MultipartFile imagen,
                                 RedirectAttributes redirectAttributes) {
        try {
            // Buscar categoría
            CategoriaProducto categoria = categoriaService.buscarPorId(request.getIdCategoria())
                    .orElseThrow(() -> new RuntimeException("Categoría no encontrada"));

            // Crear producto
            Producto producto = new Producto();
            producto.setNombre(request.getNombre());
            producto.setDescripcion(request.getDescripcion());
            producto.setPrecio(request.getPrecio());
            producto.setStock(request.getStock());
            producto.setCategoria(categoria);

            // Establecer estado
            if (request.getEstado() != null && !request.getEstado().isEmpty()) {
                producto.setEstado(Producto.EstadoProducto.valueOf(request.getEstado()));
            } else {
                producto.setEstado(Producto.EstadoProducto.DISPONIBLE);
            }

            // Guardar con imagen
            if (imagen != null && !imagen.isEmpty()) {
                productoService.crearConImagen(producto, imagen);
            } else {
                productoService.crear(producto);
            }

            redirectAttributes.addFlashAttribute("mensaje", "Producto creado exitosamente");
            return "redirect:/admin/productos";

        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Error al guardar la imagen: " + e.getMessage());
            return "redirect:/admin/productos";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin/productos";
        }
    }

    // Obtener producto por ID (JSON para el formulario de modificar)
    @GetMapping("/productos/{id}")
    @ResponseBody
    public ResponseEntity<Producto> obtenerProducto(@PathVariable Integer id) {
        Optional<Producto> producto = productoService.buscarPorId(id);
        return producto.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Modificar producto
    @PostMapping("/productos/modificar")
    public String modificarProducto(@RequestParam("idProducto") Integer idProducto,
                                     @Valid @ModelAttribute ProductoRequest request,
                                     @RequestParam(value = "imagen", required = false) MultipartFile imagen,
                                     RedirectAttributes redirectAttributes) {
        try {
            // Buscar producto existente
            Producto producto = productoService.buscarPorId(idProducto)
                    .orElseThrow(() -> new RuntimeException("Producto no encontrado"));

            // Buscar categoría
            CategoriaProducto categoria = categoriaService.buscarPorId(request.getIdCategoria())
                    .orElseThrow(() -> new RuntimeException("Categoría no encontrada"));

            // Actualizar datos
            producto.setNombre(request.getNombre());
            producto.setDescripcion(request.getDescripcion());
            producto.setPrecio(request.getPrecio());
            producto.setStock(request.getStock());
            producto.setCategoria(categoria);

            if (request.getEstado() != null && !request.getEstado().isEmpty()) {
                producto.setEstado(Producto.EstadoProducto.valueOf(request.getEstado()));
            }

            // Actualizar con o sin imagen
            if (imagen != null && !imagen.isEmpty()) {
                productoService.actualizarConImagen(producto, imagen);
            } else {
                productoService.actualizar(producto);
            }

            redirectAttributes.addFlashAttribute("mensaje", "Producto actualizado exitosamente");
            return "redirect:/admin/productos";

        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Error al guardar la imagen: " + e.getMessage());
            return "redirect:/admin/productos";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin/productos";
        }
    }

    // Eliminar producto
    @DeleteMapping("/productos/eliminar/{id}")
    @ResponseBody
    public ResponseEntity<String> eliminarProducto(@PathVariable Integer id) {
        try {
            productoService.eliminar(id);
            return ResponseEntity.ok("Producto eliminado correctamente");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Actualizar stock
    @PostMapping("/productos/{id}/stock")
    @ResponseBody
    public ResponseEntity<String> actualizarStock(@PathVariable Integer id, 
                                                    @RequestParam Integer cantidad) {
        try {
            productoService.actualizarStock(id, cantidad);
            return ResponseEntity.ok("Stock actualizado correctamente");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}