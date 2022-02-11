<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="stylesheet" href="static/css/page/monitoring.css">
<script src="static/js/lib/sweetalert2.min.js"></script>
<script src="static/js/lib/moment.min.js"></script>
<script src="static/js/lib/apexcharts.min.js"></script>
<script src="static/js/lib/vue-apexcharts.js"></script>
<script src="static/js/lib/jquery-ui.js"></script>


<div class="container" id="container">
    <div class="row m-3 mt-3 mb-2">
        <div class="col">
            <span class="fs-4 flashToggle fw-bold">모니터링 > 실시간 모니터링</span>
        </div>
        <div class="col text-end align-self-end">
            <div style="font-size: 1rem">
                <div id="audioDiv">
                    <audio muted id="audio" autoplay="autoplay" loop>
                        <source src="static/audio/alarm.mp3" type="audio/mp3">
                    </audio>
                </div>
                <div id="alarmAudio"></div>
                <span>알림음 </span>
                <input class="ms-2 form-check-input" type="radio" name="alarmTone" value="on" id="alarmOn"><label
                    class="ms-2" for="alarmOn"> On&nbsp;</label>
                <input type="radio" name="alarmTone" value="off" id="alarmOff" class="form-check-input"><label
                    class="ms-2" for="alarmOff"> Off&emsp;</label>
                <span>|&emsp;점멸효과 </span>
                <input class="ms-2 form-check-input" type="radio" name="flashing" value="on" id="checkOn" checked><label
                    class="ms-2" for="checkOn"> On&nbsp;</label>
                <input type="radio" name="flashing" value="off" id="checkOff" class="form-check-input"><label
                    class="ms-2" for="checkOff"> Off</label>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col text-end pe-4">
            <span class="text-primary small" style="font-size: 0.8rem"> * 실시간으로 업데이트됩니다.</span>
        </div>
    </div>

    <%-- 상단 대시보드 --%>
    <div class="row m-3 mt-0 bg-light" style="padding: 10px 0px; height: 180px;">
        <div style="width: 50%; display: flex; border-right: 1px solid #aaa;">
            <div class="operatingDiv" style="display: inline-grid; padding: .25rem .5rem;">
                <span class="fw-bold">가동률</span>
                <p id="sensorStatusP" class="fs-1 fw-bold text-center">0%</p>
                <div id="operating" class="text-center">0 / 0</div>
            </div>
            <div style="display: flex; flex-wrap: wrap; margin-left: 20px; border: 0px solid #a9a9a9">
                <div class="topDash-l text-center">
                    <span class="fw-bold fs-5" onmouseover="$('#normal').css('display','block')"
                          onmouseout="$('#normal').css('display','none')">정상</span>
                    <p id="statusOn" class="text-success fs-3" onmouseover="$('#normal2').css('display','block')"
                       onmouseout="$('#normal2').css('display','none')">0</p>
                    <div class="Gcloud-l" id="normal" style="display: none">모니터링 ON 되어있고, 정상적으로 데이터가 통신되고 있는 상태</div>
                    <div class="Gcloud-r box" id="normal2" style="display: none"></div>
                </div>
                <div class="topDash-l text-center">
                    <span class="fw-bold fs-5" onmouseover="$('#failure').css('display','block')"
                          onmouseout="$('#failure').css('display','none')">통신불량</span>
                    <p id="statusOff" class="text-danger fs-3" onmouseover="$('#failure2').css('display','block')"
                       onmouseout="$('#failure2').css('display','none')">0</p>
                    <div class="Gcloud-l" id="failure" style="display: none">센서 데이터가 5분이상 통신되고 있지 않은 상태</div>
                    <div class="Gcloud-r box" id="failure2" style="display: none"></div>
                </div>
                <div class="topDash-l text-center">
                    <span class="fw-bold fs-5" onmouseover="$('#off').css('display','block')"
                          onmouseout="$('#off').css('display','none')">모니터링 OFF</span>
                    <p id="monitoringOff" class="fs-3" onmouseover="$('#off2').css('display','block')"
                       onmouseout="$('#off2').css('display','none')">0</p>
                    <div class="Gcloud-l line" id="off" style="display: none">모니터링 OFF 설정 되어있는 상태</div>
                    <div class="Gcloud-r box" id="off2" style="display: none"></div>
                </div>
            </div>
        </div>
        <div style="width: 50%; height: 80%; display: flex; margin: auto 0; justify-content: space-around">
            <c:choose>
                <c:when test="${state == '1'}">
                    <div class="topDash-r">
                        <span class="text-center fw-bold bg-danger">법적기준 초과</span>
                        <p id="legal_standard_text_A" style="cursor: pointer" class="text-danger fs-1 bg-white" onclick="getAlarmList(1)">0</p>
                        <div id="legal_1" class="alarmList" style="display: none; padding: 5px 10px 10px; background-color: white; color: black; border: 2px solid #dc3545; box-shadow:5px 5px 20px 0 rgba(220,53,69,0.1), -5px -5px 20px 0 rgba(220,53,69,0.1); position: absolute; z-index: 99; width: 400px; left: 15px; top: 130px;">
                        </div>
                    </div>

                    <div class="topDash-r">
                        <span class="text-center fw-bold bg-warning">사내기준 초과</span>
                        <p id="company_standard_text_A" style="cursor: pointer" class="text-warning fs-1 bg-white" onclick="getAlarmList(2)">0</p>
                        <div id="company_1" class="alarmList" style="display: none; padding: 5px 10px 10px; background-color: white; color: black; border: 2px solid #ffc107; box-shadow:5px 5px 20px 0 rgba(255,193,7,0.1), -5px -5px 20px 0 rgba(255,193,7,0.1); position: absolute; z-index: 99; width: 400px; left: 15px; top: 130px;">
                        </div>
                    </div>

                    <%--                    관리기준 임시삭제--%>
                    <%--                    <div class="topDash-r">--%>
                    <%--                        <span class="text-center fw-bold bg-success">관리기준 초과</span>--%>
                    <%--                        <p id="management_standard_text_A" style="cursor: pointer" class="text-success fs-1 bg-white" onmouseover="$('#management').css('display','block')" onmouseout="$('#management').css('display','none')">0</p>--%>
                    <%--                        <div id="management_1" class="alarmList" style="display: none"></div>--%>
                    <%--                    </div>--%>
                </c:when>
                <c:otherwise>
                    <div class="topDash-r">
                        <span class="text-center fw-bold bg-danger">법적기준 초과</span>
                        <p id="legal_standard_text_B" class="text-danger fs-1 bg-white">0</p>
                    </div>
                    <div class="topDash-r">
                        <span class="text-center fw-bold bg-warning">사내기준 초과</span>
                        <p id="company_standard_text_B" class="text-warning fs-1 bg-white">0</p>
                    </div>
                    <%--                    관리기준 임시삭제--%>
                    <%--                    <div class="topDash-r">--%>
                    <%--                        <span class="text-center fw-bold bg-success">관리기준 초과</span>--%>
                    <%--                        <p id="management_standard_text_B" class="text-success fs-1 bg-white">0</p>--%>
                    <%--                    </div>--%>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <%--상단 대시보드 end--%>

    <div class="row m-3 mt-3 bg-light" style="margin: 0.2rem; height: 340px; overflow: auto;">
        <div class="row pb-0 margin-l" style="padding: 1rem 1rem 0">
            <div class="col fs-5 fw-bold">
                관리등급 초과 모니터링
            </div>
            <div class="col text-end">
                <span class="small">업데이트 : <span class="fw-bold" id="excess_update"></span></span><br>
                <span class="text-primary" style="font-size: 0.8rem"> * 실시간으로 업데이트 됩니다.</span>
            </div>
        </div>
        <div class="row pb-3 h-75 pb-3 margin-l mt-2">
            <div class="col">
                <div class="card text-white bg-primary mb-3" style="min-height: 100%;">
                    <div class="card-header fs-5">정상</div>
                    <div class="card-body fs-6" id="normal3" style="min-height: 180px;">
                    </div>
                </div>
            </div>
            <!-- 관리기준 임시삭제
            <div class="col">
                <div class="card text-white bg-success mb-3" style="min-height: 100%;">
                    <div class="card-header">관리기준 초과</div>
                    <div class="card-body" id="caution">
                    </div>
                </div>
            </div>
            -->
            <div class="col">
                <div class="card text-dark bg-warning mb-3" style="min-height: 100%;">
                    <div class="card-header fs-5">사내기준 초과</div>
                    <div class="card-body fs-6" id="warning">
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-danger mb-3" style="min-height: 100%;">
                    <div class="card-header fs-5">법적기준 초과</div>
                    <div class="card-body fs-6" id="danger">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- checkName 추가 -->
    <div class="modal" id="addCheck" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header justify-content-center">
                    <h5 class="modal-title fw-bold" id="addup">알림 확인자 입력</h5>
                </div>
                <div class="modal-body d-flex" style="flex-wrap: wrap;">
                    <form id="checkInfo" method="post" style="width:70%; margin: 10px auto;">
                        <div style="margin-bottom:7px; margin-top: 10px; display: flex; justify-content: space-between;">
                            <span>확인자 명</span>
                            <input type="text" class="modal-input" name="name" id="na1" style="border: 1px solid black;"
                                   autocomplete="off">
                        </div>
                        <input type="hidden" name="hiddenCode" id="hi1">
                        <input type="hidden" name="hiddenCode" id="hi2">
                    </form>
                </div>
                <div class="modal-footer d-flex justify-content-center">
                    <button id="saveBtn" class="btn btn-primary" onclick="saveCheck()">입력</button>
                    <button id="cancelBtn" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>

    <%-- 하단 대시보드 --%>
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

        <%-- 측정소 ALL --%>
        <div class="row table" id="place_table" style="margin: 0 auto">
            <c:choose>
            <c:when test="${empty placeInfo}">
                <div class="'col-md-12 mb-3 mt-2 place_border">
                    <table class='table table-bordered table-hover text-center mt-1'>
                        <thead>
                        <tr class="add-bg-color">
                            <th width=20%'>항목</th>
                            <th width=17%'>실시간</th>
                            <th width=17%'>5분</th>
                            <th width=21%'>30분</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td colspan=5">데이터가 없습니다.</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
            <c:forEach items="${placeInfo}" var="place" varStatus="pStatus">
            <c:choose>
            <c:when test="${fn:length(placeInfo) eq 1}">
            <div class="col-md-12 mb-3 mt-2 place_border ${pStatus}">
                </c:when>
                <c:otherwise>
                <div class="col-md-6 mb-3 mt-2 place_border ${pStatus}">
                    </c:otherwise>
                    </c:choose>
                    <div class='m-2 text-center' style='background-color: #0d6efd; color: #fff;'>
                        <span class='fs-5' id="placeName"><c:out value="${place.placeName}"/></span>
                    </div>
                    <c:forEach items="${place.data}" var="sensor" varStatus="sStatus">
                        <c:set value="${pStatus.index}-${sStatus.index}" var="idx"/>
                        <div class='text-end' style='font-size: 0.8rem'>
                            업데이트 : <span id='update-${pStatus.index}-${sStatus.index}'><c:out
                                value="${sensor.recent_up_time}"/></span>
                            <span id='unit-${pStatus.index}-${sStatus.index}'></span>
                        </div>
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
                                <c:otherwise>
                                    <thead>
                                    <tr class="add-bg-color">
                                        <!-- 관리기준 임시삭제
                                        <th width=22%'>항목</th>
                                        <th width=10%'>법적기준</th>
                                        <th width=10%'>사내기준</th>
                                        <th width=10%'>관리기준</th>
                                        <th width=16%'>실시간</th>
                                        <th width=16%'>5분</th>
                                        <th width=16%'>30분</th>
                                        -->
                                        <th width=18%'>항목</th>
                                        <th width=12%'>법적기준</th>
                                        <th width=12%'>사내기준</th>
                                        <th width=15%'>실시간</th>
                                        <th width=15%'>5분</th>
                                        <th width=15%'>30분</th>
                                    </tr>
                                    </thead>
                                </c:otherwise>
                            </c:choose>
                            <tbody id="sensor-table-${idx}">

                                <%-- 현재시간 - 업데이트 시간 해서 업데이트 시간이 5분 이상이면 회색으로 --%>
                            <jsp:useBean id="now" class="java.util.Date"/>
                            <fmt:parseDate var="uptime" value="${sensor.recent_up_time}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            <fmt:parseNumber var="now_N" value="${now.time / (1000 * 60)}" integerOnly="true"/>
                            <fmt:parseNumber var="uptime_N" value="${uptime.time / (1000 * 60)}" integerOnly="true"/>

                            <c:choose>
                            <c:when test="${now_N - uptime_N gt 5}">
                            <tr class="bg-secondary text-light">
                                </c:when>
                                <c:when test="${sensor.recent_value gt sensor.legalStandard}">
                            <tr class="bg-danger text-light">
                                </c:when>
                                <c:when test="${sensor.recent_value gt sensor.companyStandard}">
                            <tr class="bg-warning text-light">
                                </c:when>
                                <c:when test="${sensor.recent_value gt sensor.managementStandard}">
                            <tr class="bg-success text-light">
                                </c:when>
                                <c:otherwise>
                            <tr>
                                </c:otherwise>
                                </c:choose>

                                <td>${sensor.naming}<input type="hidden" value="${sensor.name}"></td>
                                <c:choose>
                                    <c:when test="${sensor.managementStandard eq 999999 && sensor.companyStandard eq 999999 && sensor.legalStandard eq 999999}">
                                    </c:when>
                                    <c:otherwise>
                                        <td>
                                            <div class="bg-danger text-light">
                                                <c:choose>
                                                    <c:when test="${sensor.legalStandard eq 999999}">
                                                        -
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:out value="${sensor.legalStandard}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="bg-warning text-light">
                                                <c:choose>
                                                    <c:when test="${sensor.companyStandard eq 999999}">
                                                        -
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:out value="${sensor.companyStandard}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <!-- 관리기준 임시삭제
                                        <td>
                                        <div class="bg-success text-light">
                                        <c:choose>
                                            <c:when test="${sensor.managementStandard eq 999999}">
                                                -
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${sensor.managementStandard}"/>
                                            </c:otherwise>
                                        </c:choose>
                                        </div>
                                        </td>
                                        -->
                                    </c:otherwise>
                                </c:choose>
                                <td>
                                    <c:choose>
                                        <c:when test="${sensor.value ne 0}">
                                            <c:choose>
                                                <c:when test="${sensor.recent_beforeValue gt sensor.recent_value}">
                                                    <i class="fas fa-sort-down fa-fw"
                                                       style="color: blue"></i><fmt:formatNumber
                                                        value="${sensor.recent_value}" pattern=".00"/>
                                                </c:when>
                                                <c:when test="${sensor.recent_beforeValue lt sensor.recent_value}">
                                                    <i class="fas fa-sort-up fa-fw"
                                                       style="color: red"></i><fmt:formatNumber
                                                        value="${sensor.recent_value}" pattern=".00"/>
                                                </c:when>
                                                <c:when test="${sensor.recent_beforeValue eq sensor.recent_value}">
                                                    <span style="font-weight: bold">- </span><fmt:formatNumber
                                                        value="${sensor.recent_value}" pattern=".00"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${sensor.recent_value}" pattern=".00"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            0.00
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${sensor.rm05_value ne 0}">
                                            <c:choose>
                                                <c:when test="${sensor.rm05_beforeValue gt sensor.rm05_value}">
                                                    <i class="fas fa-sort-down fa-fw"
                                                       style="color: blue"></i><fmt:formatNumber
                                                        value="${sensor.rm05_value}" pattern=".00"/>
                                                </c:when>
                                                <c:when test="${sensor.rm05_beforeValue lt sensor.rm05_value}">
                                                    <i class="fas fa-sort-up fa-fw"
                                                       style="color: red"></i><fmt:formatNumber
                                                        value="${sensor.rm05_value}" pattern=".00"/>
                                                </c:when>
                                                <c:when test="${sensor.rm05_beforeValue eq sensor.rm05_value}">
                                                    <span style="font-weight: bold">- </span><fmt:formatNumber
                                                        value="${sensor.rm05_value}" pattern=".00"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${sensor.rm05_value}" pattern=".00"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            0.00
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${sensor.rm30_value ne 0}">
                                            <c:choose>
                                                <c:when test="${sensor.rm30_beforeValue gt sensor.rm30_value}">
                                                    <i class="fas fa-sort-down fa-fw"
                                                       style="color: blue"></i><fmt:formatNumber
                                                        value="${sensor.rm30_value}" pattern=".00"/>
                                                </c:when>
                                                <c:when test="${sensor.rm30_beforeValue lt sensor.rm30_value}">
                                                    <i class="fas fa-sort-up fa-fw"
                                                       style="color: red"></i><fmt:formatNumber
                                                        value="${sensor.rm30_value}" pattern=".00"/>
                                                </c:when>
                                                <c:when test="${sensor.rm30_beforeValue eq sensor.rm30_value}">
                                                    <span style="font-weight: bold">- </span><fmt:formatNumber
                                                        value="${sensor.rm30_value}" pattern=".00"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${sensor.rm30_value}" pattern=".00"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            0.00
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <div id="chart-${pStatus.index}-${sStatus.index}"></div>
                    </c:forEach> <%-- 센서 --%>
                </div>
                    <%-- 개별 측정소 end--%>
                </c:forEach>
                </c:otherwise>
                </c:choose>
            </div>
            <%-- 측정소 ALL end--%>
        </div>
        <%-- 하단 대시보드 end --%>
    </div>
    <%-- 컨테이너 end --%>

    <script>
        //팝업창 드래그로 이동 가능
        $(function () {
            $('.modal-dialog').draggable({handle: ".modal-header"});
        });

        //modal 팝업창 close시 form에 남아있던 데이터 리셋
        $('.modal').on('hidden.bs.modal', function (e) {
            $(this).find('form')[0].reset()
        });
        let INTERVAL;
        let flashCheck;
        let alarmCheck;
        var oldSensorList;
        var chart = {};
        let placeInfoCopy;
        let audioInnerHTML;

        $(document).ready(function () {
            if (getCookie("flashCheck") == undefined) {
                setCookie("flashCheck", "on", 999);
            }
            if (getCookie("alarmCheck") == undefined) {
                setCookie("alarmCheck", "on", 999);
            }
            flashCheck = getCookie("flashCheck");
            if (flashCheck == "on") {
                $("input:radio[name='flashing']:radio[value='on']").prop("checked", true);
                $("input:radio[name='flashing']:radio[value='off']").prop("checked", false);
            } else {
                $("input:radio[name='flashing']:radio[value='on']").prop("checked", false);
                $("input:radio[name='flashing']:radio[value='off']").prop("checked", true);

            }
            alarmCheck = getCookie("alarmCheck");
            if (alarmCheck == "on") {
                $("input:radio[name='alarmTone']:radio[value='on']").prop("checked", true);
                //$('#alarmOn').trigger('click');
            } else {
                $("input:radio[name='alarmTone']:radio[value='off']").prop("checked", true);
                // $('#alarmOff').trigger('click');
            }

            setTimeout(function () {
                getData();
            }, 0);
            excess();
        });

        /**
         * 쿠키 값 가져오는 메소드
         */
        function getCookie(cookie_name) {
            var x, y;
            var val = document.cookie.split(';');

            for (var i = 0; i < val.length; i++) {
                x = val[i].substr(0, val[i].indexOf('='));
                y = val[i].substr(val[i].indexOf('=') + 1);
                x = x.replace(/^\s+|\s+$/g, ''); // 앞과 뒤의 공백 제거하기
                if (x == cookie_name) {
                    return unescape(y); // unescape로 디코딩 후 값 리턴
                }
            }
        }

        /**
         * 쿠키 값 저장하는 메소드 (이름, 값, 저장일수)
         */
        function setCookie(cookie_name, value, days) {
            var exdate = new Date();
            exdate.setDate(exdate.getDate() + days);
            // 설정 일수만큼 현재시간에 만료값으로 지정

            var cookie_value = escape(value) + ((days == null) ? '' : '; expires=' + exdate.toUTCString());
            document.cookie = cookie_name + '=' + cookie_value;
        }


        /**
         * 페이지 로딩시 측정소 별로 테이블 틀 생성, 측정소 별, 센서별 데이터를 받아 대시보드, 테이블 데이터 입력
         */
        function getData() {
            setTimeout(function interval_getData() { // 반복 처리를 위한 setTimeout
                // console.log("get data " + moment(new Date()).format("YYYY-MM-DD HH:mm:ss"))
                const placeInfo = getPlaceInfo(); // 모니터링 On된 측정소의 모든 정보(센서의 최근, 5분, 30분, 기준값 등)
                const placeCount = placeInfo.length;
                if (placeCount == 0) { // 측정소에 등록된 센서가 없을때
                    Swal.fire({icon: 'warning', title: '경고', text: '모니터링 설정된 측정소의 데이터가 없습니다.'});
                    draw_place_table_frame(placeInfo);
                    INTERVAL = setTimeout(interval_getData, 60000); //측정소에 등록된 센서가 없으면 처음 경고 띄우고 1분 후에 refresh
                } else {
                    var newSensorList = new Array();
                    for (let i = 0; i < placeCount; i++) {
                        for (let z = 0; z < placeInfo[i].sensorList.length; z++) {
                            newSensorList.push(placeInfo[i].sensorList[z]);
                        }
                    }
                    for (let i = 0; i < placeCount; i++) {
                        clearTimeout(INTERVAL); // 실행중인 interval 있다면 삭제
                        if (oldSensorList == undefined) { //처음 페이지 로딩 시, 테이블, 차트 틀 생성
                            oldSensorList = newSensorList;
                            draw_place_table_frame(placeInfo); // 측정소별 테이블 틀 생성 (개수에 따른 유동적으로 크기 변환)
                            draw_place_table(placeInfo); // 측정소별 테이블 생성
                        } else {
                            var sensorCount = 0;
                            for (var x = 0; x < newSensorList.length; x++) {
                                for (var y = 0; y < oldSensorList.length; y++) {
                                    if (newSensorList[x] == oldSensorList[y]) {
                                        sensorCount += 1;
                                    }
                                }
                            }

                            var dataChecking = false;
                            if (oldSensorList.length < newSensorList.length && newSensorList.length != sensorCount) {
                                dataChecking = true;
                            } else if (oldSensorList.length > newSensorList.length && oldSensorList.length != sensorCount) {
                                dataChecking = true;
                            } else if (oldSensorList.length == newSensorList.length && newSensorList.length != sensorCount) {
                                dataChecking = true;
                            }
                            if (typeof placeInfoCopy == 'undefined') placeInfoCopy = placeInfo;
                            if (placeInfoCopy.length >= placeInfo.length) {
                                for (let k = 0; k < placeInfo.length; k++) {
                                    for (let j = 0; j < placeInfo[k].data.length; j++) {
                                        if (placeInfo[k].data[j].standardExistStatus != placeInfoCopy[k].data[j].standardExistStatus) {
                                            dataChecking = true;
                                        }
                                    }
                                }
                            }
                            placeInfoCopy = placeInfo;
                            if (dataChecking) {
                                oldSensorList = newSensorList;
                                draw_place_table_frame(placeInfo); // 측정소별 테이블 틀 생성 (개수에 따른 유동적으로 크기 변환)
                                draw_place_table(placeInfo); // 측정소별 테이블 생성
                            } else {
                                // draw_place_table_frame(placeInfo);
                                draw_place_table(placeInfo); // 측정소별 테이블 생성
                            }
                        }
                        INTERVAL = setTimeout(interval_getData, 10000);
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
            var chartIndex = tbodyId.substr(13, 5);
            var firstExcute = true;
            setTimeout(function chartInterval() {
                var sensorDataList = getSensor(sensorName, 13);
                var recentData;
                var realTime = {};
                if (sensorDataList.length == 0) {
                    if ($('#chart-' + chartIndex)[0].innerText != '최근 10분 데이터가 없습니다.') {
                        if (firstExcute) {
                            $('#chart-' + chartIndex).append("<p style='height: 200px; text-align:center; padding-top:80px; background-color: #e6e6e7'>최근 10분 데이터가 없습니다.</p>");
                            firstExcute = false;
                        }
                        setTimeout(chartInterval, 10000);
                    } else {
                        if (firstExcute) {
                            $('#chart-' + chartIndex).find('p').remove();
                        } else {
                            setTimeout(chartInterval, 10000);
                        }
                    }
                } else {
                    // console.log("chart 생성");
                    if ($('#chart-' + chartIndex)[0].innerHTML.length == 0) {
                        draw_place_chart_frame(chartIndex);
                        recentData = getSensorData(sensorName);
                        updateChart(sensorDataList, recentData, chartIndex);
                        setTimeout(function realTime() {
                            var sensorDataLength = sensorDataList.length;
                            if ($('#chart-' + chartIndex)[0].childNodes[0] != undefined) {
                                var update = $('#update-' + chartIndex)[0].innerText;
                                var columnCount = $('#sensor-table-' + chartIndex).find('td').length;
                                var recentValue;
                                if (columnCount == 4) {
                                    recentValue = $('#sensor-table-' + chartIndex).find('td')[1].innerText;
                                    // 관리기준 임시삭제
                                    // columnCount == 7 로 변경하세요
                                } else if (columnCount == 6) {
                                    recentValue = $('#sensor-table-' + chartIndex).find('td')[4].innerText;
                                }
                                if (recentValue.indexOf("-") !== -1) {
                                    recentValue = recentValue.substr(2);
                                }
                                var dataListTime = moment(sensorDataList[sensorDataLength - 1].x).format("YYYY-MM-DD HH:mm:ss");
                                var before10Min = new Date();
                                var after1Min = new Date();
                                if (document.getElementById('statusOff').innerText > 0) {
                                    after1Min = after1Min.setMinutes(after1Min.getMinutes() + 1);
                                    before10Min = before10Min.setMinutes(before10Min.getMinutes() - 14);
                                    after1Min = moment(after1Min).format("YYYY-MM-DD HH:mm:ss");
                                    before10Min = moment(before10Min).format("YYYY-MM-DD HH:mm:ss");
                                    if (before10Min < dataListTime && dataListTime <= after1Min) {
                                        if (dataListTime < update) {
                                            sensorDataList.push({x: update, y: recentValue});
                                            updateChart(sensorDataList, recentData, chartIndex);
                                        }
                                    } else {
                                        chart['chart-' + chartIndex].destroy();
                                        $('#chart-' + chartIndex).append("<p style='height: 200px; text-align:center; padding-top:80px; background-color: #e6e6e7'>최근 10분 데이터가 없습니다.</p>");
                                        setTimeout(chartInterval, 0);
                                    }
                                } else {
                                    if (dataListTime < update) {
                                        sensorDataList.push({x: update, y: recentValue});
                                        updateChart(sensorDataList, recentData, chartIndex);
                                    }
                                }
                                if (sensorDataList.length > 1440) {
                                    sensorDataList = getSensor(sensorName, 13);
                                }
                                realTime['chart-' + chartIndex] = setTimeout(realTime, 1000);
                            }
                        }, 0);
                    } else {
                        if ($('#chart-' + chartIndex)[0].innerText == '최근 10분 데이터가 없습니다.') {
                            $('#chart-' + chartIndex).find('p').remove();
                            setTimeout(chartInterval, 0);
                        } else {
                            clearTimeout(realTime['chart-' + chartIndex]);
                            chart['chart-' + chartIndex].destroy();
                        }
                    }
                }
            }, 0);

        });


        /**
         * 알림음
         */
        function alarmTone(onOff) {
            if (onOff == 'on' && $('input:radio[name=alarmTone]:checked').val() == 'on') {
                audioInnerHTML = '<audio id="audio" autoplay="autoplay" loop><source src="static/audio/alarm.mp3" type="audio/mp3"></audio>';
            } else {
                audioInnerHTML = '<audio muted id="audio" autoplay="autoplay" loop><source src="static/audio/alarm.mp3" type="audio/mp3"></audio>';
            }
            $('#audioDiv').empty();
            $('#audioDiv').append(audioInnerHTML);
        }

        /**
         *  점멸 효과
         */
        function flashing(onOff, bg) {
            const element = $("body");
            if (onOff == 'on' && bg != null) {
                if (typeof flIn1 !== "undefined") {
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
            } else {
                if (typeof flIn1 !== "undefined") {
                    clearTimeout(flIn1);
                }
            }
        }

        function draw_place_chart_frame(index) {
            chart['chart-' + index] = new ApexCharts(document.querySelector("#chart-" + index), setChartOption());
            chart['chart-' + index].render();
            // $('#chart-'+i+'-'+z).hide();
        }

        /**
         * 측정소의 갯수에 따라 테이블 틀 생성 (홀수 : 테이블 1개, 짝수: 테이블 2개 씩 출력)
         */
        function draw_place_table_frame(placeInfo) {
            $('#place_table').empty();
            var col_md_size;
            if (placeInfo.length != 0) {
                for (let i = 0; i < placeInfo.length; i++) {
                    var placeName = placeInfo[i].place; //측정소명
                    var dataLength = placeInfo[i].monitoringOn; //모니터링On된 센서수
                    var data = placeInfo[i].data; //모니터링On된 센서수
                    if (placeInfo.length == 1) { // 측정소 1개 width 100%
                        col_md_size = 12;
                    } else { // 측정소 1개 width 50%
                        col_md_size = 6;
                    }
                    /* 기준 값 유무에 따라 split */
                    $('#place_table').append(
                        "<div class='col-md-" + col_md_size + " mb-3 mt-2 place_border " + i + "'>" +
                        "<div class='m-2 text-center' style='background-color: #0d6efd; color: #fff;'>" +
                        "<span class='fs-5' id='placeName'>" + placeName + "</span></div>");
                    for (var z = 0; z < dataLength; z++) {
                        var standardExistStatus = data[z].standardExistStatus;
                        if (!standardExistStatus) {
                            $('.' + i).append( //i:측정소idx z:센서idx
                                "<div class='text-end' style='font-size: 0.8rem'>업데이트 : <span style='padding: 0' id=update-" + i + "-" + z + "></span>&nbsp;<span style='padding: 0' id=unit-" + i + "-" + z + "></span></div>" +
                                "<table class='table table-bordered table-hover text-center mt-1'>" +
                                "<thead>" +
                                "<tr class='add-bg-color'>" +
                                "<th width=22%'>항목</th>" +
                                "<th width=26%'>실시간</th>" +
                                "<th width=26%'>5분</th>" +
                                "<th width=26%'>30분</th>" +
                                "</tr>" +
                                "</thead>" +
                                "<tbody id='sensor-table-" + i + "-" + z + "'>" +
                                "<tr>" +
                                "<td colspan='2'></td>" +
                                "</tr>" +
                                "</tbody>" +
                                "</table>" +
                                "<div id='chart-" + i + "-" + z + "'></div>" +
                                "</div>");
                        } else {
                            $('.' + i).append(
                                "<div class='text-end' style='font-size: 0.8rem'>업데이트 : <span style='padding: 0' id=update-" + i + "-" + z + "></span>&nbsp;<span style='padding: 0' id=unit-" + i + "-" + z + "></span></div>" +
                                "<table class='table table-bordered table-hover text-center mt-1'>" +
                                "<thead>" +
                                "<tr class='add-bg-color'>" +
                                "<th width=18%'>항목</th>" +
                                "<th width=12%'>법적기준</th>" +
                                "<th width=12%'>사내기준</th>" +
                                /* 관리기준 임시삭제
                                "<th width=10%'>관리기준</th>" +
                                */
                                "<th width=15%'>실시간</th>" +
                                "<th width=15%'>5분</th>" +
                                "<th width=15%'>30분</th>" +
                                "</tr>" +
                                "</thead>" +
                                "<tbody id='sensor-table-" + i + "-" + z + "'>" +
                                "<tr>" +
                                "<td colspan='4'></td>" +
                                "</tr>" +
                                "</tbody>" +
                                "</table>" +
                                "<div id='chart-" + i + "-" + z + "'></div>" +
                                "</div>");
                        }
                    }
                }
            } else {
                $('#place_table').append(
                    "<div class='col-md-12 mb-3 mt-2 place_border'>" +
                    "<table class='table table-bordered table-hover text-center mt-1'>" +
                    "<thead>" +
                    "<tr class='add-bg-color'>" +
                    "<th width=28%'>항목</th>" +
                    "<th width=17%'>실시간</th>" +
                    "<th width=17%'>5분</th>" +
                    /* 관리기준 임시삭제
                    "<th width=17%'>관리기준</th>" +
                    */
                    "<th width=21%'>30분</th>" +
                    "</tr>" +
                    "</thead>" +
                    "<tbody>" +
                    "<tr>" +
                    "<td colspan='5'>데이터가 없습니다.</td>" +
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
            if (placeCount != 0) {
                for (var i = 0; i < placeCount; i++) {
                    var data = placeInfo[i].data;
                    var dataCount = data.length;
                    if (dataCount != 0) {
                        for (let z = 0; z < dataCount; z++) {
                            var unit;
                            var recentData = data[z];
                            var standarExistStatus = data[z].standardExistStatus;
                            $('#sensor-table-' + i + '-' + z).empty();
                            var tbody = document.getElementById('sensor-table-' + i + '-' + z);
                            if (tbody == null) {
                                draw_place_table_frame(placeInfo);
                                tbody = document.getElementById('sensor-table-' + i + '-' + z);
                            }
                            /* 기준 값 유무에 따라 split */
                            const newRow = tbody.insertRow(tbody.rows.length);
                            $("#update-" + i + '-' + z).text(moment(data[z].recent_up_time).format('YYYY-MM-DD HH:mm:ss'));
                            if (data[z].unit != "" && data[z].unit != null) {
                                unit = data[z].unit;
                                $("#unit-" + i + '-' + z).text("[ 단위 : " + unit + " ]");
                            }

                            //현재시간 -5분 후 현재시간이 더 크다면 css 적용
                            let dataTime = new Date(data[z].recent_up_time);
                            let nowTime = new Date();
                            nowTime.setMinutes(nowTime.getMinutes() - 5);

                            const newCeil0 = newRow.insertCell(0);
                            const newCeil1 = newRow.insertCell(1);
                            const newCeil2 = newRow.insertCell(2);
                            // 관리기준 임시삭제 const newCeil3 = newRow.insertCell(3);
                            // newceil4 = new Row.insertCell(4) -> newCeil4 = newRow.insertCell(3)
                            const newCeil4 = newRow.insertCell(3);

                            newCeil0.innerHTML = data[z].naming + '<input type="hidden" value=' + data[z].name + '>';

                            if (!standarExistStatus) {
                                if (dataTime < nowTime) {
                                    $(newRow).attr('class', 'bg-secondary text-light');
                                } else {
                                    $(newRow).attr('class', '');
                                }

                                newCeil1.innerHTML = draw_compareData(data[z].recent_beforeValue, data[z].recent_value);
                                newCeil2.innerHTML = draw_compareData(data[z].rm05_beforeValue, data[z].rm05_value);
                                newCeil4.innerHTML = draw_compareData(data[z].rm30_beforeValue, data[z].rm30_value);
                            } else {

                                if (data[z].legalStandard == 999999) {
                                    legalStandard = '-';
                                } else {
                                    legalStandard = data[z].legalStandard;
                                }
                                if (data[z].companyStandard == 999999) {
                                    companyStandard = '-';
                                } else {
                                    companyStandard = data[z].companyStandard;
                                }
                                if (data[z].managementStandard == 999999) {
                                    managementStandard = '-';
                                } else {
                                    managementStandard = data[z].managementStandard;
                                }

                                //시간비교후 css 적용, 그외 기준값 비교후 css 적용
                                let newValue = data[z].recent_value;
                                if (dataTime < nowTime) {
                                    $(newRow).attr('class', 'bg-secondary text-light');
                                } else if (newValue > data[z].legalStandard) {
                                    $(newRow).attr('class', 'bg-danger text-light');
                                } else if (newValue > data[z].companyStandard) {
                                    $(newRow).attr('class', 'bg-warning text-light');
                                }
                                /* 관리기준 임시삭제
                                else if(newValue > data[z].managementStandard){
                                    $(newRow).attr('class', 'bg-success text-light');
                                }
                                */
                                else {
                                    $(newRow).attr('class', '');
                                }

                                const newCeil5 = newRow.insertCell(4);
                                const newCeil6 = newRow.insertCell(5);
                                newCeil1.innerHTML = '<div class="bg-danger text-light">' + legalStandard + '</div>';
                                newCeil2.innerHTML = '<div class="bg-warning text-light">' + companyStandard + '</div>';
                                /* 관리기준 임시삭제
                                newCeil3.innerHTML = '<div class="bg-success text-light">'+managementStandard+'</div>';
                                 */
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
            newCeil0.innerHTML = '<div onclick=' + 'window.event.cancelBubble=true' + '>' + '모니터링 설정된 센서의 데이터가 없습니다.'
                + '</div>';
            newCeil0.colSpan = 5;
        }

        /**
         * 직전값 현재값 비교하여 UP/DOWN 현재값 리턴
         */
        function draw_compareData(beforeData, nowData) {
            beforeData = beforeData.toFixed(2);
            nowData = nowData.toFixed(2);
            if (beforeData > nowData) {
                return '<i class="fas fa-sort-down fa-fw" style="color: blue"></i>' + nowData;
            } else if (nowData > beforeData) {
                return '<i class="fas fa-sort-up fa-fw" style="color: red"></i>' + nowData;
            } else if (nowData == beforeData) {
                return '<span style="font-weight: bold">- </span>' + nowData;
            } else {
                return nowData;
            }
        }

        /**
         *  대시보드 생성 (가동률, 통신 상태, 기준값 등)
         */
        function draw_sensor_info(placeInfo) {
            let state = ${state};
            if (placeInfo.length != 0) {
                var placeCount = placeInfo.length;
                var sensorMonitoringOn = 0, allMonitoringOFF = 0,
                    sensorStatusSuccess = 0, sensorStatusFail = 0,
                    legalSCount = 0, companySCount = 0, managementSCount = 0,
                    notexistLegalStandard = 0, notexistCompanyStandard = 0, notexistManagementStandard = 0;
                allMonitoringOFF = placeInfo[0].allMonitoringOFFList.length;
                var sensorStatusSuccessList = new Array();
                var sensorStatusFailList = new Array();
                for (var i = 0; i < placeCount; i++) { //측정소별
                    var data = placeInfo[i].data;
                    var dataCount = data.length;
                    sensorMonitoringOn += placeInfo[i].monitoringOn;
                    for (var z = 0; z < dataCount; z++) { //측정소의 센서별 조회
                        var sensorData = data[z];
                        value = sensorData.recent_value;
                        legalStandard = sensorData.legalStandard;
                        companyStandard = sensorData.companyStandard;
                        managementStandard = sensorData.managementStandard;
                        if (compareTime(sensorData.recent_up_time)) { // 최근데이터가 5분 이내 일때, 통신 정상, 알림음, 점멸효과
                            sensorStatusSuccess += 1;
                            if (legalStandard == 999999) {
                                notexistLegalStandard += 1;
                            }
                            if (companyStandard == 999999) {
                                notexistCompanyStandard += 1;
                            }
                            if (managementStandard == 999999) {
                                notexistManagementStandard += 1;
                            }
                            if (value > legalStandard) {
                                legalSCount += 1;
                            } else if (value > companyStandard) {
                                companySCount += 1;
                            } else if (value > managementStandard) {
                                managementSCount += 1;
                            }
                            sensorStatusSuccessList.push(placeInfo[i].place + "-" + sensorData.naming);
                        } else { // 최근데이터가 5분 이외일 때, 통신불량 처리
                            sensorStatusFailList.push(placeInfo[i].place + "-" + sensorData.naming);
                            sensorStatusFail += 1;
                        }

                    }
                }
                // if (legalSCount > 0) {
                //     flashing(flashCheck, "bg-danger");
                //     alarmTone('on');
                // } else if (companySCount > 0) {
                //     flashing(flashCheck, "bg-warning");
                //     alarmTone('on');
                // } else if (managementSCount > 0) {
                //     flashing(flashCheck, "bg-success");
                //     alarmTone('on');
                // } else {
                //     flashing(flashCheck, null);
                //     alarmTone('off');
                // }
                var runPercent = ((sensorStatusSuccess / (sensorStatusSuccess + sensorStatusFail)).toFixed(2) * 100).toFixed(0); //가동률(통신상태 기반)
                var run = sensorStatusSuccess + " / " + (sensorStatusSuccess + sensorStatusFail);
                if (runPercent == 'NaN') {
                    runPercent = 0;
                }
            } else {
                runPercent = 0;
                run = "0 / 0";
                sensorStatusSuccess = 0;
                sensorStatusFail = 0;
                allMonitoringOFF = getMonitoringSensor();
                legalSCount = 0;
                companySCount = 0;
                managementSCount = 0;
            }
            $("#normal2").empty();
            $("#failure2").empty();
            $("#off2").empty();
            for (var a = 0; a < sensorStatusSuccessList.length; a++) {
                $("#normal2").append("<p>" + sensorStatusSuccessList[a] + "</p>");
            }
            if (sensorStatusSuccessList.length == 0) {
                $("#normal2").append("<p>" + "모니터링 On 된 센서가 없습니다." + "</p>");
            }
            for (var a = 0; a < sensorStatusFailList.length; a++) {
                $("#failure2").append("<p>" + sensorStatusFailList[a] + "</p>");
            }
            if (sensorStatusFailList.length == 0) {
                $("#failure2").append("<p>" + "통신불량 센서가 없습니다." + "</p>");
            }
            for (var a = 0; a < placeInfo[0].allMonitoringOFFList.length; a++) {
                $("#off2").append("<p>" + placeInfo[0].allMonitoringOFFList[a] + "</p>");
            }
            if (placeInfo[0].allMonitoringOFFList.length == 0) {
                $("#off2").append("<p>" + "모니터링 Off 된 센서가 없습니다." + "</p>");
            }
            $("#sensorStatusP").text(runPercent + "%"); //가동률
            $("#operating").text(run); // 통신정상/전체
            $("#statusOn").text(sensorStatusSuccess); //정상
            $("#statusOff").text(sensorStatusFail); //통신불량
            $("#monitoringOff").text(allMonitoringOFF); //모니터링OFF 개수
            // if (state == "1") {
            //     $("#legal_standard_text_A").text(legalSCount); //법적기준 Over
            //     $("#company_standard_text_A").text(companySCount); //사내기준 Over
            //     $("#management_standard_text_A").text(managementSCount); //관리기준 Over
            // } else {
            //     $("#legal_standard_text_B").text(legalSCount); //법적기준 Over
            //     $("#company_standard_text_B").text(companySCount); //사내기준 Over
            //     $("#management_standard_text_B").text(managementSCount); //관리기준 Over
            // }
        }

        /**
         * 현재시간과 비교하여 5분이내면 true, 외외면 false
         */
        function compareTime(dateTime) {
            const dt = moment(dateTime, 'YYYY-MM-DD HH:mm:ss');
            const now = moment();
            const diffTime = moment.duration(now.diff(dt)).asMinutes();
            if (diffTime > 5) { //5분 차이
                return false;
            } else {
                return true;
            }
        }

        /**
         * 알림음 On / Off 이벤트
         */
        $('input:radio[name=alarmTone]').click(function () {

            if ($('input:radio[name=alarmTone]:checked').val() == 'on') {
                alarmCheck = "on";
            } else {
                $('#audioDiv').empty();
                audioInnerHTML = '<audio muted id="audio" autoplay="autoplay" loop><source src="static/audio/alarm.mp3" type="audio/mp3"></audio>';
                $('#audioDiv').append(audioInnerHTML);
                alarmCheck = "off";
            }
            setCookie("alarmCheck", alarmCheck, 999);
        });
        /**
         * 점멸 효과 On / Off 이벤트
         */
        document.querySelector('input[name="flashing"]:checked').value;
        $('input:radio[name=flashing]').click(function () {
            if ($('input:radio[name=flashing]:checked').val() == 'on') {
                flashCheck = "on";
            } else {
                flashCheck = "off";
                if (typeof flIn1 !== "undefined")
                    clearTimeout(flIn1);
            }
            setCookie("flashCheck", flashCheck, 999);
        });

        /**
         * 차트 기본 옵션
         */
        function setChartOption() {
            options = {
                series: [{
                    data: [],
                }],
                chart: {
                    height: '200px',
                    width: '99%',
                    offsetX: 5,
                    type: 'line',
                    animations: {
                        enabled: true,
                        easing: 'easein',
                        dynamicAnimation: {
                            enabled: true,
                            speed: 350
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
                colors: ['#97bef8'],
                markers: { //점
                    size: 4,
                    strokeWidth: 2,
                    shape: "circle",
                    radius: 1,
                    colors: ["#0d6efd"],
                    hover: {
                        size: 8,
                    }
                },
                tooltip: {
                    enabled: true,
                    style: {
                        fontSize: '13px',
                    },
                    x: {
                        show: true,
                        format: 'MM-dd HH:mm:ss'
                    },
                    marker: {
                        show: false,
                    },
                },
                stroke: {
                    show: true,
                    width: 4,
                    curve: 'smooth',
                },
                dataLabels: {
                    offsetY: -3,
                    enabled: true,
                    textAnchor: 'middle',
                    style: { //데이터 배경
                        fontSize: '10px',
                    },
                    background: { //데이터 글자
                        enabled: true,
                        foreColor: 'black',
                        opacity: 0,
                    },
                },
                xaxis: {
                    type: 'datetime',
                    range: 600000,
                    labels: {
                        show: true,
                        datetimeUTC: false,
                        datetimeFormatter: {
                            day: 'dd, HH:mm:ss',
                            hour: 'HH:mm:ss',
                            minute: 'HH:mm:ss',
                        },
                    },
                    crosshairs: {
                        show: true,
                        width: 1,
                        position: 'back',
                        stroke: {
                            color: '#414142',
                        },
                    },
                    tooltip: {
                        enabled: false,
                    },
                },
                yaxis: {
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
        function updateChart(sensor_data_list, sensor_data, chartIndex) {
            var arr = new Array();
            var unit = sensor_data.unit;
            var dataLength = sensor_data_list.length;
            var dataIndex = new Array();
            if (unit == null || unit == undefined) {
                unit = "";
            }
            if (dataLength != 0) {
                var recentDate = new Date(sensor_data_list[dataLength - 1].x);
                var before10Min = recentDate.setMinutes(recentDate.getMinutes() - 10);
                before10Min = new Date(before10Min);
                before10Min = moment(before10Min).format("YYYY-MM-DD HH:mm:ss");
                for (var i in sensor_data_list) {
                    if (before10Min <= moment(sensor_data_list[i].x).format("YYYY-MM-DD HH:mm:ss")) {
                        arr.push(sensor_data_list[i].y);
                        dataIndex.push(i);
                    }
                }
                var max = arr.reduce(function (previousValue, currentValue) {
                    return parseFloat(previousValue > currentValue ? previousValue : currentValue);
                });
                var min = arr.reduce(function (previousValue, currentValue) {
                    return parseFloat(previousValue > currentValue ? currentValue : previousValue);
                });
                var maxCeil = Math.ceil(max);
                var minFloor = Math.floor(min);
            } else {
                sensor_data_list = [];
            }
            if (sensor_data.length != 0) {
                managementStandard = sensor_data.managementStandard;
                companyStandard = sensor_data.companyStandard;
                legalStandard = sensor_data.legalStandard;
            } else {
                managementStandard = 999999;
                companyStandard = 999999;
                legalStandard = 999999;
            }
            chart['chart-' + chartIndex].updateOptions({
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
                    // opposite: true,
                    title: {
                        text: unit,
                        offsetX: 2,
                        style: {
                            fontSize: '13px',
                            fontWeight: 'bold'
                        }
                    },
                    tickAmount: 2,
                    decimalsInFloat: 2,
                    min: minFloor,
                    max: maxCeil,
                    labels: {
                        show: true,
                        formatter: function (val) {
                            return val;
                        },
                    }
                },
                tooltip: {
                    y: {
                        formatter: function (val) {
                            if (unit) {
                                return val + " " + sensor_data.unit
                            } else {
                                return val;
                            }
                        }
                    }
                },
                dataLabels: {
                    formatter: function (val, opts) {
                        for (var i in dataIndex) {
                            if (i % 4 == 0) {
                                if (opts.dataPointIndex == dataIndex[i]) {
                                    return val;
                                }
                            }
                            if (opts.dataPointIndex == dataIndex[dataIndex.length - 1]) {
                                return val;
                            }
                        }
                    }
                }
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
         * 센서의 최근 min 분 데이터 조회
         */
        function getSensor(sensor_name, min) {
            let result = new Array();
            if (sensor_name == undefined) {
                return null;
            } else {
                $.ajax({
                    url: '<%=cp%>/getSensor2',
                    dataType: 'JSON',
                    contentType: "application/json",
                    data: {"sensor": sensor_name, "min": min},
                    async: false,
                    success: function (data) {
                        if (data.length != 0) {
                            $.each(data, function (index, item) {
                                result.push({x: item.up_time, y: (item.value).toFixed(2)});
                            })
                        } else {
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
                url: '<%=cp%>/getSensorData',
                dataType: 'JSON',
                data: {"sensor": sensor},
                async: false,
                success: function (data) {
                    result = data;
                },
                error: function (e) {
                }
            })
            return result;
        }

        function getMonitoringSensor() {
            var username = "<sec:authentication property="principal.username" />";
            let result = null;
            $.ajax({
                url: '<%=cp%>/getMonitoringSensor',
                dataType: 'JSON',
                data: {"memberId": username},
                async: false,
                success: function (data) {
                    result = data["OFF"];
                },
                error: function (e) {
                }
            })
            return result;
        }

        function excess() {
            addExcessData();
            getAlarmListNum();

            setInterval(function () {
                addExcessData();
            }, 10000);
            setInterval(function () {
                getAlarmListNum();
            }, 10000);

            // 매 30초마다 실행되게 하는 함수
            /*
            const HALF_PAST = 30 * 1000;
            const timeSinceBoundary = new Date() % HALF_PAST;
            const timeToSetInterval = timeSinceBoundary === 0 ? 0 : (HALF_PAST - timeSinceBoundary);
            setTimeout(function () {
                setInterval(function () {
                    addExcessData();
                }, HALF_PAST);
            }, timeToSetInterval);
            */
        }

        function addExcessData() {
            $("#normal3").empty();
            $("#caution").empty();
            $("#warning").empty();
            $("#danger").empty();

            $.ajax({
                url: '<%=cp%>/getExcessSensor',
                dataType: 'json',
                async: false,
                success: function (data) {
                    const arr = data.excess;
                    if (arr != undefined) {
                        $("#excess_update").text(moment(arr[0].up_time).format('YYYY-MM-DD HH:mm:ss'));

                        for (let i = 0; i < arr.length; i++) {
                            const excess = arr[i].classification;
                            const place = arr[i].place;
                            const naming = arr[i].naming;
                            const value = arr[i].value;

                            if (excess == "danger") {
                                $("#danger").append("<h5>" + place + " - " + naming + " [" + value + "] </h5>");
                            } else if (excess == "warning") {
                                $("#warning").append("<h5>" + place + " - " + naming + " [" + value + "] </h5>");
                            } else if (excess == "caution") {
                                $("#caution").append("<h5>" + place + " - " + naming + " [" + value + "] </h5>");
                            } else if (excess == "normal") {
                                $("#normal3").append("<h5>" + place + " - " + naming + " [" + value + "] </h5>");
                            }
                        }
                    } else {
                        $("#excess_update").text("최근 5분 이내로 업데이트 된 데이터가 없습니다.");
                    }

                },
                error: function (request, status, error) {
                    console.log(error)
                }
            });
        }
        function getAlarmListNum() {
            let state = ${state};
            let legalSCount = 0, companySCount = 0, managementSCount = 0;
            $.ajax({
                url: '<%=cp%>/getAlarmData',
                dataType: 'json',
                data: {"num": "2"},
                async: false,
                success: function (data) {
                    const arr = data;
                    if (arr != undefined) {
                        for (let i = 0; i < arr.length; i++) {
                            if (arr[i].status == "true") {
                                let excess = arr[i].grade;
                                if (excess == 1) {
                                    excess = "danger";
                                    legalSCount +=1;
                                } else if (excess == 2) {
                                    excess = "warning";
                                    companySCount +=1;
                                } else {
                                    excess = "caution";
                                    managementSCount+=1;
                                }
                            }
                        }
                        if (legalSCount > 0) {
                            flashing(flashCheck, "bg-danger");
                            alarmTone('on');
                        } else if (companySCount > 0) {
                            flashing(flashCheck, "bg-warning");
                            alarmTone('on');
                        } else if (managementSCount > 0) {
                            flashing(flashCheck, "bg-success");
                            alarmTone('on');
                        } else {
                            flashing(flashCheck, null);
                            alarmTone('off');
                        }
                    }
                    if (state == "1") {
                        $("#legal_standard_text_A").text(legalSCount); //법적기준 Over
                        $("#company_standard_text_A").text(companySCount); //사내기준 Over
                        $("#management_standard_text_A").text(managementSCount); //관리기준 Over
                    } else {
                        $("#legal_standard_text_B").text(legalSCount); //법적기준 Over
                        $("#company_standard_text_B").text(companySCount); //사내기준 Over
                        $("#management_standard_text_B").text(managementSCount); //관리기준 Over
                    }
                },
                error: function (request, status, error) {
                    console.log(error)
                }
            });

        }


        //알림리스트 불러오기
        function getAlarmList(grade) {
            $("#legal_1").empty();
            $("#company_1").empty();
            $("#management_1").empty();
            $('#legal_1').css('display', 'none');
            $('#company_1').css('display', 'none');
            $('#management_1').css('display', 'none');
            let innerHTML1 = "<div style='font-weight:bold;' id='l' class='alarmTitle'><p>법적기준 초과</p><button style='background: white; border: solid white; font-weight: bold; font-size: 1.2rem;' onclick=\"$('#legal_1').css('display','none')\">X</button></div>";
            let innerHTML2 = "<div style='font-weight:bold;' id='c' class='alarmTitle'><p>사내기준 초과</p><button style='background: white; border: solid white; font-weight: bold; font-size: 1.2rem;' onclick=\"$('#company_1').css('display','none')\">X</button></div>";
            let innerHTML3 = "<div style='font-weight:bold;' id='m' class='alarmTitle'><p>관리기준 초과</p><button style='background: white; border: solid white; font-weight: bold; font-size: 1.2rem;' onclick=\"$('#management_1').css('display','none')\">X</button></div>";

            //그룹 측정소에서 ON된 센서 추출
            $.ajax({
                url: '<%=cp%>/getAlarmData',
                dataType: 'json',
                data: {"num": "2"},
                async: false,
                success: function (data) {
                    const arr = data;
                    arr.sort(function (a, b) {
                        var c = new Date(a.up_time);
                        var d = new Date(b.up_time);
                        return c - d;
                    });
                    if (arr != undefined) {
                        for (let i = arr.length - 1; i >= 0; i--) {
                            if (arr[i].status == "true") {
                                let excess = arr[i].grade;
                                const place = arr[i].place;
                                const naming = arr[i].sensor;
                                const value = arr[i].value;
                                const uptime = moment(arr[i].up_time).format('YYYY-MM-DD HH:mm:ss');
                                if (excess == 1) {
                                    excess = "danger";
                                } else if (excess == 2) {
                                    excess = "warning";
                                } else {
                                    excess = "caution";
                                }
                                if (arr[i].grade == grade) {
                                    if (excess == "danger") {
                                        if (document.getElementById('l') == null) {
                                            innerHTML1 += "<div><span  id='dangerInner" + i + "' style='display: inline-block;font-size: 1rem; padding: 5px;'>" + uptime + " " + place + " - " + naming + "<br> 법적기준 초과( " + value + " )";
                                        } else {
                                            innerHTML1 = "<div><span  id='dangerInner" + i + "' style='display: inline-block;font-size: 1rem; padding: 5px;'>" + uptime + " " + place + " - " + naming + "<br> 법적기준 초과( " + value + " )";
                                        }
                                        innerHTML1 += "<button class='btn btn-primary' style='margin-left:10px; padding:1px 7px;' data-bs-toggle='modal' data-bs-target='#addCheck' id='b" + i + "' onclick=\"insertCheckName('" + naming + "','" + uptime + "')\">확인</button></span></div>";
                                        $('#legal_1').append(innerHTML1);
                                        $('#legal_1').css('display', 'block');
                                    } else if (excess == "warning") {
                                        if (document.getElementById('c') == null) {
                                            innerHTML2 += "<div><span  id='warningInner" + i + "' style='display: inline-block;font-size: 1rem; padding: 5px;'>" + uptime + " " + place + " - " + naming + "<br> 사내기준 초과( " + value + " )";
                                        } else {
                                            innerHTML2 = "<div><span  id='warningInner" + i + "' style='display: inline-block;font-size: 1rem; padding: 5px;'>" + uptime + " " + place + " - " + naming + "<br> 사내기준 초과( " + value + " )";
                                        }
                                        innerHTML2 += "<button class='btn btn-primary' style='margin-left:10px; padding:1px 7px;' data-bs-toggle='modal' data-bs-target='#addCheck' id='b" + i + "' onclick=\"insertCheckName('" + naming + "','" + uptime + "')\">확인</button></span></div>";
                                        $('#company_1').append(innerHTML2);
                                        $('#company_1').css('display', 'block');
                                    } else if (excess == "caution") {
                                        if (document.getElementById('m') == null) {
                                            innerHTML3 += "<div><span  id='cautionInner" + i + "' style='display: inline-block;font-size: 1rem; padding: 5px;'>" + uptime + " " + place + " - " + naming + "<br> 관리기준 초과( " + value + " )";
                                        } else {
                                            innerHTML3 = "<div><span  id='cautionInner" + i + "' style='display: inline-block;font-size: 1rem; padding: 5px;'>" + uptime + " " + place + " - " + naming + "<br> 관리기준 초과( " + value + " )";
                                        }
                                        innerHTML3 += "<button class='btn btn-primary' style='margin-left:10px; padding:1px 7px;' data-bs-toggle='modal' data-bs-target='#addCheck' id='b" + i + "' onclick=\"insertCheckName('" + naming + "','" + uptime + "')\">확인</button></span></div>";
                                        $('#management_1').append(innerHTML3);
                                        $('#management_1').css('display', 'block');
                                    }
                                }
                            }
                        }
                    }

                },
                error: function (request, status, error) {
                    console.log(error)
                }
            });
        }

        function insertCheckName(sensor, uptime) {
            document.getElementById('na1').value = '';
            $('input[id=hi1]').attr('value', sensor);
            $('input[id=hi2]').attr('value', uptime);

        }

        function saveCheck() {
            const na = $("#na1").val();
            const name = na.replace(/(\s*)/g, ""); //공백제거
            const sensor = $("#hi1").val();
            const uptime = $("#hi2").val();
            const pattern = /[`~.!@#$%^&*()_+=|<>?:;`,{}\-\]\[/\'\"\\\']/;

            if (name == "") {
                customSwal('확인자 명을 입력해주세요.');
                return false;
            }
            if (pattern.test(name) == true) { //특수문자
                customSwal('특수문자를 입력할 수 없습니다.');
                return false;
            }
            $.ajax({
                url: '<%=cp%>/saveCheck',
                type: 'POST',
                async: false,
                cache: false,
                data: {
                    "name": name,
                    "sensor": sensor,
                    "uptime": uptime
                }, success: function (data) {
                },
                error: function (request, status, error) {
                    console.log(error)
                }
            })
            Swal.fire({
                icon: 'success',
                title: '알림 확인',
                text: '확인자 명이 입력되었습니다.',
                timer: 1500
            })
            document.getElementById("cancelBtn").click();
            $('#legal_1').css('display', 'none');
            $('#company_1').css('display', 'none');
            $('#management_1').css('display', 'none');
            if (getCookie('isAlarm') == 'true') {
                $('.alarm').attr('src', "static/images/bellOn.png");
                getAlarm();
            }else{
                $('.alarm').attr('src', "static/images/bellOff.png");
                getAlarm();
                alarmEmpty();
                viewCount();
            }
            getAlarmListNum();
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
