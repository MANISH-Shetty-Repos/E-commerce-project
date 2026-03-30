package com.jtspringproject.JtSpringProject.controller;

import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.userService;
import com.jtspringproject.JtSpringProject.services.productService;
import com.jtspringproject.JtSpringProject.dto.UserDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import javax.validation.Valid;
import org.springframework.validation.BindingResult;
import java.util.List;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@io.swagger.v3.oas.annotations.tags.Tag(name = "User Controller", description = "Customer-facing APIs")
public class UserController {

	private final userService userService;
	private final productService productService;

	@Autowired
	public UserController(userService userService, productService productService) {
		this.userService = userService;
		this.productService = productService;
	}

	@GetMapping("/register")
	@io.swagger.v3.oas.annotations.Operation(summary = "Registration Page", description = "Loads the user registration view")
	public String registerUser() {
		return "register";
	}

	@GetMapping("/buy")
	public String buy() {
		return "buy";
	}

	@GetMapping("/login")
	@io.swagger.v3.oas.annotations.Operation(summary = "Login Page", description = "Loads the user login view")
	public ModelAndView userlogin(@RequestParam(required = false) String error) {
		ModelAndView mv = new ModelAndView("userLogin");
		if ("true".equals(error)) {
			mv.addObject("msg", "Please enter correct email and password");
		}
		return mv;
	}

	@GetMapping("/")
	@io.swagger.v3.oas.annotations.Operation(summary = "Home Page", description = "Main landing page with product listings")
	public ModelAndView indexPage(
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "6") int size) {
		ModelAndView mView = new ModelAndView("index");
		String username = "";
		org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			username = auth.getName();
		}
		mView.addObject("username", username);

		List<Product> products = this.productService.getProductsPaginated(page, size, "asc");
		long totalProducts = this.productService.getProductsCount();
		int totalPages = (int) Math.ceil((double) totalProducts / size);

		if (products.isEmpty()) {
			mView.addObject("msg", "No products are available");
		} else {
			mView.addObject("products", products);
			mView.addObject("currentPage", page);
			mView.addObject("totalPages", totalPages);
		}
		return mView;
	}

	@GetMapping("/user/products")
	public ModelAndView getproduct(
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "6") int size) {

		ModelAndView mView = new ModelAndView("uproduct");

		List<Product> products = this.productService.getProductsPaginated(page, size, "asc");
		long totalProducts = this.productService.getProductsCount();
		int totalPages = (int) Math.ceil((double) totalProducts / size);

		if (products.isEmpty()) {
			mView.addObject("msg", "No products are available");
		} else {
			mView.addObject("products", products);
			mView.addObject("currentPage", page);
			mView.addObject("totalPages", totalPages);
		}

		return mView;
	}

	@RequestMapping(value = "newuserregister", method = RequestMethod.POST)
	@io.swagger.v3.oas.annotations.Operation(summary = "Register User", description = "Processes new user registration data")
	public ModelAndView newUseRegister(@Valid @ModelAttribute UserDto userDto, BindingResult bindingResult) {
		if (bindingResult.hasErrors()) {
			ModelAndView mView = new ModelAndView("register");
			org.springframework.validation.FieldError fieldError = bindingResult.getFieldError();
			String errorMsg = "Validation error";
			if (fieldError != null && fieldError.getDefaultMessage() != null) {
				errorMsg = fieldError.getDefaultMessage();
			}
			mView.addObject("msg", errorMsg);
			return mView;
		}

		// Check if username already exists in database
		boolean exists = this.userService.checkUserExists(userDto.getUsername());

		if (!exists) {
			log.info("Email: {}", userDto.getEmail());

			// Map DTO to Entity
			User newEntity = new User();
			newEntity.setUsername(userDto.getUsername());
			newEntity.setEmail(userDto.getEmail());
			newEntity.setPassword(userDto.getPassword());
			newEntity.setAddress(userDto.getAddress());
			newEntity.setRole("ROLE_NORMAL");

			this.userService.addUser(newEntity);

			log.info("New user created: {}", newEntity.getUsername());
			ModelAndView mView = new ModelAndView("userLogin");
			return mView;
		} else {
			log.info("New user not created - username taken: {}", userDto.getUsername());
			ModelAndView mView = new ModelAndView("register");
			mView.addObject("msg", userDto.getUsername() + " is taken. Please choose a different username.");
			return mView;
		}
	}

	@GetMapping("/profileDisplay")
	public String profileDisplay(Model model) {

		String username = "";
		org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			username = auth.getName();
		}
		User user = userService.getUserByUsername(username);

		if (user != null) {
			model.addAttribute("userid", user.getId());
			model.addAttribute("username", user.getUsername());
			model.addAttribute("email", user.getEmail());
			model.addAttribute("address", user.getAddress());
		} else {
			model.addAttribute("msg", "User not found");
		}

		return "updateProfile";
	}

}