<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="stylesheet" href="static/css/bootstrap.min.css">
<link rel="stylesheet" href="static/css/common.css">
<link rel="stylesheet" href="static/css/jqueryui-1.12.1.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/jquery-3.6.0.min.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/jquery-ui.js"></script>

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

<div class="container">
    <div class="row justify-content-center bg-white p-5 mt-5 rounded">
        <h1 class="py-5 fw-bold text-center">Sing Up</h1>
        <div class="col-xs-12 d-flex justify-content-center bg-white px-5">
            <div class="me-5">
                <h3 class="text text-secondary fw-bold">아이디</h3>
                <h3 class="text text-secondary fw-bold">비밀번호</h3>
                <h3 class="text text-secondary fw-bold">비밀번호확인</h3>
                <h3 class="text text-secondary fw-bold">이름</h3>
                <h3 class="text text-secondary fw-bold">이메일</h3>
                <h3 class="text text-secondary fw-bold">연락처</h3>
                <h3 class="text text-secondary fw-bold">부서명</h3>
                <h3 class="text text-secondary fw-bold">직급</h3>
            </div>
            <div>
                <input class="form-control" type="text" id="id">
                <input class="form-control mt-1" type="password" id="password">
                <input class="form-control mt-1" type="password" id="passwordCheck">
                <input class="form-control mt-1" type="text" id="name">
                <input class="form-control mt-1" type="email" id="email" onkeyup="autoEmail('email',this.value)">
                <input class="form-control mt-1" type="tel" id="tel" onkeyup="inputPhoneNumber(this)">
                <input class="form-control mt-1" type="text" id="department">
                <input class="form-control mt-1" type="text" id="grade">
            </div>
        </div>
        <button class="btn btn-primary fs-3 px-5 py-2 w-auto h-auto mt-3" onclick="join_submit()">가입신청</button>
        <button class="btn btn-outline-primary fs-3 px-5 py-2 w-auto h-auto mt-3 ms-5" onClick="location.href='/login'">취소</button>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    function join_submit() {
        if ($("#id").val() != "" && $("#password").val() != "" && $("#passwordCheck").val() != "" && $("#name").val() != "" && $("#email").val() != "" && $("#tel").val() != "" && $("#tel").val() != "" && $("#department").val() != "" && $("#grade").val() != "") {

            if ($("#password").val() != $("#passwordCheck").val()) {
                alert("비밀번호가 틀립니다.");
                return;
            }

            var settings = {
                "url": "http://localhost:8090/memberJoin",
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
                    inputLog($("#id").val(),"회원가입신청","회원가입");
                    alert("가입신청성공!");
                    location.href = "/login";
                } else if (response == "false") {
                    alert("중복되는 ID입니다.");
                } else if( response == "root") {
                    inputLog($("#id").val(),"회원가입신청","회원가입");
                    alert("최초가입시 최고관리자로 임명됩니다.");
                    location.href = "/login";
                } else {
                    alert("가입신청실패");
                }
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
        /*
            a : input의 ID
            b : 입력되는 input의 값
        */
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






