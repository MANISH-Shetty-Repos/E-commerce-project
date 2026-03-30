package com.jtspringproject.JtSpringProject.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.jtspringproject.JtSpringProject.models.Product;

@Repository
public class productDao {
	@Autowired
    private SessionFactory sessionFactory;
	
	public void setSessionFactory(SessionFactory sf) {
        this.sessionFactory = sf;
    }
	
	@Transactional
	public List<Product> getProducts(){
		return this.sessionFactory.getCurrentSession().createQuery("from PRODUCT", Product.class).list();
	}
	
	@Transactional
	public List<Product> getProductsPaginated(int page, int size, String sortDir) {
		String hql = "from PRODUCT p";
		if ("desc".equalsIgnoreCase(sortDir)) {
			hql += " order by p.price desc";
		} else if ("asc".equalsIgnoreCase(sortDir)) {
			hql += " order by p.price asc";
		}
		return this.sessionFactory.getCurrentSession().createQuery(hql, Product.class)
				.setFirstResult((page - 1) * size)
				.setMaxResults(size)
				.list();
	}

	@Transactional
	public long getProductsCount() {
		return this.sessionFactory.getCurrentSession().createQuery("select count(p) from PRODUCT p", Long.class).uniqueResult();
	}
	
	@Transactional
	public Product addProduct(Product product) {
		this.sessionFactory.getCurrentSession().save(product);
		return product;
	}
	
	@Transactional
	public Product getProduct(int id) {
		return this.sessionFactory.getCurrentSession().get(Product.class, id);
	}

	@Transactional
	public Product updateProduct(Product product){
		this.sessionFactory.getCurrentSession().update(product);
		return product;
	}
	@Transactional
	public Boolean deleteProduct(int id) {

		Session session = this.sessionFactory.getCurrentSession();
		Object persistanceInstance = session.load(Product.class, id);

		if (persistanceInstance != null) {
			session.delete(persistanceInstance);
			return true;
		}
		return false;
	}

}
