<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="stylesheet" href="static/css/bootstrap.min.css">
<link rel="stylesheet" href="static/css/common.css">
<script src="static/js/jquery-3.6.0.min.js"></script>
<script src="static/js/bootstrap.min.js"></script>

<body class="bg-secondary">

<div class="container">
    <div class="bg-white p-5 d-flex justify-content-center text-center mt-5 rounded">
        <div>
            <h1 class="py-5 fw-bold">Login</h1>
            <form method='post' name='username' value='admin'>
                <div class="">
                    <p class="text-start text-secondary fs-4 fw-bold">아이디</p>
                    <input class="form-control" type='text' name='username' value='' id="id">
                </div>
                <div class="">
                    <p class="text-start text-secondary fs-4 fw-bold mt-3">비밀번호</p>
                    <input class="form-control" type='password' name='password' value='' id="password">
                </div>
                <div>
                    <input class="btn btn-primary mt-5 fs-3 px-5" onclick="login()" type='submit' value="로그인">
                </div>
                <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
            </form>

            <a class="text-decoration-none " href="/memberJoin">회원가입</a>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>

<script>
    function login() {

        if ($("#id").val() != "" && $("#password").val() != "") {
            var settings = {
                "url": "http://localhost:8090/loginCheck",
                "method": "POST",
                "timeout": 0,
                "headers": {
                    "accept": "application/json",
                    "content-type": "application/json;charset=UTF-8"
                },
                "data": "{\r\n    \"id\": \"" + $("#id").val() + "\",\r\n    \"password\": \"" + $("#password").val() + "\"\r\n}",
            };
            $.ajax(settings).done(function (response) {
                if (response == "id") {
                    alert("아이디가 틀립니다.");
                    location.reload();
                } else if (response == "password") {
                    alert("비밀번호가 틀립니다.");
                    location.reload();
                }
            });
        } else {
            alert("빈칸없이 입력하여 주세요");
        }
    }
</script>






