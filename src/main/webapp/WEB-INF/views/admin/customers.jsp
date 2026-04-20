<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head><title>Customers</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h2>Customer List</h2>
                    <a href="${pageContext.request.contextPath}/admin/customers/new" class="btn btn-primary">Add Customer</a>
                </div>
                <table class="table table-bordered">
                    <thead>
                        <tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Address</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${customers}" var="c">
                            <tr>
                                <td>${c.custId}</td>
                                <td>${c.custName}</td>
                                <td>${c.email}</td>
                                <td>${c.phone}</td>
                                <td>${c.address}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/customers/edit/${c.custId}" class="btn btn-sm btn-warning">Edit</a>
                                    <a href="${pageContext.request.contextPath}/admin/customers/delete/${c.custId}" class="btn btn-sm btn-danger" onclick="return confirm('Delete?')">Delete</a>
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