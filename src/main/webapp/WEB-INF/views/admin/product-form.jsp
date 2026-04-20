<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Product Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div class="container mt-4">
        <h2><c:if test="${product.productId == null}">New</c:if><c:if test="${product.productId != null}">Edit</c:if> Product</h2>
        <form method="post" action="${pageContext.request.contextPath}/admin/products/save">
            <input type="hidden" name="productId" value="${product.productId}"/>
            <div class="mb-3"><label>Name</label><input type="text" name="productName" value="${product.productName}" class="form-control" required/></div>
            <div class="mb-3"><label>Price</label><input type="number" step="0.01" name="price" value="${product.price}" class="form-control" required/></div>
            <div class="mb-3"><label>Stock Quantity</label><input type="number" name="stockQuantity" value="${product.stockQuantity}" class="form-control" required/></div>
            <button type="submit" class="btn btn-primary">Save</button>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>