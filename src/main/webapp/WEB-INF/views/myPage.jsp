<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .bg-lightGrey {
        background-color: lightgrey;
    }
    .edit {
        background-color: #0d6efd;
        color: #fff;
        border-radius: 5px;
        border: 2px solid #0d6efd;
        box-shadow: 2px 2px 10px rgba(0,0,0,0.2);
        position: relative;
        left: 35px;
    }
    /*@media all and (min-width:1981px) {*/
    /*    .mypage-bg {position: relative; top:18%;}*/
    /*}*/
    /*@media all and (max-width: 1980px) {*/
    /*    .mypage-bg {position: relative; top: 10%;}*/
    /*}*/
</style>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/jqueryui-1.12.1.css">
<script src="static/js/jquery-ui.js"></script>

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
                    <input type="test" class="form-control" value="${member.name}" id="name" readonly>
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="col-sm-2 col-form-label" style="display: inline-block;">이메일</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="test" class="form-control" value="${member.email}" id="email" readonly>
                </div>
            </div>

            <div class="mb-3">
                <label for="tel" class="col-sm-2 col-form-label" style="display: inline-block;">연락처</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="test" class="form-control" value="${member.tel}" id="tel" readonly>
                </div>
            </div>

            <div class="mb-3">
                <label for="department" class="col-sm-2 col-form-label" style="display: inline-block;">부서명</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="test" class="form-control" value="${member.department}" id="department" readonly>
                </div>
            </div>

            <div class="mb-3">
                <label for="grade" class="col-sm-2 col-form-label" style="display: inline-block;">직급</label>
                <div class="col-sm-10" style="width: 50%; display: inline-block;">
                    <input type="test" class="form-control" value="${member.grade}" id="grade" readonly>
                </div>
            </div>

            <div class="edit" style="display:none;" id="passwordBox">
                <div class="mb-3" style="margin-top: 1rem; width: 80%;">
                    <label for="password" class="col-sm-2 col-form-label" style="width: 20%; display: inline-block; margin: 0 20px 0 25px;">비밀번호 변경</label>
                   <div class="col-sm-10" style="width: 60%; display: inline-block;">
                        <input type="test" class="form-control" id="password">
                    </div>
                </div>

                <div class="mb-3" style="width: 80%;">
                    <label for="passwordCheck" class="col-sm-2 col-form-label" style="width: 20%; display: inline-block; margin: 0 20px 0 25px;">비밀번호 확인</label>
                    <div class="col-sm-10" style="width: 60%; display: inline-block;">
                        <input type="test" class="form-control" id="passwordCheck">
                    </div>
                </div>

            </div>

            <div class="row">
                <div class="col text-center">
                    <button class="btn btn-outline-primary m-3" onclick="setLayout()">회원정보 수정</button>
                    <button class="btn btn-primary m-3" onclick="submit()" style="display:none;" id="up_btn">정보수정</button>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    function setLayout(){
        $("#up_btn").attr('style','display:""');
        $("#passwordBox").attr('style','display:""');
    }
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
