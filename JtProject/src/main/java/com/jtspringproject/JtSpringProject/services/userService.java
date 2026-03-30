package com.jtspringproject.JtSpringProject.services;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import com.jtspringproject.JtSpringProject.dao.userDao;
import com.jtspringproject.JtSpringProject.models.User;

@Service
public class userService {
	@Autowired
	private userDao userDao;

	@Autowired
	private org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;
	
	public List<User> getUsers(){
		return this.userDao.getAllUser();
	}
	
	public User addUser(User user) {
		try {
			user.setPassword(passwordEncoder.encode(user.getPassword()));
			return this.userDao.saveUser(user);
		} catch (DataIntegrityViolationException e) {
			throw new com.jtspringproject.JtSpringProject.exception.UserAlreadyExistsException("Username is already taken.");
		}
	}
	
	public User checkLogin(String username,String password) {
		return this.userDao.getUser(username, password);
	}

	public boolean checkUserExists(String username) {
		return this.userDao.userExists(username);
	}

	public User getUserByUsername(String username) {
	        return userDao.getUserByUsername(username);
	    }
}
