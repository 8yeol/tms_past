<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/jqueryui-1.12.1.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="stylesheet" href="static/css/page/myPage.css">

<script src="static/js/common/common.js"></script>
<script src="static/js/common/member.js"></script>
<script src="static/js/lib/jquery-ui.js"></script>
<script src="static/js/lib/sweetalert2.min.js"></script>

<div class="container" id="container" >
    <div class="row bg-light rounded p-5 mt-5 mypage-bg">
        <span class="fs-1 text-center" style="display: inline-block; width: 100%;">MY PAGE</span>
        <div style="width: 50%; margin: 2rem auto 1rem;" id="mainDIv">
            <div class="mb-3">
                <label for="id" class="col-sm-2 col-form-label" style="display: inline-block;">아이디</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="text" class="form-control" value="${member.id}" id="id" readonly  autocomplete="off">
                </div>
            </div>

            <div class="mb-3">
                <label for="name" class="col-sm-2 col-form-label" style="display: inline-block;">이름</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="text" class="form-control" value="${member.name}" id="name" readonly  autocomplete="off">
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="col-sm-2 col-form-label" style="display: inline-block;">이메일</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="text" class="form-control" value="${member.email}" id="email" onkeyup="autoEmail('email',this.value)" readonly >
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
                    <input type="text" class="form-control" value="${member.department}" id="department" readonly  autocomplete="off">
                </div>
            </div>

            <div class="mb-3">
                <label for="grade" class="col-sm-2 col-form-label" style="display: inline-block;">직급</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="text" class="form-control" value="${member.grade}" id="grade" readonly autocomplete="off">
                </div>
            </div>

            <div class="edit" style="display:none;" id="passwordBox2">
                <div class="mb-3" id="nowPassword" style="margin-top: 1rem; width: 80%;">
                    <label for="password" class="col-sm-2 col-form-label" style="width: 22%; display: inline-block; margin: 0 20px 0 25px;">현재 비밀번호</label>
                    <div class="col-sm-10" style="width: 60%; display: inline-block;">
                        <input type="password" class="form-control" id="now_password" onkeyup="nowPasswordCheck()">
                    </div>
                    <div style="text-align: left; font-size: 0.8rem; position: relative; left: 36%;" class="psText">
                        <span class="text-danger psText" id="nowPasswordText">* 사용중인 비밀번호를 입력해주세요.</span>
                    </div>
                </div>
            </div>

            <div class="edit" style="display:none;" id="passwordBox">
                <div class="mb-3" style="margin-top: 1rem; width: 80%;">
                    <label for="password" class="col-sm-2 col-form-label" style="width: 22%; display: inline-block; margin: 0 20px 0 25px;">비밀번호 변경</label>
                   <div class="col-sm-10" style="width: 60%; display: inline-block;">
                        <input type="password" class="form-control" id="password" onkeyup="passwordCheckMsg()">
                    </div>
                    <div style="text-align: left; font-size: 0.8rem; position: relative; left: 36%;" class="psText">
                        <span class="text-danger psText" id="passwordText">* 6자리 이상 20자리 미만의 비밀번호를 설정해주세요.</span>
                    </div>
                </div>

                <div class="mb-3" style="width: 80%;">
                    <label for="passwordCheck" class="col-sm-2 col-form-label" style="width: 22%; display: inline-block; margin: 0 20px 0 25px;">비밀번호 확인</label>
                    <div class="col-sm-10" style="width: 60%; display: inline-block;">
                        <input type="password" class="form-control" id="passwordCheck" onkeyup="passwordCheckMsg()" >
                    </div>
                    <div style="text-align: left; font-size: 0.8rem; position: relative; left: 36%;" class="psText">
                        <span class="text-danger" id="passwordCheckText">* 비밀번호가 일치하지 않습니다.</span>
                    </div>
                </div>
            </div>

            <div class="row btnDiv">
                    <button class="btn btn-outline-primary m-3"  style="display:none;" id="pw_button" onclick="changePassword()">비밀번호 변경</button>
                <div class="col text-center" style="padding-left: 10%;">
                    <button class="btn btn-outline-primary m-3" id="update_btn" onclick="setLayout()" >회원정보 수정</button>
                    <button class="btn btn-primary m-3" style="display:none;" id="up_btn" onclick="submit()" >정보수정</button>
                    <c:choose>
                        <c:when test="${member.state ne 1}">
                            <button class="btn btn-outline-danger m-3" id="memberOut" data-bs-toggle="modal" data-bs-target="#memberOutmodal">회원탈퇴</button>
                        </c:when>
                    </c:choose>
                </div>
            </div>
            <input type="hidden" id="state" value="${member.state}">
        </div>
    </div>
</div>

