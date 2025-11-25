-- ============================================
--  BASE DE DATOS PANADERÍA PAN Y MIEL
-- ============================================
USE panaderia;

-- ============================================
--  TABLA: CLIENTE
-- ============================================
CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(8) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    direccion TEXT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
);

-- ============================================
--  TABLA: CATEGORIA_PRODUCTO
-- ============================================
CREATE TABLE CATEGORIA_PRODUCTO (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
);

-- ============================================
--  TABLA: PRODUCTO
-- ============================================
CREATE TABLE PRODUCTO (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    imagen_url VARCHAR(255),
    estado ENUM('DISPONIBLE', 'AGOTADO', 'INACTIVO') DEFAULT 'DISPONIBLE',
    id_categoria INT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIA_PRODUCTO(id_categoria)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

-- ============================================
--  TABLA: PEDIDO
-- ============================================
CREATE TABLE PEDIDO (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_usuario INT,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega DATETIME,
    subtotal DECIMAL(10,2) DEFAULT 0.00,
    igv DECIMAL(10,2) DEFAULT 0.00,
    total DECIMAL(10,2) DEFAULT 0.00,
    estado ENUM('PENDIENTE', 'CONFIRMADO', 'EN_PREPARACION', 'LISTO_RECOJO', 'ENTREGADO', 'CANCELADO') DEFAULT 'PENDIENTE',
    tipo_entrega ENUM('RECOJO_TIENDA', 'DELIVERY') DEFAULT 'RECOJO_TIENDA',
    direccion_entrega TEXT,
    observaciones TEXT,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ============================================
--  TABLA: DETALLE_PEDIDO ( CON SET NULL)
-- ============================================
CREATE TABLE DETALLE_PEDIDO (
    id_detalle_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT,  --  Ahora puede ser NULL
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
        ON UPDATE CASCADE
        ON DELETE SET NULL  --  CAMBIADO A SET NULL
);

-- ============================================
--  TABLA: VENTA
-- ============================================
CREATE TABLE VENTA (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT UNIQUE NOT NULL,
    id_usuario INT,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    monto_pagado DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('EFECTIVO', 'TARJETA', 'YAPE', 'PLIN') DEFAULT 'EFECTIVO',
    tipo_comprobante ENUM('BOLETA', 'FACTURA', 'NINGUNO') DEFAULT 'BOLETA',
    numero_comprobante VARCHAR(50),
    estado ENUM('PAGADO', 'PENDIENTE', 'ANULADO') DEFAULT 'PAGADO',
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ============================================
--  TABLA: ESTADO_PEDIDO (Historial)
-- ============================================
CREATE TABLE ESTADO_PEDIDO (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    estado ENUM('PENDIENTE', 'CONFIRMADO', 'EN_PREPARACION', 'LISTO_RECOJO', 'ENTREGADO', 'CANCELADO') NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    observaciones TEXT,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);