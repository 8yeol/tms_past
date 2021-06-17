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
<link rel="stylesheet" href="static/css/stationManagement.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/sweetalert2.min.js"></script>
<script src="static/js/jquery-ui.js"></script>
<script src="static/js/moment.min.js"></script>

<style>
    .swal2-close {
        width: 30px;
        height: 30px;
        font-weight: bold !important;
        margin-top: 10px;
        margin-right: 10px;
        color: black;
    }

    .MultiSelecterModal {
        width: auto;
        border-radius: 10px;
        background-color: #0d6efd;
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -40%);
        text-align: center;
        color: white;
        font-weight: bold;
        display: none;
        line-height: 55px;
        padding: 10px;
    }

    @media all and (max-width: 1400px) {
        #btnDiv {
            float: right;
        }
    }

    @media all and (max-width: 1024px) {
        #station1 {
            margin-top: 20px !important;
            padding-bottom: 30px !important;
        }

        #station2 {
            margin-top: 30px !important;
            padding-bottom: 30px !important;
        }

        #btnDiv {
            float: right;
        }
    }
</style>
<div class="container" id="container">
    <div class="col " style="font-weight: bolder;margin: 30px 0px; font-size: 27px">
        환경설정 > 측정소 관리
    </div>

    <div class="row bg-light rounded"><span style=";font-size: 22px; font-weight: bolder;padding: 20px 20px 30px 25px;">측정소 등록 및 측정소별 항목 등록</span>
    </div>
    <div class="row bg-light" style="min-height:70%; margin-bottom: 50px; padding: 0px 25px 25px 25px;">
        <div class="col-6 border-end" id="station1"
             style="width: 37%;background: rgba(0, 0, 0, 0.05); margin-right: 25px;">
            <div style="padding-bottom: 15px; padding-top: 3px;">
                <span class="fw-bold" style="margin-right: 20%; font-size: 1.25rem;">측정소 관리</span>
                <span id="btnDiv">
                    <button data-bs-toggle="modal" data-bs-target="#addPlace" id="addpl" class="addBtn">추가</button>
                    <button data-bs-toggle="modal" data-bs-target="#addPlace" class="updateBtn" id="uppl"
                            onclick="updatePlaceSetting()">수정</button>
                    <button onclick="removePlace()" class="removeBtn">삭제</button>
                </span>
            </div>
            <table class="text-center" style="width: 100%;">
                <tr class="fw-bold" style="border-bottom: silver solid 2px; display: flex; width:100%; padding-bottom: 5px;">
                    <th style="margin-left: 5px; margin-right: 5px;">
                        <input name="placeall" class="form-check-input" type=checkbox onclick="placeAll(this)">
                    </th>
                    <th style="width: 33%">측정소 명</th>
                    <th style="width: 40%;">업데이트</th>
                    <th style="width: 25%;">모니터링 사용</th>
                </tr>
                <tr id="placeDiv" style="width:100%;"></tr>
            </table>
        </div>
        <div class="col-6" id="station2" style="width: 61%; background: rgba(0, 0, 0, 0.05);">
            <div>
                <div id="p_monitoring" class="fw-bold"
                     style="display: flex; margin-top: 5px; padding-bottom: 35px;"></div>
            </div>
            <table style="text-align: center;">
                <tr id="c" style="border-bottom: silver solid 2px; width: 100%; display: flex; padding-bottom: 5px;">
                    <th style="width: 2%;"></th>
                    <th style="width:18%;">측정항목</th>
                    <th style="width:25%;">관리ID</th>
                    <th style="width:14%;">법적기준</th>
                    <th style="width:14%;">사내기준</th>
                    <th style="width:14%;">관리기준</th>
                    <th style="width:13%;">모니터링</th>
                </tr>
                <tr id="items" style="width: 100%; ">

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
                <h5 class="modal-title fw-bold" id="addup">측정소 추가</h5>
            </div>
            <div class="modal-body d-flex" style="flex-wrap: wrap;">
                <form id="placeinfo" method="post" style="width:70%; margin: 10px auto;">
                    <div style="margin-bottom:7px; margin-top: 18px; display: flex; justify-content: space-between;">
                        <span>측정소 명</span>
                        <input type="text" class="modal-input" name="name" id="na1" maxlength="10"
                               style="border: 1px solid black;" autocomplete="off">
                    </div>
                    <div style="margin-bottom:7px; display: flex; justify-content: space-between;">
                        <span>위치</span>
                        <input type="text" class="modal-input" name="location" id="lo1" style="border: 1px solid black;"
                               autocomplete="off">
                    </div>
                    <div style="margin-bottom:7px; display: flex; justify-content: space-between;">
                        <span>담당자 명</span>
                        <input type="text" class="modal-input" name="admin" id="ad1" style="border: 1px solid black;"
                               autocomplete="off">
                    </div>
                    <div style="margin-bottom:7px; display: flex; justify-content: space-between;">
                        <span>연락처</span>
                        <input type="text" class="modal-input" name="tel" id="te1" style="border: 1px solid black;"
                               autocomplete="off">
                    </div>
                    <input type="hidden" name="hiddenCode" id="hi1">
                </form>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button id="saveBtn" type="button" class="btn btn-primary" onclick="insertPlace()">추가</button>
                <button id="cancelBtn" type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<%--값 수정시 알림창--%>
