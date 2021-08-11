<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 3:55
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.Date" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="stylesheet" href="static/css/page/dashboard.css">
<script src="static/js/moment.min.js"></script>
<script src="static/js/sweetalert2.min.js"></script>

<div class="container"  id="container">
    <div class="row m-3 mt-3 ms-1">
        <span class="fs-4 fw-bold">대시보드</span>
    </div>

    <div class="row m-3 mt-3 bg-white ms-1" style="width: 98%; height: 370px; overflow: auto;">
        <div class="row margin-l" style="padding: 1rem 1rem 0">
            <div class="col fs-5 fw-bold">
                연간 배출량 추이 모니터링 <br>
                <span style="color: red; font-size: 0.8rem; font-weight: normal;">* 참고용 데이터로 실제 배출량과 상이할 수 있습니다.</span>
            </div>
            <div class="col text-end">
                <c:choose>
                    <c:when test="${not empty emissionSettingList}">
                        <span class="text-primary" style="font-size: 0.8rem"> * 매일 자정 전일데이터 기준으로 업데이트 됩니다.</span>
                    </c:when>
                </c:choose>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty emissionSettingList}">
                <div class="row pb-3 margin-l" style="height: 230px">
                <c:choose>
                    <c:when test="${place_count eq 0}">
                        <div class="col align-self-center text-center" style="font-size: 1.2rem">
                            모니터링 중인 측정소가 없습니다.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="col align-self-center text-center" style="font-size: 1.2rem">
                            연간 배출량 추이 모니터링 설정된 센서가 없습니다. <br>
                            <c:choose>
                                <c:when test="${member.state eq 1}">
                                    <b>[환경설정 - 배출량 관리] > 배출량 추이 모니터링 대상 설정 설정</b>에서 모니터링 대상가스를 선택해주세요.<br>
                                    <a href="<%=cp%>/emissionsManagement">모니터링 대상 설정</a>
                                </c:when>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>
                </div>
            </c:when>
            <c:when test="${fn:length(emissionList.get(0)) eq 0}">
                <div class="row pb-3 margin-l" style="height: 230px">
                    <div class="col align-self-center text-center" style="font-size: 1.2rem">
                        업데이트 된 데이터가 없습니다. <br>
                        <b>연간 배출량 추이 모니터링은 매일 자정 업데이트됩니다.</b>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="emissionList" items="${emissionList}">
                    <c:set var="present" value="${emissionList.get(0)}"></c:set>
                    <c:set var="past" value="${emissionList.get(1)}"></c:set>
                    <c:set var="date" value="<%=new java.util.Date()%>"></c:set>
                    <c:choose>
                        <c:when test="${(date.month+1 > 0) and (date.month+1) < 4}">
                            <c:set var="presentQuater" value="${present.firstQuarter}"/>
                            <c:set var="pastQuater" value="${past.firstQuarter}"/>
                            <c:set var="quarter" value="1"/>
                        </c:when>
                        <c:when test="${(date.month+1 > 3) and (date.month+1) < 7}">
                            <c:set var="presentQuater" value="${present.secondQuarter}"/>
                            <c:set var="pastQuater" value="${past.secondQuarter}"/>
                            <c:set var="quarter" value="2"/>
                        </c:when>
                        <c:when test="${(date.month+1 > 6) and (date.month+1) < 10}">
                            <c:set var="presentQuater" value="${present.thirdQuarter}"/>
                            <c:set var="pastQuater" value="${past.thirdQuarter}"/>
                            <c:set var="quarter" value="3"/>
                        </c:when>
                        <c:when test="${date.month+1 > 9}">
                            <c:set var="presentQuater" value="${present.fourthQuarter}"/>
                            <c:set var="pastQuater" value="${past.fourthQuarter}"/>
                            <c:set var="quarter" value="4"/>
                        </c:when>
                    </c:choose>
                    <div class="row pb-3 margin-l">
                        <div class="row" style="margin-bottom: 15px;">
                            <div style="display: flex;">
                                <div class="fs-6 fw-bold" style="width: 50%">${present.placeName} - ${present.sensorName}</div>
                                <span class="small" style="width: 50%; text-align: right">업데이트 : <span class="fw-bold"><fmt:formatDate value="${present.updateTime}" pattern="yyyy-MM-dd"/></span></span>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="card border-2 border-primary" style="height: 218px;">
                                <div class="card-body m-fs">
                                    <h5 class="card-title small fw-bold fs-6">연간 대기 배출량 추이(%)</h5>
                                    <div class="d-flex justify-content-center re-pa" style="padding: 1rem 1rem 0;">
                                        <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                                        <p class="fw-bold fs-3">
                                            <c:choose>
                                                <c:when test="${past.totalEmissions == 0 and present.totalEmissions == 0}">0%</c:when>
                                                <c:when test="${past.totalEmissions == 0}">
                                                    <fmt:formatNumber value="${present.totalEmissions}" pattern=",000"/>%
                                                    <span style="font-size: 0.8rem" class="text-danger">증가</span>
                                                </c:when>
                                                <c:when test="${past.totalEmissions == present.totalEmissions }">0%</c:when>
                                                <c:otherwise>
                                                    <c:set var="totalPercent" value="${(present.totalEmissions - past.totalEmissions) / past.totalEmissions * 100}"></c:set>
                                                    <fmt:formatNumber value="${totalPercent}" pattern=".0"/>%
                                                    <c:choose>
                                                        <c:when test="${totalPercent > 0}">
                                                            <span style="font-size: 0.8rem" class="text-danger">증가</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="font-size: 0.8rem" class="text-primary">감소</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <hr class="text-primary m-0">
                                    <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                                        <div class="fw-bold text-center">
                                            <p class="m-0 text-center text-primary">
                                                <fmt:formatNumber value="${present.totalEmissions}" pattern=",000"/></p>
                                            <p class="year" style="display: inline-block;">${present.year}년</p> 현재 배출량
                                        </div>
                                        <p class="fs-3" style="margin: 0 0.5rem 0;">/</p>
                                        <div class="fw-bold text-center">
                                            <p class="m-0 text-center">
                                                <fmt:formatNumber value="${past.totalEmissions}" pattern=",000"/></p>
                                            <p class="year" style="display: inline-block;">${past.year}년</p> 총 배출량
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="card border-2 border-primary" style="height: 218px;">
                                <div class="card-body m-fs">
                                    <h5 class="card-title small fw-bold fs-6">연간 대기 배출량 추이(kg)</h5>
                                    <div class="d-flex justify-content-center re-pa" style="padding: 1rem 1rem 0;">
                                        <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                                        <p class="fw-bold fs-3">
                                            <c:set var="totalNum" value="${present.totalEmissions - past.totalEmissions}"></c:set>
                                            <c:choose>
                                                <c:when test="${totalNum == 0}">
                                                   0
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${totalNum}" pattern=",000"/>
                                                    <c:choose>
                                                        <c:when test="${totalNum > 0}">
                                                            <span style="font-size: 0.8rem" class="text-danger">증가</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="font-size: 0.8rem" class="text-primary">감소</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <hr class="text-primary m-0">
                                    <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                                        <div class="fw-bold text-center">
                                            <p class="m-0 text-center text-primary">
                                                <fmt:formatNumber value="${present.totalEmissions}" pattern=",000"/></p>
                                            <p class="year" style="display: inline-block;">${present.year}년</p> 현재 배출량
                                        </div>
                                        <p class="fs-3 mx-2">/</p>
                                        <div class="fw-bold text-center">
                                            <p class="m-0 text-center">
                                                <fmt:formatNumber value="${past.totalEmissions}" pattern=",000"/></p>
                                            <p class="year" style="display: inline-block;">${past.year}년</p> 총 배출량
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="card border-2 border-primary" style="height: 218px;">
                                <div class="card-body m-fs">
                                    <h5 class="card-title small fw-bold fs-6">분기별 대기 배출량 추이(%)</h5>
                                    <div class="d-flex justify-content-center re-pa" style="padding: 1rem 1rem 0;">
                                        <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                                        <p class="fw-bold fs-3">
                                            <c:choose>
                                                <c:when test="${pastQuater == 0 and presentQuater == 0}">0</c:when>
                                                <c:when test="${pastQuater == 0}">
                                                    <fmt:formatNumber value="${presentQuater}" pattern=",000"/>%
                                                    <span style="font-size: 0.8rem" class="text-danger">증가</span>
                                                </c:when>
                                                <c:when test="${pastQuater == presentQuater }">0%</c:when>
                                                <c:otherwise>
                                                    <c:set var="quaterPercent" value="${(presentQuater - pastQuater) / pastQuater * 100}"></c:set>
                                                    <fmt:formatNumber value="${quaterPercent}" pattern=".0"/>%

                                                    <c:choose>
                                                        <c:when test="${quaterPercent > 0}">
                                                            <span style="font-size: 0.8rem" class="text-danger">증가</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="font-size: 0.8rem" class="text-primary">감소</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>

                                            </c:choose>
                                        </p>
                                    </div>
                                    <hr class="text-primary m-0">
                                    <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                                        <div class="fw-bold text-center">
                                            <p class="m-0 text-center text-primary"><fmt:formatNumber value="${presentQuater}" pattern=",000"/></p>
                                            <p class="year" style="display: inline-block;">${present.year}년</p> ${quarter}분기
                                        </div>
                                        <p class="fs-3 mx-2">/</p>
                                        <div class="fw-bold text-center">
                                            <p class="m-0 text-center"><fmt:formatNumber value="${pastQuater}" pattern=",000"/></p>
                                            <p class="year" style="display: inline-block;">${past.year}년</p> ${quarter}분기
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="card border-2 border-primary" style="height: 218px;">
                                <div class="card-body m-fs">
                                    <h5 class="card-title small fw-bold fs-6">분기별 대기 배출량 추이(kg)</h5>
                                    <div class="d-flex justify-content-center re-pa" style="padding: 1rem 1rem 0;">
                                        <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                                        <p class="fw-bold fs-3">
                                            <c:set var="quaterNum" value="${presentQuater - pastQuater}"></c:set>
                                            <c:choose>
                                                <c:when test="${quaterNum == 0}">
                                                    0
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${quaterNum}" pattern=",000"/>
                                                    <c:choose>
                                                        <c:when test="${quaterNum > 0}">
                                                            <span style="font-size: 0.8rem" class="text-danger">증가</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="font-size: 0.8rem" class="text-primary">감소</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <hr class="text-primary m-0">
                                    <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                                        <div class="fw-bold text-center">
                                            <p class="m-0 text-center text-primary"><fmt:formatNumber value="${presentQuater}" pattern=",000"/></p>
                                            <p class="year" style="display: inline-block;">${present.year}년</p> ${quarter}분기
                                        </div>
                                        <p class="fs-3 mx-2">/</p>
                                        <div class="fw-bold text-center">
                                            <p class="m-0 text-center"><fmt:formatNumber value="${pastQuater}" pattern=",000"/></p>
                                            <p class="year" style="display: inline-block;">${past.year}년</p> ${quarter}분기
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>


    <div class="row mt-4 bg-light margin-l pb-4" style="width: 98%; margin: 0.2rem; height: 390px; overflow: auto;">
        <div class="row margin-l" style="padding: 1rem 1rem 0">
            <div class="col fs-5 fw-bold">
                연간 배출량 누적 모니터링 <br>
                <span style="color: red; font-size: 0.8rem; font-weight: normal;">* 참고용 데이터로 실제 배출량과 상이할 수 있습니다.</span>
            </div>
            <div class="col text-end">
                <c:choose>
                    <c:when test="${not empty placeList}">
                        <span class="text-primary" style="font-size: 0.8rem"> * 매일 자정 전일데이터 기준으로 업데이트 됩니다.</span>
                    </c:when>
                </c:choose>
            </div>
        </div>

        <div class="row pb-1 px-3 margin-l">
            <c:forEach items="${placeList}" var="placelist" varStatus="i">
                <c:if test="${placeList.size() <= 3}">
                    <div class="col pt-1" id="div${i.index}">
                </c:if>
                <c:if test="${placeList.size() > 3}">
                    <div class="col-md-4 pt-1" id="div${i.index}" style="width: 33%;float: left;">
                </c:if>
                <p class="mb-2 fw-bold" style="margin-left: 10px; font-size: 1.2rem;">${placelist}</p>
                <c:forEach items="${sensorList}" var="emissions">
                    <c:if test="${emissions.place eq placelist}">
                        <div class="row pe-3 margin-l" style="justify-content: space-between">
                        <div class="fw-bold" style="margin-bottom: 2px; width: 50%; margin-top: 5px">${emissions.sensorNaming}</div>
                            <span class="small" style="width: 50%; text-align: right; margin-top: 5px">업데이트 : <span class="fw-bold"><fmt:formatDate value="${emissions.updateTime}" pattern="yyyy-MM-dd"/></span></span>
                        <c:forEach items="${standard}" var="standard">
                        <c:if test="${emissions.sensor eq standard.tableName}">
                            <c:if test="${standard.emissionsStandard ne '0'}"> <!--sensor = standard -->
                                <fmt:parseNumber var="emissionsStandard" integerOnly="true" value="${standard.emissionsStandard}"/>
                                <c:set var="percent" value="${(emissions.yearlyValue*100)/(emissionsStandard)}"/>
                                <fmt:parseNumber var="percent" integerOnly="true" value="${percent}"/>
                                <div class="rounded" style="padding: 10px; background-color: #e5e5e5; margin-top: 5px">
                                    <div style="display: flex">
                                        <div class="progress" style="height: 24px; width: 100%;">
                                            <c:choose>
                                            <c:when test="${percent le 50}">
                                                <div class="progress-bar progress-blue" role="progressbar" style="width:${percent}%;"
                                            </c:when>
                                            <c:when test="${percent le 80}">
                                                <div class="progress-bar progress-yellow" role="progressbar" style="width: ${percent}%;"
                                            </c:when>
                                            <c:when test="${percent gt 80}">
                                                <div class="progress-bar progress-red" role="progressbar" style="width: ${percent}%;"
                                            </c:when>
                                            </c:choose>
                                                 aria-valuenow="${percent}" aria-valuemin="0" aria-valuemax="100"><fmt:formatNumber value="${emissions.yearlyValue}" groupingUsed="true"/>
                                            </div>
                                        </div>
                                        <p style="margin-left: 10px; margin-bottom: 0;">${percent}%</p>
                                    </div>

                                    <div class="standard">
                                        <fmt:formatNumber value="${standard.emissionsStandard}" groupingUsed="true"/>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${standard.emissionsStandard eq '0' and (member.state == '1')}">
                                <div class="pb-4 text-center rounded" style="padding-top: 20px; background-color: #e5e5e5; margin-top: 5px">
                                    연간 배출 허용 기준 미등록 &nbsp;<br>
                                    <a onclick="standardModal(this)" class="small aTag_cursor" id="${standard.tableName}">등록하기</a>
                                </div>
                            </c:if>
                            <c:if test="${standard.emissionsStandard eq '0' and (member.state == '3' || member.state == '2')}">
                                <div class="pb-4 text-center">
                                    연간 배출 허용 기준 미등록 &nbsp;<br>
                                </div>
                            </c:if>
                            </c:if>
                        </c:forEach>
                        </div>
                    </c:if>
                </c:forEach>
                </div>

                <c:if test="${(i.index+1)%3!=0 && placeList.size() !=1}">
                    <div id="line${i.index}" style="width: 1px;float: right;background-color: black;padding: 0"></div>
                </c:if>
            </c:forEach>
            <c:if test="${empty placeList}">
                <c:choose>
                    <c:when test="${place_count eq 0}">
                    <div class="pt-4 pb-4" style="text-align: center;font-size: 1.2rem;">
                        모니터링 중인 측정소가 없습니다.
                    </div>
                    </c:when>
                    <c:otherwise>
                        <div class="pt-4 pb-4" style="text-align: center;font-size: 1.2rem;">
                            연간 배출량 누적 모니터링 설정된 센서가 없습니다. <br>
                            <c:choose>
                                <c:when test="${member.state eq 1}">
                                    <b>[환경설정 - 배출량 관리] > 연간 배출량 누적 모니터링 대상 설정</b>에서 모니터링 대상가스를 선택해주세요.<br>
                                    <a href="<%=cp%>/emissionsManagement">모니터링 대상 설정</a>
                                </c:when>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </div>

        <div class="row text-center center-position" style="width: auto;">
            <div class="progress-info">
                <div id="blue" class="align-self-center"></div> &emsp;0 ~ 50%
            </div>
            <div class="progress-info">
                <div id="yellow" class="align-self-center"></div> &emsp;50 ~ 80%
            </div>
            <div class="progress-info">
                <div id="red" class="align-self-center"></div> &emsp;80 ~ 100%
            </div>
        </div>
    </div>


    <div class="row mt-4 bg-light margin-l" style="width: 98%; margin: 0.2rem; height: 340px; overflow: auto;">
        <div class="row pb-0 margin-l"  style="padding: 1rem 1rem 0">
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
                    <div class="card-header">정상</div>
                    <div class="card-body" id="normal" style="min-height: 180px;">
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-success mb-3" style="min-height: 100%;">
                    <div class="card-header">관리기준 초과</div>
                    <div class="card-body" id="caution">
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-dark bg-warning mb-3" style="min-height: 100%;">
                    <div class="card-header">사내기준 초과</div>
                    <div class="card-body" id="warning">
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-danger mb-3" style="min-height: 100%;">
                    <div class="card-header">법적기준 초과</div>
                    <div class="card-body" id="danger">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        const placeListSize = "${placeList.size()}";
        for (let i=0; i<placeListSize; i++) {
            $('#line' + i).height($('#div' + i).height() / 1.5);
            $('#line' + i).css({"margin-top": ($('#div' + i).height() - $('#line' + i).height()) / 2 + "px"});
        }
        if(placeListSize==2) $('#line1').remove();
        excess();
    });

    function standardModal(obj) {
        Swal.fire({
            icon: 'warning',
            title: '등록 하기',
            html: '<b>[연간 배출 허용 기준 설정]</b> 페이지로 이동 하시겠습니까?',
            showCancelButton: true,
            confirmButtonColor: '#0C64E8',
            confirmButtonText: '이동',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {   //삭제 버튼 누를때
                location.href = '<%=cp%>/emissionsManagement?tableName=' + obj.getAttribute('id');
            }
        });
    }

    function excess() {
        addExcessData();
        setInterval(function () {
            addExcessData();
        }, 5000)
    }

    function addExcessData() {
        $("#normal").empty();
        $("#caution").empty();
        $("#warning").empty();
        $("#danger").empty();

        $.ajax({
            url: '<%=cp%>/getExcessSensor',
            dataType: 'json',
            async: false,
            success: function (data) {
                const arr = data.excess;

                if(arr != undefined){
                    $("#excess_update").text(moment(arr[0].up_time).format('YYYY-MM-DD HH:mm:ss'));

                    for(let i=0; i<arr.length; i++){
                        const excess = arr[i].classification;
                        const place = arr[i].place;
                        const naming = arr[i].naming;
                        const value = arr[i].value;

                        if(excess == "danger" ){
                            $("#danger").append("<h5>" + place + " - " + naming + " [" + value + "] </h5>");
                        }else if(excess == "warning"){
                            $("#warning").append("<h5>" + place + " - " + naming + " [" + value + "] </h5>");
                        }else if(excess == "caution"){
                            $("#caution").append("<h5>" + place + " - " + naming + " [" + value + "] </h5>");
                        }else if(excess == "normal"){
                            $("#normal").append("<h5>" + place + " - " + naming + " [" + value + "] </h5>");
                        }
                    }
                } else{
                    $("#excess_update").text("최근 5분 이내로 업데이트 된 데이터가 없습니다.");
                }

            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>