package com.jtspringproject.JtSpringProject.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jtspringproject.JtSpringProject.dao.productDao;
import com.jtspringproject.JtSpringProject.models.Product;

@Service
public class productService {
	@Autowired
	private productDao productDao;
	
	public List<Product> getProducts(){
		return this.productDao.getProducts();
	}
	
	public List<Product> getProductsPaginated(int page, int size, String sortDir){
		return this.productDao.getProductsPaginated(page, size, sortDir);
	}

	public long getProductsCount() {
		return this.productDao.getProductsCount();
	}
	
	public Product addProduct(Product product) {
		return this.productDao.addProduct(product);
	}
	
	public Product getProduct(int id) {
		Product product = this.productDao.getProduct(id);
		if (product == null) {
			throw new com.jtspringproject.JtSpringProject.exception.ResourceNotFoundException("Product not found with id: " + id);
		}
		return product;
	}

	public Product updateProduct(int id,Product product){
		product.setId(id);
		return this.productDao.updateProduct(product);
	}
	public boolean deleteProduct(int id) {
		return this.productDao.deleteProduct(id);
	}

	
}
