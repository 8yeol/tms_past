<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<script src="static/js/moment.min.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/vue-apexcharts.js"></script>

<style>
    div {
        padding: 1px;
    }

    h1 {
        text-align: center;
    }

    #sensorStatus p{
        padding-left: 2px; margin-top: 10px;
    }

    .add-bg-color {
        background-color: #97bef8;
        color: #fff;
    }

    tbody tr:hover{
        cursor: pointer;
    }
    .place_border{
        box-shadow: 0 0 2px 0 #2295DB inset;
    }
    .standardParent {
        border: 5px solid #2295DB;
        border-top-left-radius: 20px;
        border-top-right-radius: 20px;
        background-color: #2295DB;
        color: white;
    }
    .standardDiv{
        text-align: center;
    }
    .titleDiv{
        background-color: #2295DB;
        color: white;
    }

    tr {
        border-bottom: solid #dee2e6;
    }

    .emoji {
        width: 60px;
        height: 60px;
        position: relative;
        top: 2rem;
        margin-left: 0.75rem;
    }

    .mb-0{
        padding-top: 1.9rem;
        font-size: 1.8rem;
    }

    .Gcloud {
        width: 270px;
        height: 90px;
        position: absolute;
        top: -75px;
        left: -120px;
        padding: 15px 20px;
        background: url(static/images/greenCloud.png) no-repeat center / 100% 99%;
        background-origin: padding-box;
        text-align: center;
        line-height: 20px;
    }

    .Gcloud.line {
        line-height: 40px;
    }

    .Bcloud {
        width: 100px;
        height: 50px;
        position: absolute;
        padding-top: 20px;
        top: 40px;
        left: 95px;
        background: url(static/images/blueCloud.png) no-repeat center / 100% 99%;
        background-origin: padding-box;
        text-align: center;
        line-height: 20px;
    }

    .operatingDiv {
        width: 100%;
        display: flex;
        position: relative;
        border-bottom: 1px solid #0d6efd;
        text-align: center;
    }

    .operatingDiv > span {
        font-size: 1.3rem;
        width: 33.3%;
    }

    .operatingDiv > p {
        color: #0d6efd;
        font-size: 1.4rem;
        width: 33.3%;
        margin: 0;
        text-align: left;
    }

    .operatingDiv > div {
        width: 33.3%;
        background-color: #0d6efd;
        height: 80%;
        color: #fff;
    }

    .topDash-l {
        display: flex;
        width: 33.3%;
        position: relative;
    }

    .topDash-l span {
        width: 100px;
        margin: auto;
        font-weight: bold;
    }

    .topDash-l p {
        width: 50%;
        display: inline-block;
        margin: auto;
        font-size: 1.2rem;
    }

    .topDash-l:nth-child(1) > p {
        color: #0d6efd;
    }

    .topDash-l:nth-child(4) > p {
        padding-left: 10px;
        color: #0440a3;
    }

    .topDash-r {
        display: flex;
        width: 33.3%;
        position: relative;
        padding: 0 15px;
    }

    .topDash-r span {
        width: 100px;
        margin: auto;
        font-weight: bold;
    }

    .topDash-r p {
        width: 40%;
        display: inline-block;
        margin: auto;
        font-size: 1.2rem;
        text-align: center;
    }

    .topDash-r:nth-child(2) > p {
        color: #DB510B;
    }


    @media all and (max-width: 1399px) and (min-width: 1001px) {
        .m-size {height: 200px;}
        .emoji {width: 60px; height: 60px; top:1rem;}
        #legal_standard_text_A, #company_standard_text_A, #management_standard_text_A {font-size: 1.5rem;}
        #legal_standard_text_B, #company_standard_text_B, #management_standard_text_B {font-size: 1rem;}
        .remove-m {margin: 0 !important;}
    }

    @media all and (max-width: 1000px) {
        .standardDiv span{
            font-size: 0.75rem;
        }

        .emoji {
            width: 65px !important;
            height: 65px !important;
            position: relative;
            top: 0.75rem;
            margin-left: 0.25rem;
        }
        .mb-0{
            padding-top: 1rem;
            font-size: 1rem;
        }
        .fs-6{
            padding-top: 0.45rem;
            padding-left: 0.25rem;
        }

        .row table tr{
            margin: auto;
            font-size: 0.8rem;
        }
        .svg-inline--fa{
            font-size: 0.6rem;
        }
        .text-end {
            font-size: 0.25rem;
        }
        #legal_standard_text_A, #company_standard_text_A, #management_standard_text_A {font-size: 1.5rem;}
        #legal_standard_text_B, #company_standard_text_B, #management_standard_text_B {font-size: 1rem;}
        .remove-m {margin: 0 !important;}
    }

    .bg-lightBlue{
        background-color: #EDF2F8;
    }

</style>

