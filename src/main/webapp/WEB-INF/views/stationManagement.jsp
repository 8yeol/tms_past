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
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="stylesheet" href="static/css/page/stationManagement.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/sweetalert2.min.js"></script>
<script src="static/js/jquery-ui.js"></script>
<script src="static/js/moment.min.js"></script>

<div class="container" id="container">
    <div class="col fw-bold fs-4 m-4 ms-0">
        환경설정 > 측정소 관리
    </div>

    <div class="row bg-light rounded">
        <div class="col p-3 ps-4 fs-4 fw-bold">
            <c:if test="${state == 1}">
                <span>측정소 및 기준 값 관리 </span>
            </c:if>
            <c:if test="${state != 1}">
                <span>${groupName} 그룹 측정소 모니터링 관리</span>
            </c:if>
        </div>
        <div class="col text-end align-self-end pb-1" style="color: red; font-size: 0.8rem; font-weight: normal;">
            * 모니터링 On/Off 는 모니터링 그룹별로 설정 가능하며, 기준 값은 '최고 관리자' 권한을 가진 회원만 설정 가능합니다.
        </div>
    </div>
    <div class="row bg-light p-3 pt-0" style="min-height:70%;">
        <div class="col-6 border-end me-4" id="station1" style="width: 37%; background: rgba(0, 0, 0, 0.05);">
            <div class="p-2 pb-3 ps-0 pe-0">
                <div class="row">
                    <div class="col-4">
                        <span class="fw-bold fs-5">측정소 관리</span>
                    </div>
                    <c:if test="${state == 1}">
                        <div class="col text-end">
                            <button data-bs-toggle="modal" data-bs-target="#addPlace" id="addpl" class="addBtn" onclick="$('input[id=na1]').attr('readonly', false);">추가</button>
                            <button data-bs-toggle="modal" data-bs-target="#addPlace" class="updateBtn" id="uppl" onclick="updatePlaceSetting()">수정</button>
                            <button onclick="removePlace()" class="removeBtn">삭제</button>
                        </div>
                    </c:if>
                </div>
            </div>

            <table class="text-center w-100">
                <thead style="background-color: transparent; color: #333; border-bottom: 2px solid silver;">
                    <tr class="fw-bold m-3">
                        <c:if test="${state == 1}">
                        <th>
                            <input name="placeall" class="form-check-input" type=checkbox onclick="placeAll(this)" style="margin-left: 3px;">
                        </th>
                        </c:if>
                        <th style="width: 33%">측정소 명</th>
                        <th style="width: 40%;">업데이트</th>
<%--                        <th style="width: 25%;">모니터링 사용</th>--%>
                    </tr>
                </thead>
                <tbody id="placeDiv">

                </tbody>
            </table>
        </div>

        <div class="col-6" id="station2" style="width: 61%; background: rgba(0, 0, 0, 0.05);">
            <div class="pb-2">
                <div id="p_monitoring" class="fw-bold mt-2 mb-3" style="display: flex;"></div>
            </div>
            <table class="text-center w-100">
                <thead style="background-color: transparent; color: #333; border-bottom: 2px solid silver;">
                    <tr id="c">
                        <th width="2%"></th>
                        <th width="18%">측정항목</th>
                        <th width="25%">관리ID</th>
                        <th width="10.5%">법적기준</th>
                        <th width="10.5%">사내기준</th>
                        <!--관리기준 임시삭제
                        <th width="10.5%">관리기준</th>
                        -->
                        <th width="10.5%">Chart Min</th>
                        <th width="10.5%">Chart Max</th>
                        <th width="15%">모니터링</th>
                    </tr>
                </thead>
                <tbody id="items">

                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- addPlace -->
