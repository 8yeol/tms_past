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

<script src="static/js/moment.min.js"></script>
<script src="static/js/sweetalert2.min.js"></script>

<style>
    #blue {
        width: 20px;
        height: 15px;
        background: #0C64E8;
        display: inline-block;
    }

    #yellow {
        width: 20px;
        height: 15px;
        background: #DB510B;
        display: inline-block;
    }

    #red {
        width: 20px;
        height: 15px;
        background: #D6032B;
        display: inline-block;
    }

    .progress-blue {
        background-color: #0C64E8;
    }

    .progress-yellow {
        background-color: #DB510B;
    }

    .progress-red {
        background-color: #D6032B;
    }

    .margin-l {
        margin-left: 0;
    }

    .card-body {
        border-radius: 5px;
    }

    .progress-info {
        width: 200px;
    }

    .center-position {
        position: relative;
        left: 25%;
    }


    .standard {
        text-align: right;
        font-size: 0.6rem;
        margin-top: 2px;
        padding-right: 25px;
    }

    .aTag_cursor:hover{
        cursor: pointer;
    }

    @media all and (max-width: 1399px) and (min-width: 1200px) {
        .center-position {left: 20%;}
    }

    @media all and (max-width: 1199px) and (min-width: 990px) {
        .center-position {left: 15%;}
    }

    @media all and (max-width: 989px) {
        .center-position {left: 3%;}
        .m-fs {font-size: 0.7rem !important;}
        .card-title {font-size:0.7rem !important;}
        .m-fs>div:nth-child(2)>p:nth-child(2) {font-size: 1.2rem;}

        h5 {font-size: 0.75rem;}
    }

</style>

