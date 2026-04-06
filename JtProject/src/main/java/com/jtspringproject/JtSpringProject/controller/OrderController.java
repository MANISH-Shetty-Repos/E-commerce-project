package com.jtspringproject.JtSpringProject.controller;

import com.jtspringproject.JtSpringProject.models.Order;
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
    public String processCheckout(
            @org.springframework.web.bind.annotation.RequestParam(value = "selectedProducts", required = false) java.util.List<Integer> selectedProductIds,
            @org.springframework.web.bind.annotation.RequestParam(value = "paymentMethod", defaultValue = "Cash on Delivery") String paymentMethod,
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {

        if (selectedProductIds == null || selectedProductIds.isEmpty()) {
            redirectAttributes.addFlashAttribute("msg", "Please select at least one item to checkout.");
            return "redirect:/buy";
        }
        
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userService.getUserByUsername(username);

        if (user == null) {
            return "redirect:/userLogin";
        }

        List<com.jtspringproject.JtSpringProject.models.CartProduct> allCartProducts = cartService.getCartProductsInCart(user);
        List<com.jtspringproject.JtSpringProject.models.CartProduct> selectedItems = new java.util.ArrayList<>();

        for (com.jtspringproject.JtSpringProject.models.CartProduct cp : allCartProducts) {
            if (selectedProductIds.contains(cp.getProduct().getId())) {
                selectedItems.add(cp);
            }
        }

        if (!selectedItems.isEmpty()) {
            orderService.placeOrderFromCart(user, selectedItems, paymentMethod);
            cartService.clearSelectedItems(user, selectedProductIds);
            
            redirectAttributes.addFlashAttribute("msg", "Successfully placed order via " + paymentMethod + "!");
        }

        return "redirect:/user/orders";
    }

    @GetMapping("/user/orders")
    @io.swagger.v3.oas.annotations.Operation(summary = "View Orders", description = "Retrieve personal order history")
    public ModelAndView viewOrders() {
        ModelAndView mView = new ModelAndView("userOrders");
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userService.getUserByUsername(username);
        
        if (user != null) {
            mView.addObject("orders", orderService.getOrdersByUserId(user.getId()));
            mView.addObject("username", user.getUsername());
        }
        return mView;
    }

    @PostMapping("/user/order/cancel")
    public String cancelOrder(@org.springframework.web.bind.annotation.RequestParam("orderId") int orderId, 
                             org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userService.getUserByUsername(username);
        
        if (user != null) {
            Order order = orderService.getOrderById(orderId);
            if (order != null && order.getUser().getId() == user.getId()) {
                orderService.deleteOrder(orderId);
                redirectAttributes.addFlashAttribute("msg", "Your order has been successfully canceled. Your refund of ₹" + order.getTotalAmount() + " will be credited within 24 hours!");
            } else {
                redirectAttributes.addFlashAttribute("msg", "Error: You can only cancel your own orders.");
            }
        }
        
        return "redirect:/user/orders";
    }
}
