<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head><title>All Orders</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="pt-3 pb-2 mb-3 border-bottom">
                    <h2>All Orders (Admin)</h2>
                </div>
                <table class="table table-bordered">
                    <thead>
                        <tr><th>Order ID</th><th>Customer</th><th>Date</th><th>Total</th><th>Items</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${orders}" var="order">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>${order.customer.custName}</td>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>${order.totalAmount}</td>
                                <td>
                                    <ul>
                                    <c:forEach items="${order.orderItems}" var="item">
                                        <li>${item.product.productName} x ${item.quantity} = ${item.subtotal}</li>
                                    </c:forEach>
                                    </ul>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </main>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>