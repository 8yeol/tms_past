<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .bg-lightGrey {
        background-color: lightgrey;
    }
</style>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/jqueryui-1.12.1.css">
<script src="static/js/jquery-ui.js"></script>

<div class="container bg-light rounded p-5 text-center mt-5">
    <p class="bg-lightGrey rounded-pill fs-3">마이 페이지</p>

    <div class="d-flex justify-content-center">
        <div class="me-5 mt-1">
            <p class="badge bg-primary fs-6">아이디</p><br>
            <p class="badge bg-primary fs-6">비밀번호</p><br>
            <p class="badge bg-primary fs-6">이름</p><br>
            <p class="badge bg-primary fs-6">이메일</p><br>
            <p class="badge bg-primary fs-6">전화번호</p><br>
            <p class="badge bg-primary fs-6">부서명</p><br>
            <p class="badge bg-primary fs-6">직급</p>
        </div>
        <div class="">
            <input type="text" class="form-control text-center" value="${member.id}" readonly id="id">
            <input type="password" class="form-control text-center mt-1" id="password">
            <input type="text" class="form-control text-center mt-1" value="${member.name}" id="name">
            <input type="email" class="form-control text-center mt-1" value="${member.email}" id="email"
                   onkeyup="autoEmail('email',this.value)">
            <input type="tel" class="form-control text-center mt-1" value="${member.tel}" id="tel"
                   onkeyup="inputPhoneNumber(this)">
            <input type="text" class="form-control text-center mt-1" value="${member.department}" id="department">
            <input type="text" class="form-control text-center mt-1" value="${member.grade}" id="grade">
        </div>
    </div>
    <button class="btn btn-primary mt-3" onclick="submit()">정보수정</button>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    function submit() {
        if ($("#id").val() != "" && $("#password").val() && $("#name").val() != "" && $("#email").val() != "" && $("#tel").val() != "" && $("#department").val() != "" && $("#grade").val() != "") {
            var settings = {
                "url": "http://localhost:8090/memberUpdate",
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
                    alert("가입신청실패");
                }
                location.reload();
            });
        } else {
            alert("빈칸없이 입력하여 주세요");
        }
    }           // join_submit()

    function inputPhoneNumber(obj) {
        var number = obj.value.replace(/[^0-9]/g, "");
        var phone = "";
        if (number.length < 4) {
            return number;
        } else if (number.length < 7) {
            phone += number.substr(0, 3);
            phone += "-";
            phone += number.substr(3);
        } else if (number.length < 11) {
            phone += number.substr(0, 3);
            phone += "-";
            phone += number.substr(3, 3);
            phone += "-";
            phone += number.substr(6);
        } else {
            phone += number.substr(0, 3);
            phone += "-";
            phone += number.substr(3, 4);
            phone += "-";
            phone += number.substr(7);
        }
        obj.value = phone;
    }       // inputPhoneNumber 정규식

    function autoEmail(a, b) {
        var mailId = b.split('@'); // 메일계정의 ID만 받아와서 처리하기 위함
        var mailList = ['naver.com', 'gmail.com', 'daum.net', 'hanmail.net', 'korea.kr']; // 메일목록
        var availableCity = new Array; // 자동완성 키워드 리스트
        for (var i = 0; i < mailList.length; i++) {
            availableCity.push(mailId[0] + '@' + mailList[i]); // 입력되는 텍스트와 메일목록을 조합
        }
        $("#" + a).autocomplete({
            source: availableCity, // jQuery 자동완성에 목록을 넣어줌
            focus: function (event, ui) {
                return false;
            }
        });
    }           // autoEmail 이메일 자동완성 도우미
</script>