<div class="modal" id="addPlace" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title fw-bold" id="addup">측정소 추가</h5>
            </div>
            <div class="modal-body d-flex" style="flex-wrap: wrap;">
                <form id="placeinfo" method="post" style="width:70%; margin: 10px auto;">
                    <div style="margin-bottom:7px; margin-top: 10px; display: flex; justify-content: space-between;">
                        <span>측정소 명</span>
                        <input type="text" class="modal-input" name="name" id="na1" maxlength="10" style="border: 1px solid black;" autocomplete="off">
                    </div>
                    <div style="margin-bottom:7px; display: flex; justify-content: space-between;">
                        <span>위치</span>
                        <input type="text" class="modal-input" name="location" id="lo1" style="border: 1px solid black;" autocomplete="off">
                    </div>
                    <div style="margin-bottom:7px; display: flex; justify-content: space-between;">
                        <span>담당자 명</span>
                        <input type="text" class="modal-input" name="admin" id="ad1" style="border: 1px solid black;" autocomplete="off">
                    </div>
                    <div style="margin-bottom:7px; display: flex; justify-content: space-between;">
                        <span>연락처</span>
                        <input type="text" class="modal-input" name="tel" id="te1" style="border: 1px solid black;" autocomplete="off">
                    </div>
                    <input type="hidden" name="hiddenCode" id="hi1">
                </form>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button id="saveBtn" class="btn btn-primary" onclick="insertPlace()">추가</button>
                <button id="cancelBtn" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<%--값 수정시 알림창--%>
<div class="multiSelecterModal" id="alert"></div>

