<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">

<script src="static/js/vue.min.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/vue-apexcharts.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>
<script src="static/js/moment.min.js"></script>

<%-- export excel --%>
<script src="static/js/jszip.min.js"></script>
<script src="static/js/dataTables.buttons.min.js"></script>
<script src="static/js/buttons.html5.min.js"></script>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

<style>
    table#place-table thead, table#sensor-table thead { /* 테이블 제목 셀 배경, 글자색 설정 */
        background-color: #97bef8;
        color: #fff;
    }

    /* 데이터테이블 */
    table.dataTable {
        width:100% !important;
    }

    .toolbar {
        float: left;
    }

    .toolbar>b {
        font-size: 1.25rem;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button {
        box-sizing: border-box;
        display: inline-block;
        min-width: 1.5em;
        padding: 0.5em 1em;
        margin-left: 2px;
        text-align: center;
        text-decoration: none !important;
        cursor: pointer;
        *cursor: hand;
        color: #333 !important;
        border: 0px solid transparent;
        border-radius: 50px;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button.current,
    .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
        color: #fff !important;
        border: 0px;
        background: #97bef8;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button.disabled,
    .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:hover,
    .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:active {
        cursor: default;
        color: #666 !important;
        border: 1px solid transparent;
        background: transparent;
        box-shadow: none
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
        color: white !important;
        border: 0px;
        background: #254069;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button:active {
        outline: none;
        background-color: #2b2b2b;
        box-shadow: inset 0 0 3px #111
    }

    table#sensor-table thead, table#sensor-table-time thead { /* 테이블 제목 셀 배경, 글자색 설정 */
        background-color: #97bef8;
        color: #fff;
    }

    .bg-lightGray {
        background-color: lightgrey;
    }

    ul,ol {
        list-style: none;
    }

    #place_name>li.active {
        background-color: #fff;
        border-radius: 50px;
    }
    #place_name>li.active>span {
        font-weight: bold;
        color: #0d6efd;
    }

    .pos-a {
        position: absolute;
        right: 10px;
    }
    .buttons-excel {
        margin-left: 10px;
        background-color: #000;
        color: #fff;
        border: 0px;
        border-radius: 5px;
    }

    #sensor-table_wrapper {
        margin-bottom: 5px;
    }
    .titleSpan{
        background-color: #cbd1d9;
        color: #000;
    }
    .navPlace{
        margin-top: 32px;
        text-align: -webkit-center;
        background-color: #cbd1d9;
        margin-left: 0px;
    }
    .place-item{
        /*background-color: red;*/
        /*font-size: 80% !important;*/
        /*font-weight: bold;*/
    }
</style>

<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<script src="static/js/sweetalert2.min.js"></script>