<div class="MultiSelecterModal" id="alert"></div>

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
        placeDiv();
        placeChange("p0");
    });
    $('#addpl').click(function () {
        document.getElementById('na1').value = '';
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

    //측정소 목록 불러오기
    function placeDiv() {
        $("#placeDiv").empty();
        const data = placeDiv1();
        var onoff = "";
        for (let i = 0; i < data.length; i++) {
            const test = data[i];
            const name = test.name;
            const time = moment(test.up_time).format('YYYY-MM-DD HH:mm:ss');
            onoff = data[i].monitoring ? "checked" : "";

            const innerHTML = "<tr id='p" + i + "' style='border-bottom: silver solid 2px; cursor: pointer;' value = '" + name + "' onclick=\"placeChange('p" + i + "')\" >" +
                "<td style='padding-left:6px;' onclick='event.cancelBubble=true'><input class='form-check-input' id='check" + i + "' name='place' type='checkbox' value ='" + name + "' onclick='checkPlaceAll()'></td>" +
                "<td style='width: 34%; word-break: break-all;' id='place" + i + "'>" + name + "</td>" +
                "<td style='width: 40%;'>" + time + "</td>" +
                "<td style='width: 24%; padding:5px;' onclick='event.cancelBubble=true'><label class='switch'>" +
                "<input class='placeCheckbox' id='pmonitor" + i + "' type='checkbox' " + onoff + " onchange=\"p_monitoringupdate('pmonitor" + i + "')\">" +
                "<span class='slider round'></span>" +
                "</label></td>" +
                "</tr>";

            $('#placeDiv').append(innerHTML);
            onoff = "";
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

        const none = "<div class='fw-bold' style='padding-top : 20px;'>" +
            "<div style='padding-bottom:5px;'>등록된 센서 데이터가 없습니다.</div>" +
            "<div>센서 등록 후 이용 가능합니다.</div></div>";

        $('#items').append(none); //센서 없을때

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
                                "<td style='width:14%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input'  autocomplete='off' name='legal' type='text' id='legal" + i + "' value='" + data[i].legalStandard + "' onchange='legalupdate(this)'></td>" +
                                "<td style='width:14%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input'  autocomplete='off'name='company' type='text' id='company" + i + "' value='" + data[i].companyStandard + "' onchange='companyupdate(this)'></td>" +
                                "<td style='width:14%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input'  autocomplete='off'name='management' type='text' id='management" + i + "' value='" + data[i].managementStandard + "' onchange='managementupdate(this)'></td>" +
                                "<td style='width:13%;'><label class='switch'>" +
                                "<input id='monitor" + i + "' type='checkbox' name='sensormonitor' value='" + data[i].name + "' " + data[i].monitoring + " onchange='monitoringupdate(this)'>" +
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
            placeDiv();
            placeChange(document.getElementById('nickname').value);
            return false;
        }
        $('#addup').text('측정소 수정');
        $('#saveBtn').text('수정');
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

            if (data[i].legalStandard == 999) {
                data[i].legalStandard = "";
            }
            if (data[i].companyStandard == 999) {
                data[i].companyStandard = "";
            }
            if (data[i].managementStandard == 999) {
                data[i].managementStandard = "";
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
        placeDiv();
        placeChange(send);
    }

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

                    placeDiv();
                    placeChange("p0");
                });
            }
        });
    }

    //측정소 모니터링 onchange
    function p_monitoringupdate(id) {
        const num = id.replace(/[^0-9]/g, ''); //place0 -> 0
        var check = $("#" + id).is(":checked"); //true/false
        var name = $("#p" + num).attr("value"); //측정소 명
        var timeTd = $("#" + id).parent().parent().prev();
        var sensorCheck = findSensor(name);
        if (sensorCheck == 'none') { //등록된 센서가 없을때
            customSwal('등록된 센서가 없어 모니터링 기능을 사용할 수 없습니다.');
            $("#" + id).prop("checked", false);
            return;

        } else if (sensorCheck == "Off") {
            customSwal('측정항목 모니터링이 전부 OFF 상태입니다.');
            $("#" + id).prop("checked", false);
            return;
        }
        $.ajax({
            url: '<%=cp%>/MonitoringUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "place": name, //측정소 명
                "check": check //true/false
            },
            success: function (data) {
                timeTd.html(moment(data).format('YYYY-MM-DD HH:mm:ss'));
            },
            error: function (err) {
                console.log(err);
            }
        })
        if (check == true) {
            check = "ON";
        } else {
            check = "OFF";
        }
        inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "'" + name + "' 모니터링 " + check + "", "설정");
        MultiSelecterModal(name, "", "monitor", check);
    }

    //측정항목 모니터링 onchange
    function monitoringupdate(name) {
        var id = name.id;
        const num = id.replace(/[^0-9]/g, ''); //place0 -> 0
        const naming = $("#naming" + num).text(); //관리ID
        var tablename = name.value; //
        var check = $("#" + id).is(":checked");
        var pname = $("#pname").text();

        $.ajax({
            url: '<%=cp%>/referenceMonitoringUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "sensor": tablename,
                "place": pname
            }
        })
        if (check == true) {
            check = "ON";
        } else {
            check = "OFF";
        }
        let checkFlag = false;
        if ($("input[name=sensormonitor]").is(":checked") == true) checkFlag = true;
        if (checkFlag == false) {
            $('tr[value=' + pname + ']').find('.placeCheckbox').prop("checked", false);
        }
        inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "'" + pname + " - " + naming + "' 모니터링 " + check + "", "설정");
        MultiSelecterModal(pname, naming, "monitor", check);
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
        var managename = "management" + num;
        var manage = $("#" + managename).val(); //관리기준 값
        var value = strReplace(name.value); //수정값
        var pname = $("#pname").text();
        if (value == "" || value == "999") {
            value = "999";
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
            if (parseFloat(value) <= parseFloat(manage)) { //법적기준 값이 관리기준 값보다 작을때
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: '법적기준 값은 관리기준 값보다 작거나 같을 수 없습니다.'
                })
                placeChange(document.getElementById('nickname').value);
                return;
            }
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
        if (value == "999") {
            name.value = "";
        } else {
            MultiSelecterModal(pname, naming, "legal", value);
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
        var managename = "management" + num;
        var manage = $("#" + managename).val(); //관리기준 값
        var value = strReplace(name.value);
        var pname = $("#pname").text();
        if (value == "" || value == "999") {
            value = "999";
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
            if (parseFloat(value) <= parseFloat(manage)) {  //
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: '사내기준 값은 관리기준 값보다 작거나 같을 수 없습니다.'
                })
                placeChange(document.getElementById('nickname').value);
                return;
            }
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
        if (value == "999") {
            name.value = "";
        } else {
            MultiSelecterModal(pname, naming, "company", value);
            name.value = value;
        }
    }
    //management onchange
    function managementupdate(name) {
        var id = name.id;
        const num = id.replace(/[^0-9]/g, ''); //place0 -> 0
        const naming = $("#naming" + num).text(); //관리ID
        var tablename = $("#name" + num).text(); //측정항목 명
        var legalname = "legal" + num;
        var legal = $("#" + legalname).val(); //법적기준 값
        var companyname = "company" + num;
        var company = $("#" + companyname).val(); //사내기준 값
        var value = strReplace(name.value); //관리기준
        var pname = $("#pname").text();
        if (value == "" || value == "999") {
            value = "999";
        } else {
            if (ifsum(value) == false) {
                placeChange(document.getElementById('nickname').value);
                return;
            }
            if (parseFloat(company) <= parseFloat(value)) {  //
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: '관리기준 값은 사내기준 값보다 크거나 같을 수 없습니다.'
                })
                placeChange(document.getElementById('nickname').value);
                return;
            }
            if (parseFloat(legal) <= parseFloat(value)) {  //
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: '관리기준 값은 법적기준 값보다 크거나 같을 수 없습니다.'
                })
                placeChange(document.getElementById('nickname').value);
                return;
            }
        }
        $.ajax({
            url: '<%=cp%>/managementUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "tablename": tablename,
                "value": value,
                "place": pname
            }
        });
        inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "'" + pname + "-" + naming + "' 법적 기준 값 변경 '" + value + "'", "설정");
        if (value == "999") {
            name.value = "";
        } else {
            MultiSelecterModal(pname, naming, "manage", value);
            name.value = value;
        }
    }

    //데이터 변경시 팝업창
    function MultiSelecterModal(place, name, standard, value) {
        const modal = $('#alert');
        if (standard == "legal") {
            modal.html("'" + place + "-" + name + "'의 법적기준 값이 '" + value + "'(으)로 설정되었습니다.");
        } else if (standard == "company") {
            modal.html("'" + place + "-" + name + "'의 사내기준 값이 '" + value + "'(으)로 설정되었습니다.");
        } else if (standard == "manage") {
            modal.html("'" + place + "-" + name + "'의 관리기준 값이 '" + value + "'(으)로 설정되었습니다.");
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

</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
