-- ============================================
--  BASE DE DATOS PANADERÍA PAN Y MIEL
-- ============================================

-- Eliminar y recrear la base de datos
DROP DATABASE IF EXISTS panaderia;
CREATE DATABASE panaderia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
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
--  TABLA: DETALLE_PEDIDO (🔥 CON SET NULL)
-- ============================================
CREATE TABLE DETALLE_PEDIDO (
    id_detalle_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT,  -- 🔥 Ahora puede ser NULL
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
        ON UPDATE CASCADE
        ON DELETE SET NULL  -- 🔥 CAMBIADO A SET NULL
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



-- ============================================
--  INSERTAR CATEGORÍAS
-- ============================================
INSERT INTO CATEGORIA_PRODUCTO (nombre, descripcion, estado) VALUES
('Pan', 'Panes artesanales, frescos y elaborados diariamente.', 'ACTIVO'),
('Pastel', 'Tortas y postres elaborados con recetas tradicionales.', 'ACTIVO'),
('Bebidas', 'Bebidas frías y calientes para acompañar tus pedidos.', 'ACTIVO');

-- ============================================
--  INSERTAR PRODUCTOS 
-- ============================================
INSERT INTO PRODUCTO (nombre, descripcion, precio, stock, imagen_url, estado, id_categoria) VALUES
-- PANES (Categoría 1)
('Pan Francés', 'Pan crocante, ligero y recién horneado todas las mañanas.', 0.50, 200, 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400', 'DISPONIBLE', 1),
('Pan Integral', 'Pan saludable elaborado con harina integral 100% natural.', 1.20, 150, 'https://images.unsplash.com/photo-1585478259715-876acc5be8eb?w=400', 'DISPONIBLE', 1),
('Pan de Yema', 'Suave, dulce y tradicional, perfecto para desayunos.', 1.00, 180, 'https://images.unsplash.com/photo-1608198093002-ad4e005484ec?w=400', 'DISPONIBLE', 1),
('Ciabatta', 'Pan italiano con corteza crujiente y miga esponjosa.', 3.50, 80, 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73?w=400', 'DISPONIBLE', 1),
('Pan de Ajo', 'Pan aromático con mantequilla de ajo y hierbas.', 4.00, 60, 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73?w=400', 'DISPONIBLE', 1),

-- PASTELES (Categoría 2)
('Torta de Chocolate', 'Torta húmeda de chocolate con cobertura cremosa.', 25.00, 10, 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400', 'DISPONIBLE', 2),
('Torta Tres Leches', 'Postre tradicional empapado en tres variedades de leche.', 28.00, 8, 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400', 'DISPONIBLE', 2),
('Torta de Vainilla', 'Bizcocho suave con esencia natural de vainilla.', 22.00, 12, 'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=400', 'DISPONIBLE', 2),
('Cheesecake de Fresa', 'Suave cheesecake con salsa de fresas frescas.', 30.00, 6, 'https://images.unsplash.com/photo-1533134242820-b62d1a3a6f8c?w=400', 'DISPONIBLE', 2),
('Torta Red Velvet', 'Elegante torta de terciopelo rojo con crema de queso.', 32.00, 5, 'https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=400', 'DISPONIBLE', 2),

-- BEBIDAS (Categoría 3)
('Café Pasado', 'Café pasado al estilo tradicional, intenso y aromático.', 3.00, 100, 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=400', 'DISPONIBLE', 3),
('Jugo de Naranja', 'Jugo 100% natural recién exprimido.', 4.50, 80, 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400', 'DISPONIBLE', 3),
('Chocolate Caliente', 'Bebida caliente espesa, perfecta para días fríos.', 5.00, 60, 'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=400', 'DISPONIBLE', 3),
('Limonada Frozen', 'Refrescante limonada helada con hierbabuena.', 4.00, 70, 'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f9f?w=400', 'DISPONIBLE', 3);

-- ============================================
-- 👥 INSERTAR CLIENTES DE PRUEBA
-- ============================================
-- Contraseña para todos: "123456" (encriptada con BCrypt)
INSERT INTO CLIENTE (dni, nombres, apellidos, telefono, email, direccion, username, password, estado) VALUES
('12345678', 'Juan Carlos', 'García López', '987654321', 'juan.garcia@email.com', 'Av. Los Héroes 123, Huancayo', 'jgarcia', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhKu', 'ACTIVO'),
('87654321', 'María Elena', 'Rodríguez Pérez', '965432187', 'maria.rodriguez@email.com', 'Jr. Real 456, Huancayo', 'mrodriguez', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhKu', 'ACTIVO'),
('11223344', 'Pedro Antonio', 'Martínez Silva', '912345678', 'pedro.martinez@email.com', 'Av. Giráldez 789, Huancayo', 'pmartinez', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhKu', 'ACTIVO'),
('44332211', 'Ana Sofía', 'López Torres', '923456789', 'ana.lopez@email.com', 'Jr. Puno 321, Huancayo', 'alopez', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhKu', 'ACTIVO'),
('55667788', 'Carlos Miguel', 'Fernández Ruiz', '934567890', 'carlos.fernandez@email.com', 'Av. Ferrocarril 654, Huancayo', 'cfernandez', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhKu', 'ACTIVO');

-- ============================================
-- 🛒 INSERTAR PEDIDOS DE EJEMPLO
-- ============================================

-- Pedido 1: Juan García - ENTREGADO
INSERT INTO PEDIDO (id_cliente, fecha_pedido, fecha_entrega, subtotal, total, estado, tipo_entrega, direccion_entrega) 
VALUES (1, '2025-11-20 10:30:00', '2025-11-20 12:00:00', 29.50, 29.50, 'ENTREGADO', 'RECOJO_TIENDA', NULL);

INSERT INTO DETALLE_PEDIDO (id_pedido, id_producto, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 10, 0.50, 5.00),
(1, 6, 1, 25.00, 25.00);

INSERT INTO VENTA (id_pedido, fecha_venta, monto_pagado, metodo_pago, tipo_comprobante, estado) 
VALUES (1, '2025-11-20 12:00:00', 29.50, 'EFECTIVO', 'BOLETA', 'PAGADO');

-- Pedido 2: María Rodríguez - ENTREGADO
INSERT INTO PEDIDO (id_cliente, fecha_pedido, fecha_entrega, subtotal, total, estado, tipo_entrega, direccion_entrega, observaciones) 
VALUES (2, '2025-11-21 14:00:00', '2025-11-21 17:30:00', 56.50, 56.50, 'ENTREGADO', 'DELIVERY', 'Jr. Real 456, Huancayo', 'Entregar en la tarde');

INSERT INTO DETALLE_PEDIDO (id_pedido, id_producto, cantidad, precio_unitario, subtotal) VALUES
(2, 7, 1, 28.00, 28.00),
(2, 11, 2, 3.00, 6.00),
(2, 3, 15, 1.00, 15.00),
(2, 12, 1, 4.50, 4.50);

INSERT INTO VENTA (id_pedido, fecha_venta, monto_pagado, metodo_pago, tipo_comprobante, estado) 
VALUES (2, '2025-11-21 17:30:00', 56.50, 'YAPE', 'BOLETA', 'PAGADO');

-- Pedido 3: Pedro Martínez - LISTO PARA RECOJO
INSERT INTO PEDIDO (id_cliente, fecha_pedido, subtotal, total, estado, tipo_entrega) 
VALUES (3, '2025-11-24 09:15:00', 62.00, 62.00, 'LISTO_RECOJO', 'RECOJO_TIENDA');

INSERT INTO DETALLE_PEDIDO (id_pedido, id_producto, cantidad, precio_unitario, subtotal) VALUES
(3, 10, 1, 32.00, 32.00),
(3, 2, 20, 1.20, 24.00),
(3, 11, 2, 3.00, 6.00);

INSERT INTO VENTA (id_pedido, fecha_venta, monto_pagado, metodo_pago, tipo_comprobante, estado) 
VALUES (3, '2025-11-24 09:15:00', 62.00, 'TARJETA', 'BOLETA', 'PAGADO');

-- Pedido 4: Ana López - EN PREPARACIÓN
INSERT INTO PEDIDO (id_cliente, fecha_pedido, subtotal, total, estado, tipo_entrega) 
VALUES (4, '2025-11-25 11:00:00', 45.00, 45.00, 'EN_PREPARACION', 'RECOJO_TIENDA');

INSERT INTO DETALLE_PEDIDO (id_pedido, id_producto, cantidad, precio_unitario, subtotal) VALUES
(4, 6, 1, 25.00, 25.00),
(4, 8, 1, 22.00, 22.00);

INSERT INTO VENTA (id_pedido, fecha_venta, monto_pagado, metodo_pago, tipo_comprobante, estado) 
VALUES (4, '2025-11-25 11:00:00', 45.00, 'PLIN', 'BOLETA', 'PAGADO');

-- Pedido 5: Carlos Fernández - CONFIRMADO
INSERT INTO PEDIDO (id_cliente, fecha_pedido, subtotal, total, estado, tipo_entrega) 
VALUES (5, '2025-11-25 13:30:00', 72.50, 72.50, 'CONFIRMADO', 'RECOJO_TIENDA');

INSERT INTO DETALLE_PEDIDO (id_pedido, id_producto, cantidad, precio_unitario, subtotal) VALUES
(5, 9, 1, 30.00, 30.00),
(5, 10, 1, 32.00, 32.00),
(5, 13, 2, 5.00, 10.00);

INSERT INTO VENTA (id_pedido, fecha_venta, monto_pagado, metodo_pago, tipo_comprobante, estado) 
VALUES (5, '2025-11-25 13:30:00', 72.50, 'YAPE', 'BOLETA', 'PAGADO');

-- Pedido 6: Juan García - PENDIENTE
INSERT INTO PEDIDO (id_cliente, fecha_pedido, subtotal, total, estado, tipo_entrega, observaciones) 
VALUES (1, '2025-11-25 16:00:00', 38.00, 38.00, 'PENDIENTE', 'DELIVERY', 'Entregar antes de las 7pm');

INSERT INTO DETALLE_PEDIDO (id_pedido, id_producto, cantidad, precio_unitario, subtotal) VALUES
(6, 1, 20, 0.50, 10.00),
(6, 7, 1, 28.00, 28.00);

INSERT INTO VENTA (id_pedido, fecha_venta, monto_pagado, metodo_pago, tipo_comprobante, estado) 
VALUES (6, '2025-11-25 16:00:00', 38.00, 'EFECTIVO', 'BOLETA', 'PENDIENTE');

-- Pedido 7: María Rodríguez - ENTREGADO (antiguo)
INSERT INTO PEDIDO (id_cliente, fecha_pedido, fecha_entrega, subtotal, total, estado, tipo_entrega) 
VALUES (2, '2025-11-15 10:00:00', '2025-11-15 12:00:00', 85.00, 85.00, 'ENTREGADO', 'RECOJO_TIENDA');

INSERT INTO DETALLE_PEDIDO (id_pedido, id_producto, cantidad, precio_unitario, subtotal) VALUES
(7, 6, 2, 25.00, 50.00),
(7, 3, 30, 1.00, 30.00),
(7, 13, 1, 5.00, 5.00);

INSERT INTO VENTA (id_pedido, fecha_venta, monto_pagado, metodo_pago, tipo_comprobante, estado) 
VALUES (7, '2025-11-15 12:00:00', 85.00, 'TARJETA', 'BOLETA', 'PAGADO');

-- ============================================
-- 📊 INSERTAR HISTORIAL DE ESTADOS
-- ============================================
INSERT INTO ESTADO_PEDIDO (id_pedido, estado, fecha_cambio, observaciones) VALUES
-- Pedido 1
(1, 'PENDIENTE', '2025-11-20 10:30:00', 'Pedido creado'),
(1, 'CONFIRMADO', '2025-11-20 10:35:00', 'Pedido confirmado'),
(1, 'EN_PREPARACION', '2025-11-20 11:00:00', 'En preparación'),
(1, 'LISTO_RECOJO', '2025-11-20 11:45:00', 'Listo para recojo'),
(1, 'ENTREGADO', '2025-11-20 12:00:00', 'Entregado al cliente'),

-- Pedido 2
(2, 'PENDIENTE', '2025-11-21 14:00:00', 'Pedido creado'),
(2, 'CONFIRMADO', '2025-11-21 14:10:00', 'Pedido confirmado'),
(2, 'EN_PREPARACION', '2025-11-21 15:00:00', 'En preparación'),
(2, 'LISTO_RECOJO', '2025-11-21 16:30:00', 'Listo para delivery'),
(2, 'ENTREGADO', '2025-11-21 17:30:00', 'Entregado al cliente'),

-- Pedido 3
(3, 'PENDIENTE', '2025-11-24 09:15:00', 'Pedido creado'),
(3, 'CONFIRMADO', '2025-11-24 09:20:00', 'Pedido confirmado'),
(3, 'EN_PREPARACION', '2025-11-24 10:00:00', 'En preparación'),
(3, 'LISTO_RECOJO', '2025-11-24 11:00:00', 'Listo para recojo'),

-- Pedido 4
(4, 'PENDIENTE', '2025-11-25 11:00:00', 'Pedido creado'),
(4, 'CONFIRMADO', '2025-11-25 11:05:00', 'Pedido confirmado'),
(4, 'EN_PREPARACION', '2025-11-25 12:00:00', 'En preparación'),

-- Pedido 5
(5, 'PENDIENTE', '2025-11-25 13:30:00', 'Pedido creado'),
(5, 'CONFIRMADO', '2025-11-25 13:35:00', 'Pedido confirmado'),

-- Pedido 6
(6, 'PENDIENTE', '2025-11-25 16:00:00', 'Pedido creado'),

-- Pedido 7
(7, 'PENDIENTE', '2025-11-15 10:00:00', 'Pedido creado'),
(7, 'CONFIRMADO', '2025-11-15 10:05:00', 'Pedido confirmado'),
(7, 'EN_PREPARACION', '2025-11-15 11:00:00', 'En preparación'),
(7, 'LISTO_RECOJO', '2025-11-15 11:45:00', 'Listo para recojo'),
(7, 'ENTREGADO', '2025-11-15 12:00:00', 'Entregado al cliente');

