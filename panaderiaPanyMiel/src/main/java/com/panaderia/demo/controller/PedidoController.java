package com.panaderia.demo.controller;

import com.panaderia.demo.dto.CrearPedidoRequest;
import com.panaderia.demo.model.*;
import com.panaderia.demo.service.ClienteService;
import com.panaderia.demo.service.PedidoService;
import com.panaderia.demo.service.ProductoService;
import com.panaderia.demo.service.VentaService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/pedidos")
public class PedidoController {

    @Autowired
    private PedidoService pedidoService;

    @Autowired
    private VentaService ventaService;

    @Autowired
    private ProductoService productoService;

    @Autowired
    private ClienteService clienteService;

    // Crear pedido (desde resumencompra.jsp)
    @PostMapping("/crear")
    @ResponseBody
    public ResponseEntity<?> crearPedido(@Valid @RequestBody CrearPedidoRequest request,
                                          HttpSession session) {
        try {
            // 🔥 CORRECCIÓN: Verificar que el cliente esté logueado
            Integer idCliente = (Integer) session.getAttribute("idCliente");
            
            System.out.println("🔍 DEBUG - ID Cliente en sesión: " + idCliente);
            
            if (idCliente == null) {
                return ResponseEntity.status(401).body(Map.of(
                    "success", false,
                    "error", "Debes iniciar sesión para realizar un pedido"
                ));
            }

            // 🔥 CORRECCIÓN: Verificar que el cliente existe en la base de datos
            Cliente cliente = clienteService.buscarPorId(idCliente)
                .orElseThrow(() -> new RuntimeException("Cliente no encontrado en la base de datos"));

            System.out.println("✅ Cliente encontrado: " + cliente.getNombres() + " " + cliente.getApellidos());

            // Crear lista de detalles del pedido
            List<DetallePedido> detalles = new ArrayList<>();
            
            for (CrearPedidoRequest.ItemPedido item : request.getItems()) {
                Producto producto = productoService.buscarPorId(item.getIdProducto())
                        .orElseThrow(() -> new RuntimeException("Producto no encontrado: " + item.getIdProducto()));

                System.out.println("📦 Producto: " + producto.getNombre() + " - Cantidad: " + item.getCantidad());

                DetallePedido detalle = new DetallePedido();
                detalle.setProducto(producto);
                detalle.setCantidad(item.getCantidad());
                detalle.setPrecioUnitario(producto.getPrecio());
                detalle.calcularSubtotal();

                detalles.add(detalle);
            }

            // Crear pedido
            Pedido.TipoEntrega tipoEntrega = Pedido.TipoEntrega.valueOf(request.getTipoEntrega());
            
            System.out.println("🛒 Creando pedido para cliente ID: " + idCliente);
            
            Pedido pedido = pedidoService.crearPedido(
                idCliente,
                detalles,
                tipoEntrega,
                request.getDireccionEntrega(),
                request.getObservaciones()
            );

            System.out.println("✅ Pedido creado con ID: " + pedido.getIdPedido());

            // Registrar venta
            Venta.MetodoPago metodoPago = Venta.MetodoPago.valueOf(request.getMetodoPago());
            Venta.TipoComprobante tipoComprobante = request.getTipoComprobante() != null 
                ? Venta.TipoComprobante.valueOf(request.getTipoComprobante())
                : Venta.TipoComprobante.BOLETA;

            Venta venta = ventaService.registrarVenta(
                pedido.getIdPedido(),
                metodoPago,
                tipoComprobante,
                request.getNumeroComprobante()
            );

            System.out.println("✅ Venta registrada con ID: " + venta.getIdVenta());

            // Respuesta exitosa
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("mensaje", "¡Pedido realizado exitosamente!");
            response.put("idPedido", pedido.getIdPedido());
            response.put("idVenta", venta.getIdVenta());
            response.put("total", pedido.getTotal());

            return ResponseEntity.ok(response);

        } catch (RuntimeException e) {
            System.err.println("❌ Error al crear pedido: " + e.getMessage());
            e.printStackTrace();
            
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "error", e.getMessage()
            ));
        } catch (Exception e) {
            System.err.println("❌ Error inesperado: " + e.getMessage());
            e.printStackTrace();
            
            return ResponseEntity.status(500).body(Map.of(
                "success", false,
                "error", "Error interno del servidor: " + e.getMessage()
            ));
        }
    }

    // Listar mis pedidos
    @GetMapping("/mis-pedidos")
    @ResponseBody
    public ResponseEntity<?> misPedidos(HttpSession session) {
        Integer idCliente = (Integer) session.getAttribute("idCliente");
        
        if (idCliente == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Debes iniciar sesión"));
        }

        List<Pedido> pedidos = pedidoService.listarPorCliente(idCliente);
        return ResponseEntity.ok(pedidos);
    }

    // Obtener detalle de un pedido
    @GetMapping("/{idPedido}")
    @ResponseBody
    public ResponseEntity<?> obtenerPedido(@PathVariable Integer idPedido, HttpSession session) {
        Integer idCliente = (Integer) session.getAttribute("idCliente");
        
        if (idCliente == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Debes iniciar sesión"));
        }

        Pedido pedido = pedidoService.buscarPorId(idPedido)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));

        // Verificar que el pedido pertenezca al cliente
        if (!pedido.getCliente().getIdCliente().equals(idCliente)) {
            return ResponseEntity.status(403).body(Map.of("error", "No tienes permiso para ver este pedido"));
        }

        return ResponseEntity.ok(pedido);
    }

    // Cancelar pedido
    @PostMapping("/{idPedido}/cancelar")
    @ResponseBody
    public ResponseEntity<?> cancelarPedido(@PathVariable Integer idPedido, 
                                             @RequestParam String motivo,
                                             HttpSession session) {
        try {
            Integer idCliente = (Integer) session.getAttribute("idCliente");
            
            if (idCliente == null) {
                return ResponseEntity.status(401).body(Map.of("error", "Debes iniciar sesión"));
            }

            Pedido pedido = pedidoService.buscarPorId(idPedido)
                    .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));

            // Verificar que el pedido pertenezca al cliente
            if (!pedido.getCliente().getIdCliente().equals(idCliente)) {
                return ResponseEntity.status(403).body(Map.of("error", "No tienes permiso para cancelar este pedido"));
            }

            pedidoService.cancelarPedido(idPedido, motivo);

            return ResponseEntity.ok(Map.of("success", true, "mensaje", "Pedido cancelado exitosamente"));

        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}