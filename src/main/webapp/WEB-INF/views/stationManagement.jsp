<%--
  Created by IntelliJ IDEA.
  User: hsheo
  Date: 2021-04-19
  Time: 오전 11:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<script src="static/js/common/common.js"></script>
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<script src="static/js/sweetalert2.min.js"></script>
<%--modal 사용--%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js"></script>
<%--draggable사용--%>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<style>
    /* The switch - the box around the slider */
    .switch {
        position: relative;
        display: inline-block;
        width: 60px;
        height: 34px;
    }

    /* Hide default HTML checkbox */
    .switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    /* The slider */
    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        -webkit-transition: .4s;
        transition: .4s;
    }

    .slider:before {
        position: absolute;
        content: "";
        height: 26px;
        width: 26px;
        left: 4px;
        bottom: 4px;
        background-color: white;
        -webkit-transition: .4s;
        transition: .4s;
    }

    input:checked + .slider {
        background-color: #2196F3;
    }

    input:focus + .slider {
        box-shadow: 0 0 1px #2196F3;
    }

    input:checked + .slider:before {
        -webkit-transform: translateX(26px);
        -ms-transform: translateX(26px);
        transform: translateX(26px);
    }

    /* Rounded sliders */
    .slider.round {
        border-radius: 34px;
    }

    .slider.round:before {
        border-radius: 50%;
    }

</style>
<div class="container">
    <div class="col" style="font-weight: bolder;margin: 30px 0px; font-size: 27px">
        환경설정 > 측정소 관리
    </div>

    <div class="row bg-light rounded"><span style=";font-size: 22px; font-weight: bolder;padding: 20px 20px 30px 25px;">측정소 등록 및 측정소별 항목 등록</span>
    </div>
    <div class="row bg-light" style="height: 70%; padding: 0px 25px 25px 25px;">
        <div class="col-3 border-end" style="width: 37%;background: rgba(0, 0, 0, 0.05); margin-right: 25px;">
            <div>
                <span class="fw-bold">측정소 관리</span>
                <button data-toggle="modal" data-target="#addPlace">추가</button>
                <button onclick="removePlace()">삭제</button>
            </div>
            <div class="text-center">
                <table width="100%">
                    <tr style="border-bottom: silver solid 2px;">
                        <th><input name="placeall" class="form-check-input" type=checkbox onclick="placeAll(this)"></th>
                        <th>측정소 명</th>
                        <th>업데이트</th>
                        <th>모니터링 사용</th>
                    </tr>

                    <c:forEach var="place" items="${place}" varStatus="status">
                        <tr onclick="placeChange('${place.name}')" style="border-bottom: silver solid 2px;">
                            <td><input class="form-check-input" id="${place.name}" name="place" type=checkbox
                                       onclick="checkPlaceAll()">
                            </td>
                            <td>
                                <span id="place${status.index}"><c:out value="${place.name}"/></span>
                            </td>
                            <td><c:out value="${place.up_time}"/></td>
                            <td><c:out value="${place.power}"/></td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
        <div class="col-3" style="width: 61%; background: rgba(0, 0, 0, 0.05);">

            <div>
                <div id="p_power" style="display: flex">
                </div>
                <div>
                    <input type="button" value="추가">
                    <input type="button" value="삭제">
                </div>
            </div>
            <table style="text-align: center; width: 100%">
                <tr id="c" style="border-bottom: silver solid 2px; width: 100%; display: flex; ">
                    <th style="width:5%;"><input name="selectall" class="form-check-input" type=checkbox
                                                 onclick="selectAll(this)"></th>
                    <th style="width:15%;">측정항목</th>
                    <th style="width:24%;">관리ID</th>
                    <th style="width:14%;">법적기준</th>
                    <th style="width:14%;">사내기준</th>
                    <th style="width:14%;">관리기준</th>
                    <th style="width:14%;">모니터링</th>
                </tr>
                <tr id="items" style="width: 100%;">

                </tr>

            </table>
        </div>

    </div>
</div>
<!-- addPlace -->
<div class="modal" id="addPlace" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">측정소 추가</h5>
            </div>
            <div class="modal-body d-flex" style="flex-wrap: wrap;">
                <form id="placeinfo" method="post">
                    <div><span>측정소 명</span><input type="text" class="modal-input" name="name"></div>
                    <div><span>위치</span><input type="text" class="modal-input" name="location"></div>
                    <div><span>담당자 명</span><input type="text" class="modal-input" name="admin"></div>
                    <div><span>연락처</span><input type="text" class="modal-input" name="tel"></div>
                </form>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button id="saveBtn" type="button" class="btn btn-primary" onclick="insertPlace()">추가</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<script>
    //팝업창 드래그로 이동 가능
    $(function () {
        $('.modal-dialog').draggable({handle: ".modal-header"});
    });
    //modal 팝업창 close시 form에 남아있던 데이터 리셋
    $('.modal').on('hidden.bs.modal', function (e) {
        $(this).find('form')[0].reset()
    });

