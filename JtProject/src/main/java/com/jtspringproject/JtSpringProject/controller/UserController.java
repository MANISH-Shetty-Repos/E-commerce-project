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

import com.jtspringproject.JtSpringProject.services.OrderService;

@Controller
@Slf4j
@io.swagger.v3.oas.annotations.tags.Tag(name = "User Controller", description = "Customer-facing APIs")
public class UserController {

	private final userService userService;
	private final productService productService;
	private final cartService cartService;
	private final cartProductDao cartProductDao;
	private final OrderService orderService;

	@Autowired
	public UserController(userService userService, productService productService, cartService cartService,
			cartProductDao cartProductDao, OrderService orderService) {
		this.userService = userService;
		this.productService = productService;
		this.cartService = cartService;
		this.cartProductDao = cartProductDao;
		this.orderService = orderService;
	}

	@ModelAttribute("cartCount")
	public int getCartCount() {
		String username = "";
		org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null && !(auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken)) {
			username = auth.getName();
		}

		if (username.isEmpty()) return 0;

		User user = userService.getUserByUsername(username);
		if (user == null) return 0;

		List<Cart> existingCarts = cartService.getCartByUserId(user.getId());
		if (existingCarts.isEmpty()) return 0;

		Cart userCart = existingCarts.get(0);
		List<CartProduct> cartProducts = cartProductDao.getCartProductsByCartId(userCart.getId());
		
		return cartProducts.stream().mapToInt(CartProduct::getQuantity).sum();
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
			List<CartProduct> cartProducts = cartService.getCartProductsInCart(user);
			mv.addObject("cartProducts", cartProducts);
			mv.addObject("userid", user.getId());

			int total = cartProducts.stream().mapToInt(cp -> cp.getProduct().getPrice() * cp.getQuantity()).sum();
			mv.addObject("total", total);
		}
		return mv;
	}

	@GetMapping("/user/addtocart")
	public String addtocart(@RequestParam("pid") int productId, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
		if (isAdmin()) {
			return "redirect:/admin/index";
		}
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

			try {
				if (existingCarts.isEmpty()) {
					log.info("Creating new cart for user {}", username);
					userCart = new Cart();
					userCart.setCustomer(user);
					userCart = cartService.addCart(userCart);
				} else {
					userCart = existingCarts.get(0);
				}
			} catch (Exception e) {
				log.error("Failed to create/fetch cart for user {}: {}", username, e.getMessage());
				redirectAttributes.addFlashAttribute("error", "System Error: Your cart could not be initialized. Please contact support.");
				return "redirect:/";
			}

			// Check if product is already in cart
			CartProduct cartProduct = cartProductDao.getCartProductByCartIdAndProductId(userCart.getId(), product.getId());
			
			if (cartProduct != null) {
				// Increase quantity if product already exists in cart
				cartProduct.setQuantity(cartProduct.getQuantity() + 1);
				cartProductDao.updateCartProduct(cartProduct);
				log.info("Product {} quantity increased for user {}", product.getName(), username);
				redirectAttributes.addFlashAttribute("msg", product.getName() + " quantity updated in cart!");
			} else {
				// Add as new entry if it doesn't exist
				cartProduct = new CartProduct(userCart, product);
				cartProductDao.addCartProduct(cartProduct);
				log.info("Product {} added to cart for user {}", product.getName(), username);
				redirectAttributes.addFlashAttribute("msg", product.getName() + " added to cart successfully!");
			}
		}

		return "redirect:/user/products";
	}

	@GetMapping("/user/cart/increase")
	public String increaseQuantity(@RequestParam("pid") int productId) {
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		User user = userService.getUserByUsername(username);
		if (user != null) {
			List<Cart> carts = cartService.getCartByUserId(user.getId());
			if (!carts.isEmpty()) {
				CartProduct cp = cartProductDao.getCartProductByCartIdAndProductId(carts.get(0).getId(), productId);
				if (cp != null) {
					cp.setQuantity(cp.getQuantity() + 1);
					cartProductDao.updateCartProduct(cp);
				}
			}
		}
		return "redirect:/buy";
	}

	@GetMapping("/user/cart/decrease")
	public String decreaseQuantity(@RequestParam("pid") int productId) {
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		User user = userService.getUserByUsername(username);
		if (user != null) {
			List<Cart> carts = cartService.getCartByUserId(user.getId());
			if (!carts.isEmpty()) {
				CartProduct cp = cartProductDao.getCartProductByCartIdAndProductId(carts.get(0).getId(), productId);
				if (cp != null) {
					if (cp.getQuantity() > 1) {
						cp.setQuantity(cp.getQuantity() - 1);
						cartProductDao.updateCartProduct(cp);
					} else {
						cartProductDao.deleteCartProduct(cp);
					}
				}
			}
		}
		return "redirect:/buy";
	}

	@GetMapping("/removeFromCart")
	public String removeFromCart(@RequestParam("pid") int productId) {
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		User user = userService.getUserByUsername(username);
		if (user != null) {
			List<Cart> carts = cartService.getCartByUserId(user.getId());
			if (!carts.isEmpty()) {
				CartProduct cp = cartProductDao.getCartProductByCartIdAndProductId(carts.get(0).getId(), productId);
				if (cp != null) {
					cartProductDao.deleteCartProduct(cp);
				}
			}
		}
		return "redirect:/buy";
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
			java.util.Map<Integer, Long> orderCounts = new java.util.HashMap<>();
			for (Product p : products) {
				orderCounts.put(p.getId(), orderService.getOrderCountByProductId(p.getId()));
			}
			mView.addObject("orderCounts", orderCounts);
			mView.addObject("products", products);
			mView.addObject("currentPage", page);
			mView.addObject("totalPages", totalPages);
		}
		return mView;
	}

	@GetMapping("/user/products")
	public ModelAndView getproduct(
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "24") int size) {
		if (isAdmin()) {
			return new ModelAndView("redirect:/admin/index");
		}
		
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
			java.util.Map<Integer, Long> orderCounts = new java.util.HashMap<>();
			for (Product p : products) {
				orderCounts.put(p.getId(), orderService.getOrderCountByProductId(p.getId()));
			}
			mView.addObject("orderCounts", orderCounts);
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

	private boolean isAdmin() {
		org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null && !(auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken)) {
			User user = userService.getUserByUsername(auth.getName());
			return user != null && "ROLE_ADMIN".equals(user.getRole());
		}
		return false;
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