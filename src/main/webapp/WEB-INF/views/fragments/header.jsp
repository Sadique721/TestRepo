<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <c:choose>
                <c:when test="${sessionScope.loggedUser.role == 'ADMIN'}">Admin Dashboard</c:when>
                <c:otherwise>Customer Portal</c:otherwise>
            </c:choose>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <span class="nav-link">Welcome, ${sessionScope.loggedUser.username}</span>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-outline-light" href="${pageContext.request.contextPath}/logout">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>