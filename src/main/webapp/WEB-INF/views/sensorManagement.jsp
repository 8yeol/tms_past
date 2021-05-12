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
    .mg1 {
        margin-right: 50px;
    }

    .dd {
        text-align-last: center;
        width: 150px;
        height: 30px;
    }

    .label {
        width: 100px;
        font-size: 1.3rem;
    }

</style>

<div class="container">
    <div class="row">
        <div class="d-flex justify-content-between my-3">
            <h3>센서 관리</h3>
        </div>
        <div class="col-xs-12 bg-light rounded border border-dark-1 my-1 text-center">
            <form id="saveForm">
                <div class="pt-3 pe-5 ms-1">
                    <label class="me-3 col-xs-3 w-10 label">테이블명</label>
                    <select name="tableName" id="tableName" class="btn btn-outline-dark" onchange="changeTableName('')">
                        <option>선택</option>
                        <c:forEach var="collection" items="${collections}" varStatus="status">
                            <option value="${collection}">${collection}</option>
                        </c:forEach>
                    </select>
                    <label class="me-3 col-xs-3 w-10 label">측정소</label>
                    <select name="place" id="place" class="btn btn-outline-dark">
                        <option>선택</option>
                    </select>
                </div>
                <div class="row pe-5 ms-1">
                    <div class="row bg-white m-3">
                        <div class="row">
                            <div class="col text-end">
                                <span class="text-primary" style="font-size: 15%"> * 테이블명 선택시 자동 입력됩니다.</span>
                            </div>
                        </div>
                        <div class="row p-5">
                            <div class="col">
                                <label class="me-3 col-xs-3 label">관리 ID</label>
                                <input type="text" class="text-secondary rounded-3  dd mg1 col-xs-3" name="managementId"
                                       id="m_id" readonly>
                            </div>
                            <div class="col">
                                <label class="me-3 col-xs-3 w-10 label">분류</label>
                                <input type="text" class="text-secondary rounded-3 dd col-xs-3" name="classification"
                                       id="m_class" readonly>
                            </div>
                            <div class="col">
                                <label class="me-3 col-xs-3 w-10 label">항목명</label>
                                <input type="text" class="text-secondary rounded-3  dd mg1 col-xs-3" name="naming"
                                       id="naming" readonly>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            <div class="row">
                <div class="col text-end">
                    <button class="saveBtn btn btn-primary m-0 mb-3 me-3" onclick="saveSensor('')">센서 추가</button>
                </div>
            </div>
        </div>
        <div class="col-xs-12 bg-light rounded border border-dark-1">
            <table class="table text-center" id="sensorTable">
                <thead>
                <tr>
                    <th scope="col" width="10%">분류</th>
                    <th scope="col" width="10%">한글명</th>
                    <th scope="col" width="10%">관리 ID</th>
                    <th scope="col" width="20%">테이블명</th>
                    <th scope="col" width="20%">업데이트</th>
                    <th scope="col" width="10%">측정소</th>
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

<!-- editModal -->
<div class="modal" id="editModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">센서 수정</h5>
            </div>
            <div class="modal-body d-flex justify-content-evenly">
                <form id="editForm" method="post" autocomplete="off">
                    <div class="row">
                        <div class="col text-center" id="label">
                            <span class="text-primary" style="font-size: 15%"> * 테이블명 선택시 자동 입력됩니다.</span>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">테이블명</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="tableName" id="tableName2" readonly>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">측정소</span>
                        </div>
                        <div class="col">
                            <select name="place" id="place2" class="btn btn-outline-dark" style="width: 223px;">
                            </select>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">관리 ID</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="managementId" id="m_id2" readonly>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">분류</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="classification" id="m_class2" readonly>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">항목명</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="naming" id="naming2" readonly>
                        </div>
                    </div>
                    <input type="hidden" name="hiddenCode"> <!--수정 판별할 데이터 -->
                </form>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5" onclick="saveSensor(2)">수정</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>


