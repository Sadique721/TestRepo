<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Create Order</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function addProductRow() {
            const container = document.getElementById("productRows");
            const originalRow = document.querySelector("#productRows .row");
            if (!originalRow) return;
            const newRow = originalRow.cloneNode(true);
            const select = newRow.querySelector("select");
            if (select) select.selectedIndex = 0;
            const qtyInput = newRow.querySelector("input[name='quantity']");
            if (qtyInput) qtyInput.value = "";
            const actionDiv = newRow.querySelector(".col-md-2");
            if (actionDiv && actionDiv.children.length === 0) {
                const removeBtn = document.createElement("button");
                removeBtn.type = "button";
                removeBtn.className = "btn btn-danger btn-sm";
                removeBtn.textContent = "Remove";
                removeBtn.onclick = function() { newRow.remove(); };
                actionDiv.appendChild(removeBtn);
            }
            container.appendChild(newRow);
        }
    </script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/user/header.jsp" />
    <div class="container mt-4">
        <h2>Create New Order</h2>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${empty products}">
            <div class="alert alert-warning">No products available. Please contact admin.</div>
        </c:if>
        <form method="post" action="${pageContext.request.contextPath}/user/orders/prepare">
            <div id="productRows">
                <div class="row mb-2 align-items-center">
                    <div class="col-md-5">
                        <select name="productId" class="form-select" required>
                            <option value="">-- Select Product --</option>
                            <c:forEach items="${products}" var="p">
                                <option value="${p.productId}">${p.productName} (Rs${p.price}, Stock: ${p.stockQuantity})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <input type="number" name="quantity" class="form-control" placeholder="Quantity" min="1" required>
                    </div>
                    <div class="col-md-2"></div>
                </div>
            </div>
            <button type="button" class="btn btn-secondary mb-3" onclick="addProductRow()">+ Add Another Product</button>
            <br>
            <button type="submit" class="btn btn-primary">Review Order</button>
            <a href="${pageContext.request.contextPath}/user/orders" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>