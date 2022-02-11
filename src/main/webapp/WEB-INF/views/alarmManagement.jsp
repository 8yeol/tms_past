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

<link rel="stylesheet" type="text/css" href="static/css/timepicker.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="stylesheet" type="text/css" href="static/css/page/alarmManagement.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/lib/timepicker.js"></script>
<script src="static/js/lib/sweetalert2.min.js"></script>

<div class="container" id="container">
    <div class="row m-3 mt-3 ms-1" style="padding-left: 10px;">
        <span class="col fw-bold fs-4">환경설정 > 알림설정</span>
        <span class="col"  style="color:red; font-size: 0.8rem;position: relative;top: 20px; font-weight: normal;text-align: end">
            * 알림 설정은 '최고 관리자' 권한을 가진 회원만 변경 가능합니다.
        </span>
    </div>

    <div class="row m-3 mt-3 bg-light">
        <div id="noneDiv" style="border-bottom: 2px solid #a9a9a9; margin: auto;">
            <div class="fw-bold fs-5" style='margin: auto; text-align: center; height: 151px; padding-top: 35px;'>
                모니터링 ON 설정된 측정소가 없습니다. <br>
                <b>[환경설정 > 측정소 관리]</b> 에서 측정소 모니터링을 설정해주세요.
            </div>
        </div>

        <c:forEach var="place" items="${place}" varStatus="status">
            <div id="placeDiv${status.index}">
                <div class="row bg-light border-bottom-custom">
                    <span class="fs-5 placeName" style="margin-bottom: 20px; display: inline-block; width: auto" id="place${status.index}">${place.name}</span>
                    <button type="button" class="cancelBtn" onClick="cancel(${status.index})">
                        <img src="static/images/reload.png" width="22" height="22">
                    </button>
                    <div style="" id="div${status.index}">
                        <div style="position: relative; padding-bottom: 5px;">
                            <div class="dp" id="alarm${status.index}" style="width: 65%; margin: 0 auto 10px;"></div>
                        </div>
                        <hr>
                        <div class="add-dp" style="width: 75%; margin: 0 auto; position: relative;">
                            <span style="margin-left: 60px;" class="textSpanParent"> 센서 목록</span>
                            <div style="padding-top: 10px;" id="items${status.index}">
                                    <%-- script --%>
                            </div>
                            <c:if test="${state == 1}">
                                <button type="button" class="btn btn-primary saveBtn" onClick="insert(${status.index})">저장</button>
                            </c:if>
                            <c:if test="${state != 1}">
                                <button type="button" class="btn btn-primary saveBtn" onClick="permissionError()">저장</button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <h6 style="padding-left: 12px;">* 알림을 받을 측정항목을 선택해 주세요. [환경설정 > 측정소 관리]에서 설정된 항목의 기준이 초과하는 경우 알림이 발생합니다.</h6>
</div>

