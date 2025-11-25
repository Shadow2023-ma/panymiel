package com.panaderia.demo.controller;

import com.panaderia.demo.model.Cliente;
import com.panaderia.demo.model.Producto;
import com.panaderia.demo.model.Venta;
import com.panaderia.demo.service.ClienteService;
import com.panaderia.demo.service.ProductoService;
import com.panaderia.demo.service.VentaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class MetricasController {

    @Autowired
    private VentaService ventaService;

    @Autowired
    private ClienteService clienteService;

    @Autowired
    private ProductoService productoService;

    // Endpoint para obtener todas las ventas
    @GetMapping("/ventas")
    public ResponseEntity<List<Venta>> obtenerVentas() {
        List<Venta> ventas = ventaService.listarTodas();
        return ResponseEntity.ok(ventas);
    }

    // Endpoint para obtener todos los clientes
    @GetMapping("/clientes")
    public ResponseEntity<List<Cliente>> obtenerClientes() {
        List<Cliente> clientes = clienteService.listarTodos();
        return ResponseEntity.ok(clientes);
    }

    // Endpoint para obtener todos los productos (para métricas)
    @GetMapping("/metricas/productos")
    public ResponseEntity<List<Producto>> obtenerProductos() {
        List<Producto> productos = productoService.listarTodos();
        return ResponseEntity.ok(productos);
    }
}