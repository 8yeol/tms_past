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

    #placeDiv > div.active {
        color: #0d6efd;
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
            <div style="padding-bottom: 10px;">
                <span class="fw-bold" style="margin-right: 53%;">측정소 관리</span>
                <button data-bs-toggle="modal" data-bs-target="#addPlace" class="addBtn">추가</button>
                <button onclick="removePlace()" class="removeBtn">삭제</button>
            </div>
            <div class="text-center">
                <div class="fw-bold"
                     style="border-bottom: silver solid 2px; display: flex; width:100%; position: relative; padding-bottom: 5px;">
                    <div style="margin-left: 5px; margin-right: 5px;"><input name="placeall"
                                                                             class="form-check-input"
                                                                             type=checkbox
                                                                             onclick="placeAll(this)">
                    </div>
                    <div style="width: 30%">측정소 명</div>
                    <div style="width: 40%;">업데이트</div>
                    <div style="width: 24%;">모니터링 사용</div>
                </div>
                <div>
                    <ul id="placeDiv" style="list-style: none; padding: 0px;">

                    </ul>
                </div>

            </div>
        </div>
        <div class="col-3" style="width: 61%; background: rgba(0, 0, 0, 0.05);">

            <div>
                <div id="p_monitoring" class="fw-bold" style="display: flex; margin-top: 5px; padding-bottom: 35px;">
                </div>

            </div>
            <table style="text-align: center; width: 100%">
                <tr id="c" style="border-bottom: silver solid 2px; width: 100%; display: flex; padding-bottom: 5px;">
                    <th style="width: 2%;"></th>
                    <th style="width:18%;">측정항목</th>
                    <th style="width:25%;">관리ID</th>
                    <th style="width:14%;">법적기준</th>
                    <th style="width:14%;">사내기준</th>
                    <th style="width:14%;">관리기준</th>
                    <th style="width:13%;">모니터링</th>
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
                <form id="placeinfo" method="post" style="width:100%; ">
                    <div style="margin-bottom:7px; margin-top: 18px;"><span>측정소 명</span><input type="text"
                                                                                               class="modal-input"
                                                                                               name="name"
                                                                                               id="na"
                                                                                               style="position: relative; left: 15%;">

                    </div>
                    <div style="margin-bottom:7px;"><span>위치</span><input type="text" class="modal-input"
                                                                          name="location"
                                                                          id="lo"
                                                                          style="position: relative; left: 22%;"></div>
                    <div style="margin-bottom:7px;"><span>담당자 명</span><input type="text" class="modal-input"
                                                                             name="admin"
                                                                             id="ad"
                                                                             style="position: relative; left: 15%;">
                    </div>
                    <div style="margin-bottom:7px;"><span>연락처</span><input type="text" class="modal-input" name="tel"
                                                                           id="te"
                                                                           style="position: relative; left: 19%;"></div>
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

