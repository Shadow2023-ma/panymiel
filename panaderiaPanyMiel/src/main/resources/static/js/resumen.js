document.addEventListener("DOMContentLoaded", async () => {

    const listaResumen = document.getElementById("lista-resumen");
    const totalResumen = document.getElementById("total-resumen");
    const subtotalResumen = document.getElementById("subtotal-resumen");
    // const igvResumen = document.getElementById("igv-resumen"); // 🔥 Ya no lo necesitamos

    // 🔥 Cargar carrito desde el servidor
    try {
        const response = await fetch('/api/carrito');
        const data = await response.json();

        if (!data.items || data.items.length === 0) {
            listaResumen.innerHTML = '<tr><td colspan="4" style="text-align:center; padding:20px;">Tu carrito está vacío</td></tr>';
            return;
        }

        // Renderizar items
        data.items.forEach(item => {
            const fila = document.createElement("tr");
            const subtotalItem = item.precio * item.cantidad;

            fila.innerHTML = `
                <td><img src="${item.imagen}" class="img-resumen" style="width:60px; border-radius:10px;"></td>
                <td>${item.nombre}</td>
                <td>${item.cantidad}</td>
                <td>S/ ${subtotalItem.toFixed(2)}</td>
            `;

            listaResumen.appendChild(fila);
        });

        
        if (subtotalResumen) subtotalResumen.textContent = `S/ ${data.subtotal.toFixed(2)}`;
        // if (igvResumen) igvResumen.textContent = `S/ ${data.igv.toFixed(2)}`; // 🔥 ELIMINADO
        totalResumen.textContent = `S/ ${data.subtotal.toFixed(2)}`; // 🔥 Total = Subtotal

    } catch (error) {
        console.error('Error al cargar el carrito:', error);
        alert('Error al cargar tu carrito. Por favor, recarga la página.');
    }
    /* ===========================
                MODAL
    ============================ */

    const modal = document.getElementById("modalCompra");
    const btnComprar = document.getElementById("btnComprar");
    const formCompra = document.getElementById("formCompra");

    window.cerrarModalCompra = function () {
        modal.style.display = "none";
    };

    if (btnComprar) {
        btnComprar.addEventListener("click", async () => {
            // Verificar que haya items en el carrito
            const carritoResponse = await fetch('/api/carrito');
            const carritoData = await carritoResponse.json();

            if (!carritoData.items || carritoData.items.length === 0) {
                alert("Tu carrito está vacío");
                return;
            }

            modal.style.display = "block";
        });
    }

    document.querySelector(".close")?.addEventListener("click", cerrarModalCompra);

    window.addEventListener("click", (e) => {
        if (e.target === modal) cerrarModalCompra();
    });

    /* ===========================
          FORMULARIO COMPRA
    ============================ */

    if (formCompra) {
        formCompra.addEventListener("submit", async (e) => {
            e.preventDefault();

            // Obtener valores del formulario
            const direccion = document.getElementById("direccion").value.trim();
            const metodoEntrega = document.getElementById("metodoEntrega").value;
            const metodoPago = document.getElementById("metodoPago").value;
            const tipoComprobante = document.getElementById("tipoComprobante")?.value || "BOLETA";
            const numeroComprobante = document.getElementById("comprobante").value.trim();
            const observaciones = document.getElementById("observaciones")?.value.trim() || "";

            // Validaciones
            if (!metodoEntrega) {
                alert("Por favor selecciona un método de entrega");
                return;
            }

            if (!metodoPago) {
                alert("Por favor selecciona un método de pago");
                return;
            }

            if (metodoEntrega === "DELIVERY" && !direccion) {
                alert("Por favor ingresa una dirección para el delivery");
                return;
            }

            // 🔥 Obtener items del carrito desde el servidor
            const carritoResponse = await fetch('/api/carrito');
            const carritoData = await carritoResponse.json();

            if (!carritoData.items || carritoData.items.length === 0) {
                alert("Tu carrito está vacío");
                return;
            }

            // Preparar items del pedido
            const items = carritoData.items.map(item => ({
                idProducto: item.idProducto,
                cantidad: item.cantidad
            }));

            // Crear objeto de pedido
            const pedidoData = {
                items: items,
                tipoEntrega: metodoEntrega,
                direccionEntrega: metodoEntrega === "DELIVERY" ? direccion : null,
                metodoPago: metodoPago,
                tipoComprobante: tipoComprobante,
                numeroComprobante: numeroComprobante || null,
                observaciones: observaciones
            };

            console.log("📦 Datos enviados al backend:", pedidoData);

            // Deshabilitar botón mientras se procesa
            const btnSubmit = formCompra.querySelector('button[type="submit"]');
            btnSubmit.disabled = true;
            btnSubmit.textContent = "Procesando...";

            try {
                // Enviar pedido al backend
                const response = await fetch('/pedidos/crear', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(pedidoData)
                });

                const data = await response.json();

                if (response.ok && data.success) {
                    // Éxito
                    alert(`¡Compra realizada con éxito!\n\nNúmero de pedido: ${data.idPedido}\nTotal: S/ ${data.total.toFixed(2)}\n\n¡Gracias por tu compra!`);
                    
                    // 🔥 Vaciar carrito en el servidor
                    await fetch('/api/carrito/vaciar', { method: 'DELETE' });
                    
                    // Cerrar modal
                    cerrarModalCompra();
                    
                    // Redirigir a página de confirmación o inicio
                    setTimeout(() => {
                        window.location.href = "/index";
                    }, 1000);

                } else {
                    // Error en la respuesta
                    console.error("❌ Error del servidor:", data);
                    alert("Error al procesar la compra: " + (data.error || "Error desconocido"));
                    btnSubmit.disabled = false;
                    btnSubmit.textContent = "Confirmar Compra";
                }

            } catch (error) {
                console.error("❌ Error de conexión:", error);
                alert("Error de conexión. Por favor intenta nuevamente.");
                btnSubmit.disabled = false;
                btnSubmit.textContent = "Confirmar Compra";
            }
        });
    }

});