<div class="container"  id="container">
    <div class="row m-3 mt-3 ms-1">
        <span class="fs-4 fw-bold">대시보드</span>
    </div>

    <div class="row m-3 mt-3 bg-white ms-1" style="width: 98%; height: 370px; overflow: auto;">
        <div class="row p-3 h-25 margin-l">
            <div class="col fs-5 fw-bold">연간 배출량 추이 모니터링</div>
            <div class="col text-end">
                <span class="small">마지막 업데이트 : <span class="fw-bold" id="integrated_update">업데이트 시간</span></span><br>
                <span class="text-primary" style="font-size: 0.8rem"> * 매월 마지막 날 업데이트 됩니다.</span>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty emissionSettingList}">
                <div class="row pb-3 margin-l" style="height: 230px">
                    <div class="col align-self-center text-center" style="font-size: 1.2rem">
                        측정소 통합 모니터링 설정된 센서가 없습니다. <br>
                        <b>[환경설정 - 배출량 관리] > 배출량 추이 모니터링 대상 설정 설정</b>에서 모니터링 대상가스를 선택해주세요.<br>
                        <a href="<%=cp%>/emissionsManagement">모니터링 대상 설정</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <c:choose>
                    <c:when test="${fn:length(emissionList.get(0)) > 0 || length(emissionList.get(1))}">
                        <div class="row pb-3 margin-l" style="height: 230px">
                            <div class="col align-self-center text-center" style="font-size: 1.2rem">
                                해당 측정소의 배출량 추이 데이터가 없습니다. <br>
                                배출량 추이 데이터는 매월 마지막 날 업데이트 됩니다.
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
                                    <div class="col">
                                        <div class="fs-6 fw-bold">${present.placeName} - ${present.sensorName}</div>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="card border-2 border-primary" style="height: 218px;">
                                        <div class="card-body m-fs">
                                            <h5 class="card-title small fw-bold fs-6">연간 대기 배출량 추이(%)</h5>
                                            <div class="d-flex justify-content-center" style="padding: 1rem 1rem 0;">
                                                <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                                                <p class="fw-bold fs-3"><fmt:formatNumber value="${(present.totalEmissions - past.totalEmissions) / past.totalEmissions * 100}" pattern=".00"/>%</p>
                                            </div>
                                            <hr class="text-primary m-0">
                                            <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                                                <div class="fw-bold">
                                                    <p class="m-0 text-center text-primary">
                                                        <fmt:formatNumber value="${present.totalEmissions}" pattern=",000"/></p>${present.year}년 현재 배출량
                                                </div>
                                                <p class="fs-3" style="margin: 0 0.5rem 0;">/</p>
                                                <div class="fw-bold">
                                                    <p class="m-0 text-center">
                                                        <fmt:formatNumber value="${past.totalEmissions}" pattern=",000"/></p>${past.year}년 총 배출량
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="card border-2 border-primary" style="height: 218px;">
                                        <div class="card-body m-fs">
                                            <h5 class="card-title small fw-bold fs-6">연간 대기 배출량 추이(mg/L)</h5>
                                            <div class="d-flex justify-content-center" style="padding: 1rem 1rem 0;">
                                                <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                                                <p class="fw-bold fs-3">
                                                    <fmt:formatNumber value="${present.totalEmissions - past.totalEmissions}" pattern=",000"/></p>
                                            </div>
                                            <hr class="text-primary m-0">
                                            <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                                                <div class="fw-bold">
                                                    <p class="m-0 text-center text-primary">
                                                        <fmt:formatNumber value="${present.totalEmissions}" pattern=",000"/></p>${present.year}년 현재 배출량
                                                </div>
                                                <p class="fs-3 mx-2">/</p>
                                                <div class="fw-bold">
                                                    <p class="m-0 text-center">
                                                        <fmt:formatNumber value="${past.totalEmissions}" pattern=",000"/></p>${past.year}년 총 배출량
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="card border-2 border-primary" style="height: 218px;">
                                        <div class="card-body m-fs">
                                            <h5 class="card-title small fw-bold fs-6">분기별 대기 배출량 추이(%)</h5>
                                            <div class="d-flex justify-content-center" style="padding: 1rem 1rem 0;">
                                                <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                                                <p class="fw-bold fs-3">
                                                    <fmt:formatNumber value="${(presentQuater - pastQuater) / pastQuater * 100}" pattern=".00"/>%</p>
                                            </div>
                                            <hr class="text-primary m-0">
                                            <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                                                <div class="fw-bold">
                                                    <p class="m-0 text-center text-primary"><fmt:formatNumber value="${presentQuater}" pattern=",000"/></p>
                                                        ${present.year}년 ${quarter}분기
                                                </div>
                                                <p class="fs-3 mx-2">/</p>
                                                <div class="fw-bold">
                                                    <p class="m-0 text-center"><fmt:formatNumber value="${pastQuater}" pattern=",000"/></p>
                                                        ${past.year}년 ${quarter}분기
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="card border-2 border-primary" style="height: 218px;">
                                        <div class="card-body m-fs">
                                            <h5 class="card-title small fw-bold fs-6">분기별 대기 배출량 추이(mg/L)</h5>
                                            <div class="d-flex justify-content-center" style="padding: 1rem 1rem 0;">
                                                <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                                                <p class="fw-bold fs-3"><fmt:formatNumber value="${presentQuater - pastQuater}" pattern=",000"/></p>
                                            </div>
                                            <hr class="text-primary m-0">
                                            <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                                                <div class="fw-bold">
                                                    <p class="m-0 text-center text-primary"><fmt:formatNumber value="${presentQuater}" pattern=",000"/></p>${present.year}년 ${quarter}분기
                                                </div>
                                                <p class="fs-3 mx-2">/</p>
                                                <div class="fw-bold">
                                                    <p class="m-0 text-center"><fmt:formatNumber value="${pastQuater}" pattern=",000"/></p>${past.year}년 ${quarter}분기
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="row mt-4 bg-light margin-l pb-4" style="width: 98%; margin: 0.2rem; height: 390px; overflow: auto;">
        <div class="row p-3 h-25 margin-l">
            <div class="col fs-5 fw-bold">
                연간 배출량 누적 모니터링
            </div>
            <div class="col text-end">
                <span class="small">마지막 업데이트 : <span class="fw-bold" id="accumulate_update">업데이트 시간</span></span><br>
                <span class="text-primary" style="font-size: 0.8rem"> * 매일 자정 업데이트 됩니다.</span>
            </div>
        </div>
        <div class="row pb-1 px-3 margin-l mt-3">
            <c:forEach items="${placeList}" var="placelist" varStatus="i">
                <c:if test="${placeList.size() <= 3}">
                    <div class="col pt-1" id="div${i.index}">
                </c:if>
                <c:if test="${placeList.size() > 3}">
                    <div class="col-md-4 pt-1" id="div${i.index}" style="width: 33%;float: left;">
                </c:if>
                <p class="mb-3 fw-bold" style="margin-left: 10px; font-size: 1.2rem;">${placelist}</p>
                <c:forEach items="${sensorList}" var="emissions">
                    <c:if test="${emissions.place eq placelist}">
                        <div class="row pe-3 margin-l">
                        <div class="fw-bold" style="margin-bottom: 2px;">${emissions.sensorNaming}</div>
                        <c:forEach items="${standard}" var="standard">
                        <c:if test="${emissions.sensor eq standard.tableName}">
                            <c:if test="${standard.emissionsStandard ne '0'}"> <!--sensor = standard -->
                                <fmt:parseNumber var="emissionsStandard" integerOnly="true" value="${standard.emissionsStandard}"/>
                                <c:set var="percent" value="${(emissions.yearlyValue*100)/(emissionsStandard)}"/>
                                <fmt:parseNumber var="percent" integerOnly="true" value="${percent}"/>
                                <div class="col">
                                    <div class="progress" style="height: 24px;">
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
                                </div>
                                ${percent}%
                                <div class="standard">
                                    <fmt:formatNumber value="${standard.emissionsStandard}" groupingUsed="true"/>
                                </div>
                            </c:if>
                            <c:if test="${standard.emissionsStandard eq '0' and (member.state == '1' || member.state == '2')}">
                                <div class="pb-4 text-center">
                                    연간 배출 허용 기준 미등록 &nbsp;<br>
                                    <a onclick="standardModal(this)" class="small aTag_cursor" id="${standard.tableName}">등록하기</a>
                                </div>
                            </c:if>
                            <c:if test="${standard.emissionsStandard eq '0' and (member.state == '3')}">
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
                <div class="pt-4 pb-4" style="text-align: center;font-size: 1.2rem;">
                    연간 배출량 누적 모니터링 설정된 센서가 없습니다. <br>
                    <b>[환경설정 - 배출량 관리] > 연간 배출량 누적 모니터링 대상 설정</b>에서 모니터링 대상가스를 선택해주세요.<br>
                    <a href="<%=cp%>/emissionsManagement">모니터링 대상 설정</a>
                </div>
            </c:if>
        </div>


        <div class="row pt-3 text-center margin-l center-position m-3" style="width: auto;">
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
        <div class="row p-3 pb-0 margin-l">
            <div class="col fs-5 fw-bold">
                관리등급 초과 모니터링
            </div>
            <div class="col text-end">
                <span class="small">마지막 업데이트 : <span class="fw-bold" id="excess_update">업데이트 시간</span></span><br>
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


