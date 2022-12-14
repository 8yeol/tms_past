<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/datepicker.min.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/lib/moment.min.js"></script>
<script src="static/js/lib/jquery-ui.js"></script>
<script src="static/js/lib/sweetalert2.min.js"></script>
<script src="static/js/lib/datepicker.min.js"></script>
<script src="static/js/lib/datepicker.ko.js"></script>

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

    .search>span {
        margin-right: 10px;
        vertical-align: middle;
    }
    .search>select {
        vertical-align: middle;
        border-radius: .25rem;
        border: 1px solid #999;
        height: 38px;
        padding: 0 3px;
    }
    .search>input {
        width: 150px;
        height: 38px;
        vertical-align: middle;
        border-radius: .25rem;
        border: 1px solid #999;
    }

    @media all and  (max-width: 1199px) and (min-width: 1024px) {
        .search>input {width: 120px;}
    }
    @media all and (max-width: 1023px) and (min-width: 990px) {
        .search>input {width: 100px;}
    }

    @media all and (max-width: 989px) {
        .search>input {width: 100px;height: 38px;}
        .search>select {height: 38px;}
        .search {text-align: left;}
        .search>button {margin-top: 5px;}
    }
    #searchKey{
        padding-left: 10px;
    }
</style>
<div class="container" id="container">
    <c:choose>
        <c:when test="${member.state eq '5'}">
            <c:set var="state" value="?????? ??????"></c:set>
        </c:when>
        <c:when test="${member.state eq '4'}">
            <c:set var="state" value="?????? ??????"></c:set>
        </c:when>
        <c:when test="${member.state eq '3'}">
            <c:set var="state" value="??????"></c:set>
        </c:when>
        <c:when test="${member.state eq '2'}">
            <c:set var="state" value="?????????"></c:set>
        </c:when>
        <c:when test="${member.state eq '1'}">
            <c:set var="state" value="?????? ?????????"></c:set>
        </c:when>
    </c:choose>

    <h3 class="d-flex justify-content-start mt-5 mb-3 fw-bold" style="position: relative;">?????? ??????
        <button class="btn backBtn" onclick="location.href='<%=cp%>/setting'" style="margin-left: 40px; position: absolute; right: 0;">?????? ??????</button></h3>

    <div class="row bg-light rounded py-3 px-5">
        <div class="col">
            <h4 class=" justify-content-start"><b>${member.id} [${state}] </b>&nbsp;?????? ????????????</h4>
        </div>

        <div class="col text-end search">
            <span class="fs-6 fw-bold">????????????</span>
            <select class="bg-white"  id="searchType">
                <option value="null">??????</option>
                <option value="type">??????</option>
                <option value="content">??????</option>
                <option value="date">??????</option>
            </select>

            <input type="text" id="searchKey" autocomplete="off">
            <button class="btn btn-primary ms-2" onclick="search();">??????</button>
            <button class="btn ms-2" onclick="reset();" style="border: 1px solid #0d6efd; color: #0d6efd;">?????????</button>
        </div>

        <div class="col-xs-12 mt-3">
            <table class="table table-striped" id="member-Table">
                <thead>
                <tr class="text-center">
                    <th width="15%">??????</th>
                    <th>??????</th>
                    <th width="20%">?????? ??????</th>
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

    function paging(totalData, dataPerPage, pageCount, currentPage, searchKey, searchType){
        const totalPage = Math.ceil(totalData/dataPerPage);    // ??? ????????? ???
        const pageGroup = Math.ceil(currentPage/pageCount);    // ????????? ??????
        let last = pageGroup * pageCount;    // ????????? ????????? ????????? ????????? ??????
        if(last > totalPage)
            last = totalPage;
        const first = last - (pageCount-1);    // ????????? ????????? ????????? ????????? ??????
        const next = last+1;
        const prev = first-1;

        let html = "";

        if(prev > 0) {
            html += "<a href=javascript:; id='start'>??????</a> ";
            html += "<a href=javascript:; id='prev'>??????</a> ";
        }

        for(let i=first; i <= last; i++){
            if(i > 0){
                html += "<a href='javascript:;' id=" + i + ">" + i + "</a> ";  //href=javascript:; ????????? ????????????
            }
        }

        if(last < totalPage) {
            html += "<a href=javascript:; id='next'>??????</a> ";
            html += "<a href=javascript:; id='end'>???</a>";
        }

        $("#paging").html(html);    // ????????? ?????? ??????
        $("#paging a").css("color", "#333");
        $("#paging a#" + currentPage).css({"text-decoration":"none",
            "background-color":"#97bef8",
            "font-weight":"bold",
            "color":"#fff !important"});    // ?????? ????????? ??????

        $("#paging a").click(function(){
            const $item = $(this);
            const $id = $item.attr("id");
            let selectedPage = $item.text();

            if($id == "start")    selectedPage = 1;
            if($id == "next")    selectedPage = next;
            if($id == "prev")    selectedPage = prev;
            if($id == "end")    selectedPage = totalPage;

            const id = '${member.id}';

            drawLogPagination(id,selectedPage,searchKey,searchType);

            paging(totalData, dataPerPage, pageCount, selectedPage, searchKey, searchType);
        });
    }

    function drawLogPagination(id,selectedPage,searchKey,searchType){
        $.ajax({
            url: '<%=cp%>/logPagination',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: { "id" : id,
                "pageNo" : selectedPage,
                "searchKey" : searchKey,
                "searchType" : searchType},
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
        let searchType = $('#searchType').val();
        if(searchType=='null'){
            swal('warning','??????','??????????????? ?????? ????????????.');
            return;
        }

        let searchKey = $('#searchKey').val();
        if(searchKey == ""){
            swal('warning','??????','???????????? ?????? ????????????.');
            return;
        }

        const id = '${member.id}';
        let count;
        $.ajax({
            url: '<%=cp%>/getLogCountBySearchKey',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"id" : id,"searchKey" : searchKey,"searchType" : searchType },
            success: function (data) {
                count = data;
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });

        if(count==0){
            swal('warning','??????','??????????????? ????????????.');
            return;
        }

        drawLogPagination(id,1,searchKey,searchType);
        paging(count, 20, 10, 1,searchKey,searchType);
    }

    function reset(){
        const id = '${member.id}';
        $('#searchKey').prop("type","text");
        $('#searchKey').val("");
        $('#searchType option:eq(0)').prop("selected",true);
        drawLogPagination(id,1,"","");
        paging(${count}, 20, 10, 1,"","");
    }

    $("document").ready(function(){
        paging(${count}, 20, 10, 1,"",""); //?????? ID ?????? ????????????
    });


    $('#searchType').change(function (){

        if(this.value == 'date'){
            $("#datepickers-container").css("display","block");
            $('#searchKey').val("");
            $('#searchKey').attr("readonly",true);
            $("#searchKey").datepicker({
                language:'ko',
                minDate: new Date("2021-05-12"),
                maxDate:new Date()
            });
        }else{
            $("#datepickers-container").css("display","none");
            $('#searchKey').attr("readonly",false);
            $('#searchKey').val("");
        }
    });


    function swal(icon,title,text){
        Swal.fire({
            icon: icon,
            title: title,
            text: text
        })
    }
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