</script>
<script>
    $(document).ready(function () {

        placeChange($("#place0").text());

    });

    //센서 체크박스 전체 선택, 해제
    function checkSelectAll() {
        // 전체 체크박스
        const checkboxes
            = document.querySelectorAll('input[name="item"]');
        // 선택된 체크박스
        const checked
            = document.querySelectorAll('input[name="item"]:checked');
        // select all 체크박스
        const selectAll
            = document.querySelector('input[name="selectall"]');

        if (checkboxes.length === checked.length) {
            selectAll.checked = true;
        } else {
            selectAll.checked = false;
        }

    }

    function selectAll(selectAll) {
        const checkboxes
            = document.getElementsByName('item');

        checkboxes.forEach((checkbox) => {
            checkbox.checked = selectAll.checked
        })
    }

    //측정소 체크박스 전체 선택, 해제
    function checkPlaceAll() {

        // 전체 체크박스
        const checkboxes
            = document.querySelectorAll('input[name="place"]');
        // 선택된 체크박스
        const checked
            = document.querySelectorAll('input[name="place"]:checked');
        // place all 체크박스
        const placeAll
            = document.querySelector('input[name="placeall"]');

        if (checkboxes.length == checked.length) {
            placeAll.checked = true;
        } else {
            placeAll.checked = false;
        }

    }

    function placeAll(placeAll) {
        const checkboxes
            = document.getElementsByName('place');

        checkboxes.forEach((checkbox) => {
            checkbox.checked = placeAll.checked
        })
    }

    //측정소 변경
    function placeChange(name) {
        const place = name;
        $("#items").empty();
        $("#p_power").empty();
        const p_power = findPlaceMonitor(place);

        let innerHTMLPlace =
            "<span>" + place + "상세설정</span>" +
            "<span>측정소 모니터링</span>" +
            "<label class='switch'>" +
            "<input id='monitor' type='checkbox' " + p_power + ">" +
            "<span class='slider round'></span>" +
            "</label>";
        $('#p_power').append(innerHTMLPlace);

        $.ajax({
            url: '<%=cp%>/getPlaceSensor',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place": place},
            success: function (data) {
                for (let i = 0; i < data.length; i++) {
                    const tableName = data[i];
                    const category = findSensorCategory(tableName);
                    const value = findReference(tableName);
                    const power = findMonitor(tableName);

                    const innerHtml =
                        "<td style='width:5%;'><input class='form-check-input' type='checkbox' id='" + tableName + "a' name='item' value='" + tableName + "' onclick='checkSelectAll()'></td>" +
                        "<td style='width:15%;'><label class='form-check-label' for='" + tableName + "a'>" + category + "</label></td>" +
                        "<td style='width:24%;'><label class='form-check-label' for='" + tableName + "a'>" + tableName + "</label></td>" +
                        "<td style='width:14%;'><input style = 'width:80%; height: 34px;' class='form-check-input' type='text' id='" + tableName + "l' value='" + value.get("legal") + "' ></td>" +
                        "<td style='width:14%;'><input style = 'width:80%; height: 34px;' class='form-check-input' type='text' id='" + tableName + "c' value='" + value.get("company") + "' ></td>" +
                        "<td style='width:14%;'><input style = 'width:80%; height: 34px;' class='form-check-input' type='text' id='" + tableName + "m' value='" + value.get("management") + "' ></td>" +
                        "<td style='width:14%;'><label class='switch'>" +
                        "<input id='" + tableName + "' type='checkbox' name='status' " + power + ">" +
                        "<div class='slider round'></div>" +
                        "</label></td>";

                    const elem = document.createElement('tr');
                    elem.setAttribute('style', 'border-bottom: silver solid 2px;');
                    elem.innerHTML = innerHtml;
                    document.getElementById('items').append(elem);

                    //측정소 변경시 센서 체크박스 해제
                    const selectAll
                        = document.querySelector('input[name="selectall"]');
                    selectAll.checked = false;
                }

            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
    }

    //센서 모니터링 on/off 불러오기
    function findMonitor(tableName) {
        let isChecked = "";
        $.ajax({
            url: '<%=cp%>/getReferenceValue',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"tableName": tableName},
            success: function (data) {
                const power = data.power;
                if (power == "on") {
                    isChecked = "checked";
                }
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return isChecked;
    }

    //측정소 모니터링 on/off 불러오기
    function findPlaceMonitor(tableName) {
        let isChecked = "";
        $.ajax({
            url: '<%=cp%>/getPlace',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place": tableName},
            success: function (data) {
                const power = data.power;
                if (power == "on") {
                    isChecked = "checked";
                }
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return isChecked;
    }

    //센서 기준값 불러오기
    function findReference(tableName) {
        let map = new Map();
        $.ajax({
            url: '<%=cp%>/getReferenceValue',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"tableName": tableName},
            success: function (data) {
                map.set("legal", data.legal_standard);
                map.set("company", data.company_standard);
                map.set("management", data.management_standard);

            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return map;
    }

    function insertPlace() {
        var form = $('#placeinfo').serialize();

        $.ajax({
            url: '<%=cp%>/savePlace',
            type: 'POST',
            async: false,
            cache: false,
            data: form,
            success: function (data) {

            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        Swal.fire({
            icon: 'success',
            title: '저장완료'
        }).then((result) => {
            if (result.isConfirmed) {
                location.reload();
            }
        })
    }

    function removePlace() {
        const placeList = new Array();
        $("input:checkbox[name=place]:checked").each(function () {
            placeList.push($(this).attr('id'));
        });
        if (placeList.length == 0) {

            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '삭제할 측정소를 체크해주세요.'

            })
            return false;
        }

        swal.fire({
            title: '측정소 삭제',
            text: '정말 삭제하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: 'red',
            cancelButtonColor: 'gray',
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '<%=cp%>/removePlace',
                    type: 'POST',
                    async: false,
                    cache: false,
                    data: {"placeList": placeList},
                    success: function (data) {

                    },
                    error: function (request, status, error) { // 결과 에러 콜백함수
                        console.log(error)
                    }
                })
                swal.fire(
                    '삭제 완료',
                    '',
                    'success'
                ).then((result) => {
                    if (result.isConfirmed) {
                        location.reload();
                    }
                })

            }
        })
    }


</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
