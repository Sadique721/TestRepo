package PracticalTest.controller;

import PracticalTest.entity.Customer;
import PracticalTest.entity.User;
import PracticalTest.repository.CustomerRepository;
import PracticalTest.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class SignupController {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private CustomerRepository customerRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/signup")
    public String showSignupForm(Model model) {
        return "signup";
    }

    @PostMapping("/signup")
    public String registerUser(@RequestParam String username,
                               @RequestParam String password,
                               @RequestParam String role,
                               @RequestParam(required = false) String custName,
                               @RequestParam(required = false) String custEmail,
                               @RequestParam(required = false) String custPhone,
                               @RequestParam(required = false) String custAddress,
                               RedirectAttributes redirectAttributes) {

        // Check if username already exists
        if (userRepository.findByUsername(username).isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Username already taken!");
            return "redirect:/signup";
        }

        // Encrypt password
        String encodedPassword = passwordEncoder.encode(password);

        // Create user
        User user = new User();
        user.setUsername(username);
        user.setPassword(encodedPassword);
        user.setRole(role);

        // If role is USER, we need a Customer
        if ("USER".equals(role)) {
            if (custName == null || custName.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Customer name is required for USER role");
                return "redirect:/signup";
            }
            Customer customer = new Customer();
            customer.setCustName(custName);
            customer.setEmail(custEmail != null ? custEmail : "");
            customer.setPhone(custPhone != null ? custPhone : "");
            customer.setAddress(custAddress != null ? custAddress : "");
            // Save customer first
            customer = customerRepository.save(customer);
            user.setCustomer(customer);
        } else {
            // Admin has no customer link
            user.setCustomer(null);
        }

        userRepository.save(user);
        redirectAttributes.addFlashAttribute("success", "Registration successful! Please login.");
        return "redirect:/login";
    }
}