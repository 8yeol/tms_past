<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<body>
<div class="d-flex justify-content-center">
    <div>
        <h1 class="mt-5">권한이 없습니다</h1>
        <a class="text-decoration-none d-flex justify-content-center mt-5 fs-3" href="/logout">로그아웃</a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>







