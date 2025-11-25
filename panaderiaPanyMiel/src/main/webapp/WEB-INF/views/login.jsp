<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Login - Pan y Miel</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/loginstyle.css" />
</head>
<body>

  <div class="login-container">

    <video src="${pageContext.request.contextPath}/video/fondologin.mp4" loop muted autoplay></video>

    <!-- MENSAJES -->
    <c:if test="${not empty error}">
      <div class="alert alert-error">
        ${error}
      </div>
    </c:if>

    <c:if test="${not empty success}">
      <div class="alert alert-success">
        ${success}
      </div>
    </c:if>

    <!-- LOGIN -->
    <div class="form-container" id="loginForm">
      <form action="${pageContext.request.contextPath}/auth/login" method="POST" class="form-login">
        <h2>LOGIN</h2>

        <div class="datos-container">
          <label>Usuario
            <input name="username" type="text" placeholder="Nombre de usuario" required />
          </label>

          <label>Password
            <input name="password" type="password" placeholder="Contraseña" required />
          </label>

          <div class="button-container">
            <input type="submit" value="Iniciar Sesión" />
          </div>

          <div class="links-container">
            <a class="link" href="#" onclick="toggleForms(); return false;">¿No tienes cuenta? Regístrate</a>
          </div>
        </div>
      </form>
    </div>

    <!-- REGISTRO -->
    <div class="form-container hidden" id="registerForm">
      <form action="${pageContext.request.contextPath}/auth/register" method="POST" class="form-register" novalidate>
        <h2>REGISTRO</h2>

        <div class="datos-container">

          <label>DNI
            <input name="dni" type="text" placeholder="DNI (8 dígitos)" required minlength="8" maxlength="8" pattern="\\d{8}" />
          </label>

          <label>Nombres
            <input name="nombres" type="text" placeholder="Nombres completos" required maxlength="100" />
          </label>

          <label>Apellidos
            <input name="apellidos" type="text" placeholder="Apellidos completos" required maxlength="100" />
          </label>

          <label>Teléfono
            <input name="telefono" type="text" placeholder="Teléfono (opcional)" maxlength="15" />
          </label>

          <label>Email
            <input name="email" type="email" placeholder="Correo electrónico" maxlength="100" />
          </label>

          <label>Dirección
            <input name="direccion" type="text" placeholder="Dirección" />
          </label>

          <label>Usuario
            <input name="username" type="text" placeholder="Nombre de usuario" required minlength="3" maxlength="50" />
          </label>

          <label>Password
            <input id="reg-password" name="password" type="password" placeholder="Contraseña (mínimo 6 caracteres)" required minlength="6" />
          </label>

          <label>Confirmar Password
            <input id="reg-confirm-password" name="confirmPassword" type="password" placeholder="Confirmar contraseña" required />
          </label>

          <div class="error-message" id="passwordError" style="display:none;">
            Las contraseñas deben ser iguales
          </div>

          <div class="button-container">
            <input type="submit" value="Crear Cuenta" />
          </div>

          <div class="links-container">
            <a class="link" href="#" onclick="toggleForms(); return false;">¿Ya tienes Cuenta? Iniciar Sesión</a>
          </div>

        </div>
      </form>
    </div>

  </div>

  <!-- JS -->
  <script>
    function toggleForms() {
      document.getElementById('loginForm').classList.toggle('hidden');
      document.getElementById('registerForm').classList.toggle('hidden');
      document.getElementById('passwordError').style.display = 'none';
    }

    const registerFormElement = document.querySelector('#registerForm form');

    registerFormElement.addEventListener('submit', function (e) {
      const p1 = document.getElementById('reg-password').value;
      const p2 = document.getElementById('reg-confirm-password').value;
      const errorDiv = document.getElementById('passwordError');

      if (p1 !== p2) {
        e.preventDefault();
        errorDiv.textContent = "Las contraseñas deben ser iguales";
        errorDiv.style.display = 'block';
        return false;
      }

      if (p1.length < 6) {
        e.preventDefault();
        errorDiv.textContent = "La contraseña debe tener al menos 6 caracteres";
        errorDiv.style.display = 'block';
        return false;
      }

      errorDiv.style.display = 'none';
    });

    setTimeout(() => {
      document.querySelectorAll('.alert').forEach(a => {
        a.style.transition = 'opacity 0.5s';
        a.style.opacity = '0';
        setTimeout(() => a.remove(), 500);
      });
    }, 5000);
  </script>

</body>
</html>
