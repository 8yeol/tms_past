<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<body>
<div class="container">
    <div class="row justify-content-center bg-white p-5">
        <h2 class="text-primary my-5 d-flex justify-content-center">회원가입</h2>
        <div class="col-xs-12 d-flex justify-content-center bg-white p-5">
            <div class="me-5">
                <h3 class="text text-secondary">ID</h3>
                <h3 class="text text-secondary">이름</h3>
                <h3 class="text text-secondary">이메일</h3>
                <h3 class="text text-secondary">연락처</h3>
            </div>
            <div>
                <input class="form-control" type="text" id="id">
                <input class="form-control" type="text" id="name">
                <input class="form-control" type="email" id="email" onkeyup="autoEmail('email',this.value)">
                <input class="form-control" type="tel" id="tel" onkeyup="inputPhoneNumber(this)">
            </div>
        </div>
        <button class="btn btn-success fs-3 px-5 py-2 w-auto h-auto" onclick="join_submit()">가입신청</button>
    </div>
</div>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>

<script>
    function join_submit() {
        if ($("#id").val() != "" && $("#name").val() != "" && $("#email").val() != "" && $("#tel").val() != "") {
            var settings = {
                "url": "http://localhost:8090/memberJoin",
                "method": "POST",
                "timeout": 0,
                "headers": {
                    "accept": "application/json",
                    "content-type": "application/json;charset=UTF-8"
                },
                "data": "{\r\n    \"id\": \""+$("#id").val()+"\",\r\n    \"name\": \""+$("#name").val()+"\",\r\n    \"email\": \""+$("#email").val()+"\",\r\n    \"tel\": \""+$("#tel").val()+"\"\r\n}",
            };
            $.ajax(settings).done(function (response) {
                if (response == "true") {
                    alert("가입신청성공!");
                } else {
                    alert("중복되는 ID입니다.");
                }
                location.reload();
            });
        } else{
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
    }       // inputPhoneNumber

    function autoEmail(a,b){
        /*
            a : input의 ID
            b : 입력되는 input의 값
        */
        var mailId = b.split('@'); // 메일계정의 ID만 받아와서 처리하기 위함
        var mailList = ['naver.com','gmail.com','daum.net','hanmail.net','korea.kr']; // 메일목록
        var availableCity = new Array; // 자동완성 키워드 리스트
        for(var i=0; i < mailList.length; i++ ){
            availableCity.push( mailId[0] +'@'+ mailList[i] ); // 입력되는 텍스트와 메일목록을 조합
        }
        $("#"+a).autocomplete({
            source: availableCity, // jQuery 자동완성에 목록을 넣어줌
            focus: function(event, ui) {
                return false;
            }
        });
    }           // autoEmail

</script>