<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<script src="static/js/sweetalert2.min.js"></script>
<div class="container"  id="container">
    <div class="row m-3 mt-3">
        <div class="col">
            <span class="fs-4 flashToggle fw-bold">모니터링 > 실시간 모니터링</span>
        </div>
        <div class="col text-end align-self-end">
            <div style="font-size: 1rem">
                <audio id="audio" autoplay="autoplay" loop><source src="static/audio/alarm.mp3" type="audio/mp3"></audio>
                <div id="alarmAudio"></div>
                <span>알림음 :</span>
                <input class="ms-2" type="radio" name="alarmTone" value="on" id="alarmOn" checked><label class="ms-2" for="alarmOn"> On&nbsp;</label>
                <input type="radio" name="alarmTone" value="off" id="alarmOff"><label class="ms-2" for="alarmOff"> Off&emsp;</label>
                <span>|&emsp;점멸효과 :</span>
                <input class="ms-2" type="radio" name="flashing" value="on" id="checkOn" checked><label class="ms-2" for="checkOn"> On&nbsp;</label>
                <input type="radio" name="flashing" value="off" id="checkOff"><label class="ms-2" for="checkOff"> Off</label>
            </div>
            <span class="text-primary small" style="font-size: 0.8rem"> * 실시간으로 업데이트됩니다.</span>
        </div>
    </div>
    <%-- 상단 대시보드 --%>
    <div class="row m-3 mt-3 bg-light" style="padding: 5px 0px 10px;">
        <div style="width: 50%; display: flex; flex-wrap: wrap; border-right: 1px solid #0d6efd;">
            <div class="operatingDiv bg-lightBlue p-1">
                <span class="fw-bold">가동률</span>
                <p id="sensorStatusP" class="text-center">100%</p>
                <div id="operating" class="align-self-center bg-white text-dark">4 / 4</div>
            </div>
            <div style="width: 100%; display: flex; padding: 0 25px; margin-top: 5px;">
                <div class="topDash-l">
                    <span onmouseover="$('#normal').css('display','block')" onmouseout="$('#normal').css('display','none')">정상</span>
                    <p id="statusOn" class="text-success">100%</p>
                    <div class="Gcloud" id="normal" style="display: none">모니터링 ON 되어있고, 정상적으로 데이터가 통신되고 있는 상태</div>
                </div>
                <div class="topDash-l">
                    <span onmouseover="$('#failure').css('display','block')" onmouseout="$('#failure').css('display','none')">통신불량</span>
                    <p id="statusOff" class="text-danger">0%</p>
                    <div class="Gcloud" id="failure" style="display: none">센서 데이터가 5분이상 통신되고 있지 않은 상태</div>
                </div>
                <div class="topDash-l text-center">
                    <span onmouseover="$('#off').css('display','block')" onmouseout="$('#off').css('display','none')">모니터링 OFF</span>
                    <p id="monitoringOff">100%</p>
                    <div class="Gcloud line" id="off" style="display: none">모니터링 OFF 설정 되어있는 상태</div>
                </div>
            </div>
        </div>
        <div style="width: 50%; height: 60px; display: flex; margin: auto 0;">
            <div class="topDash-r">
                <span>법적기준 초과</span>
                <p id="legal_standard_text_A" class="text-danger" onmouseover="$('#legal').css('display','block')" onmouseout="$('#legal').css('display','none')">0</p>
<%--                <div class="Bcloud legal_standard_text_B" id="legal" style="display: none">4 / 4</div>--%>
            </div>
            <div class="topDash-r">
                <span>사내기준 초과</span>
                <p id="company_standard_text_A" onmouseover="$('#company').css('display','block')" onmouseout="$('#company').css('display','none')">0</p>
<%--                <div class="Bcloud company_standard_text_B" id="company" style="display: none">4 / 4</div>--%>
            </div>
            <div class="topDash-r">
                <span>관리기준 초과</span>
                <p id="management_standard_text_A" class="text-success" onmouseover="$('#management').css('display','block')" onmouseout="$('#management').css('display','none')">0</p>
