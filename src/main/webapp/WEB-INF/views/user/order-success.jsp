<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Order Success</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/WEB-INF/views/user/header.jsp" />
    <div class="container mt-4">
        <div class="alert alert-success">
            <h3>🎉 Order Placed Successfully!</h3>
            <p>Your order ID is: <strong>${orderId}</strong></p>
            <p>Order Date: <fmt:formatDate value="${orderDate}" pattern="yyyy-MM-dd HH:mm"/></p>
            <p>Total Amount: ₹${totalAmount}</p>
        </div>
        <h4>Order Items:</h4>
        <table class="table table-bordered">
            <thead>
                <tr><th>Product</th><th>Quantity</th><th>Subtotal</th></tr>
            </thead>
            <tbody>
                <c:forEach items="${orderItems}" var="item">
                    <tr>
                        <td>${item.productName}</td>
                        <td>${item.quantity}</td>
                        <td>${item.subtotal}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <a href="${pageContext.request.contextPath}/user/orders" class="btn btn-primary">View My Orders</a>
    </div>
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>