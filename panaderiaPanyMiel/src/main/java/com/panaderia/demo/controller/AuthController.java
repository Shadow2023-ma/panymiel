package com.panaderia.demo.controller;

import com.panaderia.demo.dto.RegistroClienteRequest;
import com.panaderia.demo.model.Cliente;
import com.panaderia.demo.service.ClienteService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private ClienteService clienteService;

    // Procesar login
    @PostMapping("/login")
    public String login(@RequestParam String username, 
                        @RequestParam String password,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {
        
        System.out.println("🔐 Intento de login con username: " + username);
        
        Optional<Cliente> clienteOpt = clienteService.login(username, password);

        if (clienteOpt.isPresent()) {
            Cliente cliente = clienteOpt.get();
            
            // 🔥 IMPORTANTE: Guardar datos en sesión
            session.setAttribute("clienteLogueado", cliente);
            session.setAttribute("idCliente", cliente.getIdCliente());
            session.setAttribute("nombreCliente", cliente.getNombres() + " " + cliente.getApellidos());
            
            System.out.println("✅ Login exitoso - ID Cliente guardado en sesión: " + cliente.getIdCliente());
            System.out.println("✅ Nombre: " + cliente.getNombres() + " " + cliente.getApellidos());
            
            redirectAttributes.addFlashAttribute("success", "¡Bienvenido " + cliente.getNombres() + "!");
            return "redirect:/index";
        } else {
            System.out.println("❌ Login fallido para username: " + username);
            redirectAttributes.addFlashAttribute("error", "Usuario o contraseña incorrectos");
            return "redirect:/login";
        }
    }

    // Procesar registro
    @PostMapping("/register")
    public String register(@Valid @ModelAttribute RegistroClienteRequest request,
                           BindingResult result,
                           RedirectAttributes redirectAttributes) {
        
        System.out.println("📝 Intento de registro con username: " + request.getUsername());
        
        // Validar errores de validación
        if (result.hasErrors()) {
            redirectAttributes.addFlashAttribute("error", "Por favor corrige los errores en el formulario");
            return "redirect:/login";
        }

        // Validar que las contraseñas coincidan
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            redirectAttributes.addFlashAttribute("error", "Las contraseñas no coinciden");
            return "redirect:/login";
        }

        try {
            // Crear cliente
            Cliente cliente = new Cliente();
            cliente.setDni(request.getDni());
            cliente.setNombres(request.getNombres());
            cliente.setApellidos(request.getApellidos());
            cliente.setTelefono(request.getTelefono());
            cliente.setEmail(request.getEmail());
            cliente.setDireccion(request.getDireccion());
            cliente.setUsername(request.getUsername());
            cliente.setPassword(request.getPassword());

            clienteService.registrarCliente(cliente);

            System.out.println("✅ Cliente registrado exitosamente: " + request.getUsername());
            
            redirectAttributes.addFlashAttribute("success", "¡Registro exitoso! Ahora puedes iniciar sesión");
            return "redirect:/login";

        } catch (RuntimeException e) {
            System.err.println("❌ Error al registrar cliente: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/login";
        }
    }

    // Cerrar sesión
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        System.out.println("👋 Cerrando sesión...");
        session.invalidate();
        redirectAttributes.addFlashAttribute("success", "Has cerrado sesión correctamente");
        return "redirect:/login";
    }
}