<!-- memberOutmodal -->
<div class="modal" id="memberOutmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title text-danger">비밀번호 확인</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <div class="text-center">
                    <p class="fs-6 fw-bold">탈퇴를 원하시면 <br>사용하시는 비밀번호를 입력해주세요.</p>
                    <input type="password" class="form-control text-warning" id="outCheck_password"/>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-outline-danger me-5" data-bs-dismiss="modal" onclick="memberOut()">탈퇴
                </button>
                <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    let TOGGLE = false;

    $(document).ready(function(){
        textFieldManagement(TOGGLE);
    });

    function readonlyToggle() {
        $("#name").attr("readonly", TOGGLE);
        $("#email").attr("readonly", TOGGLE);
        $("#tel").attr("readonly", TOGGLE);
        $("#department").attr("readonly", TOGGLE);
        $("#grade").attr("readonly", TOGGLE);
        if (TOGGLE) {
            TOGGLE = false;
        } else {
            TOGGLE = true;
        }
    }

    function setLayout() {
        if ($("#update_btn").html() == "회원정보 수정") {
            $("#update_btn").html("취소");
            $("#pw_button").css('display', 'block');
        } else {
            textFieldManagement(TOGGLE);
            $("#update_btn").html("회원정보 수정");
            $("#pw_button").css('display', 'none');
        }

        const passwordBox = document.getElementById('passwordBox');
        if (passwordBox.style.display != "none") {
            changePassword();
        }

        $("#up_btn").toggle();
        readonlyToggle();
    }

    function changePassword() {
        $("#passwordBox").toggle();
        $("#passwordBox2").toggle();
        $("#pw_button").css('display', 'none');

    }

    function submit() {
        const passwordBox = document.getElementById('passwordBox');
        if (passwordBox.style.display != "none") {
            if ($("#nowPasswordText").text() != "인증완료") {
                $("#now_password").focus();
                swal('error', '현재 비밀번호 오류', '현재 비밀번호를 확인해주세요.')
                return false;
            }
            if(blankCheck('block') == false){
                swal('warning', '수정 실패', '변경 할 비밀번호를 정확히 입력해주세요.')
                return false;
            }
        }

        if (emailCheck()) {
            $.ajax({
                url: '<%=cp%>/memberUpdate',
                type: 'POST',
                dataType: 'text',
                async: false,
                cache: false,
                data: {
                    "id": $("#id").val(),
                    "password": $("#password").val(),
                    "name": $("#name").val(),
                    "email": $("#email").val(),
                    "department": $("#department").val(),
                    "grade": $("#grade").val(),
                    "tel": $("#tel").val()
                },
                success: function (data) {
                    if (data == "success") {
                        swal('success', '수정완료', '성공적으로 수정되었습니다.');
                        setTimeout(function () {
                            location.reload();
                        }, 2000);
                    } else {
                        swal('warning', '수정실패');
                    }
                },
                error: function (request, status, error) {
                    swal('warning', '수정실패');
                    console.log('member update error');
                    console.log(error);
                }
            })
        }
    }

    function blankCheck(passwordBox) {
        if (passwordBox == 'block') {
            if ($("#password").val() != "" && $("#passwordCheck").val() != "" && passwordCheck()) {
                return true;
            }else{
                return false;
            }
        }
        if ($("#name").val() != "" && $("#email").val() != "" && $("#tel").val() != "" && $("#tel").val() != "" && $("#department").val() != "" && $("#grade").val() != "" ) {
            return true;
        } else {
            return false;
        }
    }

    let debounce2 = null;
    function nowPasswordCheck() {
        clearTimeout(debounce2);
        debounce2 = setTimeout(() => {
            delayNowPasswordCheck(); //측정소의 항목 전체 데이터
        }, 300)
    }

    function delayNowPasswordCheck(){
        $.ajax({
            url: '<%=cp%>/nowPasswordCheck',
            type: 'POST',
            dataType: 'text',
            async: false,
            cache: false,
            data: {
                "id": $("#id").val(),
                "password": $("#now_password").val(),
            },
            success: function (data) {
                if (data == "success") {
                    $("#nowPasswordText").text("인증완료")
                } else if (data == "failed") {
                    $("#nowPasswordText").text("비밀번호가 틀립니다. 다시 확인해주세요.")
                }
            },
            error: function (request, status, error) {
                console.log('member update error');
                console.log(error);
            }
        })
    }

    function memberOut() {
        $.ajax({
            url: '<%=cp%>/memberOut',
            type: 'POST',
            dataType: 'text',
            async: false,
            cache: false,
            data: {
                "id": $("#id").val(),
                "password": $("#outCheck_password").val(),
            },
            success: function (data) {
                if (data == "success") {
                    swal('success', '회원탈퇴 완료', '탈퇴처리가 완료되었습니다.');
                    setTimeout(function () {
                        location.href = '<%=cp%>/logout';
                    }, 2000);
                } else {
                    swal('warning', '회원탈퇴 실패', '비밀번호가 틀립니다.');
                }
            },
            error: function (request, status, error) {
                console.log('member out error');
                console.log(error);
            }
        })
    }

    let name, email, tel, department, grade;
    function textFieldManagement(toggle){
        if(!toggle){
            name = $("#name").val();
            email = $("#email").val();
            tel = $("#tel").val();
            department = $("#department").val();
            grade = $("#grade").val();
        } else {
            $("#name").val(name);
            $("#email").val(email);
            $("#tel").val(tel);
            $("#department").val(department);
            $("#grade").val(grade);
            $("#now_password").val("");
            $("#password").val("");
            $("#passwordCheck").val("");
            $("#nowPasswordText").html("");
            $("#passwordText").html("");
            $("#passwordCheckText").html("");
        }
    }

    function swal(icon, title, text) {
        Swal.fire({
            icon: icon,
            title: title,
            text: text,
            timer: 2000
        })
    }
</script>
