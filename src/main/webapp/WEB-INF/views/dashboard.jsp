<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 3:55
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Date" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<script src="static/js/moment.min.js"></script>

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

    .h-px {
        height: 340px;
    }

    .standard {
        text-align: right;
        font-size: 0.6rem;
        margin-top: 2px;
        padding-right: 25px;
    }

    @media all and (max-width: 1399px) and (min-width: 1200px) {
        .center-position {
            left: 20%;
        }

        .h-px {
            height: 365px;
        }
    }

    @media all and (max-width: 1199px) and (min-width: 990px) {
        .center-position {
            left: 15%;
        }

        .h-px {
            height: 326px;
        }
    }

    @media all and (max-width: 989px) {
        .center-position {
            left: 3%;
        }
    }

</style>

<div class="container">
    <div class="row m-3 mt-3 ms-1">
        <span class="fs-4 fw-bold">대시보드</span>
    </div>

    <c:forEach var="ptmsList" items="${ptmsList}">

        <c:set var="present" value="${ptmsList.get(0)}"></c:set>
        <c:set var="past" value="${ptmsList.get(1)}"></c:set>
        <c:set var="date" value="<%=new java.util.Date()%>"></c:set>
        <c:choose>
            <c:when test="${(date.month+1 > 0) and (date.month+1) < 4}"><c:set var="presentQuater" value="${present.firstQuarter}"/><c:set var="pastQuater" value="${past.firstQuarter}"/></c:when>
            <c:when test="${(date.month+1 > 3) and (date.month+1) < 7}"><c:set var="presentQuater" value="${present.secondQuarter}"/><c:set var="pastQuater" value="${past.secondQuarter}"/></c:when>
            <c:when test="${(date.month+1 > 6) and (date.month+1) < 10}"><c:set var="presentQuater" value="${present.thirdQuarter}"/><c:set var="pastQuater" value="${past.thirdQuarter}"/></c:when>
            <c:when test="${date.month+1 > 9}"><c:set var="presentQuater" value="${present.fourthQuarter}"/><c:set var="pastQuater" value="${past.fourthQuarter}"/></c:when>
        </c:choose>

    <div class="row m-3 mt-3 bg-white ms-1 h-px" style="width: 98%;">
        <div class="row p-3 h-25 margin-l">
            <div class="col fs-5 fw-bold">측정소 통합 모니터링 (${present.sensorName})</div>
            <div class="col text-end">
                <span class="small">마지막 업데이트 : <span class="fw-bold" id="integrated_update">업데이트 시간</span></span><br>
                <span class="text-primary" style="font-size: 15%"> * 매월 마지막 날 업데이트 됩니다.</span>
            </div>
        </div>
        <div class="row pb-3 h-75 margin-l">

            <div class="col-3">
                <div class="card border-2 border-primary" style="height: 90%;">
                    <div class="card-body">
                        <h5 class="card-title small fw-bold fs-6">연간 대기 배출량 추이(%)</h5>
                        <div class="d-flex justify-content-center p-3">
                            <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                            <p class="fw-bold fs-3"><fmt:formatNumber value="${(present.totalEmissions - past.totalEmissions) / past.totalEmissions * 100}" pattern=".0"/>%</p>
                        </div>
                        <hr class="text-primary m-0">
                        <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                            <div class="fw-bold">
                                <p class="m-0 text-center text-primary"><fmt:formatNumber value="${present.totalEmissions}" pattern=",000"/></p>
                                ${present.year}년 현재 배출량
                            </div>
                            <p class="fs-3 mx-2">/</p>
                            <div class="fw-bold">
                                <p class="m-0 text-center"><fmt:formatNumber value="${past.totalEmissions}" pattern=",000"/></p>
                                ${past.year}년 총 배출량
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-3 h-100">
                <div class="card border-2 border-primary" style="height: 90%;">
                    <div class="card-body">
                        <h5 class="card-title small fw-bold fs-6">연간 대기 배출량 추이(mg/L)</h5>
                        <div class="d-flex justify-content-center p-3">
                            <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                            <p class="fw-bold fs-3"><fmt:formatNumber value="${present.totalEmissions - past.totalEmissions}" pattern=",000"/></p>
                        </div>
                        <hr class="text-primary m-0">
                        <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                            <div class="fw-bold">
                                <p class="m-0 text-center text-primary"><fmt:formatNumber value="${presentQuater}" pattern=",000"/></p>
                                    ${present.year} 년 현재 배출량
                            </div>
                            <p class="fs-3 mx-2">/</p>
                            <div class="fw-bold">
                                <p class="m-0 text-center"><fmt:formatNumber value="${pastQuater}" pattern=",000"/></p>
                                    ${past.year} 년 총 배출량
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-3">
                <div class="card border-2 border-primary" style="height: 90%;">
                    <div class="card-body">
                        <h5 class="card-title small fw-bold fs-6">분기별 대기 배출량 추이(%)</h5>
                        <div class="d-flex justify-content-center p-3">
                            <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                            <p class="fw-bold fs-3"><fmt:formatNumber value="${(presentQuater - pastQuater) / pastQuater * 100}" pattern=".0"/>%</p>
                        </div>
                        <hr class="text-primary m-0">
                        <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                            <div class="fw-bold">
                                <p class="m-0 text-center text-primary"><fmt:formatNumber value="${present.totalEmissions}" pattern=",000"/></p>
                                    ${present.year}년 2분기
                            </div>
                            <p class="fs-3 mx-2">/</p>
                            <div class="fw-bold">
                                <p class="m-0 text-center"><fmt:formatNumber value="${past.totalEmissions}" pattern=",000"/></p>
                                    ${past.year}년 2분기
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-3 h-100">
                <div class="card border-2 border-primary" style="height: 90%;">
                    <div class="card-body">
                        <h5 class="card-title small fw-bold fs-6">분기별 대기 배출량 추이(mg/L)</h5>
                        <div class="d-flex justify-content-center p-3">
                            <p class="fw-bold me-3" style="margin-top: 0.8rem;">전년대비</p>
                            <p class="fw-bold fs-3"><fmt:formatNumber value="${presentQuater - pastQuater}" pattern=",000"/></p>
                        </div>
                        <hr class="text-primary m-0">
                        <div class="d-flex justify-content-center mt-3" style="font-size: 13px">
                            <div class="fw-bold">
                                <p class="m-0 text-center text-primary"><fmt:formatNumber value="${presentQuater}" pattern=",000"/></p>
                                    ${present.year}년 2분기
                            </div>
                            <p class="fs-3 mx-2">/</p>
                            <div class="fw-bold">
                                <p class="m-0 text-center"><fmt:formatNumber value="${pastQuater}" pattern=",000"/></p>
                                    ${past.year}년 2분기
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </c:forEach>

    <div class="row mt-4 bg-light margin-l pb-4" style="width: 98%; margin: 0.2rem;">
        <div class="row p-3 h-25 margin-l">
            <div class="col fs-5 fw-bold">
                연간 배출량 누적 모니터링
            </div>
            <div class="col text-end">
                <span class="small">마지막 업데이트 : <span class="fw-bold" id="accumulate_update">업데이트 시간</span></span><br>
                <span class="text-primary" style="font-size: 15%"> * 매일 자정 업데이트 됩니다.</span>
            </div>
        </div>

        <div class="row pb-1 px-3 margin-l mt-3">
            <c:forEach items="${placelist}" var="placelist" varStatus="i">
            <div class="col-md-4 pb-5 pt-1">
                <p class="mb-3 fw-bold" style="margin-left: 10px; font-size: 1.2rem;">${placelist}</p>
                <c:forEach items="${sensorlist}" var="emissions">
                <c:if test="${emissions.place eq placelist}">
                <div class="row pe-3  margin-l">
                    <div class="fw-bold" style="margin-bottom: 2px;">
                            ${emissions.sensorNaming}
                    </div>
                    <c:forEach items="${standard}" var="standard">
                    <c:if test="${emissions.sensor eq standard.tableName}">
                    <c:if test="${standard.emissionsStandard ne '0'}"> <!--sensor = standard -->
                    <fmt:parseNumber var="emissionsStandard" integerOnly="true" value="${standard.emissionsStandard}"/>
                    <c:set var="percent" value="${(emissions.yearlyValue*100)/(emissionsStandard)}"/>
                    <fmt:parseNumber var="percent" integerOnly="true" value="${percent}"/>
                    <div class="col">
                        <div class="progress h-100">
                            <c:choose>
                            <c:when test="${percent le 50}">
                                <div class="progress-bar progress-blue" role="progressbar"
                                     style="width: <fmt:formatNumber value="${percent}"
                                                                     type="number"/>%;"
                            </c:when>
                            <c:when test="${percent le 80}">
                                <div class="progress-bar progress-yellow" role="progressbar"
                                     style="width: <fmt:formatNumber value="${percent}"
                                                                     type="number"/>%;"
                            </c:when>
                            <c:when test="${percent gt 80}">
                            <div class="progress-bar progress-red" role="progressbar"
                                 style="width: <fmt:formatNumber value="${percent}"
                                                                 type="number"/>%;"
                            </c:when>
                            </c:choose>
                                 aria-valuenow="<fmt:formatNumber value="${percent}" type="number"/>"
                                 aria-valuemin="0" aria-valuemax="100"><fmt:formatNumber
                                    value="${emissions.yearlyValue}" groupingUsed="true"/>
                            </div>
                        </div>
                    </div>
                        ${percent}%
                </div>
                <div class="standard">
                    <fmt:formatNumber
                            value="${standard.emissionsStandard}" groupingUsed="true"/>
                </div>
                </c:if>
                <c:if test="${standard.emissionsStandard eq '0' and (member.state == '4' || member.state == '3')}"> <!--sensor = standard -->
                <div class="pb-4 text-center">
                    연간 배출 허용 기준 미등록 &nbsp;<br>
                    <a href="/emissionsManagement?tableName=${standard.tableName}" class="small">등록하기</a>
                </div>
            </div>
            </c:if>
            </c:if>
            </c:forEach>
            </c:if>
            </c:forEach>
        </div>
        <!-- <div class="line"
        style="width: 1px; height: 70%; background-color: #a9a9a9; padding:0;position: relative; top: 60px;"></div>
        측정소가 많아져서 class='col-md-4' 을 주니 라인이 레이아웃을 망가뜨립니다. -->
        </c:forEach>

        <c:if test="${empty placelist}">
            <div class="pt-4 pb-4" style="text-align: center;font-size: 1.2rem;">
                연간 배출량 누적 모니터링 설정 된 센서가 없습니다. <br>
                <b>[환경설정 - 배출량 관리] > 연간 배출량 누적 모니터링 대상 설정</b>에서 모니터링 대상가스를 선택해주세요.
            </div>
        </c:if>
    </div>

    <div class="row text-center margin-l center-position">
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

