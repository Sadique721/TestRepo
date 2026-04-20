<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Customer Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div class="container mt-4">
        <h2><c:if test="${customer.custId == null}">New</c:if><c:if test="${customer.custId != null}">Edit</c:if> Customer</h2>
        <form method="post" action="${pageContext.request.contextPath}/admin/customers/save">
            <input type="hidden" name="custId" value="${customer.custId}"/>
            <div class="mb-3"><label>Name</label><input type="text" name="custName" value="${customer.custName}" class="form-control" required/></div>
            <div class="mb-3"><label>Email</label><input type="email" name="email" value="${customer.email}" class="form-control" required/></div>
            <div class="mb-3"><label>Phone</label><input type="text" name="phone" value="${customer.phone}" class="form-control"/></div>
            <div class="mb-3"><label>Address</label><input type="text" name="address" value="${customer.address}" class="form-control"/></div>
            <button type="submit" class="btn btn-primary">Save</button>
            <a href="${pageContext.request.contextPath}/admin/customers" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>