</script>
<script>
    $(document).ready(function () {
        placeDiv();
        placeChange($("#place0").text());

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
        $.ajax({
            url: '<%=cp%>/getPlaceList',
            async: false,
            cache: false,
            success: function (data) {
                for (let i = 0; i < data.length; i++) {
                    const test = data[i];
                    const name = test.name;
                    const time = moment(test.up_time).format('YYYY-MM-DD HH:mm:ss');
                    const monitoring = test.monitoring;
                    if (monitoring == true) {
                        onoff = "ON";
                    } else {
                        onoff = "OFF";
                    }
                    const innerHTML = "<div id='" + name + "p' style='border-bottom: silver solid 2px;' onclick=\"placeChange('" + name + "')\" >" +
                        "<li style='display: flex; text-align: center'>" +
                        "<span ><input class='form-check-input' id='" + name + "' name='place' type='checkbox' onclick='checkPlaceAll()'></span>" +
                        "<span style='width: 30%;' id='place" + i + "'>" + name + "</span>" +
                        "<span style='width: 40%; '>" + time + "</span>" +
                        "<span style='width: 24%;'>" + onoff + "</span>" +
                        "</li>" +
                        "</div>";

                    $('#placeDiv').append(innerHTML);
                }

            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
    }

    //측정소 변경
    function placeChange(name) {
        const place = name; // 측정소1 입력
        $('#placeDiv div').removeClass('active'); //텍스트 색상 제거
        $("#" + place + "p").addClass('active'); // 텍스트 색상 변경
        $("#items").empty(); //div items 비우기
        $("#p_monitoring").empty(); //div p_monitoring 비우기
        const p_monitoring = findPlaceMonitor(place); //측정소monitor on/off 확인

        let innerHTMLPlace =
            "<div id='pname'>" + place + "</div>" +
            "<div>상세설정</div>" +
            "<div>측정소 모니터링</div>" +
            "<div><label class='switch'>" +
            "<input id='monitor' type='checkbox' " + p_monitoring + " onchange='p_monitoringupdate()'>" +
            "<span class='slider round'></span>" +
            "</label></div>";
        $('#p_monitoring').append(innerHTMLPlace); //측정소 명 + 모니터링 on/off div

        const none = "<div class='fw-bold' style='padding-top : 20px;'>" +
            "<div style='padding-bottom:5px;'>등록된 센서 데이터가 없습니다.</div>" +
            "<div>센서 등록 후 이용 가능합니다.</div></div>";

        $('#items').append(none); //센서 없을때

        $.ajax({
            url: '<%=cp%>/getPlaceSensor',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place": place},
            success: function (data) {
                if (data.length != 0) {
                    $("#items").empty(); //센서 있을때 div 비움
                    for (let i = 0; i < data.length; i++) {
                        const tableName = data[i]; //측정소에 저장된 센서명---> 이걸 reference컬렉션에서 가져와야함.
                        const value = findReference(tableName); //naming, name, legal, company, management //map이 비어있을때
                        const monitoring = findMonitor(tableName); //모니터 on/off(checked)
                        if (value.size != 0) {
                            const innerHtml =
                                "<td style='width: 2%;'></td>" +
                                "<td style='width:18%;'><label class='form-check-label' for='" + value.get("name") + "'>" + value.get("naming") + "</label></td>" +
                                "<td style='width:25%;'><label class='form-check-label' for='" + value.get("name") + "'>" + value.get("name") + "</label></td>" +
                                "<td style='width:14%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input' name='" + value.get("naming") + "' type='text' id='" + tableName + "l' value='" + value.get("legal") + "' onchange='legalupdate(this)'></td>" +
                                "<td style='width:14%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input' name='" + value.get("naming") + "' type='text' id='" + tableName + "c' value='" + value.get("company") + "' onchange='companyupdate(this)'></td>" +
                                "<td style='width:14%;'><input style = 'width:80%; height: 34px; margin-bottom:5px;' class='form-check-input' name='" + value.get("naming") + "' type='text' id='" + tableName + "m' value='" + value.get("management") + "' onchange='managementupdate(this)'></td>" +
                                "<td style='width:13%;'><label class='switch'>" +
                                "<input id='" + value.get("name") + "a' type='checkbox' name='" + value.get("naming") + "' " + monitoring + " onchange='monitoringupdate(this)'>" +
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

    //센서 유무 파악(모니터링 버튼 기능 제어)
    function findSensor(name) {
        var have = "";
        $.ajax({
            url: '<%=cp%>/getPlaceSensor',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place": name},
            success: function (data) {
                have = data;
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
                have = 0;
            }
        })
        return have;
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
                const monitoring = data.monitoring;
                if (monitoring == true) {
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
                const monitoring = data.monitoring;
                if (monitoring == true) {
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
                if (data.legalStandard == 999) {
                    data.legalStandard = "";
                }
                if (data.companyStandard == 999) {
                    data.companyStandard = "";
                }
                if (data.managementStandard == 999) {
                    data.managementStandard = "";
                }
                map.set("naming", data.naming);
                map.set("name", data.name);
                map.set("legal", data.legalStandard);
                map.set("company", data.companyStandard);
                map.set("management", data.managementStandard);
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        })
        return map;
    }

    //측정소 추가
    function insertPlace() {
        const na = $("#na").val();
        const name = na.replace(/(\s*)/g, "");
        const location = $("#lo").val();
        const tel = $("#te").val();
        const admin = $("#ad").val();

        if (name == "") {
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '측정소 명을 입력해주세요.'

            })
            return false;
        } else {
            if (findPlace(name) != 0) {
                Swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: '이미 등록된 측정소 입니다.'
                })
                return false;
            }
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
                "admin": admin
            }

        })
        Swal.fire({
            icon: 'success',
            title: '저장완료',
            timer: 1500
        })
        document.getElementById("cancelBtn").click();
        placeDiv();
        placeChange($("#pname").text());
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
                swal.fire({
                    title: '삭제 완료',
                    icon: 'success',
                    timer: 1500
                })
                //location.reload();
                placeDiv();
                placeChange($("#place0").text());

            }
        })
    }

    //측정소 모니터링 onchange
    function p_monitoringupdate() {
        var check = $("#monitor").is(":checked"); //true/false
        var name = $("#pname").text(); //측정소 이름

        if (findSensor(name) == 0) { //등록된 센서가 없을때
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '등록된 센서가 없어 모니터링 기능을 사용할 수 없습니다.'
            })
            placeChange($("#pname").text());
            return false;
        }

        $.ajax({
            url: '<%=cp%>/placeMonitoringUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "name": name,
                "check": check
            }

        })
        MultiSelecterModal(name, "", "monitor", check);
        placeDiv();
        placeChange($("#pname").text());
    }

    //측정항목 모니터링 onchange
    function monitoringupdate(name) {
        var tablename = name.id;
        var str = tablename.slice(0, -1);
        var check = $("#" + name.id).is(":checked");
        var pname = $("#pname").text();

        $.ajax({
            url: '<%=cp%>/referenceMonitoringUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "tablename": str,
                "check": check,
                "place": pname
            }
        })
        MultiSelecterModal(pname, name.name, "monitor", check);
        placeDiv();
        placeChange($("#pname").text());
    }

    //legal onchange
    function legalupdate(name) {
        var tablename = name.id;
        var str = tablename.slice(0, -1);
        var companyname = str + "c";
        var company = $("#" + companyname).val(); //사내기준 값
        var managename = str + "m";
        var manage = $("#" + managename).val(); //관리기준 값
        var value = $("#" + tablename).val(); //법적기준 값
        var pname = $("#pname").text();
        if (value == "") {
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '입력 데이터를 체크해주세요.'

            })
            placeChange($("#pname").text());
            return false;
        }

        if (isNaN(value) == true) {

            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '입력 데이터를 체크해주세요.'

            })
            placeChange($("#pname").text());
            return false;
        }
        if (parseFloat(value) <= parseFloat(company)) { //법적기준 값이 사내기준 값보다 작을때
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '법적기준 값은 사내기준 값보다 작거나 같을 수 없습니다.'
            })
            placeChange($("#pname").text());
            return;
        }
        if (parseFloat(value) <= parseFloat(manage)) { //법적기준 값이 관리기준 값보다 작을때
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '법적기준 값은 관리기준 값보다 작거나 같을 수 없습니다.'
            })
            placeChange($("#pname").text());
            return;
        }

        $.ajax({
            url: '<%=cp%>/legalUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "tablename": str,
                "value": value,
                "place": pname
            }
        })
        MultiSelecterModal(pname, name.name, "legal", value);
        placeDiv();
        placeChange($("#pname").text());
    }

    //company onchange
    function companyupdate(name) {
        var tablename = name.id;
        var str = tablename.slice(0, -1);
        var legalname = str + "l";
        var legal = $("#" + legalname).val(); //법적기준 값
        var managename = str + "m";
        var manage = $("#" + managename).val(); //관리기준 값
        var value = $("#" + tablename).val();
        var pname = $("#pname").text();
        if (value == "") {
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '입력 데이터를 체크해주세요.'

            })
            placeChange($("#pname").text());
            return false;
        }
        if (isNaN(value) == true) {

            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '입력 데이터를 체크해주세요.'

            })
            placeChange($("#pname").text());
            return false;
        }

        if (parseFloat(value) <= parseFloat(manage)) {  //
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '사내기준 값은 관리기준 값보다 작거나 같을 수 없습니다.'
            })
            placeChange($("#pname").text());
            return;
        }
        if (parseFloat(legal) <= parseFloat(value)) {  //
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '사내기준 값은 법적기준 값보다 크거나 같을 수 없습니다.'
            })
            placeChange($("#pname").text());
            return;
        }

        $.ajax({
            url: '<%=cp%>/companyUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "tablename": str,
                "value": value,
                "place": pname
            }
        })
        MultiSelecterModal(pname, name.name, "company", value);
        placeDiv();
        placeChange($("#pname").text());
    }

    //management onchange
    function managementupdate(name) {
        var tablename = name.id;
        var str = tablename.slice(0, -1);
        var legalname = str + "l";
        var legal = $("#" + legalname).val(); //법적기준 값
        var companyname = str + "c";
        var company = $("#" + companyname).val(); //사내기준 값
        var value = $("#" + tablename).val(); //관리기준
        var pname = $("#pname").text();
        if (value == "") {
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '입력 데이터를 체크해주세요.'

            })
            placeChange($("#pname").text());
            return false;
        }
        if (isNaN(value) == true) {

            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '입력 데이터를 체크해주세요.'

            })
            placeChange($("#pname").text());
            return false;
        }
        if (parseFloat(company) <= parseFloat(value)) {  //
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '관리기준 값은 사내기준 값보다 크거나 같을 수 없습니다.'
            })
            placeChange($("#pname").text());
            return;
        }
        if (parseFloat(legal) <= parseFloat(value)) {  //
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '관리기준 값은 법적기준 값보다 크거나 같을 수 없습니다.'
            })
            placeChange($("#pname").text());
            return;
        }

        $.ajax({
            url: '<%=cp%>/managementUpdate',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "tablename": str,
                "value": value,
                "place": pname
            }
        })
        MultiSelecterModal(pname, name.name, "manage", value);
        placeDiv();
        placeChange($("#pname").text());
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
            if (value == true) {
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
        Modal.finish();
        Modal.fadeIn(300);
        Modal.delay(2000).fadeOut(300);
    }


</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
