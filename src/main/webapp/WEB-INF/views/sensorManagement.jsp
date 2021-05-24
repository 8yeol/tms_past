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
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<script src="static/js/sweetalert2.min.js"></script>
<script src="static/js/common/common.js"></script>
<script src="static/js/moment.min.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>

<style>

    .dd {
        text-align-last: center;
        width: 150px;
        height: 30px;
    }

    .label {
        width: 100px;
        font-size: 1.3rem;
    }

    /* 데이터테이블 */
    .toolbar>b {
        font-size: 1.25rem;
    }

    table thead {
        background-color: #97bef8;
        color: #fff;
    }

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

    #sensorTable_filter label {
        margin-bottom: 5px;
        margin-top: 5px;
    }

    .dataTables_wrapper {
        min-height: 340px;
    }
    .inputLayout{
        width: 33%;
        display: inline;
    }
    .inputText{width: 223px;
        padding-left: 20px;
        border: 2px solid black;
    }

</style>
<div class="container" id="container">
    <div class="row">
        <div class="row m-3 mt-3 ms-1">
            <span class="fw-bold" style="font-size: 27px;">환경설정 > 센서 관리</span>
        </div>
        <div class="col-xs-12 bg-light rounded border border-dark-1 my-1 text-center">
            <form id="saveForm">
                <div class="pt-3 pe-5 ms-1">
                    <label class="me-3 col-xs-3 w-10 label">테이블명</label>
                    <select name="tableName" id="tableName" class="btn btn-outline-dark" onchange="changeTableName()">
                        <option>선택</option>
                        <c:forEach var="collection" items="${collections}" varStatus="status">
                            <option value="${collection}">${collection}</option>
                        </c:forEach>
                    </select>
                    <label class="me-3 col-xs-3 w-10 label">측정소</label>
                    <select name="place" id="place" class="btn btn-outline-dark" style="padding-right: 15px;">
                        <option  >선택</option>
                        <c:forEach var="place" items="${place}" varStatus="status">
                            <option value="${place.name}"  style="padding-right: 1rem;">${place.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="row pe-5 ms-1">
                    <div class="row bg-white m-3">
                        <div class="row">
                            <div class="col text-end">
                                <span class="text-primary" style="font-size: 0.8rem;"> * 테이블명 선택시 자동 입력됩니다.</span>
                            </div>
                        </div>
                        <div class="row p-5" style="border-left: 20px solid white;">
                            <div class=" inputLayout">
                                <label class="col-xs-3 label">관리 ID</label>
                                <input type="text" class="text-secondary rounded-3  dd col-xs-3" name="managementId"
                                       id="m_id" readonly>
                            </div>
                            <div class="inputLayout">
                                <label class="col-xs-3 w-10 label">분류</label>
                                <input type="text" class="text-secondary rounded-3 dd col-xs-3" name="classification"
                                       id="m_class" readonly>
                            </div>
                            <div class=" inputLayout">
                                <label class="col-xs-3 w-10 label">항목명</label>
                                <input type="text" class="text-secondary rounded-3  dd col-xs-3" name="naming"
                                       id="naming">
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            <div class="row">
                <div class="col text-end">
                    <button class="saveBtn btn btn-primary m-0 mb-3 me-3" onclick="saveSensor()" >센서 추가</button>
                </div>
            </div>
        </div>
        <div class="col-xs-12 bg-light rounded border border-dark-1">
            <table class="table text-center" id="sensorTable" style="word-break:break-all">
                <thead>
                <tr>
                    <th scope="col" width="10%">분류</th>
                    <th scope="col" width="10%">항복명</th>
                    <th scope="col" width="10%">관리 ID</th>
                    <th scope="col" width="18%">테이블명</th>
                    <th scope="col" width="17%">업데이트</th>
                    <th scope="col" width="10%">측정소</th>
                    <th scope="col" width="15%">통신상태</th>
                    <th scope="col" width="10%">관리</th>
                </tr>
                </thead>
                <tbody id="tbody">
                <!-- script -->
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- editModal -->
<div class="modal" id="editModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title" id="modal_title"></h5>
            </div>
            <div class="modal-body d-flex justify-content-evenly">
                <form id="editForm" method="post" autocomplete="off">

                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">분류</span>
                        </div>
                        <div class="col">
                            <input type="text" readonly name="classification2" class="inputText" >
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">항목명</span>
                        </div>
                        <div class="col">
                            <input type="text" name="naming2" class="inputText" id="naming2">
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">관리 ID</span>
                        </div>
                        <div class="col">
                            <input type="text" readonly name="managementId2" class="inputText">
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">테이블 명</span>
                        </div>
                        <div class="col">
                            <input type="text" readonly  name="tableName2" class="inputText">
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">측정소</span>
                        </div>
                        <div class="col">
                            <select name="place" id="place2" class="btn btn-outline-dark" style="width: 223px;border: 2px solid black">
                                <c:forEach var="place" items="${place}" varStatus="status">
                                    <option value="${place.name}">${place.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <input type="hidden" name="hiddenCode"> <!--수정 판별할 데이터 -->
                    <input type="hidden" name="isValueDelete"> <!--속성값 삭제 판별 데이터 -->
                </form>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5" onclick="isValueDelete()">수정</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script>
    $(function () {
        getSensor();
    });


    //데이터 가져와서 그리기
    function getSensor() {
        $('#tbody').children().remove();  //테이블 비우기

        $.ajax({
            url: '<%=cp%>/getSensorList',
            type: 'POST',
            async: false,
            cache: false,
            success: function (data) {
                const tbody = document.getElementById('tbody');
                let status;
                for (let i = 0; i < data.length; i++) {
                    if (data[i].status == false) {
                        status = '<i class="fas fa-circle ms-4 text-danger"></i>'
                    } else {
                        status = '<i class="fas fa-circle ms-4 text-success"></i>'
                    }
                    const row = tbody.insertRow(tbody.rows.length);
                    const cell1 = row.insertCell(0);
                    const cell2 = row.insertCell(1);
                    const cell3 = row.insertCell(2);
                    const cell4 = row.insertCell(3);
                    const cell5 = row.insertCell(4);
                    const cell6 = row.insertCell(5);
                    const cell7 = row.insertCell(6);
                    const cell8 = row.insertCell(7);
                    cell1.innerHTML = data[i].classification;
                    cell2.innerHTML = data[i].naming;
                    cell3.innerHTML = data[i].managementId;
                    cell4.innerHTML = data[i].tableName;
                    cell5.innerHTML = moment(data[i].upTime).format('YYYY-MM-DD HH:mm:ss');
                    cell6.innerHTML = data[i].place;
                    cell7.innerHTML = status;
                    cell8.innerHTML = '<i  class="fas fa-edit me-2" data-bs-toggle="modal" data-bs-target="#editModal" onclick="editSetting(this)"></i>' +
                        '<i  class="fas fa-times" onclick="deleteModal(this)"></i>';


                }
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        });

        $('#sensorTable').dataTable({
            lengthChange: false,
            pageLength: 10,
            info: false,
            language: {
                emptyTable: "등록된 센서가 없습니다.<br> [센서추가] 버튼을 통해 센서를 등록해주세요.",
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
    }

    function editSetting(obj) {
        var sensor = $(obj).parent().parent().children();
        $("input[name=classification2]").val(sensor.eq(0).html()); //-> NOX
        $("input[name=naming2]").val(sensor.eq(1).html());         //-> 질소산화물
        $("input[name=managementId2]").val(sensor.eq(2).html());  // -> NOX_01
        $("input[name=tableName2]").val(sensor.eq(3).html());  // -> tmsWP0001_NOX_01
        $("input[name=hiddenCode]").val(sensor.eq(3).html());  // -> tmsWP0001_NOX_01

        $("#modal_title").html("관리 ID : <font class='text-primary'><b>"+sensor.eq(2).html()+"</b></font>");
        $("#place2").val(sensor.eq(5).html());


    }

    function deleteModal(obj) {
        const tableName = $(obj).parent().parent().children().eq(3).html(); //-> tmsWP0001_NOX_01
        const place = $(obj).parent().parent().children().eq(5).html();
        const sensor = $(obj).parent().parent().children().eq(1).html();

        Swal.fire({
            icon: 'error',
            title: '삭제',
            text: '정말 삭제 하시겠습니까?',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                deleteSensor(tableName,place,sensor);
            }
        });
    }

    function deleteSensor(tableName, place, sensor) {
        $.ajax({
            url: '<%=cp%>/deleteSensor',
            type: 'POST',
            async: false,
            cache: false,
            data: {tableName: tableName},
            success: function () {
                customSwal('삭제 완료','삭제 되었습니다..');
                inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', place+' - '+sensor+' 센서 삭제','설정');
                setTimeout(function () {
                    location.reload();
                }, 2000);
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }

    //배출량 관리 - 허용 기준 생성
    function saveStandard(form){
        $.ajax({
            url: '<%=cp%>/saveStandard',
            type: 'POST',
            async: false,
            cache: false,
            data: form,
            success: function () {
                Swal.fire({
                    icon: 'success',
                    title:'허용 기준 생성',
                    text: '허용 기준이 없으므로 자동으로 생성합니다.',
                });
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        });
    }

    function isValueDelete(){
        if($("input[name='naming2']").val() == ''){
            customSwal('경고','항목명을 선택 해주세요.');
            return;
        }
        if($("#place2").val() == null){
            customSwal('경고','측정소를 선택 해주세요.');
            return;
        }

        Swal.fire({
            icon: 'warning',
            title: '경고',
            text: '센서의 설정값을 초기화 하시겠습니까?',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor:'#198754',
            confirmButtonText: '설정값 초기화',
            cancelButtonText: '설정값 유지'
        }).then((result) => {
            if (result.isConfirmed) {
                $('input[name=isValueDelete]').val('delete');
                    saveSensor(2);
            }else if ( result.dismiss === Swal.DismissReason.cancel){
                    saveSensor(2);
            }
        });
    }

    //데이터 저장 후 페이지 새로고침
    function saveSensor(idx) {
        let form = "";
        let title = "";
        let content = "";

        if ($('#tableName'+idx).val() == '선택') {
            customSwal('경고','테이블명을 선택 해주세요.');
            return;
        }

        if ($('#place' + idx).val() == '선택') {
            customSwal('경고','측정소를 선택 해주세요.');
            return;
        }

        if (idx == 2) {
            form = $('#editForm').serialize();
            if($("#place2").val() == null){
                $('input[name=isValueDelete]').val('');
                customSwal('경고','측정소를 선택 해주세요.');
                return;
            }
            if($("input[name='naming2']").val() == ''){
                $('input[name=isValueDelete]').val('');
                customSwal('경고','항목명을 선택 해주세요.');
                return;
            }


            content = '센서 측정소가 수정 되었습니다.';
            title = '센서 수정';

        } else {
            form = $('#saveForm').serialize();
            if(isStandardEmpty($('#tableName').val())){
                saveStandard(form);
            }
            content = '센서가 추가 되었습니다.';
            title = '센서 추가';
            $("input[name=hiddenCode]").val("");   //수정했을때 남아있는 히든코드 초기화
        }

        // 측정소 sensor 중복 검사
        const sensorNames = [];
        const sensorNames2 = [];
        $.ajax({
            url: '<%=cp%>/getPlaceSensor',
            type: 'POST',
            async: false,
            cache: false,
            data: form,
            success: function (data) {
                for(let i=0; i<data.length; i++){
                    const tableName = data[i];
                    $.ajax({
                        url: '<%=cp%>/getSensorManagementId',
                        type: 'POST',
                        dataType: 'json',
                        async: false,
                        cache: false,
                        data: {'name' : tableName},
                        success: function (data) {
                            if($('#naming').val()==data.naming)
                                sensorNames.push(data.naming);

                            if($('#naming2').val()==data.naming)
                                sensorNames2.push(data.naming);
                        },
                        error: function (request, status, error) { // 결과 에러 콜백함수
                            console.log(error);
                        }
                    });
                }

            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        });

        if(sensorNames.length > 0) {
            $('#naming').focus();
            customSwal('항목명 중복', '해당 측정소에 이미 등록된 항목명입니다. 항목명 수정 후 다시 등록해주세요.');
        }else if(sensorNames2.length > 0){
            $('#naming2').focus();
            customSwal('항목명 중복', '해당 측정소에 이미 등록된 항목명입니다. 항목명 수정 후 다시 등록해주세요.');
        }else{
            $.ajax({
                url: '<%=cp%>/saveSensor',
                type: 'POST',
                async: false,
                cache: false,
                data: form,
                success: function () {
                    $('#editModal').modal('hide');
                    Swal.fire({
                        icon: 'success',
                        title: title,
                        text: content,
                    })
                    setTimeout(function () {
                        location.reload();
                    }, 1500);
                },
                error: function (request, status, error) { // 결과 에러 콜백함수
                    console.log(error);
                }
            });
        }
    }

    function isStandardEmpty(tableName){
        let flag= false;
        $.ajax({
            url: '<%=cp%>/isStandardEmpty',
            type: 'POST',
            async: false,
            cache: false,
            data: {'tableName' : tableName},
            success: function (data) {
                if(data)flag=true;
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        });
        return flag;
    }

    function changeTableName() {
        const tableName = $("#tableName").val();
        if (tableName == "선택") {
            $('#m_id').val("");
            $('#m_class').val("");
            $('#naming').val("");
            $('#place option:eq(0)').attr('selected', 'selected');
        } else {
            const str = tableName.split('_');
            const id = str[1] + '_' + str[2];
            $('#m_id').val(id);
            $('#m_class').val(str[1]);

            const naming = findNaming(str[1]);

            if(naming=="")
                $('#naming').val(str[1]);
            else
                $('#naming').val(naming)
        }
    }

    function findNaming(classification) {
        let result = "";
        $.ajax({
            url: '<%=cp%>/getNaming',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {classification: classification},
            success: function (data) {
                result = data.naming;
            },
            error: function (request, status, error) {
                console.log(error)
            }
        })
        return result;
    }

    function customSwal(title,text){
        Swal.fire({
            icon: 'warning',
            title: title,
            text: text,
            timer: 1500
        })
    }

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






