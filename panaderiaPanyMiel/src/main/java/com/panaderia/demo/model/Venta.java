package com.panaderia.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "VENTA")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Venta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_venta")
    private Integer idVenta;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_pedido", unique = true, nullable = false)
    private Pedido pedido;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = true)
    private Usuario usuario;

    @Column(name = "fecha_venta")
    private LocalDateTime fechaVenta;

    @Column(name = "monto_pagado", nullable = false, precision = 10, scale = 2)
    private BigDecimal montoPagado;

    @Enumerated(EnumType.STRING)
    @Column(name = "metodo_pago", nullable = false)
    private MetodoPago metodoPago = MetodoPago.EFECTIVO;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_comprobante")
    private TipoComprobante tipoComprobante = TipoComprobante.BOLETA;

    @Column(name = "numero_comprobante", length = 50)
    private String numeroComprobante;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado", nullable = false)
    private EstadoVenta estado = EstadoVenta.PAGADO;

    @PrePersist
    protected void onCreate() {
        this.fechaVenta = LocalDateTime.now();
        if (this.estado == null) {
            this.estado = EstadoVenta.PAGADO;
        }
        if (this.metodoPago == null) {
            this.metodoPago = MetodoPago.EFECTIVO;
        }
        if (this.tipoComprobante == null) {
            this.tipoComprobante = TipoComprobante.BOLETA;
        }
    }

    // Enum para método de pago
    public enum MetodoPago {
        EFECTIVO,
        TARJETA,
        YAPE,
        PLIN
    }

    // Enum para tipo de comprobante
    public enum TipoComprobante {
        BOLETA,
        FACTURA,
        NINGUNO
    }

    // Enum para estado de venta
    public enum EstadoVenta {
        PAGADO,
        PENDIENTE,
        ANULADO
    }
}