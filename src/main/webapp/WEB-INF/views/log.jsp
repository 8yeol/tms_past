<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/jquery-ui.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>

<div class="container">
    <c:choose>
        <c:when test="${member.state eq '5'}">
            <c:set var="state" value="가입 거절"></c:set>
        </c:when>
        <c:when test="${member.state eq '4'}">
            <c:set var="state" value="가입대기"></c:set>
        </c:when>
        <c:when test="${member.state eq '3'}">
            <c:set var="state" value="일반"></c:set>
        </c:when>
        <c:when test="${member.state eq '2'}">
            <c:set var="state" value="관리자"></c:set>
        </c:when>
        <c:when test="${member.state eq '1'}">
            <c:set var="state" value="최고 관리자"></c:set>
        </c:when>
    </c:choose>

    <h3 class="d-flex justify-content-start mt-5 mb-3 fw-bold">활동 기록</h3>
    <div class="row bg-light rounded py-3 px-5">
        <h4 class="d-flex justify-content-start"><b>${member.id} [${state}] </b>&nbsp;님의 활동기록</h4>
        <div class="col-xs-12">
            <table class="table table-striped " id="member-Table">
                <thead>
                <tr class="text-center">
                    <th width="30%">분류</th>
                    <th width="35%">내용</th>
                    <th>해당 날짜</th>
                </tr>
                </thead>
                </tbody>
                <c:forEach items="${logList}" var="log" varStatus="i">
                    <tr class="text-center" style="font-size: 0.9rem;">
                        <td>${log.type}</td>
                        <td>${log.content}</td>
                        <td><fmt:formatDate value="${log.date}" pattern="yyyy년 MM월 dd일"/> &nbsp;<!--<b style="font-size: 1.3rem;">/</b> -->
                            <fmt:formatDate value="${log.date}" pattern="HH시 mm분 ss초"/></td>
                    </tr>
                </c:forEach>
                <tbody>
            </table>
        </div>
    </div>
</div>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    $("#member-Table").DataTable({
        order: [[2, 'desc']],
        ordering: true,
        info: false,
        lengthChange : false,
        pageLength: 20,
        language : {
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
    });
</script>






