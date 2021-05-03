<%--
  Created by IntelliJ IDEA.
  User: hsheo
  Date: 2021-04-21
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

<link rel="stylesheet" type="text/css" href="static/css/chung-timepicker.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<%--make css--%>
<link rel="stylesheet" type="text/css" href="static/css/alarmManagement.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/chung-timepicker.js"></script>
<script src="static/js/sweetalert2.min.js"></script>

<style>
    .border-bottom-custom{
        border-bottom: 2px solid #a9a9a9;
        padding : 16px 16px 40px 16px ;
    }
    .border-tom-custom{
        border-top: 2px solid #a9a9a9;
        padding : 16px 16px 40px 16px ;
    }
</style>

<div class="container">
    <div class="row m-3 mt-3 ms-1">
        <span class="fs-4 fw-bold">환경설정 > 알림설정</span>
    </div>

    <div class="row m-3 mt-3 bg-light">
        <div class="row p-3 ms-1">
            <div class="col fs-5 fw-bold">
                알림설정
            </div>
        </div>

        <c:forEach var="place" items="${place}" varStatus="status">
            <c:choose>
                <c:when test="${status.first}">
                <div class="row bg-light rounded ms-1 border-bottom-custom border-tom-custom" id="placeDiv${status.index}">
                </c:when>
                <c:otherwise>
                <div class="row bg-light rounded ms-1 border-bottom-custom" id="placeDiv${status.index}">
                </c:otherwise>
            </c:choose>
                <span class="fs-5 placeName" id="place${status.index}">${place}</span>
                <div class="col-3" style="width: 45%;">
                <span style="margin-left: 130px;" class="textSpanParent"> 센서 목록</span>
                    <div id="items${status.index}">
                            <%-- script --%>
                    </div>
                </div>
                <div class="col-3" style="width: 30%">
                    <div class="a1" id="alarm${status.index}"></div>
                </div>
                <div class="col-3 end w-25">
                    <button type="button" class="btn btn-primary saveBtn" onClick="insert(${status.index})">저장</button>
                    <button type="button" class="cancelBtn" onClick="cancel(${status.index})"><img
                            src="../static/images/reload.png" width="23" height="23"></button>
                </div>
            </div>
        </c:forEach>
    </div>

    <h6>* 알림을 받을 측정항목을 선택해 주세요. [환경설정 > 측정소 관리]에서 설정된 항목의 기준이 초과하는 경우 알림이 발생합니다.</h6>
</div>

<script>

    $(document).ready(function () {
        const placeLength = ${place.size()};
        //저장소 DIV 반복 생성
        for (let i = 0; i < placeLength; i++) {
            placeMake($("#place" + i).text(), i);
        }
        //각각 타임피커 셋팅
        for (let i = 0; i < placeLength; i++) {
            $('#start' + i).chungTimePicker({viewType: 1});
            $('#end' + i).chungTimePicker({viewType: 1});
        }
    });

    //측정소 생성
    function placeMake(name, idx) {
        const place = name;
        const parentElem = $('#items' + idx);

        let innerHTMLTimePicker = "";
        innerHTMLTimePicker += '<div><span class="textSpanParent">알림 시간</span></div>';
        innerHTMLTimePicker += '<div><span class="textSpan">From </span><input type="text" id="start' + idx + '" name="start" class="timePicker" readonly/></div>';
        innerHTMLTimePicker += '<div><span class="textSpan">To </span><input type="text" id="end' + idx + '" name="end" class="timePicker" readonly/></div>';

        $('#alarm' + idx).append(innerHTMLTimePicker);

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
                    const checked = findNotification(tableName);

                    const innerHtml =
                        "<label style='font-size: 18px;' class='form-check-label' for='" + tableName + "'>" + category + "</label>" +
                        "<label class='switch'>" +
                        "<input id='" + tableName + "' name='status" + idx + "' type='checkbox'  " + checked + ">" +
                        "<div class='slider round'></div>" +
                        "</label>"

                    const elem = document.createElement('div');
                    elem.setAttribute('class', 'label-form')
                    elem.innerHTML = innerHtml;
                    parentElem.append(elem);

                    if(i%data.length==0){
                        const time = data[0];
                        const getTime = getNotifyTime(time);
                        $("#start" + idx).val(getTime.get("from"));
                        $("#end" + idx).val(getTime.get("to"));
                    }
                }
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
    }

    //Notification_settings status 값 불러오기
    function findNotification(tableName) {
        let isChecked = "";
        $.ajax({
            url: '<%=cp%>/getNotifyInfo',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"name": tableName},
            success: function (data) {
                const status = data.status;
                if (status == true) {
                    isChecked = "checked";
                }
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return isChecked;
    }

    // 설정된 알람시간 불러오기
    function getNotifyTime(time) {
        let map = new Map();
        $.ajax({
            url: '<%=cp%>/getNotifyTime',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"name": time},
            success: function (data) {
                map.set("from", data.start);
                map.set("to", data.end);
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return map;
    }

    //알림설정 값 저장
    function insert(idx) {
        const start = $("#start" + idx).val();
        const end = $("#end" + idx).val();

        if (start == "" || end == "") {
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '알림시간을 입력해주세요.'

            })
            return false;
        }

        const onList = new Array();
        const offList = new Array();
        $("input:checkbox[name=status" + idx + "]:checked").each(function () {
            onList.push($(this).attr('id'));
        });
        $("input:checkbox[name=status" + idx + "]:not(:checked)").each(function () {
            offList.push($(this).attr('id'));
        });

        $.ajax({
            url: '<%=cp%>/saveNotification',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "onList":onList,
                "offList":offList,
                "from":start,
                "to":end
            },
            success: function (data) {

            },
            error: function (request, status, error) {
                console.log(error)
            }
        })

        Swal.fire({
            icon: 'success',
            title: '저장완료'
        })

    }

    //시작 시간이 종료시간보다 클때 endTime 변경
    //TimePicker 객체에서 아이디->인덱스 추출
    function changeEndTime(obj) {
        let objId = obj.ele[0].id;               //console.log(objId) -> start0
        let idx = objId.replace(/[^0-9]/g, ''); //console.log(idx) -> 0

        let stime = $('#start' + idx).val();
        let etime = $('#end' + idx).val();

        if (stime > etime) {
            swal.fire({
                icon: 'warning',
                title: '경고',
                text: 'From 시간 보다 적은 시간을 입력하실 수 없습니다.'
            })
            $('#end' + idx).val(stime);
        }
    }

    //임시로 설정한값 삭제후 다시 생성
    function cancel(idx) {
        $('#alarm' + idx).empty();
        $('#items' + idx).empty();

        placeMake($("#place" + idx).text(), idx);
        $('#start' + idx).chungTimePicker({viewType: 1});
        $('#end' + idx).chungTimePicker({viewType: 1});
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>