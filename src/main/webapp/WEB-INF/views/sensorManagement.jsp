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
<link rel="stylesheet" href="static/css/page/sensorManagement.css">

<script src="static/js/common/common.js"></script>
<script src="static/js/lib/sweetalert2.min.js"></script>
<script src="static/js/lib/moment.min.js"></script>
<script src="static/js/lib/jquery.dataTables.min.js"></script>

<div class="container" id="container">
    <div class="row">
        <div class="col m-3 mt-3 ms-1" style="padding: 0">
            <span class="fw-bold fs-4">환경설정 > 센서 관리</span>
        </div>
        <div class="col text-end align-self-end" style="color:red; font-size: 0.8rem; font-weight: normal">
            * 센서 관리는 '최고 관리자' 권한을 가진 회원만 사용 가능합니다.
        </div>
        <div class="col-xs-12 bg-light rounded border border-dark-1 my-1 text-center">
            <form id="saveForm" style="margin: 0;">
                <div class="pt-3 pe-5 m-margin" style="margin: 15px 0 15px 50px;">
                    <label class="me-3 col-xs-3 w-10" style="text-align: right; font-size: 1.3rem;">테이블명</label>
                    <select name="tableName" id="tableName" class="btn btn-outline-dark" onchange="changeTableName()" style="margin-right: 20px;">
                        <option>선택</option>
                        <c:forEach var="collection" items="${collections}" varStatus="status">
                            <option value="${collection}">${collection}</option>
                        </c:forEach>
                    </select>
                    <label class="me-3 col-xs-3 w-10" style="text-align: right; font-size: 1.3rem;">측정소</label>
                    <select name="place" id="place" class="btn btn-outline-dark" style="padding-right: 15px;">
                        <option  >선택</option>
                        <c:forEach var="place" items="${place}" varStatus="status">
                            <option value="${place.name}"  style="padding-right: 1rem;">${place.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="row pe-5 ms-1">
                    <div class="row m-3" style="border-top: 1px solid #0d6efd; border-bottom: 1px solid #0d6efd; position: relative;">
                        <span class="text-primary s-style"> * 테이블명 선택시 자동 입력됩니다.</span>
                        <div class="row p-5">
                            <div class=" inputLayout">
                                <label class="col-xs-3 label" style="margin-right: 16px">관리 ID</label>
                                <input type="text" class="mediaText p-1" name="managementId" id="m_id" class="inputDisabled" readonly>
                            </div>
                            <div class="inputLayout">
                                <label class="col-xs-3 w-10 label" style="margin-right: 16px">분류</label>
                                <input type="text" class="mediaText p-1" name="classification" id="m_class" class="inputDisabled" readonly>
                            </div>
                            <div class=" inputLayout">
                                <label class="col-xs-3 w-10 label" style="margin-right: 16px">항목명</label>
                                <input type="text" class="mediaText p-1" name="naming" id="naming"  autocomplete="off" maxlength="20">
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            <div class="row">
                <div class="col text-end">
                    <button class="saveBtn btn btn-primary m-0 mb-3 me-3" onclick="saveSensorCheck(0)" >센서 추가</button>
                </div>
            </div>
        </div>
        <div class="col-xs-12 bg-light rounded border border-dark-1">
            <table class="table text-center" id="sensorTable" style="word-break:break-all">
                <thead>
                <tr>
                    <th scope="col" width="9%">분류</th>
                    <th scope="col" width="11%">항목명</th>
                    <th scope="col" width="10%">관리 ID</th>
                    <th scope="col" width="18%">테이블명</th>
                    <th scope="col" width="17%">업데이트</th>
                    <th scope="col" width="15%">측정소</th>
                    <th scope="col" width="10%">통신상태</th>
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

<%-- status message --%>
<div class="status">
    <div>
        <p>측정기</p>
        <p id="measuring">정상</p>
    </div>
    <div>
        <p>자료수집기</p>
        <p id="dataLogger">정상</p>
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
                            <input type="text" name="edit_classification" class="inputText2 p-1 inputDisabled" readonly>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">항목명</span>
                        </div>
                        <div class="col">
                            <input type="text" name="edit_naming" class="inputText p-1" id="edit_naming"  autocomplete="off" maxlength="20">
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">관리 ID</span>
                        </div>
                        <div class="col">
                            <input type="text" name="edit_managementId" class="inputText2 p-1 inputDisabled" readonly>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">테이블 명</span>
                        </div>
                        <div class="col">
                            <input type="text" name="edit_tableName" class="inputText2 p-1 inputDisabled" readonly>
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">측정소</span>
                        </div>
                        <div class="col">
                            <select name="place" id="edit_place" class="btn btn-outline-dark" style="width: 223px;">
                                <c:forEach var="place" items="${place}" varStatus="status">
                                    <option value="${place.name}"> ${place.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <input type="hidden" name="hiddenCode"> <!--수정 판별할 데이터 -->
                    <input type="hidden" name="isValueDelete"> <!--속성값 삭제 판별 데이터 -->
                </form>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5" onclick="updateSensor()">수정</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script>
    $(function () {
        getSensor();

        //swal ESC로 닫기
        $(document).keydown(function(e){
            if(e.keyCode == 27 && $('.swal2-close')!=null )
                $('.swal2-close').trigger("click");
        });
    });

    function mouseOn(status1, status2){
        let status1_color, status2_color, status1_txt, status2_txt;

        if (status1 == 0) {
            status1_color = "#50e400";
            status1_txt = "정상";
        } else if ( status1 == 1 ) {
            status1_color = "#fcd521";
            status1_txt = "교정중";
        } else if ( status1 == 2 ) {
            status1_color = "#8600e4";
            status1_txt = "동작불량";
        } else if ( status1 == 4) {
            status1_color = "#ff1c1c";
            status1_txt = "전원단절";
        } else if ( status1 == 8 ) {
            status1_color = "#f49206";
            status1_txt = "보수중";
        }

        if (status2 == 0) {
            status2_color = "#50e400";
            status2_txt = "정상";
        } else if ( status2 == 1 ) {
            status2_color = "#8600e4";
            status2_txt = "동작불량";
        } else if ( status2 == 4) {
            status2_color = "#ff1c1c";
            status2_txt = "전원단절";
        }

        $("#measuring").text(status1_txt);
        $("#measuring").css('color', status1_color);
        $("#dataLogger").text(status2_txt);
        $("#dataLogger").css('color', status2_color);

        $(".status").show();
        const status = document.querySelector(".status");
        const mouseX = event.clientX;
        const mouseY = event.clientY;
        status.style.left = mouseX + 'px';
        status.style.top = mouseY + 'px';
    }

    function mouseOut(){
        $(".status").hide();
    }

    //데이터 가져와서 그리기
    function getSensor() {
        $('#tbody').children().remove();  //테이블 비우기

        $.ajax({
            url: '<%=cp%>/getSensorList',
            type: 'POST',
            async: false,
            cache: false,
            success: function (data) {
                console.log(data);
                const tbody = document.getElementById('tbody');
                let status;
                for (let i = 0; i < data.length; i++) {
                    const status1 = data[i].status1;
                    const status2 = data[i].status2;
                    if (status1 == 0 || status2 == 0) {
                        status = '<i class="fas fa-circle" color="#50e400" onmouseover="mouseOn(\''+status1+'\', \''+status2+'\')" onmouseout="mouseOut();"></i>'
                    }
                    if ( status1 == 1 ) {
                        status = '<i class="fas fa-circle" color="#fcd521" onmouseover="mouseOn(\''+status1+'\', \''+status2+'\')" onmouseout="mouseOut();"></i>'
                    }
                    if ( status1 == 2 || status2 == 1) {
                        status = '<i class="fas fa-circle" color="#8600e4" onmouseover="mouseOn(\''+status1+'\', \''+status2+'\')"></i>'
                    }
                    if ( status1 == 4 || status2 == 4) {
                        status = '<i class="fas fa-circle" color="#ff1c1c" onmouseover="mouseOn(\''+status1+'\', \''+status2+'\')" onmouseout="mouseOut();"></i>'
                    }
                    if ( status1 == 8 ) {
                        status = '<i class="fas fa-circle" color="#f49206" onmouseover="mouseOn(\''+status1+'\', \''+status2+'\')" onmouseout="mouseOut();"></i>'
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
                    if("${state}" == "1"){
                        cell8.innerHTML = '<i  class="fas fa-edit me-2" data-bs-toggle="modal" data-bs-target="#editModal" onclick="editSetting(this)"></i>' +
                            '<i  class="fas fa-times" onclick="deleteModal(this)"></i>';
                    }
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
        const sensor = $(obj).parent().parent().children();
        $("input[name=edit_classification]").val(sensor.eq(0).html());
        $("input[name=edit_naming]").val(sensor.eq(1).html());
        $("input[name=edit_managementId]").val(sensor.eq(2).html());
        $("input[name=edit_tableName]").val(sensor.eq(3).html());
        $("input[name=hiddenCode]").val(sensor.eq(3).html());

        $("#modal_title").html("관리 ID : <font class='text-primary'><b>"+sensor.eq(2).html()+"</b></font>");
        $("#edit_place").val(sensor.eq(5).html());
    }

    function deleteModal(obj) {
        const tableName = $(obj).parent().parent().children().eq(3).html();
        const place = $(obj).parent().parent().children().eq(6).html();
        const naming = $(obj).parent().parent().children().eq(1).html();
        const id = $(obj).parent().parent().children().eq(2).html();

        Swal.fire({
            icon: 'error',
            title: '센서 삭제',
            text: '\''+ id + '\' 센서를 삭제 하시겠습니까?',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed)
                deleteSensor(tableName,place,naming);
        });
    }

    function deleteSensor(tableName, place, naming) {
        $.ajax({
            url: '<%=cp%>/deleteSensor',
            type: 'POST',
            async: false,
            cache: false,
            data: {tableName: tableName, place: place, naming: naming},
            success: function () {
                Swal.fire({
                    icon: 'success',
                    title: "삭제 완료",
                    text: "삭제 되었습니다.",
                    showConfirmButton: false
                })

                setTimeout(function () {
                    location.reload();
                }, 2000);
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }

    function updateSensor(){
        if(saveSensorCheck(2)) {
            let form = $('#editForm').serialize();
            let content = '센서 측정소가 변경 되었습니다.';
            let title = '센서 수정';
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '센서의 설정값을 초기화 하시겠습니까?',
                showCancelButton: true,
                showCloseButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#198754',
                confirmButtonText: '설정값 <a class="sign"></a> 초기화',
                cancelButtonText: '설정값 <a class="sign"></a> 유지'
            }).then((result) => {
                if (result.isConfirmed) {
                    $('input[name=isValueDelete]').val('delete');
                    saveSensor(form,title,content);
                } else if (result.dismiss === Swal.DismissReason.cancel) {
                    $('input[name=isValueDelete]').val('');
                    saveSensor(form,title,content);
                }
            });
        }
    }

    //데이터 저장 후 페이지 새로고침
    function saveSensorCheck(idx) {
        let form = "";
        let title = "";
        let content = "";

        if ("${state}" != "1"){
            customSwal('경고', '최고 관리자만 센서 등록이 가능합니다.');
            return;
        }

        if (idx == 0) {
            if ($('#tableName').val() == '선택') {
                customSwal('경고', '테이블명을 선택 해주세요.');
                return;
            }
            if ($('#place').val() == '선택') {
                customSwal('경고', '측정소를 선택 해주세요.');
                return;
            }
            if (strReplace($("#naming").val()) == '') {
                customSwal('경고', '항목명을 확인 해주세요.');
                return;
            }
        }else if(idx == 2){
            if(strReplace($("input[name='edit_naming']").val()) == ''){
                customSwal('경고','항목명을 선택 해주세요.');
                return;
            }
            if($("#edit_place").val() == null){
                customSwal('경고','측정소를 선택 해주세요.');
                return;
            }
        }

        if (idx == 0) {
            $("#naming").val( strReplace($("#naming").val()));
            form = $('#saveForm').serialize();
            content = '센서가 추가 되었습니다.';
            title = '센서 추가';
            $("input[name=hiddenCode]").val("");
            $('input[name=isValueDelete]').val("");

        } else {
            $("#edit_naming").val( strReplace($("#edit_naming").val()));
            form = $('#editForm').serialize();
        }

        // 측정소 sensor 중복 검사
        const distinctCount = [];
        const edit_distinctCount = [];
        $.ajax({
            url: '<%=cp%>/isNamingEquals',
            type: 'POST',
            async: false,
            cache: false,
            data: form,
            success: function (data) {
                if(data == 'addFalse'){
                    distinctCount.push(data.naming);
                }else if(data == 'editFalse'){
                    edit_distinctCount.push(data.naming);
                }
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        });

        if(distinctCount.length > 0) {
            $('#naming').focus();
            customSwal('항목명 중복', '해당 측정소에 이미 등록된 항목명입니다. 항목명 수정 후 다시 등록해주세요.');
            return false;

        }else if(edit_distinctCount.length > 0){
            $('#edit_naming').focus();
            customSwal('항목명 중복', '해당 측정소에 이미 등록된 항목명입니다. 항목명 수정 후 다시 등록해주세요.');
            return false;

        }else if(idx==0){
            saveSensor(form,title,content);
        }else if(idx==2){
            return true;
        }
    }

    function saveSensor(form,title,content){
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
                    showConfirmButton: false
                })
                setTimeout(function () {
                    location.reload();
                }, 2000);
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        });
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
            text: text
        })
    }
</script>
