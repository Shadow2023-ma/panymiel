document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("formContacto");
    const estado = document.getElementById("estado");
    const nombre = document.getElementById("nombre");
    const email = document.getElementById("email");
    const mensaje = document.getElementById("mensaje");

    form.addEventListener("submit", function(e) {
        e.preventDefault(); // evita recargar la página

        // Validación básica
        if (nombre.value.trim() === "" || email.value.trim() === "" || mensaje.value.trim() === "") {
            estado.style.color = "red";
            estado.textContent = "Por favor completa todos los campos.";
            return;
        }

        // Mensaje de éxito
        estado.style.color = "green";
        estado.textContent = "¡Gracias por comunicarte con nosotros! Te responderemos pronto.";

        // Limpiar campos
        nombre.value = "";
        email.value = "";
        mensaje.value = "";

        // OPCIONAL: borrar mensaje después de 4s
        setTimeout(() => {
            estado.textContent = "";
        }, 4000);
    });
});
