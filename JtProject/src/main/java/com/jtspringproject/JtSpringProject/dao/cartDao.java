package com.jtspringproject.JtSpringProject.dao;

import java.util.List;

import com.jtspringproject.JtSpringProject.models.Cart;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public class cartDao {
    @Autowired
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
        this.sessionFactory = sf;
    }

    @Transactional
    public Cart addCart(Cart cart) {
        this.sessionFactory.getCurrentSession().save(cart);
        return cart;
    }

    @Transactional
    public List<Cart> getCarts() {
        return this.sessionFactory.getCurrentSession().createQuery("from CART", Cart.class).list();
    }

    @Transactional
    public List<Cart> getCartsByCustomerID(int customer_id) {
        return this.sessionFactory.getCurrentSession()
                .createQuery("from CART where customer.id = :customer_id", Cart.class)
                .setParameter("customer_id", customer_id)
                .list();
    }

    @Transactional
    public List<Product> getProductsInCart(User user) {
        return this.sessionFactory.getCurrentSession()
                .createQuery("select cp.product from CartProduct cp where cp.cart.customer = :user", Product.class)
                .setParameter("user", user)
                .list();
    }

    @Transactional
    public void clearCart(User user) {
        this.sessionFactory.getCurrentSession()
                .createQuery("delete from CartProduct cp where cp.cart.customer = :user")
                .setParameter("user", user)
                .executeUpdate();
    }

    @Transactional
    public void updateCart(Cart cart) {
        this.sessionFactory.getCurrentSession().update(cart);
    }

    @Transactional
    public void deleteCart(Cart cart) {
        this.sessionFactory.getCurrentSession().delete(cart);
    }
}
