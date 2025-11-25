package com.panaderia.demo.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CrearPedidoRequest {
    
    // ❌ ELIMINADO: No necesitamos idCliente, se obtiene de la sesión
    // @NotNull(message = "El ID del cliente es obligatorio")
    // private Integer idCliente;
    
    @NotEmpty(message = "El pedido debe tener al menos un producto")
    private List<ItemPedido> items;
    
    @NotNull(message = "El tipo de entrega es obligatorio")
    private String tipoEntrega; // "RECOJO_TIENDA" o "DELIVERY"
    
    private String direccionEntrega;
    
    private String observaciones;
    
    @NotNull(message = "El método de pago es obligatorio")
    private String metodoPago; // "EFECTIVO", "TARJETA", "YAPE", "PLIN"
    
    private String tipoComprobante; // "BOLETA", "FACTURA", "NINGUNO"
    
    private String numeroComprobante;
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ItemPedido {
        @NotNull(message = "El ID del producto es obligatorio")
        private Integer idProducto;
        
        @NotNull(message = "La cantidad es obligatoria")
        private Integer cantidad;
    }
}