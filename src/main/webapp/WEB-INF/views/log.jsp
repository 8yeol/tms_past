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

<div class="container">

    <h3 class="d-flex justify-content-start mt-5 mb-3 fw-bold">활동 기록</h3>
    <div class="row bg-light rounded py-3 px-5">
        <h4 class="d-flex justify-content-start">내용</h4>
        <div class="col-xs-12">
            <table class="table table-striped " id="member-Table">

                <thead>
                <tr class="text-center">
                    <th>번호</th>
                    <th>ID</th>
                    <th width="45%">내용</th>
                    <th>분류</th>
                    <th width="25%">해당 날짜</th>
                </tr>
                </thead>
                </tbody>
                <c:forEach items="${logList}" var="log" varStatus="i">
                    <tr class="text-center" style="font-size: 0.9rem;">
                        <td>${i.index+1}</td>
                        <td>${log.id}</td>
                        <td>${log.content}</td>
                        <td>${log.type}</td>
                        <td><fmt:formatDate value="${log.date}" pattern="yyyy년 MM월 dd일"/> &nbsp;
                            <fmt:formatDate value="${log.date}" pattern="hh시 mm분 ss초"/></td>

                    </tr>
                </c:forEach>
                <tbody>
            </table>
        </div>
    </div>
</div>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>

</script>






