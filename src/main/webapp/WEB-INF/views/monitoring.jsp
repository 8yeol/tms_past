<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                <input class="ms-2" type="radio" name="alarmTone" value="on" id="checkOn" checked><label class="ms-2" for="checkOn"> On&nbsp;</label>
                <input type="radio" name="alarmTone" value="off" id="checkOff"><label class="ms-2" for="checkOff"> Off&nbsp;&nbsp;&nbsp;</label>
                <span>|&nbsp;&nbsp;&nbsp;점멸효과 :</span>
                <input class="ms-2" type="radio" name="flashing" value="on" id="checkOn" checked><label class="ms-2" for="checkOn"> On&nbsp;</label>
                <input type="radio" name="flashing" value="off" id="checkOff"><label class="ms-2" for="checkOff"> Off</label>
            </div>
            <span class="text-primary small" style="font-size: 0.8rem"> * 실시간으로 업데이트됩니다.</span>
        </div>
    </div>
    <%-- 상단 대시보드 --%>
    <div class="row m-3 mt-3">
        <div class="col bg-white fw-bold" style="margin-right: 5px; border-top-left-radius: 20px; border-top-right-radius: 20px;">
            <div class="row titleDiv" style="border-top-left-radius: 20px; border-top-right-radius: 20px; height: 38px;">
                <span class="fs-5 text-center" style="margin: 0 auto; line-height: 38px;">가동률</span>
            </div>
            <div class="row">
                <div class="col text-center" style="border-right: 1px solid #2295DB;">
                    <p class="fs-1" id="sensorStatusP" style="margin-top: 25px; margin-bottom: -3px"></p>
                    <hr style="margin: 0 30px 0;">
                    <p id="statusMore"></p>
                </div>

                <div class="col" style="padding: 0;" id="sensorStatus">
                    <div style="border-bottom: 1px solid #2295DB;">
                        <p>정상 : <a style="text-align: right" id="statusOn"></a></p>
                    </div>
                    <div style="border-bottom: 1px solid #2295DB;">
                        <p>통신불량 : <a style="text-align: right" id="statusOff"></a></p>
                    </div>
                    <div>
                        <p>모니터링 OFF : <a style="text-align: right" id="monitoringOff"></a></p>
                    </div>
                </div>
            </div>
        </div>

        <div class="col bg-white m-size" style="margin-left: 5px;border-top-left-radius: 20px;border-top-right-radius: 20px;">
            <div class="row standardParent" style="height: 38px">
                <div class="col fw-bold standardDiv" style="border-right: 2px solid white;">
                    <span>법적기준 초과</span>
                </div>
                <div class="col fw-bold standardDiv"style="border-right:2px solid white;">
                    <span>사내기준 초과</span>
                </div>
                <div class="col  fw-bold standardDiv">
                    <span>관리기준 초과</span>
                </div>
            </div>
            <div class="row">
                <%-- 법적 기준 --%>
                <div class="col standardImg" style="border-right: 2px solid #2295DB;">
                    <div class="row text-center" style="height: 155px;">
                        <div class="col">
                            <img src="static/images/sad.png" class="emoji">
                        </div>
                        <div class="col remove-m" style="margin-top: 3px;">
                            <p class="mb-0" id="legal_standard_text_A"></p>
                            <hr class="m-0">
                            <p id="legal_standard_text_B"></p>
                        </div>
                    </div>
                </div>
                <%-- 사내 기준 --%>
                <div class="col standardImg" style="border-right: 2px solid #2295DB;">
                    <div class="row text-center" style="height: 155px;">
                        <div class="col">
                            <img src="static/images/thinking.png" class="emoji">
                        </div>
                        <div class="col remove-m" style="margin-top: 5px;">
                            <p class="mb-0" id="company_standard_text_A"></p>
                            <hr class="m-0">
                            <p id="company_standard_text_B"></p>
                        </div>
                    </div>
                </div>
                <%-- 관리 기준 --%>
                <div class="col standardImg">
                    <div class="row text-center" style="height: 155px;">
                        <div class="col">
                            <img src="static/images/sceptic.png" class="emoji">
                        </div>
                        <div class="col remove-m" style="margin-top: 5px;">
                            <p class="mb-0" id="management_standard_text_A"></p>
                            <hr class="m-0">
                            <p id="management_standard_text_B"></p>
                        </div>
                    </div>
                </div>
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
            <c:if test="${!empty place}">
            <c:forEach items="${place}" var="placeName" varStatus="pStatus">
            <c:set value="${sensor[pStatus.index]}" var="sensorData"/>
            <c:choose>
                <%-- 모니터링 True 측정소의 개수에 따라 유동적 크기 변환(1개일때 100%, 2개이상일때 50%) --%>
                <c:when test="${fn:length(place) eq 1}">
            <div class="col-md-12 mb-3 mt-2 place_border ${pStatus}">
                </c:when>
                <c:otherwise>
            <div class="col-md-6 mb-3 mt-2 place_border ${pStatus}">
                </c:otherwise>
            </c:choose>
                <div class='m-2 text-center' style='background-color: #0d6efd; color: #fff;'>
                    <span class='fs-5' id="placeName"><c:out value="${placeName}"/></span>
                </div>
                <c:forEach items="${sensor}" var="sensorList" varStatus="status">
                    <c:forEach items="${sensorList}" var="sensorList2" varStatus="status2">
                        <c:if test="${sensorList2.place eq placeName}">
                            <c:set var="uptime" value="${sensorList2.up_time}"/>
                        </c:if>
                    </c:forEach>
                </c:forEach>

