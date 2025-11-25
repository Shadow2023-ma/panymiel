package com.panaderia.demo.repository;

import com.panaderia.demo.model.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ClienteRepository extends JpaRepository<Cliente, Integer> {
    
    // Buscar cliente por username
    Optional<Cliente> findByUsername(String username);
    
    // Verificar si existe un username
    boolean existsByUsername(String username);
    
    // Verificar si existe un DNI
    boolean existsByDni(String dni);
    
    // Buscar cliente por DNI
    Optional<Cliente> findByDni(String dni);
    
    // Buscar cliente por email
    Optional<Cliente> findByEmail(String email);
}