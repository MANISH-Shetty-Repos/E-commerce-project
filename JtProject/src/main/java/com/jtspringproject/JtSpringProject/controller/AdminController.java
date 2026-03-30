package com.jtspringproject.JtSpringProject.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.jtspringproject.JtSpringProject.models.Category;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.categoryService;
import com.jtspringproject.JtSpringProject.services.productService;
import com.jtspringproject.JtSpringProject.services.userService;
import com.jtspringproject.JtSpringProject.dto.UserResponseDto;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/admin")
@Slf4j
@io.swagger.v3.oas.annotations.tags.Tag(name = "Admin Controller", description = "Merchant management APIs")
public class AdminController {

	private final userService userService;
	private final categoryService categoryService;
	private final productService productService;

	@Autowired
	public AdminController(userService userService, categoryService categoryService, productService productService) {
		this.userService = userService;
		this.categoryService = categoryService;
		this.productService = productService;
	}
	
	@GetMapping("/index")
	public String index(Model model) {
		String username = "";
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			username = auth.getName();
		}
		model.addAttribute("username", username);
		return "index";			
	}
	
	@GetMapping("login")
	public ModelAndView adminlogin(@RequestParam(required = false) String error) {
	    ModelAndView mv = new ModelAndView("adminlogin");
	    if ("true".equals(error)) {
	        mv.addObject("msg", "Invalid username or password. Please try again.");
	    }
	    return mv;
	}
	
	@GetMapping( value={"/","Dashboard"})
	@io.swagger.v3.oas.annotations.Operation(summary = "Admin Home Dashboard", description = "Display the main admin control panel")
	public ModelAndView adminHome() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    ModelAndView mv = new ModelAndView("adminHome");
		if (auth != null) {
			mv.addObject("admin", auth.getName());
		}
	    return mv;
	}
	
	@GetMapping("categories")
	@io.swagger.v3.oas.annotations.Operation(summary = "Get Categories", description = "List all product categories")
	public ModelAndView getcategory() {
		ModelAndView mView = new ModelAndView("categories");
		List<Category> categories = this.categoryService.getCategories();
		mView.addObject("categories", categories);
		return mView;
	}
	
	@PostMapping("/categories")
	public String addCategory(@RequestParam("categoryname") String category_name)
	{
		log.info("Adding category: {}", category_name);
		
		Category category =  this.categoryService.addCategory(category_name);
		if(category.getName().equals(category_name)) {
			return "redirect:categories";
		}else {
			return "redirect:categories";
		}
	}
	
	@GetMapping("categories/delete")
	public String removeCategoryDb(@RequestParam("id") int id)
	{	
			this.categoryService.deleteCategory(id);
			return "redirect:/admin/categories";
	}
	
	@GetMapping("categories/update")
	public String updateCategory(@RequestParam("categoryid") int id, @RequestParam("categoryname") String categoryname)
	{
		this.categoryService.updateCategory(id, categoryname);
		return "redirect:/admin/categories";
	}

	

	@GetMapping("products")
	@io.swagger.v3.oas.annotations.Operation(summary = "Get All Products", description = "Retrieve a paginated list of all products")
	public ModelAndView getproduct(
			@RequestParam(defaultValue = "1") int page, 
			@RequestParam(defaultValue = "10") int size) {
		ModelAndView mView = new ModelAndView("products");

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
	
	@GetMapping("products/add")
	public ModelAndView addProduct() {
		ModelAndView mView = new ModelAndView("productsAdd");
		List<Category> categories = this.categoryService.getCategories();
		mView.addObject("categories",categories);
		return mView;
	}

	@RequestMapping(value = "products/add",method=RequestMethod.POST)
	public String addProduct(@RequestParam("name") String name,@RequestParam("categoryid") int categoryId ,@RequestParam("price") int price,@RequestParam("weight") int weight, @RequestParam("quantity")int quantity,@RequestParam("description") String description,@RequestParam("productImage") String productImage) {
		log.info("Adding product to category ID: {}", categoryId);
		Category category = this.categoryService.getCategory(categoryId);
		Product product = new Product();
		product.setId(categoryId);
		product.setName(name);
		product.setCategory(category);
		product.setDescription(description);
		product.setPrice(price);
		product.setImage(productImage);
		product.setWeight(weight);
		product.setQuantity(quantity);
		this.productService.addProduct(product);
		return "redirect:/admin/products";
	}

	@GetMapping("products/update/{id}")
	public ModelAndView updateproduct(@PathVariable("id") int id) {
		
		ModelAndView mView = new ModelAndView("productsUpdate");
		Product product = this.productService.getProduct(id);
		List<Category> categories = this.categoryService.getCategories();

		mView.addObject("categories",categories);
		mView.addObject("product", product);
		return mView;
	}
	
	@RequestMapping(value = "products/update/{id}",method=RequestMethod.POST)
	public String updateProduct()
	{
		return "redirect:/admin/products";
	}
	
	@GetMapping("products/delete")
	public String removeProduct(@RequestParam("id") int id)
	{
		this.productService.deleteProduct(id);
		return "redirect:/admin/products";
	}
	
	@PostMapping("products")
	public String postproduct() {
		return "redirect:/admin/categories";
	}
	
	@GetMapping("customers")
	public ModelAndView getCustomerDetail() {
		ModelAndView mView = new ModelAndView("displayCustomers");
		List<User> users = this.userService.getUsers();
		
		List<UserResponseDto> userDtos = users.stream().map(user -> {
			UserResponseDto dto = new UserResponseDto();
			dto.setId(user.getId());
			dto.setUsername(user.getUsername());
			dto.setEmail(user.getEmail());
			dto.setAddress(user.getAddress());
			dto.setRole(user.getRole());
			return dto;
		}).collect(java.util.stream.Collectors.toList());

		mView.addObject("customers", userDtos);
		return mView;
	}
	
	
	@GetMapping("profileDisplay")
	public String profileDisplay(Model model) {
		String username = "";
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			username = auth.getName();
		}
		User user = userService.getUserByUsername(username);
		
		if (user != null) {
			model.addAttribute("userid", user.getId());
			model.addAttribute("username", user.getUsername());
			model.addAttribute("email", user.getEmail());
			model.addAttribute("password", user.getPassword());
			model.addAttribute("address", user.getAddress());
		}
		log.info("Hello");
		return "updateProfile";
	}
	
	@RequestMapping(value = "updateuser",method=RequestMethod.POST)
	public String updateUserProfile(@RequestParam("userid") int userid,@RequestParam("username") String username, @RequestParam("email") String email, @RequestParam("password") String password, @RequestParam("address") String address) 
	{
		User user = userService.getUserByUsername(username);
		if (user != null) {
			user.setUsername(username);
			user.setEmail(email);
			user.setAddress(address);
			userService.addUser(user); 
			
			Authentication newAuthentication = new UsernamePasswordAuthenticationToken(
		            username,
		            user.getPassword(),
		            SecurityContextHolder.getContext().getAuthentication().getAuthorities());

		    SecurityContextHolder.getContext().setAuthentication(newAuthentication);
		}
		return "redirect:index";
	}

}
