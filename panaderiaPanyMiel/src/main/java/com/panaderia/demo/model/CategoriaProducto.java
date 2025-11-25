package com.panaderia.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "CATEGORIA_PRODUCTO")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CategoriaProducto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_categoria")
    private Integer idCategoria;

    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;

    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado", nullable = false)
    private EstadoCategoria estado = EstadoCategoria.ACTIVO;

    @PrePersist
    protected void onCreate() {
        if (this.estado == null) {
            this.estado = EstadoCategoria.ACTIVO;
        }
    }

    // Enum para el estado
    public enum EstadoCategoria {
        ACTIVO,
        INACTIVO
    }
}