<div class="row mt-4 bg-light margin-l h-px" style="width: 98%; margin: 0.2rem;">
    <div class="row p-3 pb-0 margin-l">
        <div class="col fs-5 fw-bold">
            관리등급 초과 모니터링
        </div>
        <div class="col text-end">
            <span class="small">마지막 업데이트 : <span class="fw-bold" id="excess_update">업데이트 시간</span></span><br>
            <span class="text-primary" style="font-size: 15%"> * 실시간으로 업데이트 됩니다.</span>
        </div>
    </div>
    <div class="row pb-3 h-75 pb-3 margin-l">
        <div class="col">
            <div class="card text-white bg-primary mb-3" style="min-height: 100%;">
                <div class="card-header">정상</div>
                <div class="card-body" id="normal">
                    <h5> 가동중인 센서가 없습니다.</h5>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card text-white bg-success mb-3" style="min-height: 100%;">
                <div class="card-header">관리기준 초과</div>
                <div class="card-body" id="caution">
                    <h5> 가동중인 센서가 없습니다.</h5>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card text-dark bg-warning mb-3" style="min-height: 100%;">
                <div class="card-header">사내기준 초과</div>
                <div class="card-body" id="warning">
                    <h5> 가동중인 센서가 없습니다.</h5>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card text-white bg-danger mb-3" style="min-height: 100%;">
                <div class="card-header">법적기준 초과</div>
                <div class="card-body" id="danger">
                    <h5> 가동중인 센서가 없습니다.</h5>
                </div>
            </div>
        </div>
    </div>