<!-- 배출허용 기준 추가 -->
<div class="modal" id="addModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">항목명 추가</h5>
            </div>
            <div class="modal-body d-flex justify-content-evenly">
                <form id="addStandard" method="post" autocomplete="off">
                    <div class="row">
                        <div class="col text-center">
                            <span class="text-danger" style="font-size: 15%"> * 설정된 분류 코드와 항목명을 기준으로 모니터링 항목명(한글명)이 적용됩니다.</span>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">분류 코드</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="code" readonly>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">항목명</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="sensorName">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5" onclick="addStandardSetting()">추가</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script>
    $(function () {
        getSensor();
        getPlace();
    });

    function getPlace() {
        $.ajax({
            url: 'getPlaceList',
            type: 'POST',
            async: false,
            cache: false,
            success: function (data) {
                for (i = 0; i < data.length; i++) {
                    innerHTML = '<option value="'+data[i].name+'">'+data[i].name+'</option>';
                    $('#place').append(innerHTML);
                    $('#place2').append(innerHTML);
                }
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }

    //데이터 가져와서 그리기
    function getSensor() {
        $('#tbody').children().remove();  //테이블 비우기

        $.ajax({
            url: 'getSensorList',
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
                    cell8.innerHTML = '<i type="button" class="fas fa-edit me-2" data-bs-toggle="modal" data-bs-target="#editModal" onclick="editSetting(this)"></i>' +
                        '<i type="button" class="fas fa-times" onclick="deleteModal(this)"></i>';
                    /* '<i class="btn fas fa-edit me-2" ata-bs-toggle="modal" data-bs-target="#exampleModal"></i>' +
                     '<i class="fas fa-times" data-toggle="modal" data-target="#deleteSensor"></i>';*/
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

        $("#tableName2").val(sensor.eq(3).html());             // -> tmsWP0001_NOX_01
        $("#place2").val(sensor.eq(5).html());                 // -> 측정소 1
        $("input[name=hiddenCode]").val(sensor.eq(3).html());  // -> tmsWP0001_NOX_01

        changeTableName(2);   // -> null= 추가 , 2 = 수정
    }

    function deleteModal(obj) {
        let tableName = $(obj).parent().parent().children().eq(3).html(); //-> tmsWP0001_NOX_01
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
                deleteSensor(tableName);
            }
        });
    }

    function deleteSensor(tableName) {
        $.ajax({
            url: 'deleteSensor',
            type: 'POST',
            async: false,
            cache: false,
            data: {tableName: tableName},
            success: function (data) {
                Swal.fire({
                    icon: 'warning',
                    title: '삭제 완료',
                    text: '삭제 되었습니다..',
                    timer: 1500
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


    //데이터 저장 후 페이지 새로고침
    function saveSensor(idx) {

        if ($('#tableName' + idx).val() == '선택') {
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '테이블명을 선택 해주세요.'
            })
            return;
        }

        if ($('#place' + idx).val() == '선택') {
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '측정소를 선택 해주세요.'
            })
            return;
        }

        if ($('#naming' + idx).val() == '') {
            $('input[name=code]').val($('#m_class').val());
            $('#addModal').modal('show');
            return;
        }

        let form = "";
        let str = "";

        if (idx == 2) {
            form = $('#editForm').serialize();
            str = '수정';
        } else {
            form = $('#saveForm').serialize();
            str = '추가';
            $("input[name=hiddenCode]").val("");   //수정했을때 남아있는 히든코드 초기화
        }

        $.ajax({
            url: 'saveSensor',
            type: 'POST',
            async: false,
            cache: false,
            data: form,
            success: function () {
                $('#editModal').modal('hide');
                Swal.fire({
                    icon: 'success',
                    title: '센서 ' + str,
                    text: '관리 항목에 센서가 ' + str + ' 되었습니다.',
                    timer: 1500
                })
                setTimeout(function () {
                    location.reload();
                }, 2000);
                /*
                drawTable(data);
                $("input[type=text]").val("");
                $('#tableName option:eq(0)').attr('selected','selected');
                $('#place option:eq(0)').attr('selected','selected');
                */
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        });
    }

    function addStandardSetting(){
        $("input[type=hidden]").val("");
        standardForm = $('#addStandard').serialize();
        addStandard(standardForm);
    }

    function addStandard(form){
        $.ajax({
            url: 'simpleSaveStandard',
            type: 'POST',
            async: false,
            cache: false,
            data: form,
            success: function () {
                $('#addModal').modal('hide');
                Swal.fire({
                    icon: 'success',
                    title: '추가 완료 ',
                    html: '항목명이 설정 되었습니다. 항목명 변경은 <b>[환경설정 - 연간 배출 허용 기준 설정]</b> 에서 변경하실 수 있습니다.',
                    timer: 1500
                })
                changeTableName('');
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        });
    }

    function changeTableName(idx) {
        const tableName = $("#tableName" + idx).val();
        if (tableName == "선택") {
            $('#m_id' + idx).val("");
            $('#m_class' + idx).val("");
            $('#naming' + idx).val("");
            $('#place' + idx + ' option:eq(0)').attr('selected', 'selected');
        } else {
            const str = tableName.split('_');
            const id = str[1] + '_' + str[2];
            $('#m_id' + idx).val(id);
            $('#m_class' + idx).val(str[1]);
            $('#naming' + idx).val(findNaming(tableName));
        }
    }

    function findNaming(tableName) {
        let result = "";
        $.ajax({
            url: '/getNaming',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            success: function (data) {
                for (i = 0; i < data.length; i++) {
                    if (tableName.includes(data[i].item))
                        result = data[i].itemName;
                }
            },
            error: function (request, status, error) {
                console.log(error)
            }
        })
        return result;
    }
</script>






