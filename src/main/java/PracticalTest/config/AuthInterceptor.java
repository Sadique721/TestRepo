package PracticalTest.config;

import PracticalTest.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        String path = request.getRequestURI();

        // Allow access to login, signup, and static resources without authentication
        if (user == null && !path.equals("/login") && !path.equals("/signup") && !path.startsWith("/css/")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        // Admin only paths
        if (path.startsWith("/admin") && (user == null || !"ADMIN".equals(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        // User only paths
        if (path.startsWith("/user") && (user == null || !"USER".equals(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}