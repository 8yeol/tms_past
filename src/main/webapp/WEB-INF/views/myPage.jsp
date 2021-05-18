<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<style>
    .edit {
        background-color: #0d6efd;
        color: #fff;
        border-radius: 5px;
        border: 2px solid #0d6efd;
        box-shadow: 2px 2px 10px rgba(0,0,0,0.2);
        position: relative;
        left: 35px;
    }
</style>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/jqueryui-1.12.1.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="shortcut icon" href="#">
<script src="static/js/jquery-ui.js"></script>
<script src="static/js/sweetalert2.min.js"></script>
<script src="static/js/common/common.js"></script>
<script src="static/js/common/member.js"></script>

<div class="container bg-light rounded p-5 mt-5 mypage-bg">
    <div class="row">
        <span class="fs-1 text-center" style="display: inline-block; width: 100%;">MY PAGE</span>
        <div class="text-center" style="width: 50%; margin: 2rem auto 1rem;">
            <div class="mb-3">
                <label for="id" class="col-sm-2 col-form-label" style="display: inline-block;">아이디</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="text" class="form-control" value="${member.id}" id="id" readonly>
                </div>
            </div>

            <div class="mb-3">
                <label for="name" class="col-sm-2 col-form-label" style="display: inline-block;">이름</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="text" class="form-control" value="${member.name}" id="name" readonly>
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="col-sm-2 col-form-label" style="display: inline-block;">이메일</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="text" class="form-control" value="${member.email}" id="email" onkeyup="autoEmail('email',this.value)" readonly>
                </div>
            </div>

            <div class="mb-3">
                <label for="tel" class="col-sm-2 col-form-label" style="display: inline-block;">연락처</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="text" class="form-control" value="${member.tel}" id="tel" readonly onkeyup="inputPhoneNumber(this)">
                </div>
            </div>

            <div class="mb-3">
                <label for="department" class="col-sm-2 col-form-label" style="display: inline-block;">부서명</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="text" class="form-control" value="${member.department}" id="department" readonly>
                </div>
            </div>

            <div class="mb-3">
                <label for="grade" class="col-sm-2 col-form-label" style="display: inline-block;">직급</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="text" class="form-control" value="${member.grade}" id="grade" readonly>
                </div>
            </div>

            <div class="edit" style="display:none;" id="passwordBox">
                <div class="mb-3" style="margin-top: 1rem; width: 80%;">
                    <label for="password" class="col-sm-2 col-form-label" style="width: 20%; display: inline-block; margin: 0 20px 0 25px;">현재 비밀번호</label>
                    <div class="col-sm-10" style="width: 60%; display: inline-block;">
                        <input type="password" class="form-control" id="now_password" onkeyup="nowPasswordCheck()">
                    </div>
                    <div class="col">
                        <span class="text-danger" id="nowPasswordText">* 사용중인 비밀번호를 입력해주세요.</span>
                    </div>
                </div>

                <hr>

                <div class="mb-3" style="margin-top: 1rem; width: 80%;">
                    <label for="password" class="col-sm-2 col-form-label" style="width: 20%; display: inline-block; margin: 0 20px 0 25px;">비밀번호 변경</label>
                   <div class="col-sm-10" style="width: 60%; display: inline-block;">
                        <input type="password" class="form-control" id="password" onkeyup="passwordCheckMsg()">
                    </div>
                    <div class="col">
                        <span class="text-danger" id="passwordText">* 6자리 이상 20자리 미만의 비밀번호를 설정해주세요.</span>
                    </div>
                </div>

                <div class="mb-3" style="width: 80%;">
                    <label for="passwordCheck" class="col-sm-2 col-form-label" style="width: 20%; display: inline-block; margin: 0 20px 0 25px;">비밀번호 확인</label>
                    <div class="col-sm-10" style="width: 60%; display: inline-block;">
                        <input type="password" class="form-control" id="passwordCheck" onkeyup="passwordCheckMsg()" >
                    </div>
                    <div class="col">
                        <span class="text-danger" id="passwordCheckText">* 비밀번호가 일치하지 않습니다.</span>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col text-center">
                    <button class="btn btn-outline-primary m-3"  style="display:none;" id="pw_button" onclick="changePassword()">비밀번호 변경</button>
                    <button class="btn btn-outline-primary m-3" id="update_btn" onclick="setLayout()">회원정보 수정</button>
                    <button class="btn btn-primary m-3" style="display:none;" id="up_btn" onclick="submit()" >정보수정</button>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    var bool = false;
    function setLayout(){
        if($("#update_btn").html() == "회원정보 수정"){
            $("#update_btn").html("취소");
        } else {
            $("#update_btn").html("회원정보 수정");
        }

        const passwordBox = document.getElementById('passwordBox');
        if(passwordBox.style.display!="none"){
            changePassword();
        }

        $("#up_btn").toggle();
        $("#pw_button").toggle();
        readonlyToggle();
    }       // setLayout

    function changePassword(){
        $("#passwordBox").toggle();
    }

    function submit() {

        const passwordBox = document.getElementById('passwordBox');
        if(passwordBox.style.display!="none"){
            passwordCheck()
            blankCheck('block');

            if($("#nowPasswordText").text()!="인증완료"){
                $("#now_password").focus();
                swal('error', '현재 비밀번호 오류', '사용중인 비밀번호를 입력해주세요.')
                return false;
            }
        }

        if (emailCheck()) {
            var settings = {
                "url": "<%=cp%>/memberUpdate",
                "method": "POST",
                "timeout": 0,
                "headers": {
                    "accept": "application/json",
                    "content-type": "application/json;charset=UTF-8"
                },
                "data": "{\r\n    \"id\": \"" + $("#id").val() + "\"," +
                    "\r\n    \"password\": \"" + $("#password").val() + "\"," +
                    "\r\n    \"name\": \"" + $("#name").val() + "\"," +
                    "\r\n    \"email\": \"" + $("#email").val() + "\"," +
                    "\r\n    \"department\": \"" + $("#department").val() + "\"," +
                    "\r\n    \"grade\": \"" + $("#grade").val() + "\"," +
                    "\r\n    \"tel\": \"" + $("#tel").val() + "\"\r\n}",
            };
            $.ajax(settings).done(function (response) {
                if (response == "true") {
                    alert("저장되었습니다.");
                } else if (response == "false") {
                    alert("비밀번호가 틀립니다.");
                } else {
                    alert("변경실패");
                }
                location.reload();
            });
        }
    }           // join_submit()

    function readonlyToggle() {
        $("#name").attr("readonly", bool);
        $("#email").attr("readonly", bool);
        $("#tel").attr("readonly", bool);
        $("#department").attr("readonly", bool);
        $("#grade").attr("readonly", bool);

        if(bool){
            bool = false;
        } else {
            bool = true;
        }
    }       // readonlyToggle

    function blankCheck(passwordBox){
        if(passwordBox=='block'){
            if ($("#password").val() == "" && $("#passwordCheck").val() == "") {
                swal('warning', '수정 실패', '변경할 비밀번호를 입력해주세요.')
                return false;
            }
        }
        if ( $("#name").val() != "" && $("#email").val() != "" && $("#tel").val() != "" && $("#tel").val() != "" && $("#department").val() != "" && $("#grade").val() != ""){
            return true;
        } else {
            swal('warning', '수정 실패', '빈칸 없이 입력해주세요.')
            return false;
        }
    }

    function nowPasswordCheck(){
        $("#nowPasswordText").text("비밀번호가 틀립니다. 다시 확인해주세요.")
        //$("#nowPasswordText").text("인증완료")
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
