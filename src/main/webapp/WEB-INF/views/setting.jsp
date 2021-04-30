<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 11:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>

<style>

</style>

<script type="text/javascript">
    jQuery(function ($) {
        $("#member-Table").DataTable({
            "language": {
                "emptyTable": "데이터가 없어요.",
                "lengthMenu": "페이지당 _MENU_ 개씩 보기",
                "info": "현재 _START_ - _END_ / _TOTAL_건",
                "infoEmpty": "데이터 없음",
                "infoFiltered": "( _MAX_건의 데이터에서 필터링됨 )",
                "search": "전체검색 : ",
                "zeroRecords": "일치하는 데이터가 없어요.",
                "loadingRecords": "로딩중...",
                "processing": "잠시만 기다려 주세요...",
                "paginate": {
                    "next": "다음",
                    "previous": "이전"
                },
            },
            pageLength: 10
        });
    });
</script>
<body>

<div class="container gap-5">

    <h4 class="d-flex justify-content-start mt-5">회원관리</h4>
    <div class="row bg-light">
        <div class="col-xs-12">
            <table class="table table-striped" id="member-Table">

                <thead>
                <tr>
                    <th>번호</th>
                    <th>ID</th>
                    <th>이름</th>
                    <th>상태</th>
                    <th>이메일</th>
                    <th>연락처</th>
                    <th>가입신청일</th>
                    <th>가입승인일</th>
                    <th>최종 로그인</th>
                    <th>가입관리</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${members}" var="mList" varStatus="cnt">
                    <tr>
                        <td>${cnt.index+1}</td>
                        <td>${mList.id}</td>
                        <td>${mList.name}</td>
                        <c:choose>
                            <c:when test="${mList.state eq '0'}">
                                <td>가입대기</td>
                            </c:when>
                            <c:when test="${mList.state eq '1'}">
                                <td class="text-success">승인</td>
                            </c:when>
                            <c:when test="${mList.state eq '2'}">
                                <td class="text-danger">거절</td>
                            </c:when>
                        </c:choose>
                        <td>${mList.email}</td>
                        <td>${mList.tel}</td>
                        <td><fmt:formatDate value="${mList._id.date}" pattern="yyyy년 MM월 dd일 hh시"/></td>


                        <c:choose>
                            <c:when test="${mList.joined != null}">
                                <td><fmt:formatDate value="${mList.joined}" pattern="yyyy년 MM월 dd일 hh시"/></td>
                            </c:when>
                            <c:otherwise>
                                <td></td>
                            </c:otherwise>
                        </c:choose>

                        <td><%--최종로그인--%></td>
                        <c:choose>
                            <c:when test="${mList.state eq '0'}">
                                <td>
                                    <button class="btn btn-success" data-toggle="modal" data-target="#okModal"
                                            onclick="sign_Set('${mList.id}')">승인
                                    </button>
                                    <button class="btn btn-danger" data-toggle="modal" data-target="#noModal"
                                            onclick="sign_Set('${mList.id}')">거절
                                    </button>
                                </td>
                            </c:when>
                            <c:otherwise>
                                <td></td>
                            </c:otherwise>
                        </c:choose>
                    </tr>
                </c:forEach>
                </tbody>

            </table>
        </div>
    </div>




<!-- okModal -->
<div class="modal" id="okModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">가입 승인</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <h3 id="okModal_Body">가입승인 하시겠습니까?</h3>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5" data-dismiss="modal" onclick="sing_Up_Ok()">승인
                </button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<!-- noModal -->
<div class="modal" id="noModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">가입 거절</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <h3>가입거절 하시겠습니까?</h3>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-danger me-5" data-dismiss="modal" onclick="sing_Up_No()">거절
                </button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>



<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>

<script>
    var ID = "";

    function sign_Set(str_id) {
        ID = str_id;
    }          // row 의 승인 및 거절 버튼 클릭시 전역변수 ID에 해당row 의 ID가 저장됨
    function sing_Up_Ok() {
        var settings = {
            "url": "http://localhost:8090/signUpOk",
            "method": "POST",
            "timeout": 0,
            "headers": {
                "accept": "application/json",
                "content-type": "application/json;charset=UTF-8"
            },
            "data": "{\r\n    \"id\": \"" + ID + "\"\r\n}",
        };
        $.ajax(settings).done(function (response) {
            alert("가입 승인 되었습니다.");
            location.reload();
        });
    }           // sing_Up_Ok

    function sing_Up_No() {
        var settings = {
            "url": "http://localhost:8090/signUpNo",
            "method": "POST",
            "timeout": 0,
            "headers": {
                "accept": "application/json",
                "content-type": "application/json;charset=UTF-8"
            },
            "data": "{\r\n    \"id\": \"" + ID + "\"\r\n}",
        };
        $.ajax(settings).done(function (response) {
            alert("가입 거절 되었습니다.");
            location.reload();
        });
    }           // sing_Up_No

    $(function () {
        $('.modal-dialog').draggable({handle: ".modal-header"});

    });         // modal drag and drop move


</script>






