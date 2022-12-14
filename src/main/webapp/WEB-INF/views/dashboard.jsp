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
<script src="static/js/lib/moment.min.js"></script>
<script src="static/js/lib/sweetalert2.min.js"></script>

<div class="container"  id="container">
    <div class="row m-3 mt-3 ms-1">
        <span class="fs-4 fw-bold">대시보드</span>
    </div>

    <div class="row m-3 mt-3 bg-white ms-1" style="width: 98%; height: 420px; overflow: auto;">
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
            <c:when test="${empty emissionList || fn:length(emissionList.get(0)) eq 0}">
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
                        <div class="row" style="margin-bottom: 5px">
                            <div style="display: flex;">
                                <div class="fs-6 fw-bold" style="width: 50%">${present.placeName} - ${present.sensorName}</div>
                                <span class="small" style="width: 50%; text-align: right">업데이트 : <span class="fw-bold">${present.updateTime}</span></span>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="card border-2 border-primary" style="height: 250px;  background: url(static/images/cardbodyBg.png) no-repeat center / cover; ">
                                <div class="card-body m-fs" style="padding: 0.5rem 1rem;">
                                    <h5 class="small fw-bold fs-6" style="display: flex; justify-content: space-between; border-bottom: 1px solid #0d6efd; padding: .5rem 0;">연간 배출량 추이 <span style="text-align: right; font-weight: normal; font-size: .8rem">단위 kg</span></h5>
                                    <div class="d-flex" style="flex-wrap: wrap; border-bottom: 1px solid #0d6efd">
                                        <p class="fw-bold fs-6" style="margin-left: 10px; margin-bottom: 0; height: fit-content">전년대비</p>
                                        <div class="fw-bold text-center" style="width: 100%; font-size: 3rem;">
                                            <p style="margin-bottom: 0px; line-height: 1.2;">
                                                <c:set var="totalNum" value="${present.totalEmissions - past.totalEmissions}"></c:set>
                                                <c:choose>
                                                    <c:when test="${totalNum == 0}">
                                                        <fmt:formatNumber value="${totalNum}" pattern=",###"/>
                                                        <span style="font-size: 1.2rem; margin-left: 10px" class="text-secondary"> (-) </span>
                                                    </c:when>
                                                    <c:when test="${totalNum > 0}">
                                                        <fmt:formatNumber value="${totalNum}" pattern=",###"/>
                                                        <span style="font-size: 1.2rem; margin-left: 10px" class="text-danger">증가</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${totalNum * -1}" pattern=",###"/>
                                                        <span style="font-size: 1.2rem; margin-left: 10px" class="text-primary">감소</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <p style="font-size: 1.1rem; text-align: center; height: 30px; margin: 5px auto 10px; line-height: 30px;">
                                            <c:choose>
                                                <c:when test="${past.totalEmissions == 0 and present.totalEmissions == 0}"> ( - ) </c:when>
                                                <c:when test="${past.totalEmissions == 0}">
                                                        ( <i class="fas fa-sort-up fa-fw" style="color: red"></i><fmt:formatNumber value="${present.totalEmissions}" pattern=",###"/> % )
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${totalNum > 0}">
                                                                ( <i class="fas fa-sort-up fa-fw" style="color: red"></i>
                                                                <fmt:formatNumber value="${(present.totalEmissions / past.totalEmissions * 100) - 100}" pattern=",###"/> % )
                                                        </c:when>
                                                        <c:when test ="${totalNum < 0}">
                                                                ( <i class="fas fa-sort-down fa-fw" style="color: blue"></i>
                                                                <fmt:formatNumber value="${ (totalNum * -1) / past.totalEmissions * 100 }" pattern=",###"/> % )
                                                        </c:when>
                                                        <c:otherwise>
                                                            ( - )
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-center" style="font-size: 14px; margin-top: 0.3rem">
                                        <div class="fw-bold text-center w-50">
                                            <p class="fs-5 m-0 text-center text-primary">
                                                <fmt:formatNumber value="${present.totalEmissions}" pattern=",###"/></p>
                                            <p class="year" style="display: inline-block;">${present.year}년 현재 배출량</p>
                                        </div>
                                        <div class="fw-bold text-center w-50">
                                            <p class="fs-5 m-0 text-center">
                                                <fmt:formatNumber value="${past.totalEmissions}" pattern=",###"/></p>
                                            <p class="year" style="display: inline-block;">${past.year}년 총 배출량</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-6">
                            <div class="card border-2 border-primary" style="height: 250px; background: url(static/images/cardbodyBg.png) no-repeat center / cover; ">
                                <div class="card-body m-fs" style="padding: 0.5rem 1rem;">
                                    <h5 class="small fw-bold fs-6" style="display: flex; justify-content: space-between; border-bottom: 1px solid #0d6efd; padding: .5rem 0;">분기별 배출량 추이 <span style="text-align: right; font-weight: normal; font-size: .8rem">단위 kg</span></h5>
                                    <div class="d-flex" style="flex-wrap: wrap; border-bottom: 1px solid #0d6efd">
                                        <p class="fw-bold fs-6" style="margin-left: 10px; margin-bottom: 0; height: fit-content">전년대비</p>
                                        <div class="fw-bold text-center" style="width: 100%; font-size: 3rem; ">
                                            <p style="margin-bottom: 0px; line-height: 1.2;">
                                                <c:set var="quaterNum" value="${presentQuater - pastQuater}"></c:set>
                                                <c:choose>
                                                    <c:when test="${quaterNum == 0}">
                                                        <fmt:formatNumber value="${quaterNum}" pattern=",###"/>
                                                        <span style="font-size: 1.2rem; margin-left: 10px" class="text-secondary"> (-) </span>
                                                    </c:when>
                                                    <c:when test="${quaterNum > 0}">
                                                        <fmt:formatNumber value="${quaterNum}" pattern=",###"/>
                                                        <span style="font-size: 1.2rem; margin-left: 10px" class="text-danger">증가</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${quaterNum * -1}" pattern=",###"/>
                                                        <span style="font-size: 1.2rem; margin-left: 10px" class="text-primary">감소</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>

                                            <p style="font-size: 1.1rem; text-align: center; height: 30px; margin: 5px auto 10px; line-height: 30px;">
                                                <c:choose>
                                                    <c:when test="${presentQuater == 0 and pastQuater == 0}"> ( - ) </c:when>
                                                    <c:when test="${pastQuater == 0}">
                                                        ( <i class="fas fa-sort-up fa-fw" style="color: red"></i><fmt:formatNumber value="${presentQuater}" pattern=",###"/> % )
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${quaterNum > 0}">
                                                                ( <i class="fas fa-sort-up fa-fw" style="color: red"></i>
                                                                <fmt:formatNumber value="${(presentQuater / pastQuater * 100) - 100}" pattern=",###"/> % )
                                                            </c:when>
                                                            <c:when test ="${quaterNum < 0}">
                                                                ( <i class="fas fa-sort-down fa-fw" style="color: blue"></i>
                                                                <fmt:formatNumber value="${ (quaterNum * -1) / pastQuater * 100 }" pattern=",###"/> % )
                                                            </c:when>
                                                            <c:otherwise>
                                                                ( - )
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>
                                    <hr class="text-primary m-0">
                                    <div class="d-flex justify-content-center" style="font-size: 14px; margin-top: 0.3rem">
                                        <div class="fw-bold text-center w-50">
                                            <p class="fs-5 m-0 text-center text-primary"><fmt:formatNumber value="${presentQuater}" pattern=",###"/></p>
                                            <p class="year" style="display: inline-block;">${present.year}년 ${quarter}분기</p>
                                        </div>
                                        <div class="fw-bold text-center w-50">
                                            <p class="fs-5 m-0 text-center"><fmt:formatNumber value="${pastQuater}" pattern=",###"/></p>
                                            <p class="year" style="display: inline-block;">${past.year}년 ${quarter}분기</p>
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

</div>

<script>
    $(document).ready(function () {
        const placeListSize = "${placeList.size()}";
        for (let i=0; i<placeListSize; i++) {
            $('#line' + i).height($('#div' + i).height() / 1.5);
            $('#line' + i).css({"margin-top": ($('#div' + i).height() - $('#line' + i).height()) / 2 + "px"});
        }
        if(placeListSize==2) $('#line1').remove();
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


</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>