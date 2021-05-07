<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 11:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<script src="static/js/jquery.dataTables.min.js"></script>
<script src="static/js/moment.min.js"></script>
<div class="container">

    <div class="row m-3 mt-3 ms-1">
        <div class="col">
            <span class="fs-4 fw-bold">환경설정 > 센서 관리</span>
        </div>
        <div class="col text-end">
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSensor"> 센서 추가</button>
        </div>
    </div>

    <div class="row m-3 mb-0 bg-light ms-1 h-25 border-bottom">
        <div class="row ms-3 mt-3">
            <div class="col">
               <div class="row">
                   <div class="col text-end">
                       분류
                   </div>
                   <div class="col">
                       <select name="place" id="place" class="btn btn-light">
                           <option value="all">all</option>
                       </select>
                   </div>
               </div>
            </div>
        </div>
    </div>

    <div class="row m-3 mt-0 ms-1 h-50 bg-light p-3">
        <table class="table table-primary text-center" id="sensorList">
            <thead>
                <tr>
                    <th>순번</th>
                    <th>분류</th>
                    <th>한글명</th>
                    <th>관리 ID</th>
                    <th>테이블명</th>
                    <th>업데이트</th>
                    <th>측정소</th>
                    <th>통신상태</th>
                </tr>
            </thead>
            <tbody id="sensorListBody">
                <%--script--%>
            </tbody>
        </table>
    </div>
</div>

<div class="modal" id="addSensor" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">센서 추가</h5>
            </div>
            <div class="modal-body d-flex justify-content-evenly">
                <div>
                    <h4>분류</h4>
                    <h4>한글명</h4>
                    <h4>센서관리ID</h4>
                    <h4>테이블명</h4>
                </div>
                <div>
                    <select name="modalDropdown1" class="btn-secondary rounded-3 mdd mb-2">
                        <option value="1">NOX</option>
                        <option value="2">O2b</option>
                    </select>
                    <input type="text" class="text-secondary d-block mb-2">
                    <input type="text" class="text-secondary d-block mb-2">
                    <input type="text" class="text-secondary d-block ">
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success">추가</button>
                <button type="button" class="btn btn-secondary" onclick="modalHide()">닫기</button>
            </div>
        </div>
    </div>
</div>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    $( document ).ready(function() {
        addTable();

        $('#sensorList').dataTable({
            lengthChange : false,
            pageLength: 8,
            info: false,
            order: false,
            language: {
                emptyTable: "데이터가 없어요.",
                lengthMenu: "페이지당 _MENU_ 개씩 보기",
                info: "현재 _START_ - _END_ / _TOTAL_건",
                infoEmpty: "데이터 없음",
                infoFiltered: "( _MAX_건의 데이터에서 필터링됨 )",
                search: "전체검색 : ",
                zeroRecords: "일치하는 데이터가 없어요.",
                loadingRecords: "로딩중...",
                processing: "잠시만 기다려 주세요...",
                paginate: {
                    next: "다음",
                    previous: "이전"
                },
            },
        });
    });

    function modalHide(){
        $('#addSensor').modal("hide");
    }

    function addTable(){
        $.ajax({
            url: '<%=cp%>/getSensorList',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            success : function(data) {
                const tbody = document.getElementById('sensorListBody');

                for(let i=0; i<data.length; i++){
                    const row = tbody.insertRow( tbody.rows.length );
                    const cell1 = row.insertCell(0);
                    const cell2 = row.insertCell(1);
                    const cell3 = row.insertCell(2);
                    const cell4 = row.insertCell(3);
                    const cell5 = row.insertCell(4);
                    const cell6 = row.insertCell(5);
                    const cell7 = row.insertCell(6);
                    const cell8 = row.insertCell(7);
                    cell1.innerHTML = i+1;
                    cell2.innerHTML = data[i].classification;
                    cell3.innerHTML = data[i].naming;
                    cell4.innerHTML = data[i].managementId;
                    cell5.innerHTML = data[i].tableName;
                    cell6.innerHTML = moment(data[i].upTime).format('YYYY-MM-DD HH:mm:ss');
                    cell7.innerHTML = data[i].place;
                    cell8.innerHTML = (data[i].status?"정상":"비정상");
                }
            },
            error : function(request, status, error) {
                console.log(error)
            }
        })
    }
</script>




