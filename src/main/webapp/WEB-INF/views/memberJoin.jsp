<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="static/css/bootstrap.min.css">
<link rel="stylesheet" href="static/css/jqueryui-1.12.1.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="shortcut icon" href="#">
<script src="static/js/common/common.js"></script>
<script src="static/js/jquery-3.6.0.min.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/jquery-ui.js"></script>
<script src="static/js/sweetalert2.min.js"></script>
<script src="static/js/common/member.js"></script>

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
    .join>div input {
        height: 40px;
    }
    @media all and (min-width:1981px) {
        .join-bg {position: relative; top:12%;}
    }

    @media all and (max-width:990px) {
        .join-bg {position: relative; top: 15%;}
    }
</style>

<div class="container h-100">
    <div class="row bg-white join-bg">
        <span class="fs-1 text-center" style="margin: 15px 0px 0px;">회원가입</span>
        <div class="col join" style="padding: 2rem;">

            <div class="mb-3" style="width: 48%; margin: 0 auto;">
                <label for="id" class="col-form-label">아이디</label>
                <div class="col-sm-10" style="width:100%;">
                    <input type="text" class="form-control" id="id">
                </div>
            </div>
            <div class="mb-3" style="width: 48%; margin: 0 auto;">
                <div class="row">
                    <div class="col">
                        <label for="password" class="col-form-label">비밀번호</label>
                    </div>
                </div>
                <div class="col-sm-10 d-flex" style="width:100%;">
                    <input type="password" class="form-control" id="password" onkeyup="passwordCheckMsg()" placeholder="6자 이상 입력해 주세요">
                </div>

                <div class="col mt-1" style="height: 10px">
                    <span style="font-size: 15%; color: red" id="passwordText"></span>
                </div>
            </div>

            <div class="mb-3" style="width: 48%; margin: 0 auto;">
                <div class="row">
                    <div class="col">
                        <label for="passwordCheck" class="col-form-label">비밀번호 확인</label>
                    </div>
                </div>
                <div class="col-sm-10" style="width:100%;">
                    <input type="password" class="form-control" id="passwordCheck" onkeyup="passwordCheckMsg()">
                </div>
                <div class="col mt-1" style="height: 8px">
                    <span style="font-size: 15%; color: red" id="passwordCheckText"></span>
                </div>
            </div>

            <div class="mb-3" style="width: 48%; margin: 0 auto;">
                <label for="name" class="col-form-label">이름</label>
                <div class="col-sm-10" style="width:100%;">
                    <input type="text" class="form-control" id="name">
                </div>
            </div>

            <div class="mb-3" style="width: 48%; margin: 0 auto;">
                <label for="email" class="col-form-label">이메일</label>
                <div class="col-sm-10" style="width:100%;">
                    <input type="text" class="form-control" id="email" onkeyup="autoEmail('email',this.value)">
                </div>
            </div>

            <div class="mb-3" style="width: 48%; margin: 0 auto;">
                <label for="tel" class="col-form-label">연락처</label>
                <div class="col-sm-10" style="width:100%;">
                    <input type="text" class="form-control" id="tel" onkeyup="inputPhoneNumber(this)">
                </div>
            </div>

            <div class="mb-3" style="width: 48%; margin: 0 auto;">
                <label for="department" class="col-form-label">부서명</label>
                <div class="col-sm-10" style="width:100%;">
                    <input type="text" class="form-control" id="department">
                </div>
            </div>

            <div class="mb-3" style="width: 48%; margin: 0 auto;">
                <label for="grade" class="col-form-label">직급</label>
                <div class="col-sm-10" style="width:100%;">
                    <input type="text" class="form-control" id="grade">
                </div>
            </div>

            <div class="row">
                <div class="col text-center">
                    <button type="submit" class="btn btn-primary px-5 py-2 w-auto h-auto mt-3" onclick="join_submit()">가입신청</button>
                    <button class="btn btn-outline-primary px-5 py-2 w-auto h-auto mt-3 ms-5" onClick="location.href='<%=cp%>/login'">취소</button>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    function join_submit() {
        if (blankCheck() && passwordCheck() && emailCheck()) {

            if($("#password").val() !== $("#passwordCheck").val()){
                $("#password").focus();
                swal('warning', '비밀번호를 확인 하세요.');
                return;
            }

            $.ajax({
                url: '<%=cp%>/memberJoin',
                type: 'POST',
                dataType: 'text',
                async: false,
                cache: false,
                data: { "id" : $("#id").val(),
                    "password" : $("#password").val(),
                    "name" : $("#name").val(),
                    "email" : $("#email").val(),
                    "department" : $("#department").val(),
                    "grade" : $("#grade").val(),
                    "tel" : $("#tel").val()
                },
                success : function(data) {
                    if (data == "success") {
                        swal('success', '회원가입 성공')
                        setTimeout(function () {
                            inputLog($("#id").val(), "가입 신청", "회원가입");
                            location.href = '<%=cp%>/login';
                        }, 1800);
                    } else if (data == "failed") {
                        $("#id").focus();
                        swal('warning', '회원가입 실패', '중복되는 ID 입니다.')
                    } else if (data == "root") {
                        swal('success', '회원가입 성공', '최초 가입 계정으로 최고관리자 계정으로 지정됩니다.')
                        setTimeout(function () {
                            inputLog($("#id").val(), "가입 신청", "회원가입");
                            location.href = '<%=cp%>/login';
                        }, 1800);
                    } else {
                        swal('warning', '회원가입 실패')
                    }
                },
                error : function(request, status, error) {
                    swal('warning', '회원가입 실패')
                    console.log('member join error');
                    console.log(error);
                }
            })
        }
    }

    // 빈값 체크
    function blankCheck(){
        if ($("#id").val() != "" && $("#password").val() != "" && $("#passwordCheck").val() != "" && $("#name").val() != "" &&
            $("#email").val() != "" && $("#tel").val() != "" && $("#tel").val() != "" && $("#department").val() != "" && $("#grade").val() != ""){
            return true;
        } else {
            swal('warning', '가입신청실패', '빈칸 없이 입력해주세요.')
            return false;
        }
    }

    function swal(icon, title, text){
        Swal.fire({
            icon: icon,
            title: title,
            text: text,
            timer: 1500
        })
    }
</script>






