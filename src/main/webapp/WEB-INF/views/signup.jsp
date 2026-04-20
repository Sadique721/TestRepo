<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function toggleCustomerFields() {
            var role = document.getElementById("role").value;
            var customerDiv = document.getElementById("customerFields");
            if (role === "USER") {
                customerDiv.style.display = "block";
            } else {
                customerDiv.style.display = "none";
            }
        }
    </script>
</head>
<body class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <h2>Create New Account</h2>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/signup">
                <div class="mb-3">
                    <label>Username</label>
                    <input type="text" name="username" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Role</label>
                    <select name="role" id="role" class="form-select" onchange="toggleCustomerFields()" required>
                        <option value="ADMIN">Admin</option>
                        <option value="USER">User (Customer)</option>
                    </select>
                </div>
                <div id="customerFields" style="display: none;">
                    <div class="mb-3">
                        <label>Customer Name</label>
                        <input type="text" name="custName" class="form-control" />
                    </div>
                    <div class="mb-3">
                        <label>Email</label>
                        <input type="email" name="custEmail" class="form-control" />
                    </div>
                    <div class="mb-3">
                        <label>Phone</label>
                        <input type="text" name="custPhone" class="form-control" />
                    </div>
                    <div class="mb-3">
                        <label>Address</label>
                        <input type="text" name="custAddress" class="form-control" />
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Register</button>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Cancel</a>
            </form>
            <p class="mt-3">Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
        </div>
    </div>
    <script>
        // Initial check
        toggleCustomerFields();
    </script>
</body>
</html>