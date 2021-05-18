<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<link rel="stylesheet" href="static/css/bootstrap.min.css">
<link rel="stylesheet" href="static/css/common.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="shortcut icon" href="#">
<script src="static/js/common/common.js"></script>
<script src="static/js/jquery-3.6.0.min.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/sweetalert2.min.js"></script>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

<style>
    body {
        background-color: #EDF2F8;
        font-family: 'Noto Sans KR', sans-serif;
    }
</style>

<body>
<div class="container">
    <div class="row h-100">
        <div class="col h-100 align-self-center">
            <div class="h-100 d-flex justify-content-center text-center">
                <div class="align-self-center bg-white" style="width: 400px; height: 410px;">
                    <img src="static/images/logo.png" class="emoji" style="width:300px; margin: 20px auto;">
                    <form method='post' name='loginFrom' value='admin'>
                        <div class="">
                            <input class="form-control" type='text' name='username' value='' id="id" placeholder="아이디" style="width:300px; height:50px; margin: 0 auto 5px;" onkeyup="enterkey()">
                        </div>
                        <div class="">
                            <input class="form-control" type='password' name='password' value='' id="password" placeholder="비밀번호" style="width:300px; height:50px; margin: 0 auto 5px;" onkeyup="enterkey()">
                        </div>
                        <div>
                            <button type="button" class="btn btn-primary mt-5 fs-4 px-5" onclick="login()" style="width:300px;">로그인</button>
                        </div>
                        <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
                    </form>

                    <a class="text-decoration-none " href="<%=cp%>/memberJoin">회원가입</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    function enterkey() {
        if (window.event.keyCode == 13) {
            login();
        }
    }

    function login() {
        const login_from = document.loginFrom;
        const id = $("#id").val();
        const pw = $("#password").val();
        if(id != "" && pw != ""){
            $.ajax({
                url: '<%=cp%>/loginCheck',
                type: 'POST',
                dataType: 'text',
                async: false,
                cache: false,
                data: { "id" : id,
                    "password" : pw },
                success : function(data) {
                    if(data == "id") {
                        Swal.fire({
                            icon: 'warning',
                            title: '로그인 오류',
                            text: '등록되지 않은 아이디입니다.',
                            timer: 1500
                        })
                    } else if (data == "password") {
                        Swal.fire({
                            icon: 'warning',
                            title: '로그인 오류',
                            text: '비밀번호가 틀립니다. 다시 확인해주세요.',
                            timer: 1500
                        })
                        $("#password").text("");
                        document.getElementById("password").focus();
                    } else if(data == "waiting"){
                        Swal.fire({
                            icon: 'warning',
                            title: '로그인 오류',
                            text: '가입신청 대기중인 회원입니다.',
                            timer: 1500
                        })
                    } else if(data == "denie"){
                        Swal.fire({
                            icon: 'warning',
                            title: '로그인 오류',
                            text: '가입신청이 거절된 회원입니다.',
                            timer: 1500
                        })
                    }else{
                        login_from.submit();
                        inputLog($("#id").val(), "로그인", "로그인");
                    }
                },
                error : function(request, status, error) {
                    console.log('get place sensor error');
                    console.log(error);
                }
            })
        }else{
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '아이디 및 패스워드를 입력해주세요.',
                timer: 1500
            })
        }
    }
</script>






