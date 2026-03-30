package com.jtspringproject.JtSpringProject.services;

import com.jtspringproject.JtSpringProject.dao.OrderDao;
import com.jtspringproject.JtSpringProject.models.Order;
import com.jtspringproject.JtSpringProject.models.OrderItem;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class OrderService {

    @Autowired
    private OrderDao orderDao;

    public Order placeOrder(User user, List<Product> products) {
        Order newOrder = new Order();
        newOrder.setUser(user);
        newOrder.setOrderDate(new Date());
        
        int totalAmount = 0;
        List<OrderItem> orderItems = new ArrayList<>();
        
        for (Product product : products) {
            OrderItem item = new OrderItem();
            item.setOrder(newOrder);
            item.setProduct(product);
            item.setQuantity(1);
            item.setPriceAtPurchase(product.getPrice());
            
            totalAmount += product.getPrice();
            orderItems.add(item);
        }
        
        newOrder.setTotalAmount(totalAmount);
        newOrder.setOrderItems(orderItems);
        
        return orderDao.saveOrder(newOrder);
    }

    public List<Order> getOrdersByUserId(int userId) {
        return orderDao.getOrdersByUserId(userId);
    }

    public Order getOrderById(int orderId) {
        return orderDao.getOrderById(orderId);
    }
}
