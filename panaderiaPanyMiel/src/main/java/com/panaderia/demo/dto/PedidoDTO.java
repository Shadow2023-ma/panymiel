package com.panaderia.demo.dto;

import com.panaderia.demo.model.Pedido;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PedidoDTO {
    private Integer idPedido;
    private ClienteSimpleDTO cliente;
    private LocalDateTime fechaPedido;
    private LocalDateTime fechaEntrega;
    private BigDecimal subtotal;
    private BigDecimal igv;
    private BigDecimal total;
    private String estado;
    private String tipoEntrega;
    private String direccionEntrega;
    private String observaciones;

    // Constructor desde Pedido
    public PedidoDTO(Pedido pedido) {
        this.idPedido = pedido.getIdPedido();
        this.cliente = new ClienteSimpleDTO(
            pedido.getCliente().getIdCliente(),
            pedido.getCliente().getNombres(),
            pedido.getCliente().getApellidos(),
            pedido.getCliente().getDni(),
            pedido.getCliente().getTelefono(),
            pedido.getCliente().getEmail()
        );
        this.fechaPedido = pedido.getFechaPedido();
        this.fechaEntrega = pedido.getFechaEntrega();
        this.subtotal = pedido.getSubtotal();
        this.total = pedido.getTotal();
        this.estado = pedido.getEstado().name();
        this.tipoEntrega = pedido.getTipoEntrega().name();
        this.direccionEntrega = pedido.getDireccionEntrega();
        this.observaciones = pedido.getObservaciones();
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ClienteSimpleDTO {
        private Integer idCliente;
        private String nombres;
        private String apellidos;
        private String dni;
        private String telefono;
        private String email;
    }
}