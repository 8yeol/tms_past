<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<script src="static/js/moment.min.js"></script>
<script src="static/js/common/common.js"></script>
<script src="static/js/jquery-ui.js"></script>
<script src="static/js/sweetalert2.min.js"></script>


<style>
    .toolbar>b {
        font-size: 1.25rem;
    }

    #paging a{
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

    #paging a:hover {
        color: white !important;
        border: 0px;
        background: #254069;
    }

    #information_filter label {
        margin-bottom: 5px;
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
        <button class="btn backBtn" onclick="location.href='<%=cp%>/setting'" style="margin-left: 40px; position: absolute; right: 0;">뒤로 가기</button></h3>

    <div class="row bg-light rounded py-3 px-5">
        <h4 class=" justify-content-start"><b>${member.id} [${state}] </b>&nbsp;님의 활동기록
            <button class="btn btn-outline-success float-end ms-2" onclick="reset();">초기화</button>
            <button class="btn btn-primary float-end ms-2" onclick="search();">검색</button>
            <input type="text" class="float-end" style="width: 150px;" id="searchKey"></h4>
        <div class="col-xs-12 mt-3">
            <table class="table table-striped" id="member-Table">
                <thead>
                <tr class="text-center">
                    <th width="15%">분류</th>
                    <th>내용</th>
                    <th width="20%">해당 날짜</th>
                </tr>
                </thead>
                <tbody id="logTbody" class="text-center">
                <c:forEach items="${logList}" var="log" varStatus="i">
                    <tr class="text-center">
                        <td>${log.type}</td>
                        <td>${log.content}</td>
                        <td><fmt:formatDate value="${log.date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <div id="paging" class="text-end"> </div>

        </div>
    </div>
</div>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>

    function paging(totalData, dataPerPage, pageCount, currentPage, searchKey){
        const totalPage = Math.ceil(totalData/dataPerPage);    // 총 페이지 수
        const pageGroup = Math.ceil(currentPage/pageCount);    // 페이지 그룹
        let last = pageGroup * pageCount;    // 화면에 보여질 마지막 페이지 번호
        if(last > totalPage)
            last = totalPage;
        const first = last - (pageCount-1);    // 화면에 보여질 첫번째 페이지 번호
        const next = last+1;
        const prev = first-1;

        let html = "";

        if(prev > 0) {
            html += "<a href=javascript:; id='start'>시작</a> ";
            html += "<a href=javascript:; id='prev'>이전</a> ";
        }

        for(let i=first; i <= last; i++){
            if(i > 0){
                html += "<a href='javascript:;' id=" + i + ">" + i + "</a> ";  //href=javascript:; 페이지 이동없음
            }
        }

        if(last < totalPage) {
            html += "<a href=javascript:; id='next'>다음</a> ";
            html += "<a href=javascript:; id='end'>끝</a>";
        }

        $("#paging").html(html);    // 페이지 목록 생성
        $("#paging a").css("color", "#333");
        $("#paging a#" + currentPage).css({"text-decoration":"none",
            "background-color":"#97bef8",
            "font-weight":"bold",
            "color":"#fff !important"});    // 현재 페이지 표시

        $("#paging a").click(function(){
            const $item = $(this);
            const $id = $item.attr("id");
            let selectedPage = $item.text();

            if($id == "start")    selectedPage = 1;
            if($id == "next")    selectedPage = next;
            if($id == "prev")    selectedPage = prev;
            if($id == "end")    selectedPage = totalPage;

            const id = '${member.id}';

            drawLogPagination(id,selectedPage,searchKey);

            paging(totalData, dataPerPage, pageCount, selectedPage, searchKey);
        });
    }

    function drawLogPagination(id,selectedPage,searchKey){
        $.ajax({
            url: '<%=cp%>/logPagination',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: { "id" : id,
                "pageNo" : selectedPage,
                "searchKey" : searchKey },
            success: function (data) {
                if(data.length != 0){
                    $("#logTbody").empty();
                    const tbody = document.getElementById('logTbody');

                    for(let i=0; i<data.length; i++){
                        const row = tbody.insertRow( tbody.rows.length );
                        const cell1 = row.insertCell(0);
                        const cell2 = row.insertCell(1);
                        const cell3 = row.insertCell(2);
                        cell1.innerHTML = data[i].type;
                        cell2.innerHTML = data[i].content;
                        cell3.innerHTML = moment(data[i].date).format('YYYY-MM-DD HH:mm:ss');
                    }

                }
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }

    function search(){
        let searchKey = $('#searchKey').val();
        if(searchKey == ""){
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '검색어를 입력 해주세요.'
            })
            return;
        }

        const id = '${member.id}';
        let count;
        $.ajax({
            url: '<%=cp%>/getLogCountByContent',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"id" : id,"searchKey" : searchKey },
            success: function (data) {
                count = data;
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });

        if(count==0){
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '검색결과가 없습니다.'
            })
            return;
        }

        drawLogPagination(id,1,searchKey);
        paging(count, 20, 10, 1,searchKey);
    }

    function reset(){
        const id = '${member.id}';
        $('#searchKey').val("");
        drawLogPagination(id,1,"");
        paging(${count}, 20, 10, 1,"");
    }

    $("document").ready(function(){
        paging(${count}, 20, 10, 1,"");
    });
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

