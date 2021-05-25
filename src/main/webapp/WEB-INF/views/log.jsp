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
    .dataTables_wrapper {
        min-height: 1000px;
    }

    /* 데이터테이블 */
    .toolbar>b {
        font-size: 1.25rem;
    }
    /*.toolbar:after {content:""; display: block; clear: both;}*/

    .dataTables_wrapper .dataTables_paginate .paginate_button {
        box-sizing: border-box;
        display: inline-block;
        min-width: 1.5em;
        padding: 0.5em 1em;
        margin-left: 2px;
        text-align: center;
        text-decoration: none !important;
        cursor: pointer;
        *cursor: hand;
        color: #333 !important;
        border: 0px solid transparent;
        border-radius: 50px;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button.current,
    .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
        color: #fff !important;
        border: 0px;
        background: #97bef8;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button.disabled,
    .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:hover,
    .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:active {
        cursor: default;
        color: #666 !important;
        border: 1px solid transparent;
        background: transparent;
        box-shadow: none;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
        color: white !important;
        border: 0px;
        background: #254069;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button:active {
        outline: none;
        background-color: #2b2b2b;
        box-shadow: inset 0 0 3px #111;
    }

    #information_filter label {
        margin-bottom: 5px;
    }

    .buttons-excel {
        background-color: #000;
        color: #fff;
        border: 0px;
        border-radius: 5px;
        position: relative;
        margin-top: 2px;
    }
    .dt-buttons {
        margin: 0 10px;
        display: inline-block;
    }
    label {
        margin-bottom: 10px;
    }
    .backBtn, .backBtn:hover {
        background-color: #0d6efd;
        color: #fff;
    }
</style>
<div class="container" id="container">
    <c:choose>
        <c:when test="${member.state eq '5'}">
            <c:set var="state" value="가입 거절"></c:set>
        </c:when>
        <c:when test="${member.state eq '4'}">
            <c:set var="state" value="가입 대기"></c:set>
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

    <h3 class="d-flex justify-content-start mt-5 mb-3 fw-bold" style="position: relative;">활동 기록
        <button class="btn backBtn" onclick="history.back(-1)" style="margin-left: 40px; position: absolute; right: 0;">뒤로 가기</button></h3>

    <div class="row bg-light rounded py-3 px-5">
        <h4 class="d-flex justify-content-start"><b>${member.id} [${state}] </b>&nbsp;님의 활동기록</h4>
        <div class="col-xs-12">
            <table class="table table-striped " id="member-Table">
                <thead>
                <tr class="text-center">
                    <th width="15%">분류</th>
                    <th>내용</th>
                    <th width="20%">해당 날짜</th>
                </tr>
                </thead>
                </tbody>
                <c:forEach items="${logList}" var="log" varStatus="i">
                    <tr class="text-center" style="font-size: 0.9rem;height: 40px;">
                        <td>${log.type}</td>
                        <td>${log.content}</td>
                        <td><fmt:formatDate value="${log.date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
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

    var mql = window.matchMedia("screen and (max-width: 1024px)");

    mql.addListener(function(e) {
        if(e.matches) {
            $('#container').attr('class','container-fluid');
        } else {
            $('#container').attr('class','container');
        }
    });

    var filter = "win16|win32|win64|mac";
    if(navigator.platform){
        if(0 > filter.indexOf(navigator.platform.toLowerCase())){
            $('#container').attr('class','container-fluid');
        } else {
            $('#container').attr('class','container');
        }
    }
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

