<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<jsp:include page="/WEB-INF/views/common/header.jsp"/>

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
                <input class="form-control" type="email" id="email">
                <input class="form-control" type="tel" id="tel">
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
                "data": "{\r\n    \"id\": \"" + $("#id").val() + "\",\r\n    \"name\": \"" + $("#name").val() + "\",\r\n    \"level\": \"1\",\r\n    \"email\": \"" + $("#email").val() + "\",\r\n    \"tel\": \"" + $("#tel").val() + "\",\r\n    \"state\": \"0\"\r\n}",
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
</script>






