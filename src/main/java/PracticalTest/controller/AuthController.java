package PracticalTest.controller;

import PracticalTest.entity.User;
import PracticalTest.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {

        // Validate input
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            model.addAttribute("error", "Username and password are required");
            return "login";
        }

        User user = userRepository.findByUsername(username.trim()).orElse(null);
        if (user == null) {
            logger.warn("Failed login attempt for username: {}", username);
            model.addAttribute("error", "Invalid credentials");
            return "login";
        }

        // Check if account is active
        if (!user.isActive()) {
            logger.warn("Inactive account login attempt: {}", username);
            model.addAttribute("error", "Your account is deactivated. Please contact support.");
            return "login";
        }

        // Verify password using BCrypt
        if (!passwordEncoder.matches(password, user.getPassword())) {
            logger.warn("Invalid password for username: {}", username);
            model.addAttribute("error", "Invalid credentials");
            return "login";
        }

        // Login success
        session.setAttribute("loggedUser", user);
        session.setAttribute("lastLoginTime", new java.util.Date());
        logger.info("User logged in successfully: {}", username);

        if ("ADMIN".equals(user.getRole())) {
            return "redirect:/admin/customers";
        } else {
            return "redirect:/user/orders";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}