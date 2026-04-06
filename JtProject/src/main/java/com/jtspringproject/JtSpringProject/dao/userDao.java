package com.jtspringproject.JtSpringProject.dao;

import java.util.List;
import javax.persistence.NoResultException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.jtspringproject.JtSpringProject.models.User;

import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
public class userDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Autowired
    private org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

    public void setSessionFactory(SessionFactory sf) {
        this.sessionFactory = sf;
    }

    @Transactional
    public List<User> getAllUser() {
        Session session = this.sessionFactory.getCurrentSession();
        List<User> userList = session.createQuery("from User", User.class).list(); // Use entity name
        return userList;
    }

    @Transactional
    public User saveUser(User user) {
        this.sessionFactory.getCurrentSession().saveOrUpdate(user);
        log.info("User added: {}", user.getId());
        return user;
    }

    @Transactional
    public User getUser(String username, String password) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("from User where username = :username", User.class); // Use entity name
        query.setParameter("username", username);

        try {
            User user = query.getSingleResult();
            if (passwordEncoder.matches(password, user.getPassword())) { 
                return user;
            } else {
                return null; // Return null if password doesn't match
            }
        } catch (NoResultException e) {
            return null; // No user found
        }
    }

    @Transactional
    public boolean userExists(String username) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("from User where username = :username", User.class); // Use entity name
        query.setParameter("username", username);
        return !query.getResultList().isEmpty();
    }

    @Transactional
    public User getUserByUsername(String username) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("from User where username = :username", User.class); // Use entity name
        query.setParameter("username", username);

        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Transactional
    public User getUserById(int id) {
        return sessionFactory.getCurrentSession().get(User.class, id);
    }

    @Transactional
    public boolean deleteUser(int id) {
        Session session = this.sessionFactory.getCurrentSession();
        
        try {
            // Drop related constraints manually before deleting user
            // 1. Delete items in the cart (CartEntity is mapped as CART)
            session.createQuery("delete from CartProduct cp where cp.cart.id in (select c.id from CART c where c.customer.id = :id)").setParameter("id", id).executeUpdate();
            
            // 2. Delete the cart itself
            session.createQuery("delete from CART where customer.id = :id").setParameter("id", id).executeUpdate();
            
            // 3. Delete order items (Order is mapped as OrderEntity)
            session.createQuery("delete from OrderItemEntity oi where oi.order.id in (select o.id from OrderEntity o where o.user.id = :id)").setParameter("id", id).executeUpdate();
            
            // 4. Delete the orders
            session.createQuery("delete from OrderEntity where user.id = :id").setParameter("id", id).executeUpdate();
            
            Object persistentInstance = session.load(User.class, id);
            if (persistentInstance != null) {
                session.delete(persistentInstance);
                return true;
            }
        } catch (Exception e) {
            log.error("Failed to delete user with ID: " + id, e);
        }
        return false;
    }
}
