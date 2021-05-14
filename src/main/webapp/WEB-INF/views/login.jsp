<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="stylesheet" href="static/css/bootstrap.min.css">
<link rel="stylesheet" href="static/css/common.css">
<link rel="shortcut icon" href="#">
<script src="static/js/common/common.js"></script>
<script src="static/js/jquery-3.6.0.min.js"></script>
<script src="static/js/bootstrap.min.js"></script>

<style>
    body {
        background-color: #EDF2F8;
        font-family: 'Noto Sans KR', sans-serif;
    }
    #id, #password {
        height: 50px;
        margin-bottom: 5px;
    }
</style>

<body>
<div class="container">
    <div class="row h-100">
        <div class="col h-100 align-self-center">
            <div class="h-100 d-flex justify-content-center text-center">
                <div class="align-self-center">
                    <img src="static/images/logo.png" class="emoji" style="width:300px; margin-bottom: 30px;">
<%--                    <h1 class="py-5 fw-bold">Login</h1>--%>
                    <form method='post' name='username' value='admin'>
                        <div class="">
<%--                            <p class="text-start text-secondary fs-4 fw-bold">아이디</p>--%>
                            <input class="form-control" type='text' name='username' value='' id="id" placeholder="아이디">
                        </div>
                        <div class="">
<%--                            <p class="text-start text-secondary fs-4 fw-bold mt-3">비밀번호</p>--%>
                            <input class="form-control" type='password' name='password' value='' id="password" placeholder="비밀번호">
                        </div>
                        <div>
                            <input class="btn btn-primary mt-5 fs-4 px-5" onclick="login()" type='submit' value="로그인" style="width:300px;">
                        </div>
                        <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
                    </form>

                    <a class="text-decoration-none " href="/memberJoin">회원가입</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    function login() {
        if ($("#id").val() != "" && $("#password").val() != "") {
            var settings = {``
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
                if(response == "id") {
                    alert("아이디가 존재하지 않습니다.");
                    location.reload();
                } else if (response == "password") {
                    alert("비밀번호가 틀립니다");
                    location.reload();
                } else {
                    inputLog($("#id").val(), "로그인", "로그인");
                }
            });
        } else {
            alert("빈칸없이 입력하여 주세요");
        }
    }
</script>






