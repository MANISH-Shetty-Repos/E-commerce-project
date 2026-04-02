package com.jtspringproject.JtSpringProject.services;

import com.jtspringproject.JtSpringProject.dao.OrderDao;
import com.jtspringproject.JtSpringProject.models.CartProduct;
import com.jtspringproject.JtSpringProject.models.Order;
import com.jtspringproject.JtSpringProject.models.OrderItem;
import com.jtspringproject.JtSpringProject.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class OrderService {

    @Autowired
    private OrderDao orderDao;

    @Transactional
    public Order placeOrder(User user) {
        Order newOrder = new Order();
        newOrder.setUser(user);
        newOrder.setOrderDate(new Date());
        
        // This is the old generic method, but we should use the itemized one
        return orderDao.saveOrder(newOrder);
    }

    @Transactional
    public Order saveOrder(Order order) {
        return orderDao.saveOrder(order);
    }

    @Transactional
    public List<Order> getOrdersByUserId(int userId) {
        return orderDao.getOrdersByUserId(userId);
    }

    @Transactional
    public Order getOrderById(int orderId) {
        return orderDao.getOrderById(orderId);
    }

    @Transactional
    public Order placeOrderFromCart(User user, List<CartProduct> cartProducts, String paymentMethod) {
        Order newOrder = new Order();
        newOrder.setUser(user);
        newOrder.setOrderDate(new Date());
        newOrder.setPaymentMethod(paymentMethod);
        
        int totalAmount = 0;
        List<OrderItem> orderItems = new ArrayList<>();
        
        for (CartProduct cp : cartProducts) {
            OrderItem item = new OrderItem();
            item.setProduct(cp.getProduct());
            item.setQuantity(cp.getQuantity());
            item.setPriceAtPurchase(cp.getProduct().getPrice());
            item.setOrder(newOrder);
            
            totalAmount += (cp.getProduct().getPrice() * cp.getQuantity());
            orderItems.add(item);
        }
        
        newOrder.setOrderItems(orderItems);
        newOrder.setTotalAmount(totalAmount);
        
        return orderDao.saveOrder(newOrder);
    }

    @Transactional
    public void deleteOrder(int orderId) {
        orderDao.deleteOrder(orderId);
    }
}
