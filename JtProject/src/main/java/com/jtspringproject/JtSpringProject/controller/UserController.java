package com.jtspringproject.JtSpringProject.controller;

import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.userService;
import com.jtspringproject.JtSpringProject.services.productService;
import com.jtspringproject.JtSpringProject.dto.UserDto;
import com.jtspringproject.JtSpringProject.models.Cart;
import com.jtspringproject.JtSpringProject.models.CartProduct;
import com.jtspringproject.JtSpringProject.services.cartService;
import com.jtspringproject.JtSpringProject.dao.cartProductDao;
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
	private final cartService cartService;
	private final cartProductDao cartProductDao;

	@Autowired
	public UserController(userService userService, productService productService, cartService cartService,
			cartProductDao cartProductDao) {
		this.userService = userService;
		this.productService = productService;
		this.cartService = cartService;
		this.cartProductDao = cartProductDao;
	}

	@GetMapping("/register")
	@io.swagger.v3.oas.annotations.Operation(summary = "Registration Page", description = "Loads the user registration view")
	public String registerUser() {
		return "register";
	}

	@GetMapping("/buy")
	public ModelAndView buy() {
		ModelAndView mv = new ModelAndView("buy");
		String username = "";
		org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			username = auth.getName();
		}

		User user = userService.getUserByUsername(username);
		if (user != null) {
			List<Product> cartProducts = cartService.getProductsInCart(user);
			mv.addObject("cartProducts", cartProducts);

			int total = cartProducts.stream().mapToInt(Product::getPrice).sum();
			mv.addObject("total", total);
		}
		return mv;
	}

	@GetMapping("/user/addtocart")
	public String addtocart(@RequestParam("pid") int productId) {
		String username = "";
		org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			username = auth.getName();
		}

		User user = userService.getUserByUsername(username);
		Product product = productService.getProduct(productId);

		if (user != null && product != null) {
			List<Cart> existingCarts = cartService.getCartByUserId(user.getId());
			Cart userCart;

			if (existingCarts.isEmpty()) {
				userCart = new Cart();
				userCart.setCustomer(user);
				userCart = cartService.addCart(userCart);
			} else {
				userCart = existingCarts.get(0);
			}

			CartProduct cartProduct = new CartProduct(userCart, product);
			cartProductDao.addCartProduct(cartProduct);
			log.info("Product {} added to cart for user {}", product.getName(), username);
		}

		return "redirect:/user/products";
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
		if (auth != null && !(auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken)) {
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
		String username = "";
		org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null && !(auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken)) {
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

	@GetMapping("/user/profile")
	public String userProfile(Model model) {
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
		return "profile";
	}

	@GetMapping("/user/profile/edit")
	public String profileEdit(Model model) {
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

	@PostMapping("/updateuser")
	public String updateUserProfile(@RequestParam("userid") int userid, @RequestParam("username") String username,
			@RequestParam("email") String email, @RequestParam("password") String password,
			@RequestParam("address") String address, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
		User user = userService.getUserById(userid);
		if (user != null) {
			user.setUsername(username);
			user.setEmail(email);
			user.setAddress(address);
			
			userService.updateExistingUser(user, (password != null && !password.isEmpty()) ? password : null);

			org.springframework.security.authentication.UsernamePasswordAuthenticationToken newAuthentication = new org.springframework.security.authentication.UsernamePasswordAuthenticationToken(
					username,
					user.getPassword(),
					SecurityContextHolder.getContext().getAuthentication().getAuthorities());

			SecurityContextHolder.getContext().setAuthentication(newAuthentication);
			redirectAttributes.addFlashAttribute("msg", "Profile updated successfully!");
		} else {
			redirectAttributes.addFlashAttribute("msg", "Profile update failed. User not found.");
		}
		return "redirect:/user/profile";
	}

}