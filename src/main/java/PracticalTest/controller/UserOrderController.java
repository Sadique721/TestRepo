package PracticalTest.controller;

import PracticalTest.entity.*;
import PracticalTest.repository.*;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/user/orders")
public class UserOrderController {

    @Autowired
    private OrderRepository orderRepository;
    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private UserRepository userRepository;

    // ======================= Helper =======================
    private Customer getLoggedCustomer(HttpSession session) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || user.getCustomer() == null) {
            throw new RuntimeException("No customer linked to this user");
        }
        return user.getCustomer();
    }

    // ======================= Existing Methods =======================
    @GetMapping
    public String listMyOrders(HttpSession session, Model model) {
        Customer customer = getLoggedCustomer(session);
        model.addAttribute("orders", orderRepository.findByCustomer(customer));
        return "user/orders";
    }

    @GetMapping("/new")
    public String showOrderForm(Model model) {
        model.addAttribute("products", productRepository.findAll());
        return "user/order-form";
    }

    // Original createOrder method – kept for backward compatibility (but can be removed)
    @PostMapping("/create")
    @Transactional
    public String createOrder(@RequestParam(value = "productId", required = false) List<Long> productIds,
                              @RequestParam(value = "quantity", required = false) List<Integer> quantities,
                              HttpSession session, RedirectAttributes redirectAttributes) {
        if (productIds == null || productIds.isEmpty() || quantities == null) {
            redirectAttributes.addFlashAttribute("error", "No products available. Please add products first.");
            return "redirect:/user/orders/new";
        }
        Customer customer = getLoggedCustomer(session);
        Order order = new Order();
        order.setCustomer(customer);
        order.setOrderDate(new Date());   // FIXED: LocalDateTime → Date

        double total = 0.0;
        boolean anyItem = false;
        for (int i = 0; i < productIds.size(); i++) {
            Long productId = productIds.get(i);
            Integer qty = (i < quantities.size()) ? quantities.get(i) : 0;
            if (qty == null || qty <= 0) continue;

            Product product = productRepository.findById(productId)
                    .orElseThrow(() -> new RuntimeException("Product not found"));
            if (product.getStockQuantity() < qty) {
                redirectAttributes.addFlashAttribute("error", "Insufficient stock for: " + product.getProductName());
                return "redirect:/user/orders/new";
            }
            product.setStockQuantity(product.getStockQuantity() - qty);
            productRepository.save(product);

            OrderItem item = new OrderItem();
            item.setProduct(product);
            item.setQuantity(qty);
            double subtotal = product.getPrice() * qty;
            item.setSubtotal(subtotal);
            total += subtotal;
            order.addOrderItem(item);
            anyItem = true;
        }
        if (!anyItem) {
            redirectAttributes.addFlashAttribute("error", "Please select at least one product with quantity > 0");
            return "redirect:/user/orders/new";
        }
        order.setTotalAmount(total);
        orderRepository.save(order);
        return "redirect:/user/orders";
    }

    @GetMapping("/delete/{orderId}")
    @Transactional
    public String deleteOrder(@PathVariable Long orderId, HttpSession session) {
        Customer customer = getLoggedCustomer(session);
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        if (!order.getCustomer().getCustId().equals(customer.getCustId())) {
            throw new RuntimeException("Unauthorized");
        }
        for (OrderItem item : order.getOrderItems()) {
            Product product = item.getProduct();
            product.setStockQuantity(product.getStockQuantity() + item.getQuantity());
            productRepository.save(product);
        }
        orderRepository.delete(order);
        return "redirect:/user/orders";
    }

    // ======================= New Enhanced Order Flow =======================
    // DTO for temporary storage in session
    public static class TempOrderItem {
        private Long productId;
        private String productName;
        private Double price;
        private Integer quantity;
        private Double subtotal;

        // Getters and Setters
        public Long getProductId() { return productId; }
        public void setProductId(Long productId) { this.productId = productId; }
        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }
        public Double getPrice() { return price; }
        public void setPrice(Double price) { this.price = price; }
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
        public Double getSubtotal() { return subtotal; }
        public void setSubtotal(Double subtotal) { this.subtotal = subtotal; }
    }

    @PostMapping("/prepare")
    public String prepareOrder(@RequestParam("productId") List<Long> productIds,
                               @RequestParam("quantity") List<Integer> quantities,
                               HttpSession session, RedirectAttributes redirectAttributes) {
        if (productIds == null || productIds.isEmpty() || quantities == null) {
            redirectAttributes.addFlashAttribute("error", "Please add at least one product.");
            return "redirect:/user/orders/new";
        }
        List<TempOrderItem> tempItems = new ArrayList<>();
        double total = 0.0;
        for (int i = 0; i < productIds.size(); i++) {
            Long pid = productIds.get(i);
            Integer qty = quantities.get(i);
            if (pid == null || qty == null || qty <= 0) continue;
            Product product = productRepository.findById(pid).orElse(null);
            if (product == null) {
                redirectAttributes.addFlashAttribute("error", "Product not found.");
                return "redirect:/user/orders/new";
            }
            if (product.getStockQuantity() < qty) {
                redirectAttributes.addFlashAttribute("error", "Insufficient stock for " + product.getProductName());
                return "redirect:/user/orders/new";
            }
            TempOrderItem item = new TempOrderItem();
            item.setProductId(pid);
            item.setProductName(product.getProductName());
            item.setPrice(product.getPrice());
            item.setQuantity(qty);
            double subtotal = product.getPrice() * qty;
            item.setSubtotal(subtotal);
            tempItems.add(item);
            total += subtotal;
        }
        if (tempItems.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "No valid items selected.");
            return "redirect:/user/orders/new";
        }
        session.setAttribute("tempOrderItems", tempItems);
        session.setAttribute("tempOrderTotal", total);
        return "user/order-confirm";
    }

    @PostMapping("/finalize")
    @Transactional
    public String finalizeOrder(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        @SuppressWarnings("unchecked")
        List<TempOrderItem> tempItems = (List<TempOrderItem>) session.getAttribute("tempOrderItems");
        Double total = (Double) session.getAttribute("tempOrderTotal");
        if (tempItems == null || tempItems.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "No order data found. Please start over.");
            return "redirect:/user/orders/new";
        }
        Customer customer = getLoggedCustomer(session);
        Order order = new Order();
        order.setCustomer(customer);
        order.setOrderDate(new Date());
        order.setTotalAmount(total);

        for (TempOrderItem temp : tempItems) {
            Product product = productRepository.findById(temp.getProductId()).orElseThrow();
            // reduce stock
            product.setStockQuantity(product.getStockQuantity() - temp.getQuantity());
            productRepository.save(product);
            OrderItem item = new OrderItem();
            item.setProduct(product);
            item.setQuantity(temp.getQuantity());
            item.setSubtotal(temp.getSubtotal());
            order.addOrderItem(item);
        }
        order = orderRepository.save(order);

        // Prepare data for success page
        model.addAttribute("orderId", order.getOrderId());
        model.addAttribute("orderDate", order.getOrderDate());
        model.addAttribute("totalAmount", order.getTotalAmount());
        model.addAttribute("orderItems", tempItems);

        // Clear session temp data
        session.removeAttribute("tempOrderItems");
        session.removeAttribute("tempOrderTotal");

        return "user/order-success";
    }
}