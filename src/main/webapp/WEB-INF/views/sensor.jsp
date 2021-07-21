<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="stylesheet" href="static/css/page/sensor.css">

<script src="static/js/vue.min.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/vue-apexcharts.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>
<script src="static/js/moment.min.js"></script>
<script src="static/js/jszip.min.js"></script>
<script src="static/js/dataTables.buttons.min.js"></script>
<script src="static/js/buttons.html5.min.js"></script>
<script src="static/js/sweetalert2.min.js"></script>

<div class="container"  id="container" style="padding-left: 0;">
    <div class="row bg-white sizing">
        <%-- 측정소 리스트 --%>
        <div class="col-md-2 rounded-0 pt-5 px-0 navPlace">
            <ul id="place_name">
                <c:forEach var="placeNames" items="${placeList}">
                    <li class='place-item btn d-block fs-3 mt-3 me-3<c:if test="${placeNames eq activePlace}"> active</c:if>' id='<c:out value="${placeNames}"/>'>
                        <span><c:out value='${placeNames}'/></span>
                    </li>
                    <hr style="height: 2px">
                </c:forEach>
            </ul>
        </div>
        <%-- 상단 테이블 --%>
        <div class="col-md-10 bg-light rounded p-0" style="position: relative;">
            <div class="d-flex justify-content-end">
                <span class="fs-7 mb-2" id="update">업데이트 : ${activeSensor.up_time}</span>
            </div>
            <span class="fs-4 fw-bold d-flex justify-content-center titleSpan" id="title">${activePlace}</span>
            <div id="place_table" style="margin:0 10px 0;">
                <div class="col text-end align-self-end mt-2 mb-1"><span class="text-primary" style="font-size: 0.8rem"> * 측정항목 클릭시 해당 항목의 상세 데이터로 하단의 차트/표가 변경됩니다.</span></div>
                <table class="table table-bordered table-hover text-center">
                    <thead>
                    <tr>
                        <th width="20%">항목</th>
                        <th width="15%">법적기준</th>
                        <th width="15%">사내기준</th>
                        <th width="15%">관리기준</th>
                        <th width="15%">측정값</th>
                        <th width="20%">관리등급</th>
                    </tr>
                    <thead>
                    <tbody id="place-tbody-table">
                    <c:forEach items="${sensor}" var="sensorList">
                        <c:choose>
                            <c:when test="${activeSensor.naming eq sensorList.naming}">
                        <tr class="rowSelected">
                            </c:when>
                            <c:otherwise>
                        <tr>
                            </c:otherwise>
                        </c:choose>
                            <td><c:out value="${sensorList.naming}"/><input type="hidden" value="<c:out value="${sensorList.name}"/>"> </td>
                            <td>
                                <c:choose>
                                    <c:when test="${sensorList.legalStandard eq 999999}">
                                        -
                                    </c:when>
                                    <c:when test="${sensorList.legalStandard ne 999999}">
                                    <div class="bg-danger text-light">
                                        <c:out value="${sensorList.legalStandard}"/>
                                    </div>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${sensorList.companyStandard eq 999999}">
                                        -
                                    </c:when>
                                    <c:when test="${sensorList.companyStandard ne 999999}">
                                    <div class="bg-warning text-light">
                                        <c:out value="${sensorList.companyStandard}"/>
                                    </div>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${sensorList.managementStandard eq 999999}">
                                        -
                                    </c:when>
                                    <c:when test="${sensorList.managementStandard ne 999999}">
                                    <div class="bg-success text-light">
                                        <c:out value="${sensorList.managementStandard}"/>
                                    </div>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${sensorList.value != 0}">
                                    <c:if test="${sensorList.beforeValue > sensorList.value}">
                                        <i class="fas fa-sort-down fa-fw" style="color: blue"></i><fmt:formatNumber value="${sensorList.value}" pattern=".00"/>
                                    </c:if>
                                    <c:if test="${sensorList.beforeValue < sensorList.value}">
                                        <i class="fas fa-sort-up fa-fw" style="color: red"></i><fmt:formatNumber value="${sensorList.value}" pattern=".00"/>
                                    </c:if>
                                </c:if>
                                <c:if test="${sensorList.value eq 0}">
                                    0.00
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${sensorList.value > sensorList.legalStandard}">
                                        <div class="bg-danger text-light">법적기준 초과</div>
                                    </c:when>
                                    <c:when test="${sensorList.value > sensorList.companyStandard}">
                                        <div class="bg-warning text-light">사내기준 초과</div>
                                    </c:when>
                                    <c:when test="${sensorList.value > sensorList.managementStandard}">
                                        <div class="bg-success text-light">관리기준 초과</div>
                                    </c:when>
                                    <c:when test="${sensorList.value <= sensorList.managementStandard}">
                                        정상
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <hr>
            <%-- 차트 --%>
            <div class="row" style="margin-left: 1px; padding-bottom: 15px;">
                <div class="col">
                    <div class="justify-content-between" style="position: relative;">
                        <div class="d-flex radio" style="width: 100%;">
                            <span class="me-3 fs-5" id="radio_text" style="margin-left: 10px; display: inline-block; width: 50%;">${activeSensor.naming}</span>
                            <div style="width: 50%; text-align: right; margin-right: 15px;">
                                <span>숫자표시</span>
                                <input class="form-check-input" type="radio" name="chartLabel" id="on" value="on">
                                <label for='on'>on</label>
                                <input class="form-check-input" type="radio" name="chartLabel" id="off" value="off" checked>
                                <label for="off">off&emsp;</label>
                                <span>|&emsp;최근</span>
                                <input class="form-check-input" type="radio" name="chartRadio" id="hour"  value="on" checked>
                                <label for='hour'>1시간</label>
                                <input class="form-check-input" type="radio" name="chartRadio" id="day" value="off">
                                <label for="day">24시간</label>
                            </div>
                        </div>
                        <span class="text-primary" style="font-size: 0.8rem; position: absolute; right: 15px;"> * 최근 1시간은 실시간, 최근 24시간은 5분평균 데이터로 실시간 업데이트됩니다.</span>
                    </div>
                    <div id="chart" style=" margin-right: 10px; margin-top: 20px;"></div>
                    <div id="noData"><p style="text-align:center; padding-top:150px;"></p></div>
                </div>
            </div>
            <%-- 하단 테이블 --%>
            <div class="row ms-2 bg-white" style="padding-top: 15px;">
                <div class="col">
                    <div class="d-flex fw-bold pos-a align-self-end" id="sensor-standard"></div>
                    <div class="col-md-12" style="position: relative">
                        <table id="sensor-table" class="table table-striped table-bordered table-hover text-center no-footer dataTable"></table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    var interval1, interval2, interval3;
    var chart;

    /**
     * 페이지 로딩시 측정소 선택 화면과 차트의 기본 틀을 생성하고
     * 선택된 측정소의 전체 센서 정보를 테이블 생성 및
     * 선택된 센서의 최근 1시간, 24시간 데이터로 차트 및 테이블 생성
     */
    $(document).ready(function() {
        if(getCookie("chartLabel") ==undefined){
            setCookie("chartLabel", true, 999);
        }
        if(getCookie("sensor_time_length") ==undefined){
            setCookie("sensor_time_length", 1, 999);
        }
        chartLabel = getCookie("chartLabel");
        if(chartLabel == "true"){
            $("input:radio[name='chartLabel']:radio[value='on']").prop("checked", true);
            $("input:radio[name='chartLabel']:radio[value='off']").prop("checked", false);
        }else{
            $("input:radio[name='chartLabel']:radio[value='on']").prop("checked", false);
            $("input:radio[name='chartLabel']:radio[value='off']").prop("checked", true);

        }
        sensor_time_length = getCookie("sensor_time_length");
        if(sensor_time_length == 1){
            $("input:radio[name='chartRadio']:radio[value='on']").prop("checked", true);
            $("input:radio[name='chartRadio']:radio[value='off']").prop("checked", false);
        }else{
            $("input:radio[name='chartRadio']:radio[value='on']").prop("checked", false);
            $("input:radio[name='chartRadio']:radio[value='off']").prop("checked", true);

        }

        var sensor_data_list = ${sensorData};
        var sensor_data = ${activeSensor};

        draw_sensor_table(sensor_data_list, sensor_data);
        if (sensor_data_list.length == 0){
            console.log("sensor_data is none");
            return;
        }
        chart = new ApexCharts(document.querySelector("#chart"), setChartOption(JSON.parse(chartLabel))); //차트 틀 생성
        chart.render();
        updateChart(sensor_data_list, sensor_data);
        draw_frame();
    }); //ready


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

    function draw_frame(){
        setTimeout( function draw_frame() {
            var placeName = getPlace();
            clearTimeout(interval3);
            if(placeName.length ==0){
                Swal.fire({icon: 'warning',title: '경고',text: '모니터링 설정된 측정소의 데이터가 없습니다.'});
                interval3 = setTimeout(draw_frame, 60000);
            }else{
                draw_place_frame(placeName);
                /* URL로 파라미터 확인 (모니터링페이지에서 넘어온 경우 파라미터 있음)*/
                const url = new URL(window.location.href);
                const urlParams = url.searchParams;
                if(urlParams.has('sensor')){ //파라미터가 있을 때
                    const sensorName = urlParams.get('sensor'); //센서명
                    placeName = getPlaceName(sensorName);
                    var existPlace = false;
                    $('#place_name li').each(function (index, elemnet) {
                        if(placeName == $(this).text()){
                            existPlace = true;
                        }
                    })
                    if(existPlace){
                        $("#"+placeName).addClass('active'); // 해당 측정소 선택됨 표시
                        $('#title').text(placeName); // 해당 측정소명 텍스트 출력
                        getPlaceAllSensorData(placeName, sensorName); //측정소의 항목 전체 데이터
                    }else{
                        const place_name = $('#place_name > li').attr('id'); //기본값
                        $("#place_name li").eq(0).addClass('active');
                        $('#title').text(place_name);
                        getPlaceAllSensorData(place_name); //측정소의 항목 전체 데이터
                    }
                }else{ //파라미터가 없을 경우
                    const place_name = $('#place_name > li').attr('id'); //기본값
                    if(place_name != undefined){
                        $("#place_name li").eq(0).addClass('active');
                        $('#title').text(place_name);
                        getPlaceAllSensorData(place_name); //측정소의 항목 전체 데이터
                    }
                }
            }
        }, 0);
    }

    /**
     * 측정소명 클릭 이벤트(해당 측정소 조회)
     */
    var debounce2 = null;
    $("#place_name").on('click', 'li', function () {
        const place_name = $(this).attr('id'); //선택된 측정소명
        $('#title').text(place_name); // 해당 측정소명 텍스트 출력
        $("#place_name li").removeClass('active'); // 해당 측정소 외 선택됨 제거
        $(this).addClass('active'); // 해당 측정소 선택됨 표시
        clearTimeout(debounce2);
        debounce2 = setTimeout(() => {
            getPlaceAllSensorData(place_name); //측정소의 항목 전체 데이터
        }, 300)

    });

    /**
     * 센서명 클릭 이벤트 (해당 센서 조회)
     */
    var debounce = null;
    $("#place-tbody-table").on('click', 'tr', function(){
        const name = $(this).find('input').val(); //선택된 센서명
        var trParent = $(this).parent();
        var parentChild = trParent.children();
        parentChild.removeAttr('class');
        $(this).addClass('rowSelected');
        sensor_data = getSensorData(name); //해당 센서 데이터
        clearTimeout(debounce);
        debounce = setTimeout(() => {
            getData2(sensor_data);
        }, 300)
    });
    /**
     *  숫자 표시 On / Off
     */
    $("input[name=chartLabel]").on('click' , function (){
        if(document.getElementsByName("chartLabel")[0].checked){ //off
            chartLabel = true;
        }else{ //최근 24시간 선택 시
            chartLabel = false;
        }
        setCookie("chartLabel", chartLabel, 999);
        chart.destroy();
        chart = new ApexCharts(document.querySelector("#chart"), setChartOption(chartLabel)); //차트 틀 생성
        chart.render();
        sensor_naming = $('#radio_text').text();
        var temp = $("#place-tbody-table > tr > td:contains('" + sensor_naming + "')");
        if(temp.length != 0){
            sensor_name = temp[0].childNodes[1].value; //측정소 테이블로부터 센서명을 구함
            sensor_data = getSensorData(sensor_name);
            getData2(sensor_data);
        }
    });

    /**
     * 최근 1시간 or 최근 24시간(5분 단위 데이터) 클릭 이벤트 (조건에 맞는 해당 센서 조회)
     */
    $("input[name=chartRadio]").on('click' , function (){
        if(document.getElementsByName("chartRadio")[0].checked){ //최근 1시간 선택 시
            sensor_time_length = 1;
            //$('#textUpdate').text("* 최근 1시간(실시간 업데이트)");
        }else{ //최근 24시간 선택 시
            sensor_time_length = 24;
            //$('#textUpdate').text("* 최근 24시간(실시간 업데이트) - 5분 평균데이터");
            sensor_naming = $('#radio_text').text();
        }
        setCookie("sensor_time_length", sensor_time_length, 999);
        var temp = $("#place-tbody-table > tr > td:contains('" + sensor_naming + "')");
        if(temp.length != 0){
            sensor_name = temp[0].childNodes[1].value; //측정소 테이블로부터 센서명을 구함
            sensor_data = getSensorData(sensor_name);
            getData2(sensor_data);
        }
    });

    /**
     * 센서명으로 측정소명 리턴
     */
    function getPlaceName(sensorName){
        var result;
        $.ajax({
            url: '<%=cp%>/getPlaceName',
            dataType: 'text',
            data:  {"tableName": sensorName},
            async: false,
            success: function (data) { //전체 측정소명
                result = data;
            }
        });
        return result;
    }

    /**
     * 측정소의 항목 전체 데이터 조회 (최근데이터, 직전데이터, 기준값 등)
     */
    function getPlaceAllSensorData(place_name, sensor_naming){
        try{
            const place_data = getPlaceData(place_name); // 센서 데이터 (최근, 직전, 기준값, 한글명 등) 저장
            clearTimeout(interval1);
            if(place_data.length != 0){
                setTimeout(function interval_getData() { // $초 마다 업데이트
                    var recentData = getPlaceData(place_name);
                    for(var i=0; i<recentData.length; i++){
                        if(place_data[i].up_time != recentData[i].up_time){
                            place_data[i].value = recentData[i].value;
                            place_data[i].up_time = recentData[i].up_time;
                        }
                    }
                    draw_place_table(place_data); //측정소 테이블 생성(센서 데이터)
                    interval1 = setTimeout(interval_getData, 5000);
                }, 0); //setTimeout
                if (!sensor_naming) {  //파라미터 없을 경우
                    var sensor_data = place_data[0]; // 기본값
                } else {   // 파라미터 있을 경우
                    for (var i = 0; i < place_data.length; i++) {
                        if (sensor_naming == place_data[i].name) { // 측정소의 센서명과 파라미터로 넘어온 센서명 비교 작업
                            var sensor_data = place_data[i];
                        }
                    }
                }
            }else{ // 센서데이터가 없거나 모니터링이 False 인 경우
                draw_place_table(null); // 측정소 테이블 생성(데이터없음)
                sensor_data = []; //센서데이터 [] 처리
            }
            getData2(sensor_data); //차트와 센서 테이블 생성
        }catch (e) {
            console.log(e);
        }
    }

    /**
     *  센서 데이터 (최근 1시간, 24시간)로 차트 및 테이블 생성
     */
    function getData2(sensor_data) {
        clearTimeout(interval2);
        if(sensor_data.length!=0){
            let sensor_name = sensor_data.name;
            let sensor_time_length;
            if(document.getElementsByName("chartRadio")[0].checked){ //최근 1시간
                sensor_time_length = 1;
            }else{ //최근 24시간
                sensor_time_length = 24;
                sensor_name = "RM05_"+sensor_name;
            }
            var sensor_data_list = getSensor(sensor_name, sensor_time_length); //센서 데이터 (최근 1시간, 24시간)
            var sensorDataLength = sensor_data_list.length;
            var dt = draw_sensor_table(sensor_data_list, sensor_data); // 센서 테이블 생성 (측정시간, 측정값, 관리등급)
            if(sensor_data_list.length != 0){
                $('#chart').show();
                $('#noData').css("height", "0px");
                $('#noData').hide();
                $("#radio_text").text(sensor_data.naming); // 선택된 센서명 텍스트 출력
                setTimeout(function interval_getData2() { //$초 마다 업데이트
                    // 센서의 최근데이터와 기존데이터 비교하여 기존데이터 업데이트
                    var sensor_data_list_recent = getSensorRecent(sensor_name);
                    $('#update').text("업데이트 : "+moment(sensor_data_list_recent.up_time).format('YYYY-MM-DD HH:mm:ss'));
                    if(sensor_data_list_recent.length != 0) { // null = []
                        if (sensor_data_list[sensor_data_list.length - 1].x != sensor_data_list_recent.up_time) {
                            sensor_data_list.push({
                                x: sensor_data_list_recent.up_time,
                                y: sensor_data_list_recent.value
                            });
                            sensor_table_update(dt, sensor_data_list_recent, sensor_data); //테이블 업데이트
                        }
                        updateChart(sensor_data_list, sensor_data); //차트 업데이트
                        if (sensor_data_list.length > sensorDataLength * 2) { //차트 초기화
                            sensor_data_list = getSensor(sensor_name, sensor_time_length);
                        }
                    }
                    var placeName = getPlace();
                    if($('#place_name > li').length != placeName.length){
                        $('#place_name').empty();
                        $('#place-tbody-table').empty();
                        draw_sensor_table(null);
                        updateChart(null, sensor_data);
                        $("#radio_text").text("-") ;
                        $("#standard_text").text("");
                        $("#unit_text").text("");
                        draw_frame();
                    }
                    interval2 = setTimeout(interval_getData2, 5000);
                }, 0);
            }else{ // sensor_data_list (최근데이터) 가 없을 때
                if(sensor_data){
                    Swal.fire({
                        icon: 'warning',
                        title: '경고',
                        text: '최근 '+sensor_time_length+'시간의 결과가 없습니다.'
                    })
                    // draw_sensor_table(sensor_data_list, sensor_data);
                    $("#radio_text").text(sensor_data.naming);
                    $('#chart').hide();
                    $('#noData').css("height", "350px");
                    $('#noData').css("background-color", "#F2F2F3");
                    $('#noData p').text("최근 데이터가 없습니다.");
                    $('#noData').show();
                }
            }
        }else{ // 측정소 데이터, 센서데이터가 없을 때
            $("#radio_text").text("-") ;
            $("#standard_text").text("");
            $("#unit_text").text("");
            draw_sensor_table(null);
            updateChart(null, sensor_data);
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
            success: function (data) { //전체 측정소명
                $.each(data, function (index, item) {
                    monitoring = item.monitoring;
                    if(monitoring || monitoring == 'true'){ //모니터링 True 인 측정소만 추가
                        placeName.push(item.name);
                    }else{
                        return [];
                    }

                });
            },
            error: function (request, status, error) {
            }
        });
        return placeName;
    }

    /**
     *  측정소명으로 센서데이터 (최근데이터, 직전데이터, 기준값 등) 리턴
     */
    function getPlaceData(place){
        var result = null;
        $.ajax({
            url:'<%=cp%>/getPlaceData',
            dataType: 'json',
            data:  {"place": place},
            async: false,
            success: function (data) {
                result = data;
            },
            error: function (e) {
            }
        });
        if(result.length != 0){
            return result;
        }else {
            Swal.fire({icon: 'warning', title: '경고', text: '모니터링 설정된 센서의 데이터가 없습니다.'});
            return [];
        }
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




    /**
     * 센서의 최근 1시간 / 24시간 데이터 리턴
     */
    function getSensor(sensor_name, hour) {
        let result = new Array();
        if(sensor_name==undefined){
            return null;
        }else{
            $.ajax({
                url:'<%=cp%>/getSensor',
                dataType: 'JSON',
                contentType: "application/json",
                data: {"sensor": sensor_name, "hour": hour},
                async: false,
                success: function (data) {
                    if(data.length != 0){
                        $.each(data, function (index, item) {
                            result.push({x: item.up_time, y: (item.value).toFixed(2)});
                        })
                    }else{
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
     * 페이지 로딩 시 측정소 선택 화면 생성
     */
    function draw_place_frame(placeName) {
        if(placeName.length != 0){
            $('#place_name').empty();
            for(var i=0; i<placeName.length; i++){
                $('#place_name').append("<li class='place-item btn d-block fs-3 mt-3 me-3'"+
                    "id='"+placeName[i]+"'>"+
                    "<span>"+placeName[i]+"</span>"+
                    "</li>"+
                    "<hr style='height: 2px;'>");
            }
        }
    }

    /**
     * 차트 기본 옵션
     */
    function setChartOption(chartLabel){
        options = {
            series: [{
                data: [],
            }],
            chart: {
                height: '400px',
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
                enabled: chartLabel,
                background: { //데이터 글자
                    enabled: true,
                    foreColor: 'black',
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
    function updateChart(sensor_data_list, sensor_data){
        // chart.resetSeries();
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

        chart.updateOptions({
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

    /**
     * 측정소 테이블 생성 (상단 테이블)
     */
    function draw_place_table(data){
        try{
            $('#place-tbody-table').empty();
            if(data == null){
                const innerHtml = '<tr><td colspan="6">'
                    +'<div onclick='+'event.cancelBubble=true'+'>'+'모니터링 설정된 센서의 데이터가 없습니다.'
                    +'</div></td></tr>';
                $('#place-tbody-table').append(innerHtml);
            }else{
                const tbody = document.getElementById('place-tbody-table');
                for(let i=0; i<data.length; i++){
                    const newRow = tbody.insertRow(tbody.rows.length);

                    const newCeil0 = newRow.insertCell(0);
                    const newCeil1 = newRow.insertCell(1);
                    const newCeil2 = newRow.insertCell(2);
                    const newCeil3 = newRow.insertCell(3);
                    const newCeil4 = newRow.insertCell(4);
                    const newCeil5 = newRow.insertCell(5);

                    if(data[i].legalStandard == 999999){
                        legalStandard = '-';
                        newCeil1.innerHTML = legalStandard;
                    }else{
                        legalStandard = data[i].legalStandard;
                        newCeil1.innerHTML = '<div class="bg-danger text-light">'+legalStandard+'</div>';
                    }
                    if(data[i].companyStandard == 999999){
                        companyStandard = '-';
                        newCeil2.innerHTML = companyStandard;
                    }else{
                        companyStandard = data[i].companyStandard;
                        newCeil2.innerHTML = '<div class="bg-warning text-light">'+companyStandard+'</div>';
                    }
                    if(data[i].managementStandard == 999999){
                        managementStandard = '-';
                        newCeil3.innerHTML = managementStandard;
                    }else{
                        managementStandard = data[i].managementStandard;
                        newCeil3.innerHTML = '<div class="bg-success text-light">'+managementStandard+'</div>';
                    }
                    var selectSensorName = $('#radio_text').text();
                    var sensorName = data[i].naming;
                    if(selectSensorName == sensorName){
                        newRow.setAttribute('class', 'rowSelected');
                    }
                    newCeil0.innerHTML = sensorName+'<input type="hidden" value="'+ data[i].name+'">';
                    newCeil4.innerHTML = draw_compareData(data[i].beforeValue, data[i].value);

                    if(data[i].value > data[i].legalStandard){
                        newCeil5.innerHTML =  '<div class="bg-danger text-light">'+"법적기준 초과"+'</div>';
                    } else if( data[i].value > data[i].companyStandard){
                        newCeil5.innerHTML =  '<div class="bg-warning text-light">'+"사내기준 초과"+'</div>';
                    } else if( data[i].value > data[i].managementStandard){
                        newCeil5.innerHTML =  '<div class="bg-success text-light">'+"관리기준 초과"+'</div>';
                    } else {
                        newCeil5.innerHTML =  "정상";
                    }
                }
            }
        }catch (e) {

        }
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
     * 센서 테이블 생성 (하단 테이블)
     */
    function draw_sensor_table(sensor_data_list, sensor_data) {
        var standard = "";
        $('#sensor-table').empty();
        $('#sensor-standard').empty();
        $('#sensor-table').append('<thead><td>측정 시간</td><td>측정 값</td><td>관리 등급</td></thead>');
        $('#sensor-standard').append('<div id="standard_text" style="color: #000;"></div><div id="unit_text" style="color: #000;"></div>');
        $("#sensor-table").DataTable().clear();
        $("#sensor-table").DataTable().destroy();
        if(sensor_data_list == null){
            arr = [];
        }else{
            var arr = new Array();
            for(var i=0; i<sensor_data_list.length; i++){
                if(sensor_data_list[i].y > sensor_data.legalStandard){
                    standard =  '<div class="bg-danger text-light">'+"법적기준 초과"+'</div>';
                }else if(sensor_data_list[i].y > sensor_data.companyStandard){
                    standard =  '<div class="bg-warning text-light">'+"사내기준 초과"+'</div>';
                }else if(sensor_data_list[i].y > sensor_data.managementStandard){
                    standard =   '<div class="bg-success text-light">'+"관리기준 초과"+'</div>';
                }else if(sensor_data_list[i].y <= sensor_data.managementStandard){
                    standard = "정상";
                }
                arr.push({x:moment(sensor_data_list[i].x).format('YYYY-MM-DD HH:mm:ss'), y:sensor_data_list[i].y, z: standard});
            }
        }
        if(sensor_data != null){
            if(sensor_data.legalStandard == 999999){
                legalStandard = '-';
            }else{
                legalStandard = sensor_data.legalStandard;
            }
            if(sensor_data.companyStandard == 999999){
                companyStandard = '-';
            }else{
                companyStandard = sensor_data.companyStandard;
            }
            if(sensor_data.managementStandard == 999999){
                managementStandard = '-';
            }else{
                managementStandard = sensor_data.managementStandard;
            }
            var unit;
            if(sensor_data.unit != "" && sensor_data.unit != null){
                unit = sensor_data.unit;
                $('#unit_text').text("[ 단위 : "+unit+ " ]");
                $('#standard_text').css("padding-right", "10px");
            }
            if(legalStandard != '-' || companyStandard != '-' || managementStandard != '-'){
                $("#standard_text").text("법적/사내/관리 기준 : "+legalStandard+"/"+companyStandard+"/"+managementStandard+" 이하");
            }
        }

        var dt = $('#sensor-table').dataTable({
            data: arr,
            columns:[
                {"data": "x"},
                {"data": "y"},
                {"data": "z"}
            ],
            "bStateSave": true,
            "stateSave" : true,
            "search": false,
            "searching": false,
            "bInfo": false,
            "ordering": true,
            "pagingType": 'numbers',
            "language": {
                "emptyTable": "최근 데이터가 없습니다.",
                "lengthMenu": "페이지당 _MENU_ 개씩 보기",
                "info": "현재 _START_ - _END_ / _TOTAL_건",
                "infoEmpty": "데이터 없음",
                "infoFiltered": "( _MAX_건의 데이터에서 필터링됨 )",
                "search": "에서 검색: ",
                "zeroRecords": "일치하는 데이터가 없어요.",
                "loadingRecords": "로딩중...",
                "processing":     "잠시만 기다려 주세요...",
                "paginate": {
                    "next": "다음",
                    "previous": "이전"
                }
            },
            dom: '<"toolbar">Bfrtip',
            buttons: [{
                extend: 'excelHtml5',
                autoFilter: true,
                sheetName: 'Exported data',
                text:'엑셀 다운로드',
                filename: function(){
                    const d = moment(new Date()).format('YYYYMMDDHHmmss');
                    return d + '_' + sensor_data.naming + '(' + sensor_data.name + ')';
                },
            }]
        });
        dt.fnSort([0,'desc']);
        $("div.toolbar").html('<b>상세보기</b>');
        return dt;
    }

    function sensor_table_update(table, sensor_data_list_recent, sensorData) {
        var dt = $('#sensor-table').DataTable();
        var pageNum = dt.page.info().page;
        upDate = moment(sensor_data_list_recent.up_time).format('YYYY-MM-DD HH:mm:ss');
        value = sensor_data_list_recent.value;
        if(sensorData.legalStandard == 999999){
            legalStandard = '-';
        }else{
            legalStandard = sensorData.legalStandard;
        }
        if(sensorData.companyStandard == 999999){
            companyStandard = '-';
        }else{
            companyStandard = sensorData.companyStandard;
        }
        if(sensorData.managementStandard == 999999){
            managementStandard = '-';
        }else{
            managementStandard = sensorData.managementStandard;
        }

        if(sensor_data_list_recent.value > sensorData.legalStandard){
            standard =  '<div class="bg-danger text-light">'+"법적기준 초과"+'</div>';
        } else if( sensor_data_list_recent.value > sensorData.companyStandard){
            standard =  '<div class="bg-warning text-light">'+"사내기준 초과"+'</div>';
        } else if( sensor_data_list_recent.value > sensorData.managementStandard){
            standard =   '<div class="bg-success text-light">'+"관리기준 초과"+'</div>';
        } else {
            standard =  "정상";
        }
        table.fnSort([0, 'desc']);
        firstData = new Date(table.fnGetData()[0].x);1
        lastData = new Date(table.fnGetData()[table.fnGetData().length-2].x);
        timeDiff = lastData-firstData
        if(timeDiff > 3600000 && timeDiff < 3660000 || timeDiff > 86400000 && timeDiff < 86700000){
            table.fnDeleteRow(0);
        }
        table.fnAddData([{'x':upDate, 'y': value, 'z':standard}]);
        table.fnPageChange(pageNum);
    }
</script>