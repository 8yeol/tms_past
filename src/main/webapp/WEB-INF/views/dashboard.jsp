<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 3:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<script src="static/js/moment.min.js"></script>

<style>
    #blue {
        width: 20px;
        height: 15px;
        background: dodgerblue;
    }

    #yellow {
        width: 20px;
        height: 15px;
        background: yellow;
    }

    #red {
        width: 20px;
        height: 15px;
        background: orange;
    }

</style>

<div class="container">
    <div class="row m-3 mt-3 bg-light" style="height: 8%">
        <div class="row">
            <div class="col text-end pt-2">
                <span class="small">마지막 업데이트 : <span class="fw-bold" id="weather_update">업데이트 시간</span></span><br>
                <span class="text-primary" style="font-size: 15%"> * 1시간 단위로 업데이트 됩니다.</span>
            </div>
        </div>
        <div class="row">
            <div class="col">
                날씨 정보 추가
            </div>
        </div>
    </div>
    <%--
     <div class="row m-3 mt-3">
         <span class="fs-4">대시보드</span>
     </div>
    --%>
    <div class="row m-3 mt-3 bg-light h-25">
        <div class="row p-3 h-25">
            <div class="col fs-5 fw-bold">
                측정소 통합 모니터링 (질소산화물)
            </div>
            <div class="col text-end">
                <span class="small">마지막 업데이트 : <span class="fw-bold" id="integrated_update">업데이트 시간</span></span><br>
                <span class="text-primary" style="font-size: 15%"> * 매월 마지막 날 업데이트 됩니다.</span>
            </div>
        </div>
        <div class="row pb-3 h-75">
            <div class="col-3">
                <div class="card h-100">
                    <div class="card-body">
                        <h5 class="card-title small">연간 대기 배출량 추이(%)</h5>
                        <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                    </div>
                </div>
            </div>

            <div class="col-3 h-100">
                <div class="card h-100">
                    <div class="card-body">
                        <h5 class="card-title small">연간 대기 배출량 추이(mg/L)</h5>
                        <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                    </div>
                </div>
            </div>

            <div class="col-3 h-100">
                <div class="card h-100">
                    <div class="card-body">
                        <h5 class="card-title small">분기별 대기 배출량 추이(%)</h5>
                        <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                    </div>
                </div>
            </div>

            <div class="col-3 h-100">
                <div class="card h-100">
                    <div class="card-body">
                        <h5 class="card-title small">분기별 대기 배출량 추이(mg/L)</h5>
                        <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-3 mt-4 bg-light h-25">
        <div class="row p-3 h-25">
            <div class="col fs-5 fw-bold">
                연간 배출량 누적 모니터링
            </div>
            <div class="col text-end">
                <span class="small">마지막 업데이트 : <span class="fw-bold" id="accumulate_update">업데이트 시간</span></span><br>
                <span class="text-primary" style="font-size: 15%"> * 매일 자정 업데이트 됩니다.</span>
            </div>
        </div>
        <div class="row pb-3 px-3">
            <%--script--%>
            <div class="col">
                <p class="mb-3 fs-5">측정소 1</p>
                <div class="row ps-5 pe-5 pb-3">
                    <div class="col-2">
                        질소산화물
                    </div>
                    <div class="col">
                        <div class="progress h-100">
                            <div class="progress-bar" role="progressbar" style="width: 25%;" aria-valuenow="25"
                                 aria-valuemin="0" aria-valuemax="100">25%
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row ps-5 pe-5 pb-3">
                    <div class="col-2">
                        산소
                    </div>
                    <div class="col">
                        <div class="progress h-100">
                            <div class="progress-bar bg-warning" role="progressbar" style="width: 75%;"
                                 aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">75%
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row text-center">
            <hr>
            <div class="col">
                <div id="blue" class="align-self-center"></div> &emsp;0 ~ 50%
            </div>
            <div class="col">
                <div id="yellow" class="align-self-center"></div> &emsp;50 ~ 80%
            </div>
            <div class="col">
                <div id="red" class="align-self-center"></div> &emsp;80 ~ 100%
            </div>
        </div>
    </div>

    <div class="row m-3 mt-3 bg-light h-25">
        <div class="row p-3 pb-0">
            <div class="col fs-5 fw-bold">
                관리등급 초과 모니터링
            </div>
            <div class="col text-end">
                <span class="small">마지막 업데이트 : <span class="fw-bold" id="excess_update">업데이트 시간</span></span><br>
                <span class="text-primary" style="font-size: 15%"> * 5분 단위로 업데이트 됩니다.</span>
            </div>
        </div>
        <div class="row pb-3 h-75 pb-3">
            <div class="col">
                <div class="card text-white bg-primary mb-3 h-100">
                    <div class="card-header">정상</div>
                    <div class="card-body" id="normal">
                        <%--script--%>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-success mb-3 h-100">
                    <div class="card-header">관리기준 초과</div>
                    <div class="card-body" id="caution">
                        <%--script--%>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-dark bg-warning mb-3 h-100">
                    <div class="card-header">사내기준 초과</div>
                    <div class="card-body" id="warning">
                        <%--script--%>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card text-white bg-danger mb-3 h-100">
                    <div class="card-header">법적기준 초과</div>
                    <div class="card-body" id="danger">
                        <%--script--%>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<script>
    $(document).ready(function () {
        weather();
        integrated();
        accumulate();
        excess();
    });

    // 날씨 정보 출력 (처음 로딩될 때 한번, 그 후로 매 시간마다 실행)
    function weather() {
        $("#weather_update").text(moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));

    }

    function addWeatherData() {

        // 완료 후 업데이트 시간 표시
        $("#weather_update").text(moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));
    }

    // 측정소 통합 모니터링
    // DB 저장(매월 마지막날 Sheduler 돌려서 update)
    function integrated() {
        $("#integrated_update").text(moment(new Date()).subtract(1, 'months').endOf('month').format('YYYY-MM-DD'));
    }

    // 연간 배출량 누적 모니터링(매일 자정 페이지 새로고침)
    // DB 저장 (매일 일정시간에 Scheduler 돌려서 update)
    function accumulate() {
        $("#accumulate_update").text(moment(new Date()).format('YYYY-MM-DD'));
    }

    // 관리등급 초과 모니터링 (처음 로딩될 때 한번, 그 후로 매 5분마다 실행)
    function excess() {
        addExcessData();
        // 매 5분마다 실행되게 하는 평션
        const FIVE_MINUTES = 5 * 60 * 1000;
        const timeSinceBoundary = new Date() % FIVE_MINUTES;
        const timeToSetInterval = timeSinceBoundary === 0 ? 0 : (FIVE_MINUTES - timeSinceBoundary);
        setTimeout(function () {
            setInterval(function () {
                console.log(moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));
                addExcessData();
            }, FIVE_MINUTES);
        }, timeToSetInterval);
    }

    function addExcessData() {
        //for 문 돌려서 해당 항목 개수만큼 append
        $("#normal").empty();

        $("#normal").append("<h5 class='card-title'>normal</h5>");
        $("#caution").append("<h5 class='card-title'>caution</h5>");
        $("#warning").append("<h5 class='card-title'>warning</h5>");
        $("#danger").append("<h5 class='card-title'>danger</h5>");

        // 완료 후 업데이트 시간 표시
        $("#excess_update").text(moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));
    }

</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



