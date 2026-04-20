<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head><title>My Orders</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body>
    <jsp:include page="/WEB-INF/views/user/header.jsp" />
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>My Orders</h2>
            <a href="${pageContext.request.contextPath}/user/orders/new" class="btn btn-success">Place New Order</a>
        </div>
        <table class="table table-bordered">
            <thead>
                <tr><th>Order ID</th><th>Date</th><th>Total</th><th>Items</th><th>Action</th></tr>
            </thead>
            <tbody>
                <c:forEach items="${orders}" var="order">
                    <tr>
                        <td>${order.orderId}</td>
                        <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>${order.totalAmount}</td>
                        <td>
                            <ul>
                            <c:forEach items="${order.orderItems}" var="item">
                                <li>${item.product.productName} x ${item.quantity} = ${item.subtotal}</li>
                            </c:forEach>
                            </ul>
                        </td>
                        <td><a href="${pageContext.request.contextPath}/user/orders/delete/${order.orderId}" class="btn btn-sm btn-danger" onclick="return confirm('Delete order? Stock will be restored.')">Delete</a></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>