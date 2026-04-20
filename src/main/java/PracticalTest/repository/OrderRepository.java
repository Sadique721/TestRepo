package PracticalTest.repository;

import PracticalTest.entity.Order;
import PracticalTest.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByCustomer(Customer customer);
}