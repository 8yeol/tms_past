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
    .join>div input {
        width:1000px;
        height: 40px;
    }
    @media all and (min-width:1981px) {
        .join-bg {position: relative; top:12%;}
    }
</style>

<div class="container h-100">
    <div class="row bg-white join-bg">
        <span class="fs-1 text-center" style="margin: 15px 0px 0px;">회원가입</span>
        <div class="col join" style="padding: 2rem;">

            <div class="mb-3" style="width: 80%; margin: 0 auto;">
                <label for="id" class="col-form-label">아이디</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="id">
                </div>
            </div>
            <div class="mb-3" style="width: 80%; margin: 0 auto;">
                <label for="password" class="col-form-label">비밀번호</label>
                <div class="col-sm-10">
                    <input type="password" class="form-control" id="password" placeholder="6자 이상 입력해 주세요">
<%--                    <span class="text-primary" style="font-size: 15%"> * 6자 이상 입력해주세요.</span>--%>
                </div>
            </div>

            <div class="mb-3" style="width: 80%; margin: 0 auto;">
                <label for="passwordCheck" class="col-form-label">비밀번호 확인</label>
                <div class="col-sm-10">
                    <input type="password" class="form-control" id="passwordCheck">
                    <span class="text-primary" style="font-size: 15%"> * 입력한 비밀번호와 동일하지 않습니다.</span>
                </div>
            </div>

            <div class="mb-3" style="width: 80%; margin: 0 auto;">
                <label for="name" class="col-form-label">이름</label>
                <div class="col-sm-10">
                    <input type="test" class="form-control" id="name">
                </div>
            </div>

            <div class="mb-3" style="width: 80%; margin: 0 auto;">
                <label for="email" class="col-form-label">이메일</label>
                <div class="col-sm-10">
                    <input type="test" class="form-control" id="email" onkeyup="autoEmail('email',this.value)">
                </div>
            </div>

            <div class="mb-3" style="width: 80%; margin: 0 auto;">
                <label for="tel" class="col-form-label">연락처</label>
                <div class="col-sm-10">
                    <input type="test" class="form-control" id="tel" onkeyup="inputPhoneNumber(this)">
                </div>
            </div>

            <div class="mb-3" style="width: 80%; margin: 0 auto;">
                <label for="department" class="col-form-label">부서명</label>
                <div class="col-sm-10">
                    <input type="test" class="form-control" id="department">
                </div>
            </div>

            <div class="mb-3" style="width: 80%; margin: 0 auto;">
                <label for="grade" class="col-form-label">직급</label>
                <div class="col-sm-10">
                    <input type="test" class="form-control" id="grade">
                </div>
            </div>

            <div class="row">
                <div class="col text-center">
                    <button class="btn btn-primary px-5 py-2 w-auto h-auto mt-3" onclick="join_submit()">가입신청</button>
                    <button class="btn btn-outline-primary px-5 py-2 w-auto h-auto mt-3 ms-5" onClick="location.href='/login'">취소</button>
                </div>
            </div>

        </div>
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






