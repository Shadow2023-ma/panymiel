package com.panaderia.demo.service;

import com.panaderia.demo.model.Usuario;
import com.panaderia.demo.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // Login de usuario (admin, vendedor, cajero)
    public Optional<Usuario> login(String username, String password) {
        Optional<Usuario> usuarioOpt = usuarioRepository.findByUsername(username);

        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            
            // Verificar que esté activo
            if (usuario.getEstado() != Usuario.EstadoUsuario.ACTIVO) {
                return Optional.empty();
            }

            // Verificar contraseña
            if (passwordEncoder.matches(password, usuario.getPassword())) {
                return Optional.of(usuario);
            }
        }

        return Optional.empty();
    }

    // Crear usuario (solo desde backend/admin)
    public Usuario crearUsuario(Usuario usuario) {
        if (usuarioRepository.existsByUsername(usuario.getUsername())) {
            throw new RuntimeException("El username ya está registrado");
        }

        // Encriptar contraseña
        usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));
        usuario.setEstado(Usuario.EstadoUsuario.ACTIVO);

        return usuarioRepository.save(usuario);
    }

    // Buscar usuario por ID
    public Optional<Usuario> buscarPorId(Integer id) {
        return usuarioRepository.findById(id);
    }

    // Buscar usuario por username
    public Optional<Usuario> buscarPorUsername(String username) {
        return usuarioRepository.findByUsername(username);
    }

    // Listar todos los usuarios
    public List<Usuario> listarTodos() {
        return usuarioRepository.findAll();
    }

    // Listar usuarios por rol
    public List<Usuario> listarPorRol(Usuario.RolUsuario rol) {
        return usuarioRepository.findByRol(rol);
    }

    // Listar usuarios activos
    public List<Usuario> listarActivos() {
        return usuarioRepository.findByEstado(Usuario.EstadoUsuario.ACTIVO);
    }

    // Actualizar usuario
    public Usuario actualizar(Usuario usuario) {
        if (!usuarioRepository.existsById(usuario.getIdUsuario())) {
            throw new RuntimeException("Usuario no encontrado");
        }
        return usuarioRepository.save(usuario);
    }

    // Cambiar contraseña
    public void cambiarPassword(Integer idUsuario, String passwordActual, String passwordNueva) {
        Usuario usuario = usuarioRepository.findById(idUsuario)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        // Verificar contraseña actual
        if (!passwordEncoder.matches(passwordActual, usuario.getPassword())) {
            throw new RuntimeException("Contraseña actual incorrecta");
        }

        // Establecer nueva contraseña
        usuario.setPassword(passwordEncoder.encode(passwordNueva));
        usuarioRepository.save(usuario);
    }

    // Cambiar rol
    public void cambiarRol(Integer idUsuario, Usuario.RolUsuario nuevoRol) {
        Usuario usuario = usuarioRepository.findById(idUsuario)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        
        usuario.setRol(nuevoRol);
        usuarioRepository.save(usuario);
    }

    // Desactivar usuario
    public void desactivar(Integer idUsuario) {
        Usuario usuario = usuarioRepository.findById(idUsuario)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        
        usuario.setEstado(Usuario.EstadoUsuario.INACTIVO);
        usuarioRepository.save(usuario);
    }

    // Activar usuario
    public void activar(Integer idUsuario) {
        Usuario usuario = usuarioRepository.findById(idUsuario)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        
        usuario.setEstado(Usuario.EstadoUsuario.ACTIVO);
        usuarioRepository.save(usuario);
    }

    // Eliminar usuario
    public void eliminar(Integer idUsuario) {
        if (!usuarioRepository.existsById(idUsuario)) {
            throw new RuntimeException("Usuario no encontrado");
        }
        usuarioRepository.deleteById(idUsuario);
    }
}