<script>

    $(document).ready(function () {
        const placeLength = "${place.size()}";

        for (let i = 0; i < placeLength; i++) {
                $("#noneDiv").empty();
                document.getElementById("noneDiv").style = "";
                placeMake($("#place" + i).text(), i);
        }

        for (let i = 0; i < placeLength; i++) {
            $(".example").timepicker();
        }
    });

    function permissionError(){
        swal.fire({
            icon: 'warning',
            title: '경고',
            text: '최고 관리자만 변경 가능합니다.'
        })
    }

    //측정소 생성
    function placeMake(name, idx) {
        const state = "${state}" == "1" ? '' : 'disabled';
        const stateEvent = "${state}" == "1" ? '' : 'onclick="permissionError()"';
        const place = name;
        const parentElem = $('#items' + idx);
        let status ;
        let tableName ;
        let naming ;
        let notificationIndex =-1;

        let innerHTMLTimePicker = "<div><span class=\"textSpanParent\">알림 시간</span></div>";
        innerHTMLTimePicker += "<div style='display: inline-flex; margin-top: 10px;'>";
        innerHTMLTimePicker += '<div '+stateEvent+'><span class="textSpan" style="margin-right: 20px;">From </span>  ' ;
        innerHTMLTimePicker += '<input style="background-color: white;"class="form-control example timePicker" name="start" type="text" id="start'+idx+'" readonly '+state+'/></div>';
        innerHTMLTimePicker += '<div '+stateEvent+'><span class="textSpan" style="margin-right: 20px;">To </span>  ' ;
        innerHTMLTimePicker += '<input style="background-color: white;"class="form-control example timePicker" name="end" type="text"id="end'+idx+'"readonly '+state+'/></div>';
        innerHTMLTimePicker += "</div>";

        $('#alarm' + idx).append(innerHTMLTimePicker);
        $(".example").timepicker();
        $.ajax({
            url: '<%=cp%>/getNotificationValue',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"placeName": place},
            success: function (data) {
                    for (let i = 0; i < data.length; i++) {

                        if(data[i].start != null) { //알림설정값 있다면
                            status = data[i].status ? 'checked' : '';
                            tableName = data[i].name.split(",")[0]  //->lghausys_NOX_01
                            naming = data[i].name.split(",")[1]     //->질소산화물
                            notificationIndex = i;
                        }else{
                            status = '';
                            tableName = data[i].tableName;
                            naming = data[i].naming;
                        }

                        const innerHtml =
                            "<label style='font-size: 18px; ' class='form-check-label' id='" + tableName + "'for='" + tableName + "'>" + naming + "</label>" +
                            "<label class='switch' "+stateEvent+">" +
                            "<input "+state +" id='" + tableName + "' name='status" + idx + "' type='checkbox'  " + status + ">" +
                            "<div class='slider round'></div>" +
                            "</label>"

                        const elem = document.createElement('div');
                        elem.setAttribute('class', 'label-form');
                        elem.setAttribute('style', 'margin-top:5px')
                        elem.innerHTML = innerHtml;
                        parentElem.append(elem);
                    }  //--for

                    if(notificationIndex != -1){
                        fromTime = data[notificationIndex].start;
                        endTime = data[notificationIndex].end;
                    }else{
                        fromTime = '00:00';
                        endTime = '23:59';
                    }
                    $("#start" + idx).val(fromTime);
                    $("#end" + idx).val(endTime);
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error);
            }
        })
    }

    //Notification_settings status 값 불러오기
    function findNotification(tableName) {
        let notifycation = "";
        $.ajax({
            url: '<%=cp%>/getNotifyInfo',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"name": tableName},
            success: function (data) {
                notifycation = data;
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return notifycation;
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
            return ;
        } else {
            //저장할때 시간 검사
            if (start >= end) {
                swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: 'To 시간이 From 시간 보다 적거나 같을 수 없습니다.'
                })
                return;
            }
        }
        const stateOn_TableName = new Array();
        const stateOn_Naming = new Array();
        const stateOff_TableName = new Array();
        const stateOff_Naming = new Array();

        $("input:checkbox[name=status" + idx + "]:checked").each(function () {
            stateOn_TableName.push($(this).attr('id'));
            let sensorName = $(this).attr('id');
            stateOn_Naming.push($('#'+sensorName).text());
        });
        $("input:checkbox[name=status" + idx + "]:not(:checked)").each(function () {
            stateOff_TableName.push($(this).attr('id'));
            let sensorName = $(this).attr('id');
            stateOff_Naming.push($('#'+sensorName).text());
        });

        $.ajax({
            url: '<%=cp%>/saveNotification',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "onList": stateOn_TableName,
                "offList": stateOff_TableName,
                "from": start,
                "to": end
            }
        })
        if(stateOn_TableName.length==0){
            inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}',
                $("#place" + idx).text() + " - 알림 설정 변경(알림 시간 : "+start+"~"+end+" 알림 OFF : "+ stateOff_Naming + ")","설정");
        }else if(stateOff_TableName.length==0){
            inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}',
                $("#place" + idx).text() + " - 알림 설정 변경(알림 시간 : "+start+"~"+end+", 알림 ON : "+ stateOn_Naming+")","설정");
        }else{
            inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}',
                $("#place" + idx).text() + " - 알림 설정 변경(알림 시간 : "+start+"~"+end+", ON : "+ stateOn_Naming+", OFF : "+ stateOff_Naming + ")","설정");
        }
        Swal.fire({
            icon: 'success',
            title: '저장 완료',
            text: '성공적으로 저장되었습니다.',
            showConfirmButton: false,
            timer: 2000
        })
    }

    //임시로 설정한값 삭제후 다시 생성
    function cancel(idx) {
        $('#alarm' + idx).empty();
        $('#items' + idx).empty();

        placeMake($("#place" + idx).text(), idx);
        $(".example").timepicker();
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
