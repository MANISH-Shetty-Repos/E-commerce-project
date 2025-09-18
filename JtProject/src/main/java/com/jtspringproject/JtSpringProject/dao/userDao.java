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

@Repository
public class userDao {

    @Autowired
    private SessionFactory sessionFactory;

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
        System.out.println("User added: " + user.getId());
        return user;
    }

    @Transactional
    public User getUser(String username, String password) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("from User where username = :username", User.class); // Use entity name
        query.setParameter("username", username);

        try {
            User user = query.getSingleResult();
            if (password.equals(user.getPassword())) { // Plain check; replace with encoder in production
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
}
