<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 3:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />


<script src="static/js/apexcharts.min.js"></script>

<div class="container">
    <div class="row m-3">
        <div class="col fs-4 fw-bold">대시보드</div>
        <div class="col text-end"><h6 class="pt-3 mb-0 small">마지막 업데이트 : </h6></div>
    </div>

    <div class="row p-3 bg-light rounded">
        <div class="col-3 border-end">
            <small class="fw-bold">연간 대기 배출량 추이(%)</small> <br>
            <div class="text-center">
                <span class="border-bottom pb-2"><smail>전년 대비 </smail> <b class="fs-1">29.4%</b></span>
            </div>
        </div>
        <div class="col-3 border-end">
            <small class="fw-bold">연간 대기 배출량 추이(mg/L)</small> <br>
        </div>
        <div class="col-3 border-end">
            <small class="fw-bold">분기별 대기 배출량 추이(%)</small> <br>
        </div>
        <div class="col-3">
            <small class="fw-bold">분기별 대기 배출량 추이(mg/L)</small> <br>
        </div>
    </div>

    <div class="row p-3 mt-1 bg-light rounded">
        <div class="row">
            <div class="col fs-5 fw-bold">연간 배출량 초과 모니터링</div>
            <div class="col text-end"><h6 class="pt-2 mb-0 small">2021년 4월 14일 기준</h6></div>
        </div>
        <div class="row mt-2">
            <div class="col-3">
                <div id="chart"></div>
            </div>
            <div class="col-3">
                2
            </div>
            <div class="col-3">
                3
            </div>
            <div class="col-3">
                4
            </div>
            <div class="col-3">
                5
            </div>
        </div>
    </div>

    <div class="row p-3 mt-3 bg-light rounded">
        <div class="col">
            <span class="fs-5 fw-bold">가동률</span>
        </div>
        <div class="col">
            <span class="fs-5 fw-bold">실시간 알림 로그</span>
        </div>
    </div>
</div>

<script>

</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />