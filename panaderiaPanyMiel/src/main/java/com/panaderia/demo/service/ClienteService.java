package com.panaderia.demo.service;

import com.panaderia.demo.model.Cliente;
import com.panaderia.demo.repository.ClienteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ClienteService {

    @Autowired
    private ClienteRepository clienteRepository;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // Registrar nuevo cliente
    public Cliente registrarCliente(Cliente cliente) {
        // Validar que no exista el username
        if (clienteRepository.existsByUsername(cliente.getUsername())) {
            throw new RuntimeException("El username ya está registrado");
        }

        // Validar que no exista el DNI
        if (clienteRepository.existsByDni(cliente.getDni())) {
            throw new RuntimeException("El DNI ya está registrado");
        }

        // Encriptar contraseña
        cliente.setPassword(passwordEncoder.encode(cliente.getPassword()));

        // Establecer estado activo por defecto
        cliente.setEstado(Cliente.EstadoCliente.ACTIVO);

        return clienteRepository.save(cliente);
    }

    // Login de cliente
    public Optional<Cliente> login(String username, String password) {
        Optional<Cliente> clienteOpt = clienteRepository.findByUsername(username);

        if (clienteOpt.isPresent()) {
            Cliente cliente = clienteOpt.get();
            
            // Verificar que esté activo
            if (cliente.getEstado() != Cliente.EstadoCliente.ACTIVO) {
                return Optional.empty();
            }

            // Verificar contraseña
            if (passwordEncoder.matches(password, cliente.getPassword())) {
                return Optional.of(cliente);
            }
        }

        return Optional.empty();
    }

    // Buscar cliente por ID
    public Optional<Cliente> buscarPorId(Integer id) {
        return clienteRepository.findById(id);
    }

    // Buscar cliente por username
    public Optional<Cliente> buscarPorUsername(String username) {
        return clienteRepository.findByUsername(username);
    }

    // Buscar cliente por DNI
    public Optional<Cliente> buscarPorDni(String dni) {
        return clienteRepository.findByDni(dni);
    }

    // Listar todos los clientes
    public List<Cliente> listarTodos() {
        return clienteRepository.findAll();
    }

    // Actualizar cliente
    public Cliente actualizar(Cliente cliente) {
        if (!clienteRepository.existsById(cliente.getIdCliente())) {
            throw new RuntimeException("Cliente no encontrado");
        }
        return clienteRepository.save(cliente);
    }

    // Actualizar perfil (sin cambiar password)
    public Cliente actualizarPerfil(Integer idCliente, String nombres, String apellidos, 
                                     String telefono, String email, String direccion) {
        Cliente cliente = clienteRepository.findById(idCliente)
                .orElseThrow(() -> new RuntimeException("Cliente no encontrado"));

        cliente.setNombres(nombres);
        cliente.setApellidos(apellidos);
        cliente.setTelefono(telefono);
        cliente.setEmail(email);
        cliente.setDireccion(direccion);

        return clienteRepository.save(cliente);
    }

    // Cambiar contraseña
    public void cambiarPassword(Integer idCliente, String passwordActual, String passwordNueva) {
        Cliente cliente = clienteRepository.findById(idCliente)
                .orElseThrow(() -> new RuntimeException("Cliente no encontrado"));

        // Verificar contraseña actual
        if (!passwordEncoder.matches(passwordActual, cliente.getPassword())) {
            throw new RuntimeException("Contraseña actual incorrecta");
        }

        // Establecer nueva contraseña
        cliente.setPassword(passwordEncoder.encode(passwordNueva));
        clienteRepository.save(cliente);
    }

    // Desactivar cliente
    public void desactivar(Integer idCliente) {
        Cliente cliente = clienteRepository.findById(idCliente)
                .orElseThrow(() -> new RuntimeException("Cliente no encontrado"));
        
        cliente.setEstado(Cliente.EstadoCliente.INACTIVO);
        clienteRepository.save(cliente);
    }

    // Activar cliente
    public void activar(Integer idCliente) {
        Cliente cliente = clienteRepository.findById(idCliente)
                .orElseThrow(() -> new RuntimeException("Cliente no encontrado"));
        
        cliente.setEstado(Cliente.EstadoCliente.ACTIVO);
        clienteRepository.save(cliente);
    }

    // Verificar si existe username
    public boolean existeUsername(String username) {
        return clienteRepository.existsByUsername(username);
    }

    // Verificar si existe DNI
    public boolean existeDni(String dni) {
        return clienteRepository.existsByDni(dni);
    }
}