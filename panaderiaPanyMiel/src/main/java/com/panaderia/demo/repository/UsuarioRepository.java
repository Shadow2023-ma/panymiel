package com.panaderia.demo.repository;

import com.panaderia.demo.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.List;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
    
    // Buscar usuario por username
    Optional<Usuario> findByUsername(String username);
    
    // Verificar si existe un username
    boolean existsByUsername(String username);
    
    // Buscar usuarios por rol
    List<Usuario> findByRol(Usuario.RolUsuario rol);
    
    // Buscar usuarios activos
    List<Usuario> findByEstado(Usuario.EstadoUsuario estado);
}