</div>
</div>

<script>
    $(document).ready(function () {
        integrated();
        excess();

        $("#accumulate_update").text(moment(new Date()).format('YYYY-MM-DD') + " 00:00");
        $('.line').eq($('.line').length - 1).remove();
    });

    // 측정소 통합 모니터링
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
        }, 1000)
    }

    function addExcessData() {
        // 정상 값이 필요 없으면 센서 목록 불러와서 5분전 데이터 계산해서 넣어주면 되는데, 정상 값도 필요하기 때문에 해당 로직으로 작성
        $.ajax({
            url: '<%=cp%>/getMonitoringSensorOn',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {},
            success: function (data) {
                for (let i = 0; i < data.length; i++) {
                    let tableName = data[i].name;
                    $.ajax({
                        url: '<%=cp%>/getSensorRecent',
                        dataType: 'json',
                        data: {"sensor": tableName},
                        async: false,
                        success: function (data) {
                            const now = moment();
                            const up_time = moment(new Date(data.up_time), 'YYYY-MM-DD HH:mm:ss');
                            const minutes = moment.duration(now.diff(up_time)).asMinutes();
                            const value = (data.value).toFixed(2);
                            let place; //측정소 명
                            if (minutes <= 5) {
                                $("#normal").empty();
                                $("#caution").empty();
                                $("#warning").empty();
                                $("#danger").empty();

                                $.ajax({
                                    url: '<%=cp%>/getReferenceValue',
                                    dataType: 'json',
                                    data: {"tableName": tableName},
                                    async: false,
                                    success: function (data) {
                                        $.ajax({
                                            url: 'getPlaceName',
                                            dataType: 'text',
                                            data: {"tableName": tableName},
                                            async: false,
                                            success: function (data) {
                                                place = data;
                                            },
                                            error: function (request, status, error) {
                                                console.log(error)
                                            }
                                        });

                                        if (value > data.legalStandard) {
                                            $("#danger").append("<h5>" + place + " - " + data.naming + " [" + value + "] </h5>");
                                        } else if (value > data.companyStandard) {
                                            $("#warning").append("<h5>" + place + " - " + data.naming + " [" + value + "] </h5>");
                                        } else if (value > data.managementStandard) {
                                            $("#caution").append("<h5>" + place + " - " + data.naming + " [" + value + "] </h5>");
                                        } else {
                                            $("#normal").append("<h5>" + place + " - " + data.naming + " [" + value + "] </h5>");
                                        }
                                    },
                                    error: function (request, status, error) {
                                        console.log(error)
                                    }
                                });
                            }
                            //$("#excess_update").text(moment(data.up_time).format('YYYY-MM-DD HH:mm:ss'));
                        },
                        error: function (request, status, error) {
                            console.log(error)
                        }
                    });
                }
            },
            error: function (request, status, error) {
                console.log(error)
            }
        })
        $("#excess_update").text(moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));
    }

</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



