package com.jtspringproject.JtSpringProject.controller;

import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.OrderService;
import com.jtspringproject.JtSpringProject.services.cartService;
import com.jtspringproject.JtSpringProject.services.userService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
@io.swagger.v3.oas.annotations.tags.Tag(name = "Order Controller", description = "Endpoints for handling customer orders and checkouts")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private userService userService;

    @Autowired
    private cartService cartService;

    @PostMapping("/user/checkout")
    public String processCheckout() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userService.getUserByUsername(username);

        List<Product> checkoutProducts = cartService.getProductsInCart(user);
        
        if (!checkoutProducts.isEmpty()) {
            orderService.placeOrder(user, checkoutProducts);
            cartService.clearCart(user);
        }

        return "redirect:/user/orders";
    }

    @GetMapping("/user/orders")
    @io.swagger.v3.oas.annotations.Operation(summary = "View Orders", description = "Retrieve personal order history")
    public ModelAndView viewOrders() {
        ModelAndView mView = new ModelAndView("orders");
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userService.getUserByUsername(username);
        
        mView.addObject("orders", orderService.getOrdersByUserId(user.getId()));
        return mView;
    }
}