<%--                    <table class='table table-bordered table-hover text-center mt-1'>--%>
<%--                        <thead>--%>
<%--                        <tr class="add-bg-color">--%>
<%--                            <th width=28%'>항목</th>--%>
<%--                            <th width=17%'>법적기준</th>--%>
<%--                            <th width=17%'>사내기준</th>--%>
<%--                            <th width=17%'>관리기준</th>--%>
<%--                            <th width=21%'>실시간</th>--%>
<%--                        </tr>--%>
<%--                        </thead>--%>
<%--                        <tbody id="${tbody}">--%>
<%--                        <c:forEach items="${sensor}" var="sensorList" varStatus="status">--%>
<%--                            <c:forEach items="${sensorList}" var="sensorList2" varStatus="status2">--%>
<%--                                <tr>--%>
<%--                                    <c:if test="${sensorList2.place eq placeName}">--%>
<%--                                        <td>${sensorList2.naming}<input type="hidden" value="${sensorList2.name}"> </td>--%>
<%--                                        <td><div class="bg-danger text-light">--%>
<%--                                            <c:choose>--%>
<%--                                                <c:when test="${sensorList2.legalStandard eq 999999}">--%>
<%--                                                    ---%>
<%--                                                </c:when>--%>
<%--                                                <c:when test="${sensorList2.legalStandard ne 999999}">--%>
<%--                                                    <c:out value="${sensorList2.legalStandard}"/>--%>
<%--                                                </c:when>--%>
<%--                                            </c:choose>--%>
<%--                                        </div></td>--%>
<%--                                        <td><div class="bg-warning text-light">--%>
<%--                                            <c:choose>--%>
<%--                                                <c:when test="${sensorList2.companyStandard eq 999999}">--%>
<%--                                                    ---%>
<%--                                                </c:when>--%>
<%--                                                <c:when test="${sensorList2.companyStandard ne 999999}">--%>
<%--                                                    <c:out value="${sensorList2.companyStandard}"/>--%>
<%--                                                </c:when>--%>
<%--                                            </c:choose>--%>
<%--                                        </div></td>--%>
<%--                                        <td><div class="bg-success text-light">--%>
<%--                                            <c:choose>--%>
<%--                                                <c:when test="${sensorList2.managementStandard eq 999999}">--%>
<%--                                                    ---%>
<%--                                                </c:when>--%>
<%--                                                <c:when test="${sensorList2.managementStandard ne 999999}">--%>
<%--                                                    <c:out value="${sensorList2.managementStandard}"/>--%>
<%--                                                </c:when>--%>
<%--                                            </c:choose>--%>
<%--                                        </div></td>--%>
<%--                                        <td>--%>
<%--                                            <c:if test="${sensorList2.value != 0}">--%>
<%--                                                <c:if test="${sensorList2.beforeValue > sensorList2.value}">--%>
<%--                                                    <i class="fas fa-sort-down fa-fw" style="color: blue"></i><fmt:formatNumber value="${sensorList2.value}" pattern=".00"/>--%>
<%--                                                </c:if>--%>
<%--                                                <c:if test="${sensorList2.beforeValue < sensorList2.value}">--%>
<%--                                                    <i class="fas fa-sort-up fa-fw" style="color: red"></i><fmt:formatNumber value="${sensorList2.value}" pattern=".00"/>--%>
<%--                                                </c:if>--%>
<%--                                            </c:if>--%>
<%--                                            <c:if test="${sensorList2.value eq 0}">--%>
<%--                                                0.00--%>
<%--                                            </c:if>--%>
<%--                                        </td>--%>
<%--                                    </c:if>--%>
<%--                                </tr>--%>
<%--                            </c:forEach>--%>
<%--                        </c:forEach>--%>
<%--                        <c:if test="${fn:length(sensorData) == 0}">--%>
<%--                            <tr>--%>
<%--                                <td colspan="5">--%>
<%--                                    <div onclick="window.event.cancelBubble=true">모니터링 설정된 센서의 데이터가 없습니다.</div>--%>
<%--                                </td>--%>
<%--                            </tr>--%>
<%--                        </c:if>--%>
<%--                        </tbody>--%>
<%--                    </table>--%>
                    <%-- 기준 값 유무에 따라 split --%>
                    <c:set value="${pStatus.index}" var="index1"/>
                    <c:forEach items="${sensor}" var="sensorList" varStatus="status">
                        <c:forEach items="${sensorList}" var="sensorList2" varStatus="status2">
                            <c:set value="${index1}-${status2.index}" var="index2"/>
                    <c:if test="${sensorList2.place eq placeName}">
                    <div class='text-end' style='font-size: 0.8rem'>
                        업데이트 :<span id='update-${index2}'><c:if test="${fn:length(sensorData) > 0 }"><c:out value="${sensorList2.up_time}"/></c:if></div>
                    <table class='table table-bordered table-hover text-center mt-1'>
                    <c:choose>
                    <c:when test="${sensorList2.managementStandard eq 999999 && sensorList2.companyStandard eq 999999 && sensorList2.legalStandard eq 999999}">
                        <tr class="add-bg-color">
                            <th width=28%'>항목</th>
                            <th width=24%'>5분</th>
                            <th width=24%'>30분</th>
                            <th width=24%'>실시간</th>
                        </tr>
                    </thead>
                    </c:when>
                    <c:otherwise>
                    <thead>
                        <tr class="add-bg-color">
                            <th width=28%'>항목</th>
                            <th width=10%'>법적기준</th>
                            <th width=10%'>사내기준</th>
                            <th width=10%'>관리기준</th>
                            <th width=14%'>5분</th>
                            <th width=14%'>30분</th>
                            <th width=14%'>실시간</th>
                        </tr>
                    </c:otherwise>
                    </c:choose>
                        <tbody id="sensor-table-${index2}">
                        <tr>
                                <td>${sensorList2.naming}<input type="hidden" value="${sensorList2.name}"> </td>
                                <c:choose>
                                    <c:when test="${sensorList2.managementStandard eq 999999 && sensorList2.companyStandard eq 999999 && sensorList2.legalStandard eq 999999}">
                                    </c:when>
                                    <c:otherwise>
                                        <td><div class="bg-danger text-light">
                                           <c:choose>
                                                <c:when test="${sensorList2.legalStandard eq 999999}">
                                                    -
                                                </c:when>
                                                <c:when test="${sensorList2.legalStandard ne 999999}">
                                                    <c:out value="${sensorList2.legalStandard}"/>
                                                </c:when>
                                            </c:choose>
                                        </div></td>
                                        <td><div class="bg-warning text-light">
                                            <c:choose>
                                                <c:when test="${sensorList2.companyStandard eq 999999}">
                                                    -
                                                </c:when>
                                                <c:when test="${sensorList2.companyStandard ne 999999}">
                                                    <c:out value="${sensorList2.companyStandard}"/>
                                                </c:when>
                                            </c:choose>
                                        </div></td>
                                        <td><div class="bg-success text-light">
                                            <c:choose>
                                                <c:when test="${sensorList2.managementStandard eq 999999}">
                                                    -
                                                </c:when>
                                                <c:when test="${sensorList2.managementStandard ne 999999}">
                                                    <c:out value="${sensorList2.managementStandard}"/>
                                                </c:when>
                                            </c:choose>
                                        </div></td>
                                    </c:otherwise>
                                </c:choose>
                            <td>
                                <c:if test="${sensorList2.rm05_value ne 0}">
                                <c:choose>
                                    <c:when test="${sensorList2.rm05_beforeValue gt sensorList2.rm05_value}">
                                        <i class="fas fa-sort-down fa-fw" style="color: blue"></i><fmt:formatNumber value="${sensorList2.rm05_value}" pattern=".00"/>
                                    </c:when>
                                    <c:when test="${sensorList2.rm05_beforeValue lt sensorList2.rm05_value}">
                                        <i class="fas fa-sort-up fa-fw" style="color: red"></i><fmt:formatNumber value="${sensorList2.rm05_value}" pattern=".00"/>
                                    </c:when>
                                    <c:when test="${sensorList2.rm05_beforeValue eq sensorList2.rm05_value}">
                                        <span style="font-weight: bold">- </span><fmt:formatNumber value="${sensorList2.rm05_value}" pattern=".00"/>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${sensorList2.rm05_value}" pattern=".00"/>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                                <c:if test="${sensorList2.rm05_value eq 0}">
                                    0.00
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${sensorList2.rm30_value ne 0}">
                                    <c:choose>
                                        <c:when test="${sensorList2.rm30_beforeValue gt sensorList2.rm30_value}">
                                            <i class="fas fa-sort-down fa-fw" style="color: blue"></i><fmt:formatNumber value="${sensorList2.rm30_value}" pattern=".00"/>
                                        </c:when>
                                        <c:when test="${sensorList2.rm30_beforeValue lt sensorList2.rm30_value}">
                                            <i class="fas fa-sort-up fa-fw" style="color: red"></i><fmt:formatNumber value="${sensorList2.rm30_value}" pattern=".00"/>
                                        </c:when>
                                        <c:when test="${sensorList2.rm30_beforeValue eq sensorList2.rm30_value}">
                                            <span style="font-weight: bold">- </span><fmt:formatNumber value="${sensorList2.rm30_value}" pattern=".00"/>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${sensorList2.rm30_value}" pattern=".00"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <c:if test="${sensorList2.rm30_value eq 0}">
                                    0.00
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${sensorList2.value ne 0}">
                                    <c:choose>
                                        <c:when test="${sensorList2.beforeValue gt sensorList2.value}">
                                            <i class="fas fa-sort-down fa-fw" style="color: blue"></i><fmt:formatNumber value="${sensorList2.value}" pattern=".00"/>
                                        </c:when>
                                        <c:when test="${sensorList2.beforeValue lt sensorList2.value}">
                                            <i class="fas fa-sort-up fa-fw" style="color: red"></i><fmt:formatNumber value="${sensorList2.value}" pattern=".00"/>
                                        </c:when>
                                        <c:when test="${sensorList2.beforeValue eq sensorList2.value}">
                                            <span style="font-weight: bold">- </span><fmt:formatNumber value="${sensorList2.value}" pattern=".00"/>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${sensorList2.value}" pattern=".00"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <c:if test="${sensorList2.value eq 0}">
                                    0.00
                                </c:if>
                            </td>
                        </tr>
                        <div id="chart-${index2}"></div>
                    </c:if>
                    <c:if test="${fn:length(sensorData) == 0}">
                        <tr>
                            <td colspan="5">
                                <div onclick="window.event.cancelBubble=true">모니터링 설정된 센서의 데이터가 없습니다.</div>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                    </c:forEach>
                </c:forEach>
                <%-- //기준 값 유무에 따라 split --%>
            </div>
                </c:forEach>
                </c:if>
                <c:if test="${empty place}">
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
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    let INTERVAL; let flashCheck; let alarmCheck;
    var dataList; var chart = {};
    $(document).ready(function () {
        let placeData2 = ${sensor}; // 모니터링 True 인 측정소 리스트의 모니터링 True인 센서 데이터(최근,이전,기준값 등)
        draw_sensor_info(placeData2); //대시보드 생성
        setTimeout(function () {
            getData();
        }, 1000);
        // 페이지 로딩 후 1초뒤 실시간 동기화
        flashCheck = "on"; //플래시 효과의 기본값 설정
        alarmCheck = "on";
    });

    /**
     * 페이지 로딩시 측정소 별로 테이블 틀 생성, 측정소 별, 센서별 데이터를 받아 대시보드, 테이블 데이터 입력
     */
    function getData() {
        setTimeout(function interval_getData(placeName2) { // 반복 처리를 위한 setTimeout
            const placeName = getPlace(); // 전체 측정소명 리턴 받아 변수에 저장
            // draw_place_table_frame(placeName); // 측정소별 테이블 틀 생성 (개수에 따른 유동적으로 크기 변환)
            // const placeData = new Array();
                const placeData = new Array();
            if(placeName.length == 0){ // 측정소가 없을 때
                Swal.fire({icon: 'warning',title: '경고',text: '모니터링 설정된 측정소의 데이터가 없습니다.'});
                INTERVAL = setTimeout(interval_getData, 60000);
            }else{ //측정소가 있을 때
                var sensorDataNullCheck = true;
                for (let i = 0; i < placeName.length; i++) {
                    clearTimeout(INTERVAL); // 실행중인 interval 있다면 삭제
                    const data = getPlaceData(placeName[i]); //측정소 별 센서 데이터 (최근데이터, 이전데이터, 정보)
                    nSensorName = new Array(); // 페이지 로딩 후, 센서 저장
                    for(let z=0; z<data.length; z++){
                        nSensorName.push(data[z].name);
                    }
                    if(dataList == undefined){ //처음 페이지 로딩 시, 테이블, 차트 틀 생성
                        dataList = nSensorName;
                        // sensorDataList = getSensor2(placeName[i], 30);
                        draw_place_table_frame(placeName, data); // 측정소별 테이블 틀 생성 (개수에 따른 유동적으로 크기 변환)
                        // draw_place_chart_frame(placeName.length, data.length);
                    }else{ // 측정소, 센서 변경시 초기화, 테이블, 차트 틀 생성
                        // if(sensorDataList[z].length != 0) {
                        //     if (data[z].up_time > sensorDataList[z][sensorDataList[z].length - 1].x && sensorDataList[z][sensorDataList[z].length - 1].x != data[z].up_time) {
                        //         sensorDataList[z].push({y: data[z].value, x: data[z].up_time})
                        //     }
                        //     updateChart(sensorDataList[z], data[z], i, z); //차트 업데이트
                        //     if (sensorDataList[z].length > 800) { //차트 초기화
                        //         sensorDataList = getSensor2(placeName[i], 30);
                        //     }
                        // }
                    }
                    // for(var z=0; z<data.length; z++){ //최근 데이터의 시간 비교하여 업데이트
                    //     if(sensorDataList[z].length != 0){
                    //         dataLength = sensorDataList[z].length-1;
                    //         if(data[z].up_time > sensorDataList[z][dataLength].x && sensorDataList[z][dataLength].x != data[z].up_time){
                    //             sensorDataList[z].push({y:data[z].value, x:data[z].up_time})
                    //         }
                    //         updateChart(sensorDataList[z], data[z], i, z); //차트 업데이트
                            // if (sensorDataList[z].length > 800) { //차트 초기화
                            //     sensorDataList = getSensor2(placeName[i], 30);
                            // }
                        // }else{
                            //센서데이터리스트 없을때
                        // }
                    // }
                    draw_place_table(data, i); // 측정소별 테이블 생성
                    placeData.push(data); //측정소별 센서 데이터 통합
                    if(placeData[i].length != 0){
                        sensorDataNullCheck = false;
                    }
                    INTERVAL = setTimeout(interval_getData, 5000);
                }
                if(sensorDataNullCheck){
                    Swal.fire({icon: 'warning',title: '경고',text: '모니터링 설정된 센서의 데이터가 없습니다.'});
                }
            }
            setTimeout(function () {
                draw_sensor_info(placeData); // 대시보드 생성(가동률, 법적기준 정보 등)
            }, 0);
        }, 0);
    }

    /**
     *  센서명 클릭 이벤트 (해당센서의 상세페이지 이동)
     */
    $("#place_table").on('click', 'tbody tr', function () {
        const sensorName = $(this).find('td input')[0].value;
        location.replace("<%=cp%>/sensor?sensor=" + sensorName);
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

    /**
     * 전체 측정소명 리턴 (조건 : 모니터링 True)
     */
    function getPlace(){
        const placeName = new Array();
        $.ajax({
            url: '<%=cp%>/getPlaceList',
            dataType: 'json',
            async: false,
            success: function (data) {
                $.each(data, function (index, item) { //item (센서명)
                    monitoring = item.monitoring; //모니터링 True
                    if(monitoring){
                        placeName.push(item.name);
                    }
                })
            },
            error: function (request, status, error) {
            }
        });
        return placeName;
    }

    function draw_place_chart_frame(placeLength, dataLength) {
        if(placeName.length != 0) {
            for (let i = 0; i < placeLength; i++) {
                for(var z=0; z<dataLength;z++){
                    chart['chart-'+i+'-'+z] = new ApexCharts(document.querySelector("#chart-"+i+'-'+z), setChartOption());
                    chart['chart-'+i+'-'+z].render();
                }
            }
        }
    }
    /**
     * 측정소의 갯수에 따라 테이블 틀 생성 (홀수 : 테이블 1개, 짝수: 테이블 2개 씩 출력)
     */
    function draw_place_table_frame(placeName) {
        var col_md_size;
        $('#place_table').empty();
        if(placeName.length != 0){
            for(let i=0; i<placeName.length; i++){
                const data = getPlaceData(placeName[i]);
                if(placeName.length==1){ //1개
                    col_md_size = 12;
                }else {
                    col_md_size = 6;
                }
                /* 기준 값 유무에 따라 split */
                $('#place_table').append(
                    "<div class='col-md-"+col_md_size+" mb-3 mt-2 place_border "+i+"'>" +
                    "<div class='m-2 text-center' style='background-color: #0d6efd; color: #fff;'>" +
                    "<span class='fs-5' id='placeName'>"+placeName[i]+"</span></div>");
                for(var z=0; z<data.length;z++){
                    if(placeName[i] == data[z].place){
                        if(data[z].companyStandard==999999 && data[z].legalStandard==999999 && data[z].managementStandard==999999){
                            $('.'+i).append(
                                "<div class='text-end' style='font-size: 0.8rem'>업데이트 :<span id=update-"+i+"-"+z+">"+"</span></div>"+
                                "<table class='table table-bordered table-hover text-center mt-1'>" +
                                "<thead>" +
                                "<tr class='add-bg-color'>" +
                                "<th width=28%'>항목</th>" +
                                "<th width=24%'>5분</th>" +
                                "<th width=24%'>30분</th>" +
                                "<th width=24%'>실시간</th>" +
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
                                "<th width=28%'>항목</th>" +
                                "<th width=10%'>법적기준</th>" +
                                "<th width=10%'>사내기준</th>" +
                                "<th width=10%'>관리기준</th>" +
                                "<th width=14%'>5분</th>" +
                                "<th width=14%'>30분</th>" +
                                "<th width=14%'>실시간</th>" +
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
                /* //기준 값 유무에 따라 split */
                // $('#place_table').append(
                //     "<div class='col-md-"+col_md_size+" mb-3 mt-2 place_border'>" +
                //     "<div class='m-2 text-center' style='background-color: #0d6efd; color: #fff;'>" +
                //     "<span class='fs-5'>"+placeName[i]+"</span></div>" +
                //     "<div class='text-end' style='font-size: 0.8rem'>업데이트 :<span id=update-"+i+">"+"</span></div>" +
                //     "<table class='table table-bordered table-hover text-center mt-1'>" +
                //     "<thead>" +
                //     "<tr class='add-bg-color'>" +
                //     "<th width=28%'>항목</th>" +
                //     "<th width=17%'>법적기준</th>" +
                //     "<th width=17%'>사내기준</th>" +
                //     "<th width=17%'>관리기준</th>" +
                //     "<th width=21%'>실시간</th>" +
                //     "</tr>" +
                //     "</thead>"+
                //     "<tbody id='sensor-table-"+i+"'>"+
                //     "<tr>" +
                //     "<td colspan='4'></td>" +
                //     "</tr>" +
                //     "</tbody>" +
                //     "</table>" +
                //     "</div>");
            }
        }
    }

    /**
     * 센서의 모니터링 True인 최근, 직전, 기준 데이터 등을 리턴
     */
    function getPlaceData(place) {
        var getData = null;
        $.ajax({  //측정소의 센서명을 구함
            url: '<%=cp%>/getPlaceData',
            dataType: 'json',
            data: {"place": place},
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
     * 센서의 모니터링 상태값 리턴 (true , false)
     */
    function getMonitoring(sensor) {
        let result;
        $.ajax({
            url: '<%=cp%>/getMonitoring',
            dataType: 'text',
            data: {"name": sensor},
            async: false,
            success: function (data) {
                result = data;
            },
            error: function (e) {
                result = false;
            }
        });
        return result;
    }

    /**
     * 측정소 테이블 생성
     */
    function draw_place_table(data, index) {
        var monitoringIsCheck = true;
        for (let i = 0; i < data.length; i++) {
            /* 측정소의 센서 모니터링 체크 확인 (한개라도 있으면 false) */
            if(data[i] != 0){
                monitoringIsCheck = monitoringIsCheck && false;
            }else {
                monitoringIsCheck = monitoringIsCheck && true;
            }
        }
        if(data.length != 0){
            for (let i = 0; i < data.length; i++) {
                recentData = getSensorRecentAll(data[i].name);
                $('#sensor-table-' + index + '-' + i).empty();
                const tbody = document.getElementById('sensor-table-' + index + '-' + i);
                /* 모니터링 ON 한개라도 있을 때 */
                if(!monitoringIsCheck){
                    if(data[i] != 0){
                        /* 기준 값 유무에 따라 split */
                        const newRow = tbody.insertRow(tbody.rows.length);
                        $("#update-"+index+'-'+i).text(moment(data[i].up_time).format('YYYY-MM-DD HH:mm:ss'));
                        if(data[i].companyStandard == 999999 && data[i].legalStandard == 999999 && data[i].managementStandard == 999999){
                            const newCeil0 = newRow.insertCell(0);
                            const newCeil1 = newRow.insertCell(1);
                            const newCeil2 = newRow.insertCell(2);
                            const newCeil3 = newRow.insertCell(3);
                            newCeil0.innerHTML = data[i].naming+'<input type="hidden" value='+data[i].name+'>';
                            newCeil1.innerHTML = draw_compareData(recentData[3].value, recentData[2].value);
                            newCeil2.innerHTML = draw_compareData(recentData[5].value, recentData[4].value);
                            newCeil3.innerHTML = draw_compareData(data[i].beforeValue, data[i].value);
                        }else{
                            const newCeil0 = newRow.insertCell(0);
                            const newCeil1 = newRow.insertCell(1);
                            const newCeil2 = newRow.insertCell(2);
                            const newCeil3 = newRow.insertCell(3);
                            const newCeil4 = newRow.insertCell(4);
                            const newCeil5 = newRow.insertCell(5);
                            const newCeil6 = newRow.insertCell(6);

                            if(data[i].legalStandard == 999999){
                                legalStandard = '-';
                            }else{
                                legalStandard = data[i].legalStandard;
                            }
                            if(data[i].companyStandard == 999999){
                                companyStandard = '-';
                            }else{
                                companyStandard = data[i].companyStandard;
                            }
                            if(data[i].managementStandard == 999999){
                                managementStandard = '-';
                            }else{
                                managementStandard = data[i].managementStandard;
                            }
                            newCeil0.innerHTML = data[i].naming+'<input type="hidden" value='+data[i].name+'>';
                            newCeil1.innerHTML = '<div class="bg-danger text-light">'+legalStandard+'</div>';
                            newCeil2.innerHTML = '<div class="bg-warning text-light">'+companyStandard+'</div>';
                            newCeil3.innerHTML = '<div class="bg-success text-light">'+managementStandard+'</div>';
                            newCeil4.innerHTML = draw_compareData(recentData[3].value, recentData[2].value);
                            newCeil5.innerHTML = draw_compareData(recentData[5].value, recentData[4].value);
                            newCeil6.innerHTML = draw_compareData(data[i].beforeValue, data[i].value);
                            // if(data[i].value > data[i].legalStandard){
                            //     newCeil4.innerHTML = '<span class="text-danger fw-bold">' + draw_compareData(data[i].beforeValue, data[i].value) + '</span>';
                            // } else if( data[i].value > data[i].companyStandard){
                            //     newCeil4.innerHTML = '<span class="text-warning fw-bold">' + draw_compareData(data[i].beforeValue, data[i].value) + '</span>';
                            // } else if( data[i].value > data[i].managementStandard){
                            //     newCeil4.innerHTML = '<span class="text-success fw-bold">' + draw_compareData(data[i].beforeValue, data[i].value) + '</span>';
                            // } else{
                            //     newCeil4.innerHTML = draw_compareData(data[i].beforeValue, data[i].value);
                            // }
                        }
                        // "chart-"+index+'-'+i = new ApexCharts(document.querySelector("#chart-"+index+'-'+i), setChartOption());
                        /* //기준 값 유무에 따라 split */
                        // const newRow = tbody.insertRow(tbody.rows.length);
                        // const newCeil0 = newRow.insertCell(0);
                        // const newCeil1 = newRow.insertCell(1);
                        // const newCeil2 = newRow.insertCell(2);
                        // const newCeil3 = newRow.insertCell(3);
                        // const newCeil4 = newRow.insertCell(4);
                        //
                        // if(data[i].legalStandard == 999999){
                        //     legalStandard = '-';
                        // }else{
                        //     legalStandard = data[i].legalStandard;
                        // }
                        // if(data[i].companyStandard == 999999){
                        //     companyStandard = '-';
                        // }else{
                        //     companyStandard = data[i].companyStandard;
                        // }
                        // if(data[i].managementStandard == 999999){
                        //     managementStandard = '-';
                        // }else{
                        //     managementStandard = data[i].managementStandard;
                        // }
                        //
                        // newCeil0.innerHTML = data[i].naming+'<input type="hidden" value='+data[i].name+'>';
                        // newCeil1.innerHTML = '<div class="bg-danger text-light">'+legalStandard+'</div>';
                        // newCeil2.innerHTML = '<div class="bg-warning text-light">'+companyStandard+'</div>';
                        // newCeil3.innerHTML = '<div class="bg-success text-light">'+managementStandard+'</div>';
                        //
                        // if(data[i].value > data[i].legalStandard){
                        //     newCeil4.innerHTML = '<span class="text-danger fw-bold">' + draw_compareData(data[i].beforeValue, data[i].value) + '</span>';
                        // } else if( data[i].value > data[i].companyStandard){
                        //     newCeil4.innerHTML = '<span class="text-warning fw-bold">' + draw_compareData(data[i].beforeValue, data[i].value) + '</span>';
                        // } else if( data[i].value > data[i].managementStandard){
                        //     newCeil4.innerHTML = '<span class="text-success fw-bold">' + draw_compareData(data[i].beforeValue, data[i].value) + '</span>';
                        // } else{
                        //     newCeil4.innerHTML = draw_compareData(data[i].beforeValue, data[i].value);
                        // }
                        // $("#update-" + index).text(moment(data[i].up_time).format('YYYY-MM-DD HH:mm:ss'));
                    }
                }
            }
        }else{
            noData(tbody, index);
        }

    }

    function noData(tbody, index) {
        const newRow = tbody.insertRow(tbody.rows);
        const newCeil0 = newRow.insertCell();
        newCeil0.innerHTML = '<div onclick='+'window.event.cancelBubble=true'+'>'+'모니터링 설정된 센서의 데이터가 없습니다.'
            +'</div>';
        newCeil0.colSpan = 5;
        $("#update-" + index).text("-");
    }

    /**
     * 직전값 현재값 비교하여 UP/DOWN 현재값 리턴
     */
    function draw_compareData(beforeData , nowData){
        nowData = nowData.toFixed(2);
        if(beforeData > nowData ){
            return '<i class="fas fa-sort-down fa-fw" style="color: blue"></i>' +nowData;
        } else if( nowData > beforeData ) {
            return '<i class="fas fa-sort-up fa-fw" style="color: red"></i>' +nowData;
        } else if( nowData == beforeData ){
            return '<span style="font-weight: bold">- </span>' +nowData;
        } else{
            return nowData;
        }
    }

    /**
     *  대시보드 생성 (가동률, 통신 상태, 기준값 등)
     */
    function draw_sensor_info(data) {
        var sensorMonitoringOn=0, sensorMonitoringOff=0, sensorStatusSuccess=0,
            sensorStatusFail=0, legalSCount=0, companySCount=0, managementSCount=0,
            notexistLegalStandard=0, notexistCompanyStandard=0, notexistManagementStandard=0;
        for(var i=0; i<data.length; i++){ //측정소별
            for(var z=0; z<data[i].length; z++){ //측정소의 센서별 조회
                sensorData = data[i][z];
                if(sensorData.length != 0){
                    monitoring = sensorData.monitoring;
                    status = sensorData.status;
                    value = sensorData.value;
                    legalStandard = sensorData.legalStandard;
                    companyStandard = sensorData.companyStandard;
                    managementStandard = sensorData.managementStandard;
                    if(monitoring){
                        sensorMonitoringOn +=1;
                    }
                    if(compareTime(sensorData.up_time)){
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
                    }else{
                        sensorStatusFail += 1;
                    }
                }else{
                    sensorMonitoringOff +=1;
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
        var runPercent = ((sensorStatusSuccess / (sensorStatusSuccess +sensorMonitoringOff)).toFixed(2) * 100).toFixed(0); //가동률(통신상태 기반)
        var legalPercent = ((legalSCount / (sensorStatusSuccess - notexistLegalStandard)) * 100).toFixed(0); //법적기준 %
        var companyPercent = ((companySCount / (sensorStatusSuccess - notexistCompanyStandard)) * 100).toFixed(0); //사내기준 %
        var managementPercent = ((managementSCount / (sensorStatusSuccess - notexistCompanyStandard)) * 100).toFixed(0); ////관리기준 %

        /* NaN 처리 */
        if(runPercent == 'NaN'){ runPercent = 0; }
        if(legalPercent == 'NaN'){ legalPercent = 0; }
        if(companyPercent == 'NaN'){ companyPercent = 0; }
        if(managementPercent == 'NaN'){ managementPercent = 0;}

        $("#sensorStatusP").text(runPercent + "%"); //가동률
        $("#statusMore").text(sensorStatusSuccess + " / " + (sensorStatusSuccess +sensorMonitoringOff)); // 통신정상/전체
        $("#statusOn").text(sensorStatusSuccess); //정상
        $("#statusOff").text(sensorStatusFail); //통신불량
        $("#monitoringOff").text(sensorMonitoringOff); //모니터링OFF 개수
        $("#legal_standard_text_A").text(legalPercent + "%"); //법적기준 Over
        $("#legal_standard_text_B").text(legalSCount + " / " + (sensorStatusSuccess - notexistLegalStandard)); //법적기준 Over 개수/전체
        $("#company_standard_text_A").text(companyPercent + "%"); //사내기준 Over
        $("#company_standard_text_B").text(companySCount + " / " + (sensorStatusSuccess - notexistCompanyStandard)); //사내기준 Over 개수/전체
        $("#management_standard_text_A").text(managementPercent + "%"); //관리기준 Over
        $("#management_standard_text_B").text(managementSCount + " / " + (sensorStatusSuccess - notexistManagementStandard)); //관리기준 Over 개수/전체
    }

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
     * 센서의 최근 데이터 리턴
     */
    function getSensorRecent(sensor){
        let result;
        if(sensor==undefined){
            result = null;
        } else{
            $.ajax({
                url:'<%=cp%>/getSensorRecent',
                dataType: 'JSON',
                data:  {"sensor": sensor},
                async: false,
                success: function (data) {
                    result = {value: (data.value).toFixed(2), status: data.status, up_time:data.up_time};
                },
                error: function (e) {
                }
            });
        }
        return result;
    }

    function getSensorRecentAll(sensor){
        var result = new Array();
        if(sensor==undefined){
            result = null;
        } else{
            $.ajax({
                url:'<%=cp%>/getSensorRecentAll',
                dataType: 'JSON',
                data:  {"sensor": sensor},
                async: false,
                success: function (data) {
                    result = data;
                },
                error: function (e) {
                }
            });
        }
        return result;
    }


    <%--/**--%>
    <%-- * 센서의 최근 *분--%>
    <%-- */--%>
    <%--function getSensor2(place, min) {--%>
    <%--    let result = new Array();--%>
    <%--    if(place==undefined){--%>
    <%--        return null;--%>
    <%--    }else{--%>
    <%--        $.ajax({--%>
    <%--            url:'<%=cp%>/getSensor2',--%>
    <%--            dataType: 'JSON',--%>
    <%--            contentType: "application/json",--%>
    <%--            data: {"place": place, "min": min},--%>
    <%--            async: false,--%>
    <%--            success: function (data) {--%>
    <%--                if(data.length != 0){--%>
    <%--                    $.each(data, function (index, item) {--%>
    <%--                        result.push(item);--%>
    <%--                    })--%>
    <%--                }else{--%>
    <%--                    // 조회 결과 없을 때 return [];--%>
    <%--                    result = [];--%>
    <%--                }--%>
    <%--            },--%>
    <%--            error: function (e) {--%>
    <%--            }--%>
    <%--        });--%>
    <%--    }--%>
    <%--    return result;--%>
    <%--}--%>


    /**
     * 차트 기본 옵션
     */
    function setChartOption(){
        options = {
            series: [{
                data: [],
            }],
            chart: {
                height: '150px',
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
                    show: true,
                    tools: {
                        download: true,
                        selection: false,
                        zoom: false,
                        zoomin: false,
                        zoomout: false,
                        pan: false,
                        reset: false,
                    },
                }
            },
            colors: ['#97bef8'],
            markers: { //점
                size: 2,
                strokeWidth:1,
                shape: "square",
                radius: 1,
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
                enabled: false,
                // style: { //데이터 배경
                //     fontSize: '10px',
                //     colors: ['#629cf4'],
                // },
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
                    formatter: function (val) {
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
    function updateChart(sensor_data_list, sensor_data, tableIndex, sensorIndex){
        // chart.resetSeries();
        var arr =new Array();
        if(sensor_data_list != null){
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
        chart['chart-'+tableIndex+'-'+sensorIndex].updateOptions({
            series: [{
                name: sensor_data.naming,
                data: sensor_data_list.slice()
            }],
            annotations: {
                yaxis: [{
                    y: managementStandard,
                    borderColor: '#00E396',
                    label: {
                        borderColor: '#00E396',
                        style: {
                            color: '#fff',
                            background: '#00E396'
                        },
                        text: '관리기준',
                        position: 'left',
                        offsetX: 0
                    }
                },
                    {
                        y: companyStandard,
                        borderColor: '#FEB019',
                        label: {
                            borderColor: '#FEB019',
                            style: {
                                color: '#fff',
                                background: '#FEB019'
                            },
                            text: '사내기준',
                            position: 'left',
                            offsetX: 0
                        }
                    },
                    {
                        y: legalStandard,
                        borderColor: '#FF4560',
                        label: {
                            borderColor: '#FF4560',
                            style: {
                                color: '#fff',
                                background: '#FF4560'
                            },
                            text: '법적기준',
                            position: 'left',
                            offsetX: 0
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


</script>