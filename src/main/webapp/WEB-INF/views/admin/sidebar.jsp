<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<div class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="position-sticky pt-3">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/customers') ? 'active fw-bold' : ''}" 
                   href="${pageContext.request.contextPath}/admin/customers"> Customers</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/products') ? 'active fw-bold' : ''}" 
                   href="${pageContext.request.contextPath}/admin/products"> Products</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/orders') ? 'active fw-bold' : ''}" 
                   href="${pageContext.request.contextPath}/admin/orders"> All Orders</a>
            </li>
        </ul>
    </div>
</div>