<%--                <div class="Bcloud management_standard_text_B" id="management" style="display: none">4 / 4</div>--%>
            </div>
        </div>
    </div>
    <%-- //상단 대시보드 --%>

    <%-- 하단 모니터링 On인 측정소의 센서 테이블 --%>
    <div class="row m-3 mt-3 bg-light">
        <div style="margin-top: 12px;">
            <div class="col text-center border">
                <div class="row p-3">
                    <div class="col">
                        <span class="small fw-bold"><i class="fas fa-sort-up fa-fw" style="color: red"></i>직전 데이터보다 높아진 경우</span>
                    </div>
                    <div class="col">
                        <span class="small fw-bold"><i class="fas fa-sort-down fa-fw" style="color: blue"></i>직전 데이터보다 낮아진 경우</span>
                    </div>
                    <div class="col">
                        <span class="small fw-bold"> <b> - </b> 직전 데이터와 같은 경우</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="row table" id="place_table" style="margin: 0 auto">
        <c:if test="${!empty placeInfo}">
        <c:forEach items="${placeInfo}" var="place" varStatus="pStatus">
         <c:choose>
            <%-- 모니터링 True 측정소의 개수에 따라 유동적 크기 변환(1개일때 100%, 2개이상일때 50%) --%>
            <c:when test="${fn:length(placeInfo) eq 1}">
            <div class="col-md-12 mb-3 mt-2 place_border ${pStatus}">
            </c:when>
            <c:otherwise>
            <div class="col-md-6 mb-3 mt-2 place_border ${pStatus}">
            </c:otherwise>
         </c:choose>
            <div class='m-2 text-center' style='background-color: #0d6efd; color: #fff;'>
                <span class='fs-5' id="placeName"><c:out value="${place.place}"/></span>
            </div>
            <c:forEach items="${place.data}" var="sensor" varStatus="sStatus">
            <c:set value="${pStatus.index}-${sStatus.index}" var="idx"/>
                <div class='text-end' style='font-size: 0.8rem'>
                업데이트 :<span id='update-${sStatus.index}'><c:out value="${sensor.recent_up_time}"/></span></div>
            <table class="table table-bordered table-hover text-center mt-1">
            <c:choose>
                <c:when test="${sensor.standardExistStatus == false}">
                <thead>
                    <tr class="add-bg-color">
                        <th width=22%'>항목</th>
                        <th width=26%'>실시간</th>
                        <th width=26%'>5분</th>
                        <th width=26%'>30분</th>
                    </tr>
                </thead>
                </c:when>
                <c:when test="${sensor.standardExistStatus == true}">
                <thead>
                    <tr class="add-bg-color">
                        <th width=22%'>항목</th>
                        <th width=10%'>법적기준</th>
                        <th width=10%'>사내기준</th>
                        <th width=10%'>관리기준</th>
                        <th width=16%'>실시간</th>
                        <th width=16%'>5분</th>
                        <th width=16%'>30분</th>
                    </tr>
                </thead>
                </c:when>
            </c:choose>
                <tbody id="sensor-table-${idx}">
                <tr>
                    <td>${sensor.naming}<input type="hidden" value="${sensor.name}"> </td>
                <c:choose>
                    <c:when test="${sensor.managementStandard eq 999999 && sensor.companyStandard eq 999999 && sensor.legalStandard eq 999999}">
                    </c:when>
                    <c:otherwise>
                        <td><div class="bg-danger text-light">
                           <c:choose>
                                <c:when test="${sensor.legalStandard eq 999999}">
                                    -
                                </c:when>
                                <c:when test="${sensor.legalStandard ne 999999}">
                                    <c:out value="${sensor.legalStandard}"/>
                                </c:when>
                            </c:choose>
                        </div></td>
                        <td><div class="bg-warning text-light">
                            <c:choose>
                                <c:when test="${sensor.companyStandard eq 999999}">
                                    -
                                </c:when>
                                <c:when test="${sensor.companyStandard ne 999999}">
                                    <c:out value="${sensor.companyStandard}"/>
                                </c:when>
                            </c:choose>
                        </div></td>
                        <td><div class="bg-success text-light">
                            <c:choose>
                                <c:when test="${sensor.managementStandard eq 999999}">
                                    -
                                </c:when>
                                <c:when test="${sensor.managementStandard ne 999999}">
                                    <c:out value="${sensor.managementStandard}"/>
                                </c:when>
                            </c:choose>
                        </div></td>
                    </c:otherwise>
                </c:choose>
                <td>
                    <c:if test="${sensor.value ne 0}">
                        <c:choose>
                            <c:when test="${sensor.recent_beforeValue gt sensor.recent_value}">
                                <i class="fas fa-sort-down fa-fw" style="color: blue"></i><fmt:formatNumber value="${sensor.recent_value}" pattern=".00"/>
                            </c:when>
                            <c:when test="${sensor.recent_beforeValue lt sensor.recent_value}">
                                <i class="fas fa-sort-up fa-fw" style="color: red"></i><fmt:formatNumber value="${sensor.recent_value}" pattern=".00"/>
                            </c:when>
                            <c:when test="${sensor.recent_beforeValue eq sensor.recent_value}">
                                <span style="font-weight: bold">- </span><fmt:formatNumber value="${sensor.recent_value}" pattern=".00"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="${sensor.recent_value}" pattern=".00"/>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    <c:if test="${sensor.value eq 0}">
                        0.00
                    </c:if>
                </td>
                <td>
                    <c:if test="${sensor.rm05_value ne 0}">
                    <c:choose>
                        <c:when test="${sensor.rm05_beforeValue gt sensor.rm05_value}">
                            <i class="fas fa-sort-down fa-fw" style="color: blue"></i><fmt:formatNumber value="${sensor.rm05_value}" pattern=".00"/>
                        </c:when>
                        <c:when test="${sensor.rm05_beforeValue lt sensor.rm05_value}">
                            <i class="fas fa-sort-up fa-fw" style="color: red"></i><fmt:formatNumber value="${sensor.rm05_value}" pattern=".00"/>
                        </c:when>
                        <c:when test="${sensor.rm05_beforeValue eq sensor.rm05_value}">
                            <span style="font-weight: bold">- </span><fmt:formatNumber value="${sensor.rm05_value}" pattern=".00"/>
                        </c:when>
                        <c:otherwise>
                            <fmt:formatNumber value="${sensor.rm05_value}" pattern=".00"/>
                        </c:otherwise>
                    </c:choose>
                </c:if>
                    <c:if test="${sensor.rm05_value eq 0}">
                        0.00
                    </c:if>
                </td>
                <td>
                    <c:if test="${sensor.rm30_value ne 0}">
                        <c:choose>
                            <c:when test="${sensor.rm30_beforeValue gt sensor.rm30_value}">
                                <i class="fas fa-sort-down fa-fw" style="color: blue"></i><fmt:formatNumber value="${sensor.rm30_value}" pattern=".00"/>
                            </c:when>
                            <c:when test="${sensor.rm30_beforeValue lt sensor.rm30_value}">
                                <i class="fas fa-sort-up fa-fw" style="color: red"></i><fmt:formatNumber value="${sensor.rm30_value}" pattern=".00"/>
                            </c:when>
                            <c:when test="${sensor.rm30_beforeValue eq sensor.rm30_value}">
                                <span style="font-weight: bold">- </span><fmt:formatNumber value="${sensor.rm30_value}" pattern=".00"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="${sensor.rm30_value}" pattern=".00"/>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    <c:if test="${sensor.rm30_value eq 0}">
                        0.00
                    </c:if>
                </td>
                </tr>
                </tbody>
            </table>
            <div id="chart-${pStatus.index}-${sStatus.index}"></div>
            </c:forEach> <%-- //sensor--%>
         </div> <%-- //col-md-@ --%>
        </c:forEach> <%-- //place --%>
        </c:if> <%-- //!empty place --%>
        <c:if test="${empty placeInfo}">
            <div class="'col-md-12 mb-3 mt-2 place_border">
                <table class='table table-bordered table-hover text-center mt-1'>
                    <thead>
                    <tr class="add-bg-color">
                        <th width=28%'>항목</th>
                        <th width=17%'>법적기준</th>
                        <th width=17%'>사내기준</th>
                        <th width=17%'>관리기준</th>
                        <th width=21%'>실시간</th>
                    </tr>
                    </thead>
                    <tbody>
                    <td colspan=5">No data</td>
                    </tbody>
                </table>
            </div>
        </c:if>