<script>
    //팝업창 드래그로 이동 가능
    $(function () {
        $('.modal-dialog').draggable({handle: ".modal-header"});
    });

    //modal 팝업창 close시 form에 남아있던 데이터 리셋
    $('.modal').on('hidden.bs.modal', function (e) {
        $(this).find('form')[0].reset()
    });

    $(document).ready(function () {

        placeDiv(${groupPlace});
        //측정소 있다면 첫번쨰 측정소 출력
        if(typeof $('#placeDIv tr').eq(0).attr('id') !== 'undefined') {
            placeChange($('#placeDIv tr').eq(0).attr('id'));
        }
    });

    $('#addpl').click(function () {
        document.getElementById('na1').value = '';
        let addStyle = document.getElementById("na1");
        addStyle.style.backgroundColor = "white";
        document.getElementById('lo1').value = '';
        document.getElementById('te1').value = '';
        document.getElementById('ad1').value = '';
        document.getElementById('hi1').value = '';
        $('#addup').text('측정소 추가');
        $('#saveBtn').text('추가');
    });

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

        if (checkboxes.length === checked.length) {
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

    //해당 그룹의 측정소 목록 불러오기
    function placeDiv(groupPlace) {
        $("#placeDiv").empty();
        //측정가능한 측정소 없음
        if(groupPlace[0] == null){
            $('#placeDiv').append('<tr><td colspan="4" style="height: 250px;line-height: 250px;">측정 가능한 측정소가 없습니다.</td></tr>');
            $('#items').append('<tr><td colspan="7" style="height: 250px;line-height: 250px;">측정 가능한 측정소가 없습니다.</td></tr>');
            return;
        }
        const data = placeDiv1();
        let onoff = "";
        for (let i = 0; i < data.length; i++) {
            if(groupPlace.includes(data[i].name) || groupPlace[0] == '모든 측정소') {
                const test = data[i];
                const name = test.name;
                const time = moment(test.up_time).format('YYYY-MM-DD HH:mm:ss');
                onoff = data[i].monitoring ? "checked" : "";
                let check;
                if('${state}' == '1'){
                    check = "<td style='padding-left:6px;' onclick='event.cancelBubble=true'><input class='form-check-input' id='check" + i + "' name='place' type='checkbox' value ='" + name + "' onclick='checkPlaceAll()'></td>";
                }else{
                    check = "";
                }

                const innerHTML = "<tr id='p" + i + "' style='border-bottom: silver solid 2px; cursor: pointer;' value = '" + name + "' onclick=\"placeChange('p" + i + "')\"  class='placeTr'>" +
                    check +
                    "<td style='width: 34%; word-break: break-all;' id='place" + i + "'>" + name + "</td>" +
                    "<td style='width: 40%;'>" + time + "</td>" +
                    "</tr>";

                $('#placeDiv').append(innerHTML);
                onoff = "";
            }
        }

    }

    function placeDiv1() {
        var getData = null;
        $.ajax({
            url: '<%=cp%>/getPlaceList2',
            dataType: 'json',
            async: false,
            cache: false,
            success: function (data) {
                getData = data;
            },
            error: function () {

            }
        });
        return getData;
    }

    //측정소 변경
    function placeChange(name) {
        if (document.getElementById(name) == null) {
            $("#items").empty(); //div items 비우기
            $("#p_monitoring").empty(); //div p_monitoring 비우기
            return;
        }
        const place = $("#" + name).attr("value"); // 측정소1 입력
        $('#placeDiv tr').css('color', 'black'); //텍스트 색상 제거
        var x = document.getElementById(name);
        x.style.color = '#0d6efd';
        $("#items").empty(); //div items 비우기
        $("#p_monitoring").empty(); //div p_monitoring 비우기

        let innerHTMLPlace =
            "<div id='pname'>" + place + "</div>" +
            "<div>상세설정</div>" +
            "<input type='hidden' id='nickname' value='" + name + "'>";
        $('#p_monitoring').append(innerHTMLPlace); //측정소 명  div

        let none = "<tr><td colspan='8' class='p-3'><br> 등록된 센서 데이터가 없습니다. <br> 센서 등록 후 이용 가능합니다. <br><br>";

        if(${state == 1}){
            none += " <a href='<%=cp%>/sensorManagement'>센서 등록 바로가기</a></td></tr>";
        }

        $('#items').append(none); //센서 없을때
        let readonly = ${state} != 1 ? 'readonly' : '';
        let readonlyCSS = ${state} != 1 ? 'readonlyCSS' : '';
        let monitoringDisabled;
        let labelEvent;
        if('${groupName}' == 'default' && '${state}' != '1'){
            monitoringDisabled = 'disabled';
            labelEvent = 'onclick="permissionError()"';
        }

        $.ajax({
            url: '<%=cp%>/getPlaceSensorValue',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place": place},
            success: function (data) {

                if (data.length != 0) {
                    const value = findReference(data); //naming, name, legal, company, management //map이 비어있을때
                    $("#items").empty(); //센서 있을때 div 비움
                    for (let i = 0; i < data.length; i++) {
                        if (value.size != 0) {
                            const innerHtml =
                                "<td style='width: 2%;'></td>" +
                                "<td style='width:18%;'><span id='naming" + i + "' >" + data[i].naming + "</span></td>" +
                                "<td style='width:25%;'><span id='name" + i + "'>" + data[i].name + "</span></td>" +
                                "<td style='width:10.5%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input "+readonlyCSS+"' "+readonly+"  autocomplete='off' name='legal' type='text' id='legal" + i + "' value='" + data[i].legalStandard + "' onchange='legalupdate(this)'></td>" +
                                "<td style='width:10.5%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input "+readonlyCSS+"' "+readonly+"  autocomplete='off'name='company' type='text' id='company" + i + "' value='" + data[i].companyStandard + "' onchange='companyupdate(this)'></td>" +
                               //관리기준 임시삭제  "<td style='width:10.5%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input "+readonlyCSS+"' "+readonly+"  autocomplete='off'name='management' type='text' id='management" + i + "' value='" + data[i].managementStandard + "' onchange='managementupdate(this)'></td>" +
                                "<td style='width:10.5%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input "+readonlyCSS+"' "+readonly+"  autocomplete='off'name='chartmin' type='text' id='chartmin" + i + "' value='" + data[i].min + "' onchange='chartminupdate(this)'></td>" +
                                "<td style='width:10.5%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input "+readonlyCSS+"' "+readonly+"  autocomplete='off'name='chartmax' type='text' id='chartmax" + i + "' value='" + data[i].max + "' onchange='chartmaxupdate(this)'></td>" +
                                "<td style='width:13%;'><label class='switch' "+labelEvent+">" +
                                "<input id='monitor" + i + "' type='checkbox' name='sensormonitor' value='" + data[i].name + "' " + data[i].monitoring + " onchange='monitoringupdateCheck(this)' "+monitoringDisabled+">" +
                                "<div class='slider round'></div>" +
                                "</label></td>";
                            const elem = document.createElement('tr');
                            elem.setAttribute('style', 'border-bottom: silver solid 2px;');
                            elem.setAttribute('id', 'tr' + i);
                            elem.innerHTML = innerHtml;
                            document.getElementById('items').append(elem);

                        } else {
                            if (i == 0) {
                                const none = "<div class='fw-bold' style='padding-top : 20px;'>" +
                                    "<div style='padding-bottom:5px;'>등록된 센서 데이터가 없습니다.</div>" +
                                    "<div>센서 등록 후 이용 가능합니다.</div></div>";

                                $('#items').append(none); //센서 없을때
                            }
                        }
                    }
                }

            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        })
    }

    function permissionError(){
        customSwal('권한이 없습니다.');
    }

    //측정소 명 중복 확인
    function findPlace(name) {
        var data1 = "";
        $.ajax({
            url: '<%=cp%>/getPlace',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place": name},
            success: function (data) {
                data1 = data;
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
                data1 = 0;
            }
        })
        return data1;
    }

    //측정소 정보
    function updatePlaceSetting() {
        if ($("input:checkbox[name=place]:checked").length == 0) {
            document.getElementById("cancelBtn").click();
            customSwal('측정소를 선택해 주세요.');
            return false;
        }
        if ($("input:checkbox[name=place]:checked").length != 1) {
            document.getElementById("cancelBtn").click();
            customSwal('측정소를 한개만 체크해 주세요.');
            const placeall = document.querySelector('input[name="placeall"]');
            placeall.checked = false;
            placeDiv(${groupPlace});
            placeChange(document.getElementById('nickname').value);
            return false;
        }
        $('#addup').text('측정소 수정');
        $('#saveBtn').text('수정');

        let addStyle = document.getElementById("na1");
        addStyle.style.backgroundColor = "rgba(239, 239, 239, 0.5)";

        const place = $("input:checkbox[name=place]:checked").attr('value');
        $.ajax({
            url: '<%=cp%>/getPlace',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place": place},
            success: function (data) {
                $('input[id=na1]').attr('value', data.name);
                $('input[id=na1]').attr('readonly', true);
                $('input[id=lo1]').attr('value', data.location);
                $('input[id=ad1]').attr('value', data.admin);
                $('input[id=te1]').attr('value', data.tel);
                $('input[name=hiddenCode]').attr('value', data.name);

            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        })
    }

    //센서 유무 파악(모니터링 버튼 기능 제어)
    function findSensor(name) {
        let str = "Off"
        $.ajax({
            url: '<%=cp%>/getPlaceSensorValue',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place": name},
            success: function (data) {
                if (data.length == 0) str = "none";
                for (i = 0; i < data.length; i++) {
                    if (data[i].monitoring == true) str = "On";
                }
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return str;
    }

    //센서값 가공
    function findReference(data) {
        for (i = 0; i < data.length; i++) {

            if (data[i].legalStandard == 999999) {
                data[i].legalStandard = "";
            }
            if (data[i].companyStandard == 999999) {
                data[i].companyStandard = "";
            }
           /* 관리기준 임시삭제
           if (data[i].managementStandard == 999999) {
                data[i].managementStandard = "";
            }
            */
            if (data[i].max == 999999) {
                data[i].max = "";
            }
            if (data[i].min == 999999) {
                data[i].min = "";
            }
            if (data[i].monitoring == true) {
                data[i].monitoring = "checked";
            } else {
                data[i].monitoring = "";
            }
        }
        return data;
    }

    //측정소 추가
    function insertPlace() {
        var idx = '';
        if ($('#addup').text() == '측정소 추가') {
            idx = 1;
        } else {
            idx = 2;
        }
        const na = $("#na1").val();
        const name = na.replace(/(\s*)/g, ""); //
        const location = $("#lo1").val();
        const tel = $("#te1").val();
        const admin = $("#ad1").val();
        const hiddenCode = $("input[name=hiddenCode]").val();
        const pattern = /[`~.!@#$%^&*()_+=|<>?:;`,{}\-\]\[/\'\"\\\']/;

        let title = "";
        let content = "";
        let send = "";

        if (name == "") {
            customSwal('측정소 명을 입력해주세요.');
            return false;
        }
        if (pattern.test(name) == true) { //특수문자
            customSwal('특수문자를 입력할 수 없습니다.');
            return false;
        }
        if (findPlace(name) != 0) {  //측정소명 중복확인
            if (hiddenCode != name) { //기존 측정소 명과 바꾼 측정소 명이 다를때
                customSwal('이미 등록된 측정소 입니다.');
                return false;
            }
        }
        if (idx == 2) {
            content = '측정소가 수정 되었습니다.';
            title = '측정소 수정';
            const pnum = $("input:checkbox[name=place]:checked").attr('id');
            const num = pnum.replace(/[^0-9]/g, ''); //place0 -> 0
            send = 'p' + num;
        } else {
            content = '측정소가 추가 되었습니다.';
            title = '측정소 추가';
            if ($("#nickname").val() == undefined) {
                send = "p0";
            } else {
                send = document.getElementById('nickname').value;
            }
            $("input[name=hiddenCode]").val("");   //수정했을때 남아있는 히든코드 초기화
        }

        $.ajax({
            url: '<%=cp%>/savePlace',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "name": name,
                "location": location,
                "tel": tel,
                "admin": admin,
                "hiddenCode": hiddenCode
            }, success: function (data) {
            },
            error: function (request, status, error) {
                console.log(error)
            }
        })
        Swal.fire({
            icon: 'success',
            title: title,
            text: content,
            timer: 1500
        })
        document.getElementById("cancelBtn").click();
        placeDiv(${groupPlace});
        placeChange($('#placeDIv tr').eq(0).attr('id'));
    }

    //센서 개수 확인
    function countPlaceSensor(placeList) {
        let count = 0;
        $.ajax({
            url: '<%=cp%>/countPlaceSensor',
            type: 'POST',
            async: false,
            cache: false,
            data: {"placeList": placeList},
            success: function (data) {
                count = data;
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return count;
    }

    //측정소 제거
    function removePlace() {
        const placeList = new Array();
        $("input:checkbox[name=place]:checked").each(function () {
            placeList.push($(this).attr('value'));
        });
        if (placeList.length == 0) {
            customSwal('삭제할 측정소를 체크해주세요.');
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
                const count = countPlaceSensor(placeList);
                if(count == 0){

                    $.ajax({
                        url: '<%=cp%>/removePlace',
                        type: 'POST',
                        async: false,
                        cache: false,
                        data: {"placeList": placeList, "flag": false},
                        success: function () {
                            swal.fire({
                                title: '삭제 완료',
                                icon: 'success',
                                timer: 1500
                            });
                        },
                        error: function (request, status, error) { // 결과 에러 콜백함수
                            console.log(error)
                        }
                    })

                    placeDiv(${groupPlace});
                    placeChange($('#placeDIv tr').eq(0).attr('id'));
                }else{
                    swal.fire({
                        title: '센서 삭제',
                        text: '해당 측정소의 센서도 삭제 하시겠습니까?',
                        icon: 'warning',
                        showCancelButton: true,
                        showCloseButton: true,
                        confirmButtonColor: 'red',
                        cancelButtonColor: 'gray',
                        confirmButtonText: '포함된 센서 삭제',
                        cancelButtonText: '측정소만 삭제'
                    }).then((result) => {
                        let flag;

                        if (result.isConfirmed) {
                            flag = true;
                        } else if (result.dismiss === Swal.DismissReason.cancel) {
                            flag = false;
                        } else {
                            return false;
                        }

                        $.ajax({
                            url: '<%=cp%>/removePlace',
                            type: 'POST',
                            async: false,
                            cache: false,
                            data: {"placeList": placeList, "flag": flag},
                            success: function () {
                                swal.fire({
                                    title: '삭제 완료',
                                    icon: 'success',
                                    timer: 1500
                                });
                            },
                            error: function (request, status, error) { // 결과 에러 콜백함수
                                console.log(error)
                            }
                        })

                        placeDiv(${groupPlace});
                        placeChange($('#placeDIv tr').eq(0).attr('id'));
                    });
                }

            }
        });
    }

    function monitoringupdateCheck(name){
        let state = ${state};
        let id = name.id;
        let tablename = name.value;

        if(state == 1 && $("#" + id).is(":checked") == false) {
            Swal.fire({
                icon: 'warning',
                title: '경고',
                html: '<label style="color:#2295DB;font-weight: bold">' + tablename + '</label> '
                    + '센서의<br> 모니터링 상태 <label style="color:red;font-weight: bold">OFF</label>는 모든 그룹에 적용됩니다.'
                    + '<br>OFF 하시겠습니까?',
                showCancelButton: true,
                confirmButtonColor: 'red',
                cancelButtonColor: 'gray',
                confirmButtonText: '모니터링 OFF',
                cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {
                    monitoringupdate(name);
                }else{
                    $("#" + id).prop("checked", true);
                }
            });
        }else{
            monitoringupdate(name);
        }
    }

    //측정항목 모니터링 onchange
    function monitoringupdate(name) {
        var id = name.id;
        const num = id.replace(/[^0-9]/g, ''); //place0 -> 0
        const naming = $("#naming" + num).text(); //관리ID
        var tablename = name.value;
        var check = $("#" + id).is(":checked");
        var pname = $("#pname").text();
        check = check  ? "ON" : "OFF";

        $.ajax({
            url: '<%=cp%>/referenceMonitoringUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {"sensor": tablename},
            success: function (data) {
                 if(data == 'permissionError'){
                     $(name).prop("checked", false);
                     Swal.fire({
                         icon: 'error',
                         title: '경고',
                         html: '<label style="color:#2295DB;font-weight: bold">'+tablename+'</label> 센서는 ' +
                             '<br>관리자에 의해 모니터링 On으로 변경이 불가능 합니다.'
                     })

                 }else{
                     inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "'" + pname + " - " + naming + "' 모니터링 " + check + "", "설정");
                     multiSelecterModal(pname, naming, "monitor", check);
                 }
            }
        });
    }

    function ifsum(value) {
        if (value.indexOf('.') != -1) {
            var value_dot = value.substring(value.indexOf('.') + 1);
            if (value_dot.length > 2) {
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: '소수점 2자리까지만 입력 가능합니다.'
                })
                return false;
            }
        }
        if (isNaN(value) == true) {
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '입력 데이터를 체크해주세요.'
            })
            return false;
        }
        return true;
    }

    //legal onchange
    function legalupdate(name) {
        var id = name.id;
        const num = id.replace(/[^0-9]/g, ''); //place0 -> 0
        const naming = $("#naming" + num).text(); //관리ID
        var tablename = $("#name" + num).text(); //측정항목 명
        var companyname = "company" + num;
        var company = $("#" + companyname).val(); //사내기준 값
        // var managename = "management" + num;
        // var manage = $("#" + managename).val(); //관리기준 값
        var value = strReplace(name.value); //수정값
        var pname = $("#pname").text();
        if (value == "" || value == "999999") {
            value = "999999";
        } else {
            if (value == 0) {
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: "법적기준은 '0'을 입력할 수 없습니다."
                })
                placeChange(document.getElementById('nickname').value);
                return false;
            }
            if (ifsum(value) == false) {
                placeChange(document.getElementById('nickname').value);
                return;
            }
            if (parseFloat(value) <= parseFloat(company)) { //법적기준 값이 사내기준 값보다 작을때
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: '법적기준 값은 사내기준 값보다 작거나 같을 수 없습니다.'
                })
                placeChange(document.getElementById('nickname').value);
                return;
            }
            // if (parseFloat(value) <= parseFloat(manage)) { //법적기준 값이 관리기준 값보다 작을때
            //     Swal.fire({
            //         icon: 'warning',
            //         title: '경고',
            //         text: '법적기준 값은 관리기준 값보다 작거나 같을 수 없습니다.'
            //     })
            //     placeChange(document.getElementById('nickname').value);
            //     return;
            // }
        }
        $.ajax({
            url: '<%=cp%>/legalUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "tablename": tablename,
                "value": value,
                "place": pname
            }
        })
        inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "'" + pname + "-" + naming + "' 법적 기준 값 변경 '" + value + "'", "설정");
        inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "'" + pname + "-" + naming + "' Chart Max 값 변경 '" + value + "'", "설정");
        if (value == "999999") {
            name.value = "";
        } else {
            multiSelecterModal(pname, naming, "legal", value);
            name.value = value;
        }
    }

    //company onchange
    function companyupdate(name) {
        var id = name.id;
        const num = id.replace(/[^0-9]/g, ''); //place0 -> 0
        const naming = $("#naming" + num).text(); //관리ID
        var tablename = $("#name" + num).text(); //측정항목 명
        var legalname = "legal" + num;
        var legal = $("#" + legalname).val(); //법적기준 값
        // var managename = "management" + num;
        // var manage = $("#" + managename).val(); //관리기준 값
        var value = strReplace(name.value);
        var pname = $("#pname").text();
        if (value == "" || value == "999999") {
            value = "999999";
        } else {
            if (value == 0) {
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: "사내기준은 '0'을 입력할 수 없습니다."

                })
                placeChange(document.getElementById('nickname').value);
                return false;
            }
            if (ifsum(value) == false) {
                placeChange(document.getElementById('nickname').value);
                return;
            }
            // if (parseFloat(value) <= parseFloat(manage)) {  //
            //     Swal.fire({
            //         icon: 'warning',
            //         title: '경고',
            //         text: '사내기준 값은 관리기준 값보다 작거나 같을 수 없습니다.'
            //     })
            //     placeChange(document.getElementById('nickname').value);
            //     return;
            // }
            if (parseFloat(legal) <= parseFloat(value)) {  //
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: '사내기준 값은 법적기준 값보다 크거나 같을 수 없습니다.'
                })
                placeChange(document.getElementById('nickname').value);
                return;
            }
        }
        $.ajax({
            url: '<%=cp%>/companyUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "tablename": tablename,
                "value": value,
                "place": pname
            }
        })
        inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "'" + pname + "-" + naming + "' 법적 기준 값 변경 '" + value + "'", "설정");
        if (value == "999999") {
            name.value = "";
        } else {
            multiSelecterModal(pname, naming, "company", value);
            name.value = value;
        }
    }
    //management onchange
    <%--function managementupdate(name) {--%>
    <%--    var id = name.id;--%>
    <%--    const num = id.replace(/[^0-9]/g, ''); //place0 -> 0--%>
    <%--    const naming = $("#naming" + num).text(); //관리ID--%>
    <%--    var tablename = $("#name" + num).text(); //측정항목 명--%>
    <%--    var legalname = "legal" + num;--%>
    <%--    var legal = $("#" + legalname).val(); //법적기준 값--%>
    <%--    var companyname = "company" + num;--%>
    <%--    var company = $("#" + companyname).val(); //사내기준 값--%>
    <%--    var value = strReplace(name.value); //관리기준--%>
    <%--    var pname = $("#pname").text();--%>
    <%--    if (value == "" || value == "999999") {--%>
    <%--        value = "999999";--%>
    <%--    } else {--%>
    <%--        if (ifsum(value) == false) {--%>
    <%--            placeChange(document.getElementById('nickname').value);--%>
    <%--            return;--%>
    <%--        }--%>
    <%--        if (parseFloat(company) <= parseFloat(value)) {  //--%>
    <%--            Swal.fire({--%>
    <%--                icon: 'warning',--%>
    <%--                title: '경고',--%>
    <%--                text: '관리기준 값은 사내기준 값보다 크거나 같을 수 없습니다.'--%>
    <%--            })--%>
    <%--            placeChange(document.getElementById('nickname').value);--%>
    <%--            return;--%>
    <%--        }--%>
    <%--        if (parseFloat(legal) <= parseFloat(value)) {  //--%>
    <%--            Swal.fire({--%>
    <%--                icon: 'warning',--%>
    <%--                title: '경고',--%>
    <%--                text: '관리기준 값은 법적기준 값보다 크거나 같을 수 없습니다.'--%>
    <%--            })--%>
    <%--            placeChange(document.getElementById('nickname').value);--%>
    <%--            return;--%>
    <%--        }--%>
    <%--    }--%>
    <%--    $.ajax({--%>
    <%--        url: '<%=cp%>/managementUpdate',--%>
    <%--        type: 'POST',--%>
    <%--        async: false,--%>
    <%--        cache: false,--%>
    <%--        data: {--%>
    <%--            "tablename": tablename,--%>
    <%--            "value": value,--%>
    <%--            "place": pname--%>
    <%--        }--%>
    <%--    });--%>
    <%--    inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "'" + pname + "-" + naming + "' 법적 기준 값 변경 '" + value + "'", "설정");--%>
    <%--    if (value == "999999") {--%>
    <%--        name.value = "";--%>
    <%--    } else {--%>
    <%--        multiSelecterModal(pname, naming, "manage", value);--%>
    <%--        name.value = value;--%>
    <%--    }--%>
    <%--}--%>

    //legal onchange
    function chartmaxupdate(name) {
        var id = name.id;
        const num = id.replace(/[^0-9]/g, ''); //place0 -> 0
        const naming = $("#naming" + num).text(); //관리ID
        var tablename = $("#name" + num).text(); //측정항목 명
        var companyname = "company" + num;
        var company = $("#" + companyname).val(); //사내기준 값
        // var managename = "management" + num;
        // var manage = $("#" + managename).val(); //관리기준 값
        var chartminname = "chartmin" + num;
        var chartmin = $("#" + chartminname).val(); //chartmin 값
        var value = strReplace(name.value); //수정값
        var pname = $("#pname").text();
        if (value == "" || value == "999999") {
            value = "999999";
        } else {

            if (ifsum(value) == false) {
                placeChange(document.getElementById('nickname').value);
                return;
            }
            if (parseFloat(chartmin) >= parseFloat(value)) {  //
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: 'Chart Max 값은 Chart Min 값보다 작거나 같을 수 없습니다.'
                })
                placeChange(document.getElementById('nickname').value);
                return;
            }
        }
        $.ajax({
            url: '<%=cp%>/chartmaxUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "tablename": tablename,
                "value": value,
                "place": pname
            }
        })
        inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "'" + pname + "-" + naming + "' Chart Max 값 변경 '" + value + "'", "설정");
        if (value == "999999") {
            name.value = "";
        } else {
            multiSelecterModal(pname, naming, "ChartMax", value);
            name.value = value;
        }
    }

    //데이터 변경시 팝업창
    function multiSelecterModal(place, name, standard, value) {
        const modal = $('#alert');
        if (standard == "legal") {
            modal.html("'" + place + "-" + name + "'의 법적기준 값이 '" + value + "'(으)로 설정되었습니다.");
        } else if (standard == "company") {
            modal.html("'" + place + "-" + name + "'의 사내기준 값이 '" + value + "'(으)로 설정되었습니다.");
        } else if (standard == "manage") {
            modal.html("'" + place + "-" + name + "'의 관리기준 값이 '" + value + "'(으)로 설정되었습니다.");
        } else if(standard == "ChartMin") {
            modal.html("'" + place + "-" + name + "'의 Chart Min 값이 '" + value + "'(으)로 설정되었습니다.");
        } else if(standard == "ChartMax") {
            modal.html("'" + place + "-" + name + "'의 Chart Max 값이 '" + value + "'(으)로 설정되었습니다.");
        } else {
            if (value == "ON") {
                if (name == "") {
                    modal.html("'" + place + "' 모니터링 'ON'(으)로 설정되었습니다.");
                } else {
                    modal.html("'" + place + "-" + name + "' 모니터링 'ON'(으)로 설정되었습니다.");
                }
            } else {
                if (name == "") {
                    modal.html("'" + place + "' 모니터링 'OFF'(으)로 설정되었습니다.");
                } else {
                    modal.html("'" + place + "-" + name + "' 모니터링 'OFF'(으)로 설정되었습니다.");
                }
            }
        }
        fade(modal);
    }

    //Modal FadeIn FadeOut
    function fade(Modal) {
        Modal.finish().fadeIn(300).delay(2000).fadeOut(300);
    }
    function customSwal(text) {
        Swal.fire({
            icon: 'warning',
            title: '경고',
            text: text,
            timer: 1500
        });
    }

    //min onchange
    function chartminupdate(name) {
        var id = name.id;
        const num = id.replace(/[^0-9]/g, ''); //place0 -> 0
        const naming = $("#naming" + num).text(); //관리ID
        var tablename = $("#name" + num).text(); //측정항목 명
        var companyname = "company" + num;
        var company = $("#" + companyname).val(); //사내기준 값
        var chartmaxname = "chartmax" + num;
        var chartmax = $("#" + chartmaxname).val(); //chartmax 값
        var value = strReplace(name.value); //수정값
        var pname = $("#pname").text();
        if (value == "" || value == "999999") {
            value = "999999";
        } else {

            if (ifsum(value) == false) {
                placeChange(document.getElementById('nickname').value);
                return;
            }
            if (parseFloat(chartmax) <= parseFloat(value)) {  //
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: 'Chart Min 값은 Chart Max 값보다 크거나 같을 수 없습니다.'
                })
                placeChange(document.getElementById('nickname').value);
                return;
            }
        }
        $.ajax({
            url: '<%=cp%>/chartminUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "tablename": tablename,
                "value": value,
                "place": pname
            }
        })
        inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "'" + pname + "-" + naming + "' Chart Min 값 변경 '" + value + "'", "설정");
        if (value == "999999") {
            name.value = "";
        } else {
            multiSelecterModal(pname, naming, "ChartMin", value);
            name.value = value;
        }
    }

</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
