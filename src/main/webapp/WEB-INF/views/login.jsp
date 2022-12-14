<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<head>
    <title>TMS</title>
    <link rel="stylesheet" href="static/css/bootstrap.min.css">
    <link rel="stylesheet" href="static/css/sweetalert2.min.css">
    <link rel="shortcut icon" href="static/images/favicon.ico" type="image/x-icon">
    <script src="static/js/common/common.js"></script>
    <script src="static/js/lib/jquery-3.6.0.min.js"></script>
    <script src="static/js/lib/bootstrap.min.js"></script>
    <script src="static/js/lib/sweetalert2.min.js"></script>
</head>

<style>
    body {
        background-color: #EDF2F8;
        font-family: 'Noto Sans KR', sans-serif;
    }
    #div1{
        width: 400px; height: 410px;
    }
    .emoji{
        width:300px; margin: 35px auto;
    }
    #id{
        width:300px; height:50px; margin: 0 auto 5px;
    }
    #password{
        width:300px; height:50px; margin: 0 auto 5px;
    }
    #loginBtn{
        width:300px;
    }
    .remember {
        display: flex;
        margin-left: 50px;
    }
    .remember label {
        padding-left: 10px;
    }

    @media all and  (max-width:1024px) {
        #div1{width: 100%;height: 100%;overflow: auto;}
        .emoji{width: 90%;margin: 100px auto;}
        #id{width: 80%;height: 150px; margin: 20px auto 100px;font-size: 3rem;}
        #password{width: 80%;height: 150px;;margin: 20px auto 100px;font-size: 3rem;}
        #loginBtn{width: 80%;height: 130px;}
        #join{font-size: 3rem;margin-bottom: 100px;}
        #btnFont{font-size: 3rem;}
        #btnDiv{margin-top: 25%;margin-bottom: 50px;}
        .remember {margin-left: 100px;}
        .remember input {width: 3rem; height: 3rem; margin-top: 8px;}
        .remember label {font-size: 2.6rem; padding-left: 15px;}

        .swal2-popup{width: 48rem;}
        #swal2-content{font-size: 2rem;}
        #swal2-title{font-size: 3rem;}
        .swal2-actions button{width: 230px;font-size: 2rem!important;height:80px; }
    }


</style>

<body>
<div class="container" id="container">
            <div class=" w-100 d-flex justify-content-center text-center" style="height: 100%;">
                <div class="align-self-center bg-white " id="div1">
                    <img src="static/images/LXlogo.png" class="emoji">
                    <form method='post' name='loginFrom' value='admin'>
                        <div class="">
                            <input class="form-control" type='text' name='username' value='' id="id" placeholder="?????????"  onkeyup="enterkey()" autocomplete="off">
                        </div>
                        <div class="">
                            <input class="form-control" type='password' name='password' value='' id="password" placeholder="????????????" onkeyup="enterkey()">
                        </div>
                        <div class="form-group form-check remember">
                            <input type="checkbox" class="form-check-input" id="rememberMe" name="remember-me" checked>
                            <label class="form-check-label" for="rememberMe" aria-describedby="rememberMeHelp">?????? ?????????</label>
                        </div>
                        <div id="btnDiv">
                            <button type="button" class="btn btn-primary fs-4 px-5" onclick="login()" id="loginBtn" style="margin-top: 2rem;"><font id="btnFont">?????????</font></button>
                        </div>
                        <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
                    </form>

                    <a class="text-decoration-none " href="<%=cp%>/memberJoin" id="join">????????????</a>
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
                        $("#id").val("").focus();
                        $("#password").val("").focus();
                        swal('????????? ??????','???????????? ?????? ??????????????????.');
                    } else if (data == "password") {
                        $("#password").val("").focus();
                        swal('????????? ??????','??????????????? ????????????. ?????? ??????????????????.');
                    } else if(data == "waiting"){
                        swal('????????? ??????','???????????? ???????????? ???????????????.');
                    } else if(data == "denie"){
                        swal('????????? ??????','??????????????? ????????? ???????????????.');
                    }else{
                        login_from.submit();
                        inputLog($("#id").val(), "?????????", "??????");
                    }
                },
                error : function(request, status, error) {
                    console.log('login error');
                    console.log(error);
                }
            })
        }else{
            swal('??????','????????? ??? ??????????????? ??????????????????.');
        }
    }

    function swal(title, text){
        Swal.fire({
            icon: 'warning',
            title: title,
            text: text
        })
    }
</script>