<div class="container" style="padding-left: 0;">
    <div class="row">
        <div class="row bg-white sizing">
            <div class="col-md-2 rounded-0 pt-5 px-0 navPlace">
                <ul id="place_name"></ul>
            </div>
            <div class="col-md-10 bg-light rounded p-0" style="position: relative;">
                <div class="d-flex justify-content-end">
                    <span class="fs-7 mb-2" >업데이트 : <a id="update"></a></span>
                </div>
                <span class="fs-4 fw-bold d-flex justify-content-center titleSpan" id="title"></span>
                <div id="place_table" style="margin:0 10px 0;">
                    <div class="col text-end align-self-end mt-2 mb-1"><span class="text-primary" style="font-size: .875em; margin-right: 10px;"> * 항목 클릭시 해당 항목의 상세 데이터로 하단의 차트/표 변경</span></div>
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
                            <%--script--%>
                        </tbody>
                    </table>
                </div>
                <hr>
                <%-- 차트 --%>
                <div class="row" style="margin-left: 1px; padding-bottom: 15px;">
                    <div class="col">
                            <div class="d-flex justify-content-between">
                                <div class="d-flex radio">
                                    <span class="me-3 fs-5" id="radio_text" style="margin-left: 10px;"></span>
                                    <div class="align-self-end">
                                        <input class="form-check-input" type="radio" name="chartRadio" id="hour" checked>
                                        <label for='hour'>&nbsp;최근 1시간</label> &emsp;
                                        <input class="form-check-input" type="radio" name="chartRadio" id="day">
                                        <label for="day">&nbsp;최근 24시간</label>
                                    </div>
                                </div>
                                <span class="text-primary" style="font-size: .875em; margin-right: 10px;" id="textUpdate"> * 최근 1시간(실시간 업데이트)</span>
                            </div>
                          <div id="chart" style=" margin-right: 10px;"></div>
                        </div>
                </div>
                <%-- 차트의 데이터 테이블 --%>
                <div class="row ms-2 bg-white" style="padding-top: 15px;">
                    <div class="col">
                        <div class="d-flex fw-bold pos-a align-self-end">
                            <div style="color: #000;  margin-right:5px" >법적/사내/관리 기준 :</div>
                            <div id="standard_text" style="color: #000;"></div>
                        </div>
                        <%-- 차트의 데이터 테이블 --%>
                        <table id="sensor-table" class="table table-striped table-bordered table-hover text-center no-footer dataTable">
                            <thead>
                            <tr>
                                <th width="35%">측정시간</th>
                                <th width="30%">측정 값</th>
                                <th width="35%">관리 등급</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    var interval1, interval2;
    var chart;

    /**
     * 페이지 로딩시 측정소 선택 화면과 차트의 기본 틀을 생성하고
     * 선택된 측정소의 전체 센서 정보를 테이블 생성 및
     * 선택된 센서의 최근 1시간, 24시간 데이터로 차트 및 테이블 생성
     */
    $(document).ready(function () {
        draw_place_frame(); //페이지 로딩 시 측정소 선택 화면 생성
        chart = new ApexCharts(document.querySelector("#chart"), setChartOption()); //차트 틀 생성
        chart.render();
            
        /* URL로 파라미터 확인 (모니터링페이지에서 넘어온 경우 파라미터 있음)*/
        const url = new URL(window.location.href);
        const urlParams = url.searchParams;
        if(urlParams.has(('place')) && urlParams.has('sensor')){ //파라미터가 있을 때
            const place_name = urlParams.get('place'); //측정소명
            const sensor_naming = urlParams.get('sensor'); //센서명(한글)
            $("#"+place_name).addClass('active'); // 해당 측정소 선택됨 표시
            $('#title').text(place_name); // 해당 측정소명 텍스트 출력
            getPlaceAllSensorData(place_name, sensor_naming); //측정소의 항목 전체 데이터
        }else{ //파라미터가 없을 경우
            const place_name = $('#place_name > li').attr('id'); //기본값
            console.log(place_name);
            if(place_name != undefined){
                $("#place_name li").eq(0).addClass('active');
                $('#title').text(place_name);
                getPlaceAllSensorData(place_name); //측정소의 항목 전체 데이터
            }
        }
    }); //ready


    /**
     * 측정소명 클릭 이벤트(해당 측정소 조회)
     */
    $("#place_name").on('click', 'li', function () {
        const place_name = $(this).attr('id'); //선택된 측정소명
        $('#title').text(place_name); // 해당 측정소명 텍스트 출력
        $("#place_name li").removeClass('active'); // 해당 측정소 외 선택됨 제거
        $(this).addClass('active'); // 해당 측정소 선택됨 표시
        getPlaceAllSensorData(place_name); //측정소의 항목 전체 데이터
    });

    /**
     * 센서명 클릭 이벤트 (해당 센서 조회)
     */
    $("#place-tbody-table").on('click', 'tr', function(){
        const name = $(this).find('input').val(); //선택된 센서명
        sensor_data = getSensorData(name); //해당 센서 데이터
        getData2(sensor_data);
    });

    /**
     * 최근 1시간 or 최근 24시간(5분 단위 데이터) 클릭 이벤트 (조건에 맞는 해당 센서 조회)
     */
    $("input[name=chartRadio]").on('click' , function (){
        if(document.getElementsByName("chartRadio")[0].checked){ //최근 1시간 선택 시
            sensor_time_length = 1;
            $('#textUpdate').text("* 최근 1시간(실시간 업데이트)");
        }else{ //최근 24시간 선택 시
            sensor_time_length = 24;
            $('#textUpdate').text("* 최근 24시간(실시간 업데이트) - 5분 평균데이터");
            sensor_naming = $('#radio_text').text();
        }
        var temp = $("#place-tbody-table > tr > td:contains('" + sensor_naming + "')");
        if(temp.length != 0){
            sensor_name = temp[0].childNodes[1].value; //측정소 테이블로부터 센서명을 구함
            sensor_data = getSensorData(sensor_name);
            getData2(sensor_data);
        }
    });

    /**
     * 측정소의 항목 전체 데이터 조회 (최근데이터, 직전데이터, 기준값 등)
     */
    function getPlaceAllSensorData(place_name, sensor_naming){
        try{
            const place_data = getPlaceData(place_name); // 센서 데이터 (최근, 직전, 기준값, 한글명 등) 저장
            clearTimeout(interval1);
        if(place_data.length != 0){
            setTimeout(function interval_getData() { // $초 마다 업데이트
                for (var i = 0; i < place_data.length; i++) {
                    // 측정소의 센서별로 최근데이터와 기존데이터 비교하여 기존데이터 업데이트
                    var recentData = getSensorRecent(place_data[i].name)
                    if(place_data[i].up_time != recentData.up_time){
                        place_data[i].value = recentData.value;
                        place_data[i].up_time = recentData.up_time;
                        $('#update').text(moment(recentData.up_time).format('YYYY-MM-DD HH:mm:ss'));
                    }
                }
                draw_place_table(place_data); //측정소 테이블 생성(센서 데이터)
                interval1 = setTimeout(interval_getData, 50000);
            }, 0); //setTimeout
            if (!sensor_naming) {  //파라미터 없을 경우
                var sensor_data = place_data[0]; // 기본값
            } else {   // 파라미터 있을 경우
                for (var i = 0; i < place_data.length; i++) {
                    if (sensor_naming == place_data[i].naming) { // 측정소의 센서명과 파라미터로 넘어온 센서명 비교 작업
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
                $("#radio_text").text(sensor_data.naming); // 선택된 센서명 텍스트 출력
                    setTimeout(function interval_getData2() { //$초 마다 업데이트
                        // 센서의 최근데이터와 기존데이터 비교하여 기존데이터 업데이트
                        var sensor_data_list_recent = getSensorRecent(sensor_name);
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
                        interval2 = setTimeout(interval_getData2, 5000);
                    }, 0);
            }else{ // sensor_data_list (최근데이터) 가 없을 때
                if(sensor_data){
                    Swal.fire({
                        icon: 'warning',
                        title: '경고',
                        text: '최근 '+sensor_time_length+'시간의 결과가 없습니다.'
                    })
                    draw_sensor_table(sensor_data_list, sensor_data);
                    $("#radio_text").text(sensor_data.naming);
                    updateChart(sensor_data_list, sensor_data);
                }
            }
        }else{ // 측정소 데이터, 센서데이터가 없을 때
            $("#radio_text").text("-") ;
            $("#standard_text").text("");
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
            let result = new Array();
            $.ajax({
                url:'<%=cp%>/getPlaceSensor',
                dataType: 'json',
                data:  {"place": place},
                async: false,
                success: function (data) {
                    $.each(data, function (index, item) { //센서명(item) 으로 최근데이터, 직전데이터, 기준값 등
                        if(getSensorData(item)){
                            result.push(getSensorData(item));
                        }
                    })
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
    function getSensorData(sensor){
        let result;
        let sensorValue, sensorUptime, beforeValue;
        const monitor = getMonitoring(sensor);
        if(monitor === 'true'){
            const recentData = getSensorRecent(sensor); //최근데이터
            if(recentData == undefined){
                return null;
            }else{
                if(recentData.value == 0 || recentData.value == null){
                    recentData.value = "-";
                }else{
                    sensorValue = recentData.value;
                    sensorUptime = moment(recentData.up_time).format('YYYY-MM-DD HH:mm:ss');
                }
                const beforeData = getSensorBeforeData(sensor);  // 직전 데이터(up/down 표시하기 위함)
                if(beforeData.length == 0){
                    beforeValue = "-";
                }else{
                    beforeValue = beforeData[0].value;
                }
                const sensorInfo = getSensorInfo(sensor); //기준데이터, 센서한글명, 센서 모니터링
                const naming = sensorInfo.naming;
                const monitoring = sensorInfo.monitoring;
                const legalStandard = sensorInfo.legalStandard;
                const companyStandard = sensorInfo.companyStandard;
                const managementStandard = sensorInfo.managementStandard;

                result =({
                    naming: naming, name:sensor,
                    value:sensorValue, up_time: sensorUptime,
                    legalStandard: legalStandard, companyStandard: companyStandard, managementStandard: managementStandard,
                    beforeValue: beforeValue, monitoring: monitoring
                });
            }
        }else{ //모니터링 False 인 경우
            return null;
        }
        return result;
    }

    /**
     * 센서의 모니터링 상태값 리턴 (true , false)
     */
    function getMonitoring(sensor){
        let result;
        $.ajax({
            url:'<%=cp%>/getMonitoring',
            dataType: 'text',
            data:  {"name": sensor},
            async: false,
            success: function (data) {
                result = data;
            },
            error: function () {
                result = false;
            }
        });
        return result;
    }

    /**
     * 센서의 직전 데이터 리턴
     */
    function getSensorBeforeData(sensor) {
        let result = new Array();
        $.ajax({
            url: '<%=cp%>/getSensorBeforeData',
            dataType: 'json',
            data: {"sensor": sensor},
            async: false,
            success: function (data) { // from ~ to 또는 to-minute ~ nowData 또는 from ~ from+minute 데이터 조회
                result.push({up_time: data.up_time, value: data.value});
            },
            error: function (e) {
                // 조회 결과 없을 때 return [];
            }
        }); //ajax
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
                    result = {value: data.value, status: data.status, up_time:data.up_time};
                },
                error: function (e) {
                }
            });
        }
        return result;
    }

    /**
     *  센서의 기준값, 모니터링, 한글명 리턴
     */
    function getSensorInfo(sensor) {
        let result;
        $.ajax({
            url:'<%=cp%>/getSensorInfo',
            dataType: 'json',
            data: {"sensor": sensor},
            async: false,
            success: function (data) {
                result = data;
            },
            error: function (e) {
                /* 결과가 존재하지 않을 경우 센서명만 전달 */
                result = {"name": sensor, "naming": sensor,
                    "legalStandard": 999, "companyStandard": 999, "managementStandard": 999, "power": "off"}
            }
        });
        return result;
    }

    /**
     * 센서의 최근 1시간 / 24시간 데이터 리턴
     */
    function getSensor(sensor_name, hour) {
        let result = new Array();
        if(sensor_name==undefined){
            console.log('get sensor null 처리');
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
                            result.push({x: item.up_time, y: item.value});
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
    function draw_place_frame() {
        var placeName = getPlace(); // 전체 측정소 이름 구함 (조건:파워ON, 모니터링 True)
        for(var i=0; i<placeName.length; i++){
            $('#place_name').append("<li class='place-item btn d-block fs-3 mt-3 me-3' id='"+
                placeName[i]+"'>"+
                "<span>"+placeName[i]+"</span>"+
                "</li>"+
                "<hr style='height: 2px;'>");
        }
    }

    /**
     * 차트 기본 옵션
     */
    function setChartOption(){
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
                        speed: 1000
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
                enabled: false
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
        if(sensor_data_list != null){
            for(var i in sensor_data_list){
                arr.push(sensor_data_list[i].y);
            }
            var max = Math.max.apply(null, arr);
            var min = Math.min.apply(null, arr);
        }else{
            sensor_data_list = [];
        }
        if(sensor_data.length != 0){
            managementStandard = sensor_data.managementStandard;
            companyStandard = sensor_data.companyStandard;
            legalStandard = sensor_data.legalStandard;
        }else{
            managementStandard = 999;
            companyStandard = 999;
            legalStandard = 999;
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
                        offsetX: -970
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
                            offsetX: -970
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
                            offsetX: -970
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
                            return val.toFixed(2);
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

                    if(data[i].legalStandard == 999){
                        legalStandard = '-';
                    }else{
                        legalStandard = data[i].legalStandard;
                    }
                    if(data[i].companyStandard == 999){
                        companyStandard = '-';
                    }else{
                        companyStandard = data[i].companyStandard;
                    }
                    if(data[i].managementStandard == 999){
                        managementStandard = '-';
                    }else{
                        managementStandard = data[i].managementStandard;
                    }


                    newCeil0.innerHTML = data[i].naming+'<input type="hidden" value="'+ data[i].name+'">';
                    newCeil1.innerHTML = '<div class="bg-danger text-light">'+legalStandard+'</div>';
                    newCeil2.innerHTML = '<div class="bg-warning text-light">'+companyStandard+'</div>';
                    newCeil3.innerHTML = '<div class="bg-success text-light">'+managementStandard+'</div>';
                    newCeil4.innerHTML = draw_compareData((data[i].beforeValue).toFixed(2), (data[i].value).toFixed(2));

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
        if(beforeData > nowData){
            return '<i class="fas fa-sort-down fa-fw" style="color: blue"></i>' + nowData;
        } else if( nowData > beforeData) {
            return '<i class="fas fa-sort-up fa-fw" style="color: red"></i>' + nowData;
        } else{
            return nowData;
        }
    }

    /**
     * 센서 테이블 생성 (하단 테이블)
     */
    function draw_sensor_table(sensor_data_list, sensor_data) {
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
                arr.push({x:moment(sensor_data_list[i].x).format('YYYY-MM-DD HH:mm:ss'), y:(sensor_data_list[i].y).toFixed(2), z: standard});
            }
        }

        if(sensor_data != null){
            if(sensor_data.legalStandard == 999){
                legalStandard = '-';
            }else{
                legalStandard = sensor_data.legalStandard;
            }
            if(sensor_data.companyStandard == 999){
                companyStandard = '-';
            }else{
                companyStandard = sensor_data.companyStandard;
            }
            if(sensor_data.managementStandard == 999){
                managementStandard = '-';
            }else{
                managementStandard = sensor_data.managementStandard;
            }




            $("#standard_text").text(legalStandard+"/"+companyStandard+"/"+managementStandard+" mg/Sm³ 이하");
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
                "emptyTable": "센서 데이터가 없습니다.",
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
        value = (sensor_data_list_recent.value).toFixed(2);
        if(sensorData.legalStandard == 999){
            legalStandard = '-';
        }else{
            legalStandard = sensorData.legalStandard;
        }
        if(sensorData.companyStandard == 999){
            companyStandard = '-';
        }else{
            companyStandard = sensorData.companyStandard;
        }
        if(sensorData.managementStandard == 999){
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