</div> <%-- //row table --%>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    let INTERVAL; let flashCheck; let alarmCheck;
    var oldSensorList; var chart = {};
    $(document).ready(function () {
        <%--let placeData2 = ${sensor}; // 모니터링 True 인 측정소 리스트의 모니터링 True인 센서 데이터(최근,이전,기준값 등)--%>
        <%--draw_sensor_info(placeData2); //대시보드 생성--%>
        setTimeout(function () {
            getData();
        }, 0);
        // 페이지 로딩 후 1초뒤 실시간 동기화
        flashCheck = "on"; //플래시 효과의 기본값 설정
        alarmCheck = "on";
    });

    /**
     * 페이지 로딩시 측정소 별로 테이블 틀 생성, 측정소 별, 센서별 데이터를 받아 대시보드, 테이블 데이터 입력
     */
    function getData() {
        setTimeout(function interval_getData() { // 반복 처리를 위한 setTimeout
            const placeInfo = getPlaceInfo(); // 모니터링 On된 측정소의 모든 정보(센서의 최근, 5분, 30분, 기준값 등)
            const placeCount = placeInfo.length;
            if(placeCount == 0){ // 측정소가 없을 때
                Swal.fire({icon: 'warning',title: '경고',text: '모니터링 설정된 측정소의 데이터가 없습니다.'});
                draw_place_table_frame(placeInfo);
                INTERVAL = setTimeout(interval_getData, 60000);
            }else{ //측정소가 있을 때
                var newSensorList = new Array();
                for (let i = 0; i < placeCount; i++) {
                    for(let z=0; z<placeInfo[i].sensorList.length; z++){
                        newSensorList.push(placeInfo[i].sensorList[z]);
                    }
                }
                for (let i = 0; i < placeCount; i++) {
                    clearTimeout(INTERVAL); // 실행중인 interval 있다면 삭제
                    if(oldSensorList == undefined){ //처음 페이지 로딩 시, 테이블, 차트 틀 생성
                        oldSensorList = newSensorList;
                        draw_place_table_frame(placeInfo); // 측정소별 테이블 틀 생성 (개수에 따른 유동적으로 크기 변환)
                        draw_place_table(placeInfo); // 측정소별 테이블 생성
                    }else{
                        var sensorCount = 0;
                        for(var x=0; x<newSensorList.length; x++) {
                            for (var y = 0; y < oldSensorList.length; y++) {
                                if (newSensorList[x] == oldSensorList[y]) {
                                    sensorCount += 1;
                                }
                            }
                        }
                        var dataChecking = false;
                        if(oldSensorList.length < newSensorList.length && newSensorList.length != sensorCount){
                            dataChecking = true;
                        }else if(oldSensorList.length > newSensorList.length && oldSensorList.length != sensorCount){
                            dataChecking = true;
                        }else if(oldSensorList.length ==newSensorList.length && newSensorList.length != sensorCount){
                            dataChecking = true;
                        }
                       if(dataChecking){
                            oldSensorList = newSensorList;
                            draw_place_table_frame(placeInfo); // 측정소별 테이블 틀 생성 (개수에 따른 유동적으로 크기 변환)
                            draw_place_table(placeInfo); // 측정소별 테이블 생성
                        }else{
                            draw_place_table(placeInfo); // 측정소별 테이블 생성
                        }
                    }
                    INTERVAL = setTimeout(interval_getData, 5000);
                }
            }
            setTimeout(function () {
                draw_sensor_info(placeInfo); // 대시보드 생성(가동률, 법적기준 정보 등)
            }, 0);
        }, 0);
    }

    /**
     *  센서명 클릭 이벤트 (해당 센서 차트)
     */
    $("#place_table").on('click', 'tbody tr', function () {
        <%--location.replace("<%=cp%>/sensor?sensor=" + sensorName);--%>
        var tbodyId = $(this).parent('tbody').attr('id');
        const sensorName = $(this).find('td input')[0].value;
        var chartIndex = tbodyId.substr(13,5);
        var sensorDataList = getSensor(sensorName, 10);
        var recentData;
        var sensorDataLength = sensorDataList.length;
        var realTime = {};
        if(sensorDataList.length == 0){
            if($('#chart-'+chartIndex)[0].innerHTML.length ==0){
               $('#chart-'+chartIndex).append("<p style='height: 50px; text-align:center; padding-top:12px; background-color: #e6e6e7'>최근 10분 데이터가 없습니다.</p>")
            }else{
                $('#chart-'+chartIndex).find('span').remove();
            }
        }else{
            if ($('#chart-'+chartIndex)[0].innerHTML.length ==0){
                draw_place_chart_frame(chartIndex);
                recentData = getSensorData(sensorName);
                updateChart(sensorDataList, recentData, chartIndex);
                setTimeout(function realTime() {
                    if($('#chart-'+chartIndex)[0].childNodes[0] != undefined){
                        var update = $('#update-'+chartIndex)[0].innerText;
                        var columnCount = $('#sensor-table-'+chartIndex).find('td').length;
                        var recentValue;
                        if(columnCount == 4){
                            recentValue = $('#sensor-table-'+chartIndex).find('td')[1].innerText;
                        }else if(columnCount == 7){
                            recentValue = $('#sensor-table-'+chartIndex).find('td')[4].innerText;
                        }
                        if(recentValue.indexOf("-") !== -1){
                            recentValue = recentValue.substr(2);
                        }
                        // recentData = getSensorData(sensorName);
                        if(sensorDataList.length != 0){
                            if(sensorDataList[sensorDataLength-1].x != update){
                                sensorDataList.push({x: update, y: recentValue});
                            }
                            updateChart(sensorDataList, recentData, chartIndex);
                            if(sensorDataList.length > sensorDataLength*2){
                                sensorDataList = getSensor(sensorName, 10);
                            }
                        }
                        realTime['chart-'+chartIndex] = setTimeout(realTime, 5000);
                    }
                }, 0);
            }else{
                clearTimeout(realTime['chart-'+chartIndex]);
                chart['chart-'+chartIndex].destroy();
            }
        }

    });


    /**
     * 알림음
     */
    function alarmTone(onOff) {
        if(onOff == 'on'){
            document.getElementById("audio").muted = false;// 소리 켜기
        }else{
            document.getElementById("audio").muted = true;// 소리 끄기
        }
    }

    /**
     *  점멸 효과
     */
    function flashing(onOff, bg) {
        const element = $("body");
        if(onOff == 'on' && bg != null){
            if(typeof flIn1 !== "undefined"){
                clearTimeout(flIn1);
            }
            setTimeout(function flashInterval() {
                setTimeout(function () {
                    element.removeClass("bg-lightBlue");
                    element.addClass(bg);
                }, 0);
                setTimeout(function () {
                    element.removeClass(bg);
                    element.addClass("bg-lightBlue");
                }, 400); //0.4초 숨김
                flIn1 = setTimeout(flashInterval, 1000); //0.6초 보여줌
            }, 0)
        }else{
            if(typeof flIn1 !== "undefined"){
                clearTimeout(flIn1);
            }
        }
    }

    function draw_place_chart_frame(index) {
                chart['chart-'+index] = new ApexCharts(document.querySelector("#chart-"+index), setChartOption());
                chart['chart-'+index].render();
                // $('#chart-'+i+'-'+z).hide();
    }

    /**
     * 측정소의 갯수에 따라 테이블 틀 생성 (홀수 : 테이블 1개, 짝수: 테이블 2개 씩 출력)
     */
    function draw_place_table_frame(placeInfo) {
        $('#place_table').empty();
        var col_md_size;
        if(placeInfo.length != 0){
            for(let i=0; i<placeInfo.length; i++){
                var placeName = placeInfo[i].place; //측정소명
                var dataLength = placeInfo[i].monitoringOn; //모니터링On된 센서수
                var data = placeInfo[i].data; //모니터링On된 센서수
                if(placeInfo.length==1){ // 측정소 1개 width 100%
                    col_md_size = 12;
                }else { // 측정소 1개 width 50%
                    col_md_size = 6;
                }
                /* 기준 값 유무에 따라 split */
                $('#place_table').append(
                    "<div class='col-md-"+col_md_size+" mb-3 mt-2 place_border "+i+"'>" +
                    "<div class='m-2 text-center' style='background-color: #0d6efd; color: #fff;'>" +
                    "<span class='fs-5' id='placeName'>"+placeName+"</span></div>");
                for(var z=0; z<dataLength;z++){
                    var standardExistStatus = data[z].standardExistStatus;
                    if(!standardExistStatus){
                        $('.'+i).append( //i:측정소idx z:센서idx
                            "<div class='text-end' style='font-size: 0.8rem'>업데이트 :<span id=update-"+i+"-"+z+">"+"</span></div>"+
                            "<table class='table table-bordered table-hover text-center mt-1'>" +
                            "<thead>" +
                            "<tr class='add-bg-color'>" +
                            "<th width=22%'>항목</th>" +
                            "<th width=26%'>실시간</th>" +
                            "<th width=26%'>5분</th>" +
                            "<th width=26%'>30분</th>" +
                            "</tr>" +
                            "</thead>"+
                            "<tbody id='sensor-table-"+i+"-"+z+"'>"+
                            "<tr>" +
                            "<td colspan='2'></td>" +
                            "</tr>" +
                            "</tbody>" +
                            "</table>" +
                            "<div id='chart-"+i+"-"+z+"'></div>"+
                            "</div>");
                    }else{
                        $('.'+i).append(
                            "<div class='text-end' style='font-size: 0.8rem'>업데이트 :<span id=update-"+i+"-"+z+">"+"</span></div>"+
                            "<table class='table table-bordered table-hover text-center mt-1'>" +
                            "<thead>" +
                            "<tr class='add-bg-color'>" +
                            "<th width=22%'>항목</th>" +
                            "<th width=10%'>법적기준</th>" +
                            "<th width=10%'>사내기준</th>" +
                            "<th width=10%'>관리기준</th>" +
                            "<th width=16%'>실시간</th>" +
                            "<th width=16%'>5분</th>" +
                            "<th width=16%'>30분</th>" +
                            "</tr>" +
                            "</thead>"+
                            "<tbody id='sensor-table-"+i+"-"+z+"'>"+
                            "<tr>" +
                            "<td colspan='4'></td>" +
                            "</tr>" +
                            "</tbody>" +
                            "</table>" +
                            "<div id='chart-"+i+"-"+z+"'></div>"+
                            "</div>");
                    }
                }
            }
        }else{
            $('#place_table').append(
                "<div class='col-md-12 mb-3 mt-2 place_border'>" +
                "<table class='table table-bordered table-hover text-center mt-1'>" +
                "<thead>" +
                "<tr class='add-bg-color'>" +
                "<th width=28%'>항목</th>" +
                "<th width=17%'>법적기준</th>" +
                "<th width=17%'>사내기준</th>" +
                "<th width=17%'>관리기준</th>" +
                "<th width=21%'>실시간</th>" +
                "</tr>" +
                "</thead>"+
                "<tbody>"+
                "<tr>" +
                "<td colspan='5'>No data</td>" +
                "</tr>" +
                "</tbody>" +
                "</table>" +
                "</div>");
        }
    }


    /**
     * 측정소 테이블 생성
     */
    function draw_place_table(placeInfo) {
        var placeCount = placeInfo.length;
        if(placeCount != 0) {
            for (var i = 0; i < placeCount; i++) {
                var data = placeInfo[i].data;
                var dataCount = data.length;
                if(dataCount != 0){
                    for (let z = 0; z < dataCount; z++) {
                        var unit;
                        var recentData = data[z];
                        var standarExistStatus = data[z].standardExistStatus;
                        $('#sensor-table-' + i + '-' + z).empty();
                        const tbody = document.getElementById('sensor-table-' + i + '-' + z);
                        /* 기준 값 유무에 따라 split */
                        const newRow = tbody.insertRow(tbody.rows.length);
                        $("#update-"+i+'-'+z).text(moment(data[z].recent_up_time).format('YYYY-MM-DD HH:mm:ss'));
                        if(data[z].unit != ""){
                            unit = "("+data[z].unit + ")";
                        }else{
                            unit = "";
                        }
                        if(!standarExistStatus){
                            const newCeil0 = newRow.insertCell(0);
                            const newCeil1 = newRow.insertCell(1);
                            const newCeil2 = newRow.insertCell(2);
                            const newCeil3 = newRow.insertCell(3);
                            newCeil0.innerHTML = data[z].naming+unit+'<input type="hidden" value='+data[z].name+'>';
                            newCeil1.innerHTML = draw_compareData(data[z].recent_beforeValue, data[z].recent_value);
                            newCeil2.innerHTML = draw_compareData(data[z].rm05_beforeValue, data[z].rm05_value);
                            newCeil3.innerHTML = draw_compareData(data[z].rm30_beforeValue, data[z].rm30_value);
                        }else{
                            const newCeil0 = newRow.insertCell(0);
                            const newCeil1 = newRow.insertCell(1);
                            const newCeil2 = newRow.insertCell(2);
                            const newCeil3 = newRow.insertCell(3);
                            const newCeil4 = newRow.insertCell(4);
                            const newCeil5 = newRow.insertCell(5);
                            const newCeil6 = newRow.insertCell(6);

                            if(data[z].legalStandard == 999999){
                                legalStandard = '-';
                            }else{
                                legalStandard = data[z].legalStandard;
                            }
                            if(data[z].companyStandard == 999999){
                                companyStandard = '-';
                            }else{
                                companyStandard = data[z].companyStandard;
                            }
                            if(data[z].managementStandard == 999999){
                                managementStandard = '-';
                            }else{
                                managementStandard = data[z].managementStandard;
                            }
                            newCeil0.innerHTML = data[z].naming+'<input type="hidden" value='+data[z].name+'>';
                            newCeil1.innerHTML = '<div class="bg-danger text-light">'+legalStandard+'</div>';
                            newCeil2.innerHTML = '<div class="bg-warning text-light">'+companyStandard+'</div>';
                            newCeil3.innerHTML = '<div class="bg-success text-light">'+managementStandard+'</div>';
                            newCeil4.innerHTML = draw_compareData(data[z].recent_beforeValue, data[z].recent_value);
                            newCeil5.innerHTML = draw_compareData(data[z].rm05_beforeValue, data[z].rm05_value);
                            newCeil6.innerHTML = draw_compareData(data[z].rm30_beforeValue, data[z].rm30_value);
                        }
                        }
                    }
                }
            }
    }

    function noData() {
        const tbody = document.getElementsByTagName('tbody');
        const newRow = tbody.insertRow(tbody.rows);
        const newCeil0 = newRow.insertCell();
        newCeil0.innerHTML = '<div onclick='+'window.event.cancelBubble=true'+'>'+'모니터링 설정된 센서의 데이터가 없습니다.'
            +'</div>';
        newCeil0.colSpan = 5;
    }

    /**
     * 직전값 현재값 비교하여 UP/DOWN 현재값 리턴
     */
    function draw_compareData(beforeData , nowData){
        beforeData = beforeData.toFixed(2);
        nowData = nowData.toFixed(2);
        if(beforeData > nowData ){
            return '<i class="fas fa-sort-down fa-fw" style="color: blue"></i>'+nowData;
        } else if( nowData > beforeData ) {
            return '<i class="fas fa-sort-up fa-fw" style="color: red"></i>'+nowData;
        } else if( nowData == beforeData ){
            return '<span style="font-weight: bold">- </span>' +nowData;
        } else{
            return nowData;
        }
    }

    /**
     *  대시보드 생성 (가동률, 통신 상태, 기준값 등)
     */
    function draw_sensor_info(placeInfo) {
        var placeCount = placeInfo.length;
        var sensorMonitoringOn=0, allMonitoringOFF=0,
            sensorStatusSuccess=0, sensorStatusFail=0,
            legalSCount=0, companySCount=0, managementSCount=0,
            notexistLegalStandard=0, notexistCompanyStandard=0, notexistManagementStandard=0;

        allMonitoringOFF = placeInfo[0].allMonitoringOFF;
        for(var i=0; i<placeCount; i++){ //측정소별
            var data = placeInfo[i].data;
            var dataCount = data.length;
            sensorMonitoringOn += placeInfo[i].monitoringOn;
            for(var z=0; z<dataCount; z++){ //측정소의 센서별 조회
                var sensorData = data[z];
                    value = sensorData.recent_value;
                    legalStandard = sensorData.legalStandard;
                    companyStandard = sensorData.companyStandard;
                    managementStandard = sensorData.managementStandard;
                    if(compareTime(sensorData.recent_up_time)){ // 최근데이터가 5분 이내 일때, 통신 정상, 알림음, 점멸효과
                        sensorStatusSuccess +=1;
                        if(legalStandard == 999999){
                            notexistLegalStandard += 1;
                        }
                        if(companyStandard == 999999){
                            notexistCompanyStandard += 1;
                        }
                        if(managementStandard == 999999){
                            notexistManagementStandard += 1;
                        }
                        if(value > legalStandard){
                            legalSCount +=1;
                        }else if(value > companyStandard){
                            companySCount +=1;
                        }else if(value > managementStandard){
                            managementSCount +=1;
                        }
                    }else{ // 최근데이터가 5분 이외일 때, 통신불량 처리
                        sensorStatusFail += 1;
                    }

            }
        }
        if(legalSCount > 0 ){
            flashing(flashCheck, "bg-danger");
            alarmTone('on');
        }else if(companySCount > 0){
            flashing(flashCheck, "bg-warning");
            alarmTone('on');
        }else if(managementSCount > 0){
            flashing(flashCheck, "bg-success");
            alarmTone('on');
        }else{
            flashing(flashCheck, null);
            alarmTone('off');
        }
        var runPercent = ((sensorStatusSuccess / (sensorStatusSuccess + sensorStatusFail)).toFixed(2) * 100).toFixed(0); //가동률(통신상태 기반)
        var run = sensorStatusSuccess + " / " + (sensorStatusSuccess + sensorStatusFail);
        // var legalPercent = ((legalSCount / (sensorStatusSuccess - notexistLegalStandard)) * 100).toFixed(0); //법적기준 %
        // var companyPercent = ((companySCount / (sensorStatusSuccess - notexistCompanyStandard)) * 100).toFixed(0); //사내기준 %
        // var managementPercent = ((managementSCount / (sensorStatusSuccess - notexistCompanyStandard)) * 100).toFixed(0); ////관리기준 %

        /* NaN 처리 */
        if(runPercent == 'NaN'){ runPercent = 0; }
        // if(legalPercent == 'NaN'){ legalPercent = 0; }
        // if(companyPercent == 'NaN'){ companyPercent = 0; }
        // if(managementPercent == 'NaN'){ managementPercent = 0;}

        $("#sensorStatusP").text(runPercent + "%"); //가동률
        $("#operating").text(run); // 통신정상/전체
        $("#statusOn").text(sensorStatusSuccess); //정상
        $("#statusOff").text(sensorStatusFail); //통신불량
        $("#monitoringOff").text(allMonitoringOFF); //모니터링OFF 개수
        $("#legal_standard_text_A").text(legalSCount); //법적기준 Over
        // $(".legal_standard_text_B").text(legalSCount + " / " + (sensorStatusSuccess - notexistLegalStandard)); //법적기준 Over 개수/전체
        $("#company_standard_text_A").text(companySCount); //사내기준 Over
        // $(".company_standard_text_B").text(companySCount + " / " + (sensorStatusSuccess - notexistCompanyStandard)); //사내기준 Over 개수/전체
        $("#management_standard_text_A").text(managementSCount); //관리기준 Over
        // $(".management_standard_text_B").text(managementSCount + " / " + (sensorStatusSuccess - notexistManagementStandard)); //관리기준 Over 개수/전체
    }

    /**
     * 현재시간과 비교하여 5분이내면 true, 외외면 false
     */
    function compareTime(dateTime){
        var dt = new Date(dateTime);
        var now = new Date();
        var diffTime = (now.getTime()-dt.getTime())/1000/60;
        if (diffTime <= 5){ //5분 차이
            return true;
        }else{
            return false;
        }
    }

    /**
     * 알림음 On / Off 이벤트
     */
    document.querySelector('input[name="alarmTone"]:checked').value;
    $('input:radio[name=alarmTone]').click(function () {
        if($('input:radio[name=alarmTone]:checked').val() == 'on'){
            alarmCheck = "on";
        }else{
            alarmCheck = "off";
            if(typeof flIn2 !== "undefined")
                clearTimeout(flIn2);
        }
    });
    /**
     * 점멸 효과 On / Off 이벤트
     */
    document.querySelector('input[name="flashing"]:checked').value;
    $('input:radio[name=flashing]').click(function () {
        if($('input:radio[name=flashing]:checked').val() == 'on'){
            flashCheck = "on";
        }else{
            flashCheck = "off";
            if(typeof flIn1 !== "undefined")
                clearTimeout(flIn1);
        }
    });

    /**
     * 차트 기본 옵션
     */
    function setChartOption(){
        options = {
            series: [{
                data: [],
            }],
            chart: {
                height: '200px',
                type: 'line',
                animations: {
                    enabled: true,
                    easing: 'linear',
                    dynamicAnimation: {
                        enabled: true,
                        speed: 500
                    }
                },
                toolbar: {
                    show: false,
                    tools: {
                        download: false,
                        selection: false,
                        zoom: false,
                        zoomin: false,
                        zoomout: false,
                        pan: false,
                        reset: false,
                    },
                }
            },
            colors: ['#629cf4'],
            markers: { //점
                size: 1,
                strokeWidth:1,
                shape: "circle",
                radius: 0,
                colors: ["#629cf4"],
                hover: {
                    size: 5,
                }
            },
            tooltip:{
                enbaled: true,
                x: {
                    show: true,
                    format: 'HH:mm:ss',
                    // formatter: undefined,
                },
            },
            stroke: {
                show: true,
                width: 3
            },
            dataLabels: {
                enabled: true,
                textAnchor: 'middle',
                style: { //데이터 배경
                    fontSize: '11px',
                },
                background: { //데이터 글자
                    enabled: true,
                    foreColor: 'black',
                    // padding: 1,
                    // borderRadius: 1,
                    // borderWidth: 0.3,
                    // borderColor: 'green',
                    opacity: 0,
                },
            },
            xaxis: {
                type: 'datetime',
                labels: {
                    show: true,
                    datetimeUTC: false,
                    datetimeFormatter: {
                        year: 'yyyy년',
                        month: 'MM월',
                        day: 'dd일',
                        hour: 'HH:mm:ss',
                    },
                },
            },
            yaxis:{
                labels: {
                    show: true,
                    formatter: function () {
                        return 'No data'
                    }
                },
            }
        };
        return options;
    }

    /**
     *  차트 업데이트
     */
    function updateChart(sensor_data_list, sensor_data, chartIndex){
        var arr =new Array();
        if(sensor_data_list.length != 0){
            for(var i in sensor_data_list){
                arr.push(sensor_data_list[i].y);
            }
            // var max = Math.max.apply(null, arr);
            // var min = Math.min.apply(null, arr);
            var max = arr.reduce(function (previousValue, currentValue) {
                return parseInt(previousValue > currentValue ? previousValue:currentValue);
            })
            var min = arr.reduce(function (previousValue, currentValue) {
                return parseInt(previousValue > currentValue ? currentValue:previousValue);
            })
            max = max+1;
            min = min-1;
        }else{
            sensor_data_list = [];
        }
        if(sensor_data.length != 0){
            managementStandard = sensor_data.managementStandard;
            companyStandard = sensor_data.companyStandard;
            legalStandard = sensor_data.legalStandard;
        }else{
            managementStandard = 999999;
            companyStandard = 999999;
            legalStandard = 999999;
        }
        chart['chart-'+chartIndex].updateOptions({
            series: [{
                name: sensor_data.naming,
                data: sensor_data_list.slice()
            }],
            annotations: {
                yaxis: [{
                    y: managementStandard,
                    label: {
                        borderColor: '#82e8b7',
                        style: {
                            color: '#fff',
                            background: '#82e8b7'
                        },
                        text: '관리기준',
                        position: 'left',
                        offsetX: 8
                    }
                },
                    {
                        y: companyStandard,
                        label: {
                            borderColor: '#ffd862',
                            style: {
                                color: '#fff',
                                background: '#ffd862'
                            },
                            text: '사내기준',
                            position: 'left',
                            offsetX: 8
                        }
                    },
                    {
                        y: legalStandard,
                        label: {
                            borderColor: '#ed969e',
                            style: {
                                color: '#fff',
                                background: '#ed969e'
                            },
                            text: '법적기준',
                            position: 'left',
                            offsetX: 8
                        }
                    }]
            },
            yaxis: {
                tickAmount: 2,
                decimalsInFloat: 2,
                min: min,
                max: max,
                labels: {
                    show: true,
                    formatter: function (val) {
                        if (sensor_data_list == null || sensor_data_list.length == 0)
                            return 'No data'
                        else
                            return val;
                    }
                }
            },
        })
    }


    /**
     * 모니터링On된 측정소, 센서 모든 정보 Get
     */
    function getPlaceInfo() {
        var getData = null;
        $.ajax({  //측정소의 센서명을 구함
            url: '<%=cp%>/placeInfo',
            dataType: 'json',
            async: false,
            success: function (data) {
                getData = data;
            },
            error: function () {
            }
        });
        return getData;
    }

    /**
     * 센서의 최근 1시간 / 24시간 데이터 리턴
     */
    function getSensor(sensor_name, min) {
        let result = new Array();
        if(sensor_name==undefined){
            return null;
        }else{
            $.ajax({
                url:'<%=cp%>/getSensor2',
                dataType: 'JSON',
                contentType: "application/json",
                data: {"sensor": sensor_name, "min": min},
                async: false,
                success: function (data) {
                    if(data.length != 0){
                        $.each(data, function (index, item) {
                            result.push({x: item.up_time, y: (item.value).toFixed(2)});
                        })
                    }else{
                        console.log("sensor_data is none")
                        // 조회 결과 없을 때 return [];
                        result = [];
                    }
                },
                error: function (e) {
                }
            });
        }
        return result;
    }

    /**
     * 센서의 모니터링 True인 최근, 직전, 기준 데이터 등을 리턴
     */
    function getSensorData(sensor) {
        let result = null;
        $.ajax({
            url:'<%=cp%>/getSensorData',
            dataType: 'JSON',
            data:  {"sensor": sensor},
            async: false,
            success: function (data) {
                result = data;
            },
            error: function (e) {
            }
        })
        return result;
    }

</script>