<script>
    $(document).ready(function () {
        //div의 크기에 비례하는 라인높이, 마진값 계산후 적용
        for (let i=0; i<${placeList.size()}; i++) {
            $('#line' + i).height($('#div' + i).height() / 1.5);
            $('#line' + i).css({"margin-top": ($('#div' + i).height() - $('#line' + i).height()) / 2 + "px"});
        }
        const placeListSize = ${placeList.size()};
        if(placeListSize==2) $('#line1').remove();

        integrated();
        excess();

        $("#accumulate_update").text(moment(new Date()).format('YYYY-MM-DD'));
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

    // 연간 배출량 추이 모니터링
    // DB 저장(매월 마지막날 Sheduler 돌려서 update)
    function integrated() {
        $("#integrated_update").text(moment(new Date()).subtract(1, 'months').endOf('month').format('YYYY-MM-DD'));
    }

    // 관리등급 초과 모니터링 (처음 로딩될 때 한번, 그 후로 매 5분마다 실행) - 완료
    function excess() {
        addExcessData();
        // 매 5분마다(5분, 10분, 15분..) 실행되게 하는 평션
        /*
        const FIVE_MINUTES = 5 * 60 * 1000;
        const timeSinceBoundary = new Date() % FIVE_MINUTES;
        const timeToSetInterval = timeSinceBoundary === 0 ? 0 : (FIVE_MINUTES - timeSinceBoundary);
        setTimeout(function () {
            setInterval(function () {
                addExcessData();
            }, FIVE_MINUTES);
        }, timeToSetInterval);
        */
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
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



