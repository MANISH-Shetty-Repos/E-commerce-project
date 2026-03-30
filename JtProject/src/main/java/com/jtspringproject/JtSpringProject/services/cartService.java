package com.jtspringproject.JtSpringProject.services;

import com.jtspringproject.JtSpringProject.dao.cartDao;
import com.jtspringproject.JtSpringProject.models.Cart;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class cartService {
    @Autowired
    private cartDao cartDao;

    public Cart addCart(Cart cart) {
        return cartDao.addCart(cart);
    }


    public List<Cart> getCarts() {
        return this.cartDao.getCarts();
    }

    public void updateCart(Cart cart) {
        cartDao.updateCart(cart);
    }

    public void deleteCart(Cart cart) {
        cartDao.deleteCart(cart);
    }

    public List<Cart> getCartByUserId(int customer_id){
        return cartDao.getCartsByCustomerID(customer_id);
    }

    public List<Product> getProductsInCart(User user) {
        return cartDao.getProductsInCart(user);
    }

    public void clearCart(User user) {
        cartDao.clearCart(user);
    }


}
