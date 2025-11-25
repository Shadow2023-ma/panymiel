package com.panaderia.demo.controller;

import com.panaderia.demo.dto.PedidoDTO;
import com.panaderia.demo.model.Pedido;
import com.panaderia.demo.service.PedidoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/gestion")
public class GestionController {

    @Autowired
    private PedidoService pedidoService;

    // ✅ Página principal de gestión
    @GetMapping
    public String gestionPage(Model model) {
        List<Pedido> pedidos = pedidoService.listarTodos();
        System.out.println("🔍 Total de pedidos: " + pedidos.size());
        model.addAttribute("pedidos", pedidos);
        return "gestion";
    }

    // 🔥 API: Listar todos los pedidos (JSON) - USANDO DTO
    @GetMapping("/pedidos")
    @ResponseBody
    public ResponseEntity<?> listarPedidos() {
        try {
            List<Pedido> pedidos = pedidoService.listarTodos();
            
            System.out.println("🔍 Total pedidos en BD: " + pedidos.size());
            
            // Convertir a DTO para evitar referencias circulares
            List<PedidoDTO> pedidosDTO = pedidos.stream()
                    .map(PedidoDTO::new)
                    .collect(Collectors.toList());
            
            System.out.println("✅ Pedidos convertidos a DTO: " + pedidosDTO.size());
            
            return ResponseEntity.ok(pedidosDTO);
            
        } catch (Exception e) {
            System.err.println("❌ Error al listar pedidos: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of(
                "error", "Error al cargar pedidos: " + e.getMessage()
            ));
        }
    }

    // API: Obtener detalle de un pedido
    @GetMapping("/pedidos/{idPedido}")
    @ResponseBody
    public ResponseEntity<?> obtenerDetallePedido(@PathVariable Integer idPedido) {
        try {
            Pedido pedido = pedidoService.buscarPorId(idPedido)
                    .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));

            // Crear respuesta sin referencias circulares
            Map<String, Object> response = new HashMap<>();
            
            // Datos del pedido
            PedidoDTO pedidoDTO = new PedidoDTO(pedido);
            response.put("pedido", pedidoDTO);
            
            // Detalles del pedido
            List<Map<String, Object>> detalles = pedido.getDetalles().stream()
                    .map(detalle -> {
                        Map<String, Object> detalleMap = new HashMap<>();
                        detalleMap.put("cantidad", detalle.getCantidad());
                        detalleMap.put("precioUnitario", detalle.getPrecioUnitario());
                        detalleMap.put("subtotal", detalle.getSubtotal());
                        
                        // Datos del producto
                        Map<String, Object> productoMap = new HashMap<>();
                        productoMap.put("idProducto", detalle.getProducto().getIdProducto());
                        productoMap.put("nombre", detalle.getProducto().getNombre());
                        productoMap.put("imagenUrl", detalle.getProducto().getImagenUrl());
                        
                        detalleMap.put("producto", productoMap);
                        return detalleMap;
                    })
                    .collect(Collectors.toList());
            
            response.put("detalles", detalles);

            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            System.err.println("❌ Error al obtener detalle: " + e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // API: Actualizar estado de un pedido
    @PostMapping("/pedidos/{idPedido}/estado")
    @ResponseBody
    public ResponseEntity<?> actualizarEstado(@PathVariable Integer idPedido,
                                                @RequestParam String estado,
                                                @RequestParam(required = false) String observaciones) {
        try {
            Pedido.EstadoPedido nuevoEstado = Pedido.EstadoPedido.valueOf(estado);
            pedidoService.cambiarEstado(idPedido, nuevoEstado, observaciones);

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "mensaje", "Estado actualizado correctamente"
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Estado inválido: " + estado));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // API: Confirmar pedido
    @PostMapping("/pedidos/{idPedido}/confirmar")
    @ResponseBody
    public ResponseEntity<?> confirmarPedido(@PathVariable Integer idPedido) {
        try {
            pedidoService.confirmarPedido(idPedido);
            return ResponseEntity.ok(Map.of("success", true, "mensaje", "Pedido confirmado"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/pedidos/{idPedido}/preparacion")
    @ResponseBody
    public ResponseEntity<?> marcarEnPreparacion(@PathVariable Integer idPedido) {
        try {
            pedidoService.marcarEnPreparacion(idPedido);
            return ResponseEntity.ok(Map.of("success", true, "mensaje", "Pedido en preparación"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/pedidos/{idPedido}/listo")
    @ResponseBody
    public ResponseEntity<?> marcarListoRecojo(@PathVariable Integer idPedido) {
        try {
            pedidoService.marcarListoRecojo(idPedido);
            return ResponseEntity.ok(Map.of("success", true, "mensaje", "Pedido listo para recojo"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/pedidos/{idPedido}/entregar")
    @ResponseBody
    public ResponseEntity<?> marcarEntregado(@PathVariable Integer idPedido) {
        try {
            pedidoService.marcarEntregado(idPedido);
            return ResponseEntity.ok(Map.of("success", true, "mensaje", "Pedido entregado"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/pedidos/{idPedido}/cancelar")
    @ResponseBody
    public ResponseEntity<?> cancelarPedido(@PathVariable Integer idPedido,
                                             @RequestParam String motivo) {
        try {
            pedidoService.cancelarPedido(idPedido, motivo);
            return ResponseEntity.ok(Map.of("success", true, "mensaje", "Pedido cancelado"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}