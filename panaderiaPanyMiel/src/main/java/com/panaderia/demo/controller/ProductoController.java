package com.panaderia.demo.controller;

import com.panaderia.demo.model.Producto;
import com.panaderia.demo.service.ProductoService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
public class ProductoController {

    @Autowired
    private ProductoService productoService;

    // Página de productos (con carrito)
    @GetMapping("/producto")
    public String productoPage(Model model, HttpSession session) {
        List<Producto> productos = productoService.listarDisponibles();
        model.addAttribute("productos", productos);
        
        // Verificar si hay usuario logueado
        Object cliente = session.getAttribute("clienteLogueado");
        String usuarioLogueado = (cliente != null) ? "true" : "false";
        
        // Enviar al JSP como STRING para que producto.js lo use
        model.addAttribute("usuarioLogueado", usuarioLogueado);
        
        return "producto";
    }

    // ❌ ELIMINADO: @GetMapping("/catalogo") - ya existe en MainController

    // API REST: Listar todos los productos (JSON)
    @GetMapping("/api/productos")
    @ResponseBody
    public List<Producto> listarProductos() {
        return productoService.listarDisponibles();
    }

    // API REST: Obtener producto por ID (JSON)
    @GetMapping("/api/productos/{id}")
    @ResponseBody
    public ResponseEntity<Producto> obtenerProducto(@PathVariable Integer id) {
        Optional<Producto> producto = productoService.buscarPorId(id);
        return producto.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // API REST: Buscar productos por nombre
    @GetMapping("/api/productos/buscar")
    @ResponseBody
    public List<Producto> buscarProductos(@RequestParam String nombre) {
        return productoService.buscarPorNombre(nombre);
    }

    // API REST: Filtrar productos por categoría
    @GetMapping("/api/productos/categoria/{idCategoria}")
    @ResponseBody
    public List<Producto> listarPorCategoria(@PathVariable Integer idCategoria) {
        return productoService.listarPorCategoria(idCategoria);
    }
}