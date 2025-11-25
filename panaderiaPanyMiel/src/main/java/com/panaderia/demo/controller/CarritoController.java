package com.panaderia.demo.controller;

import com.panaderia.demo.model.Producto;
import com.panaderia.demo.service.ProductoService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/carrito")
public class CarritoController {

    @Autowired
    private ProductoService productoService;

    // Clase interna para representar un item del carrito
    public static class ItemCarrito {
        private Integer idProducto;
        private String nombre;
        private BigDecimal precio;
        private Integer cantidad;
        private String imagen;

        public ItemCarrito() {}

        public ItemCarrito(Integer idProducto, String nombre, BigDecimal precio, Integer cantidad, String imagen) {
            this.idProducto = idProducto;
            this.nombre = nombre;
            this.precio = precio;
            this.cantidad = cantidad;
            this.imagen = imagen;
        }

        // Getters y Setters
        public Integer getIdProducto() { return idProducto; }
        public void setIdProducto(Integer idProducto) { this.idProducto = idProducto; }
        
        public String getNombre() { return nombre; }
        public void setNombre(String nombre) { this.nombre = nombre; }
        
        public BigDecimal getPrecio() { return precio; }
        public void setPrecio(BigDecimal precio) { this.precio = precio; }
        
        public Integer getCantidad() { return cantidad; }
        public void setCantidad(Integer cantidad) { this.cantidad = cantidad; }
        
        public String getImagen() { return imagen; }
        public void setImagen(String imagen) { this.imagen = imagen; }

        public BigDecimal getSubtotal() {
            return precio.multiply(BigDecimal.valueOf(cantidad));
        }
    }

    // Obtener el carrito de la sesión
    @SuppressWarnings("unchecked")
    private List<ItemCarrito> obtenerCarrito(HttpSession session) {
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carrito", carrito);
        }
        return carrito;
    }

    // GET: Obtener items del carrito
    @GetMapping
    public ResponseEntity<?> obtenerItems(HttpSession session) {
        List<ItemCarrito> carrito = obtenerCarrito(session);
        
        BigDecimal subtotal = BigDecimal.ZERO;
        for (ItemCarrito item : carrito) {
            subtotal = subtotal.add(item.getSubtotal());
        }
        
        BigDecimal igv = subtotal.multiply(new BigDecimal("0.18"));
        BigDecimal total = subtotal.add(igv);
        
        Map<String, Object> response = new HashMap<>();
        response.put("items", carrito);
        response.put("subtotal", subtotal);
        response.put("igv", igv);
        response.put("total", total);
        response.put("cantidad", carrito.size());
        
        return ResponseEntity.ok(response);
    }

    // POST: Agregar producto al carrito
    @PostMapping("/agregar")
    public ResponseEntity<?> agregarProducto(@RequestBody Map<String, Object> body, HttpSession session) {
        try {
            Integer idProducto = Integer.parseInt(body.get("idProducto").toString());
            Integer cantidad = body.get("cantidad") != null 
                ? Integer.parseInt(body.get("cantidad").toString()) 
                : 1;

            Producto producto = productoService.buscarPorId(idProducto)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));

            List<ItemCarrito> carrito = obtenerCarrito(session);

            // Buscar si el producto ya existe en el carrito
            ItemCarrito itemExistente = null;
            for (ItemCarrito item : carrito) {
                if (item.getIdProducto().equals(idProducto)) {
                    itemExistente = item;
                    break;
                }
            }

            if (itemExistente != null) {
                // Si existe, aumentar cantidad
                itemExistente.setCantidad(itemExistente.getCantidad() + cantidad);
            } else {
                // Si no existe, agregar nuevo
                ItemCarrito nuevoItem = new ItemCarrito(
                    producto.getIdProducto(),
                    producto.getNombre(),
                    producto.getPrecio(),
                    cantidad,
                    producto.getImagenUrl()
                );
                carrito.add(nuevoItem);
            }

            session.setAttribute("carrito", carrito);

            return ResponseEntity.ok(Map.of(
                "success", true,
                "mensaje", "Producto agregado al carrito",
                "cantidad", carrito.size()
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "error", e.getMessage()
            ));
        }
    }

    // DELETE: Eliminar producto del carrito
    @DeleteMapping("/eliminar/{idProducto}")
    public ResponseEntity<?> eliminarProducto(@PathVariable Integer idProducto, HttpSession session) {
        List<ItemCarrito> carrito = obtenerCarrito(session);
        carrito.removeIf(item -> item.getIdProducto().equals(idProducto));
        session.setAttribute("carrito", carrito);

        return ResponseEntity.ok(Map.of(
            "success", true,
            "mensaje", "Producto eliminado del carrito"
        ));
    }

    // PUT: Actualizar cantidad de un producto
    @PutMapping("/actualizar/{idProducto}")
    public ResponseEntity<?> actualizarCantidad(@PathVariable Integer idProducto, 
                                                  @RequestBody Map<String, Integer> body,
                                                  HttpSession session) {
        Integer nuevaCantidad = body.get("cantidad");
        
        if (nuevaCantidad == null || nuevaCantidad < 1) {
            return ResponseEntity.badRequest().body(Map.of("error", "Cantidad inválida"));
        }

        List<ItemCarrito> carrito = obtenerCarrito(session);
        
        for (ItemCarrito item : carrito) {
            if (item.getIdProducto().equals(idProducto)) {
                item.setCantidad(nuevaCantidad);
                session.setAttribute("carrito", carrito);
                return ResponseEntity.ok(Map.of(
                    "success", true,
                    "mensaje", "Cantidad actualizada"
                ));
            }
        }

        return ResponseEntity.badRequest().body(Map.of("error", "Producto no encontrado en el carrito"));
    }

    // DELETE: Vaciar carrito
    @DeleteMapping("/vaciar")
    public ResponseEntity<?> vaciarCarrito(HttpSession session) {
        session.setAttribute("carrito", new ArrayList<>());
        return ResponseEntity.ok(Map.of(
            "success", true,
            "mensaje", "Carrito vaciado"
        ));
    }
}