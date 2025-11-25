package com.panaderia.demo.controller;

import com.panaderia.demo.service.CategoriaService;
import com.panaderia.demo.service.ProductoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @Autowired
    private ProductoService productoService;

    @Autowired
    private CategoriaService categoriaService;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @GetMapping("/index")
    public String panaderiaPage() {
        return "index";
    }

    @GetMapping("/contactanos")
    public String contactanosPage() {
        return "contactanos";
    }

    @GetMapping("/publicidad")
    public String publicidadPage() {
        return "publicidad";
    }

    @GetMapping("/metricas")
    public String metricasPage() {
        return "metricas";
    }

    @GetMapping("/modificar")
    public String modificarPage(Model model) {
        model.addAttribute("productos", productoService.listarTodos());
        model.addAttribute("categorias", categoriaService.listarActivas());
        return "modificar"; 
    }

    @GetMapping("/servicios")
    public String serviciosPage() {
        return "servicios";
    }

    @GetMapping("/resumencompra")
    public String resumencompraPage() {
        return "resumencompra";
    }
    @GetMapping("/catalogo")
    public String catalogoPage(Model model) {
        model.addAttribute("productos", productoService.listarDisponibles());
        model.addAttribute("categorias", categoriaService.listarActivas());
        return "catalogo";
    }
}