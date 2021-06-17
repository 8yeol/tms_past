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
<%--make css--%>
<link rel="stylesheet" type="text/css" href="static/css/alarmManagement.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/timepicker.js"></script>
<script src="static/js/sweetalert2.min.js"></script>

<style>
    .border-bottom-custom {
        border-bottom: 2px solid #a9a9a9;
        padding: 16px 16px 25px 16px;
    }
</style>



<div class="container" id="container">
    <div class="row m-3 mt-3 ms-1">
        <span class=" fw-bold" style="font-size: 27px;">환경설정 > 알림설정</span>
    </div>

    <div class="row m-3 mt-3 bg-light">
        <div id="noneDiv" style="border-bottom: 2px solid #a9a9a9; margin: auto;">
            <div class="fw-bold fs-5" style='margin: auto; text-align: center; height: 151px; padding-top: 35px;'>
                모니터링 ON 설정된 측정소가 없습니다. <br> <b>[환경설정 > 측정소 관리]</b> 에서 측정소 모니터링을 설정해주세요.
            </div>
        </div>

        <c:forEach var="place" items="${place}" varStatus="status">
            <div id="placeDiv${status.index}">

                <div class="row bg-light border-bottom-custom">

                    <span class="fs-5 placeName" style="margin-bottom: 20px; display: inline-block; width: auto"
                          id="place${status.index}">${place.name}</span>
                    <button type="button" class="cancelBtn" onClick="cancel(${status.index})"><img
                            src="static/images/reload.png" width="22" height="22"></button>

                    <div style="" id="div${status.index}">
                        <div style="position: relative; padding-bottom: 5px;">
                            <div class="dp" id="alarm${status.index}" style="width: 65%; margin: 0 auto 10px;">
                            </div>

                        </div>
                        <hr>
                        <div class="add-dp" style="width: 75%; margin: 0 auto; position: relative;">
                            <span style="margin-left: 60px;" class="textSpanParent"> 센서 목록</span>
                            <div style="padding-top: 10px;" id="items${status.index}">
                                    <%-- script --%>
                            </div>
                            <button type="button" class="btn btn-primary saveBtn" onClick="insert(${status.index})">저장
                            </button>
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
        const placeLength = ${place.size()};
        //저장소 DIV 반복 생성
        for (let i = 0; i < placeLength; i++) {
                $("#noneDiv").empty();
                document.getElementById("noneDiv").style = "";
                placeMake($("#place" + i).text(), i);
        }
        for (let i = 0; i < placeLength; i++) {
            $(".example").timepicker();
        }

    });

    //측정소 생성
    function placeMake(name, idx) {
        const place = name;
        const parentElem = $('#items' + idx);
        let status ;
        let tableName ;
        let naming ;
        let check =-1;

        let innerHTMLTimePicker = "<div><span class=\"textSpanParent\">알림 시간</span></div>";
        innerHTMLTimePicker += "<div style='display: inline-flex; margin-top: 10px;'>";
        innerHTMLTimePicker += '<div><span class="textSpan" style="margin-right: 20px;">From </span>  <input style="background-color: white;"class="form-control example timePicker" name="start" type="text" id="start'+idx+'" readonly/></div>';
        innerHTMLTimePicker += '<div><span class="textSpan" style="margin-right: 20px;">To </span>  <input style="background-color: white;"class="form-control example timePicker" name="end" type="text"id="end'+idx+'"readonly/></div>';
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
                            check = i;
                        }else{
                            status = '';
                            tableName = data[i].tableName;
                            naming = data[i].naming;
                        }

                        const innerHtml =
                            "<label style='font-size: 18px; ' class='form-check-label' id='" + tableName + "'for='" + tableName + "'>" + naming + "</label>" +
                            "<label class='switch'>" +
                            "<input id='" + tableName + "' name='status" + idx + "' type='checkbox'  " + status + ">" +
                            "<div class='slider round'></div>" +
                            "</label>"

                        const elem = document.createElement('div');
                        elem.setAttribute('class', 'label-form');
                        elem.setAttribute('style', 'margin-top:5px')
                        elem.innerHTML = innerHtml;
                        parentElem.append(elem);

                    }  //--for

                    if(check!=-1){
                        fromTime = data[check].start;
                        endTime = data[check].end;
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
        const onList = new Array();
        const onList2 = new Array();
        const offList = new Array();
        const offList2 = new Array();
        $("input:checkbox[name=status" + idx + "]:checked").each(function () {
            onList.push($(this).attr('id'));
            sensorName = $(this).attr('id');
            onList2.push($('#'+sensorName).text());
        });
        $("input:checkbox[name=status" + idx + "]:not(:checked)").each(function () {
            offList.push($(this).attr('id'));
            sensorName = $(this).attr('id');
            offList2.push($('#'+sensorName).text());
        });
        $.ajax({
            url: '<%=cp%>/saveNotification',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "onList": onList,
                "offList": offList,
                "from": start,
                "to": end
            }
        })
        if(onList.length==0){
            inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}',
                $("#place" + idx).text() + " - 알림 설정 변경(알림 시간 : "+start+"~"+end+" 알림 OFF : "+ offList2 + ")","설정");
        }else if(offList2.length==0){
            inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}',
                $("#place" + idx).text() + " - 알림 설정 변경(알림 시간 : "+start+"~"+end+", 알림 ON : "+ onList2+")","설정");
        }else{
            inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}',
                $("#place" + idx).text() + " - 알림 설정 변경(알림 시간 : "+start+"~"+end+", ON : "+ onList2+", OFF : "+ offList2 + ")","설정");
        }
        Swal.fire({
            icon: 'success',
            title: '저장완료'
        })
    }

    //시작 시간이 종료시간보다 클때 endTime 변경
    //TimePicker 객체에서 아이디->인덱스 추출
    function changeEndTime(self) {
        let objId = obj.ele[0].id;               //console.log(objId) -> start0
        let idx = objId.replace(/[^0-9]/g, ''); //console.log(idx) -> 0
        let stime = $('#start' + idx).val();
        let etime = $('#end' + idx).val();
        if (stime.length == 3) {
            swal.fire({
                icon: 'warning',
                title: '경고',
                text: '시간을 정확히 입력 해주세요.'
            })
            $("#start" + idx).val("");
            return;
        }
        if (etime.length == 3) {
            swal.fire({
                icon: 'warning',
                title: '경고',
                text: '시간을 정확히 입력 해주세요.'
            })
            $("#end" + idx).val("");
            return;
        }
        if (etime != "") {
            if (stime >= etime) {
                swal.fire({
                    icon: 'warning',
                    title: '경고',
                    text: 'To 시간이 From 시간 보다 적거나 같을 수 없습니다.'
                })
                $("#end" + idx).val("");
                return;
            }
        }
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
