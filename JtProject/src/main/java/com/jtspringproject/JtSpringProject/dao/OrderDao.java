package com.jtspringproject.JtSpringProject.dao;

import com.jtspringproject.JtSpringProject.models.Order;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class OrderDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Transactional
    public Order saveOrder(Order order) {
        this.sessionFactory.getCurrentSession().save(order);
        return order;
    }

    @Transactional
    public List<Order> getOrdersByUserId(int userId) {
        return this.sessionFactory.getCurrentSession()
                .createQuery("from OrderEntity o where o.user.id = :userId order by o.orderDate desc", Order.class)
                .setParameter("userId", userId)
                .list();
    }

    @Transactional
    public List<Order> getAllOrders() {
        return this.sessionFactory.getCurrentSession()
                .createQuery("from OrderEntity o order by o.orderDate desc", Order.class)
                .list();
    }

    @Transactional
    public Order getOrderById(int orderId) {
        return this.sessionFactory.getCurrentSession().get(Order.class, orderId);
    }

    @Transactional
    public void deleteOrder(int orderId) {
        Order order = getOrderById(orderId);
        if (order != null) {
            this.sessionFactory.getCurrentSession().delete(order);
        }
    }

    @Transactional
    public long getOrderCountByProductId(int productId) {
        Long count = (Long) this.sessionFactory.getCurrentSession()
                .createQuery("select coalesce(sum(oi.quantity), 0L) from OrderItemEntity oi where oi.product.id = :productId")
                .setParameter("productId", productId)
                .uniqueResult();
        return count == null ? 0L : count;
    }
}
