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

<style>
    table#place-table thead, table#sensor-table thead { /* 테이블 제목 셀 배경, 글자색 설정 */
        background-color: #97bef8;
        color: #fff;
    }

    div.bg-skyblue { /* param.place 배경, 글자색 설정 */
        background-color: #094EB5;
        color: #fff;
    }
    .img{
        width: 10px;
        height: 10px;
        margin-right: 10px;
    }

    /* 데이터테이블 */
    table.dataTable {
        width:98% !important;
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

</style>

<style>
    table#sensor-table thead, table#sensor-table-time thead { /* 테이블 제목 셀 배경, 글자색 설정 */
        background-color: #97bef8;
        color: #fff;
    }

    .bg-grayblue { /* param.place 배경, 글자색 설정 */
        background-color: #EDF2F8;
    }

    .bg-lightGray {
        background-color: lightgrey;
    }

    ul,ol {
        list-style: none;
    }

    #place_name>li.active {
        background-color: #fff;
        border-radius: 100px;
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
    }

</style>


<div class="container">


    <div class="row">

        <div class="col-md-2 bg-lightGray rounded-0 pt-5 px-0" style="margin-top: 32px; text-align: -webkit-center;">
            <ul id="place_name">
                <c:forEach var="place" items="${place}" varStatus="cnt">
                    <li class="place-item btn bg-lightGray d-block fs-3 mt-3 me-3" id="${place.name}">
                        <span>${place.name}</span>
                    </li>
                    <hr style="height: 2px;">
                </c:forEach>
            </ul>
        </div>

        <div class="col-md-10 bg-light rounded p-0">
            <div class="d-flex justify-content-end bg-grayblue">
                <span class="fs-7 mb-2">업데이트 : </span>
                <span class="mb-2" id="update" style="margin-left: 5px;"></span>
            </div>

            <span class="fs-4 fw-bold d-flex justify-content-center bg-lightGray" id="title">temp</span>

            <div id="place_table">
                <table class="table table-bordered table-hover text-center" style="margin-top: 13px; text-align: center;">
                    <thead>
                    <tr>
                        <th>항목</th>
                        <th>법적기준</th>
                        <th>사내기준</th>
                        <th>관리기준</th>
                        <th>측정값</th>
                        <th>관리등급</th>
                    </tr>
                    <thead>
                    <tbody id="place-tbody-table"></tbody>
                </table>
            </div>
            <hr>

            <div class="d-flex justify-content-between">
                <div class="d-flex radio">
                    <span class="me-3" id="radio_text" style="margin-left: 10px;">센서명 - 최근 1시간 자료</span>
                    <input class="form-check-input" type="radio" name="chartRadio" id="hourRadio" checked >
                    <span class="me-2">1시간</span>
                    <input class="form-check-input" type="radio" name="chartRadio" id="dayRadio" >
                    <span>24시간</span>
                </div>

                <span style="margin-right: 10px;">* 5분 단위로 업데이트 됩니다.</span>
            </div>

            <%-- 차트 --%>
            <div id="chart" class="" style="margin: 0 10px;"></div>

            <hr>

            <%-- 차트의 데이터 테이블 --%>
            <div class="d-flex fw-bold pos-a" style="text-align: right;">
                <div style="color: #000;  margin-right:5px" >법적/사내/관리 기준 -</div>
                <div id="standard_text" style="color: #000;">100/85/70 mg/Sm³ 이하</div>
            </div>

            <%-- 차트의 데이터 테이블 --%>
            <table id="sensor-table" class="table-responsive bg-gradient col-md-12 mt-1">
                <thead>
                <tr>
                    <th>측정시간</th>
                    <th>측정 값</th>
                    <th>관리 등급</th>
                </tr>
                </thead>
            </table>
        </div>

    </div>

</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script>
    var place_table, sensor_table, sensor_chart;
    var interval1, interval2;
    var sensor_data;

    $(document).ready(function () {
        /* URI로부터 파라미터 확인 */
        var url = new URL(window.location.href);
        var urlParams = url.searchParams;
        if(urlParams.has(('place')) && urlParams.has('sensor')){ //place와 sensor 파라미터가 있을 경우
            var place_name = urlParams.get('place');
            var sensor_naming = urlParams.get('sensor');
            $("#"+place_name).addClass('active');
            $('#title').text(place_name);
            getData(place_name, sensor_naming);
        }else{ //파라미터가 없을 경우
            var place_name = "${place.get(0).name}"; // 기본값
            $("#place_name li").eq(0).addClass('active');
            $('#title').text(place_name);
            getData(place_name);
        }
    }); //ready

    /* 측정소 변경 이벤트 */
    $("#place_name").on('click', 'li', function () {
        var place_name = $(this).attr('id');
        $('#title').text(place_name);
        $("#place_name li").removeClass('active');
        $(this).addClass('active');
        getData(place_name);
    });


    /* 차트 1시간 / 하루 이벤트 */
    $("input[name=chartRadio]").on('click' , function (){
        if(sensor_data == null){
            var temp_sensor_data = place_table.row(0).data();
            getData2(temp_sensor_data);
        } else{
            getData2(sensor_data);
        }
    });

    /* 센서명 클릭 이벤트 */
    $("#place-tbody-table").on('click', 'tr', function(){
        const name = $(this).find('input').val();
        var sensor_data = getSensorData(name);
        getData2(sensor_data);
    });

    /* sansor_naming 받는 이유 - 모니터링 페이지로부터 파라미터로 전달될 경우 */
    function getData(place_name, sensor_naming){
        try{
            var place_data = getPlaceData(place_name); // 최근데이터, 60분전데이터, 정보
            place_table = draw_place_table(place_data);
            if(place_data.length != 0){
                setTimeout(function interval_getData() {
                    clearTimeout(interval1);
                    console.log("g1: "+interval1);
                    var place_data_recent = getPlaceData(place_name);
                    for (var i = 0; i < place_data.length; i++) {
                        if (place_data[i].up_time != place_data_recent[i].up_time) {
                            place_data[i].value = place_data_recent[i].value;
                            place_data[i].up_time = place_data_recent[i].up_time;
                            place_table = draw_place_table(place_data);
                        }
                    }
                    interval1 = setTimeout(interval_getData, 5000);
                }, 0);
                // $('#sensorInfo2').text("(경고:"+warning + "/ 위험:"+danger + ")");
                if(!sensor_naming){
                    var sensor_data = place_data[0];
                    getData2(sensor_data);
                }else{
                    for(var i=0; i<place_data.length; i++){
                        if(sensor_naming == place_data[i].naming){
                            var sensor_data = place_data[i];
                        }
                    }
                    getData2(sensor_data);
                }
            }else{
                clearTimeout(interval1);
                getData2(sensor_data);
            }
        }catch (e) {

        }
    }

    function getData2(sensor_data) {
        var textTime;
        if($("input[id=hourRadio]:radio" ).is( ":checked")){
            sensor_time_length = 60;
            textTime = "1시간";
        }else{
            sensor_time_length = 1440;
            textTime = "24시간";
        }
        try{
            var sensor_name = sensor_data.name;
            var sensor_time_length;

            var sensor_data_list = getSensor(sensor_name, "", "", sensor_time_length);

            draw_chart(sensor_data_list, sensor_data);
            draw_sensor_table(sensor_data_list);

            $("#radio_text").text(sensor_data.naming+ " - 최근 " + textTime + " 자료") ;
            $("#standard_text").text(sensor_data.legalStandard+"/"+sensor_data.companyStandard+"/"+sensor_data.managementStandard+" mg/Sm³ 이하");
            setTimeout(function interval_getData2() {
                clearTimeout(interval2);
                console.log("g2: "+interval2);
                var sensor_data_list_recent = getSensorRecent(sensor_name);
                if(sensor_data_list_recent.length != 0){ // null = []
                    if(sensor_data_list[0].x != sensor_data_list_recent.up_time){
                        sensor_data_list.unshift({x:sensor_data_list_recent.up_time, y: sensor_data_list_recent.value.toFixed(2), standard: sensor_data_list_recent.standard});
                        // sensor_data_list.pop();
                        draw_sensor_table(sensor_data_list);
                        draw_chart(sensor_data_list, sensor_data);
                    }
                }
                interval2 = setTimeout(interval_getData2, 5000);
            }, 0);

        }catch (e) {
            clearTimeout(interval2);
            draw_chart(null, null);
            draw_sensor_table(null);
            $("#radio_text").text(" - 최근 " + textTime + " 자료") ;
            $("#standard_text").text("");
        }

    }

    /* 센서 정보 조회 */
    function getSensorData(sensor){
        var getData;
        var Monitoring = getMonitoring(sensor);
        if(Monitoring){
            /* 센서의 최근 데이터 */
            var recentData = getSensorRecent(sensor);
            if(recentData.value == 0 || recentData.value == null){ //null 일때
                recentData.value = "-"; // "-" 출력(datatable)
            }else{
                sensorValue = recentData.value.toFixed(2);
                sensorUptime = moment(sensor.up_time).format('YYYY-MM-DD HH:mm:ss');
            }
            /* 센서의 이전 데이터*/
            var beforeData = getSensorBeforeData(sensor); //sensor 이전 데이터
            if(beforeData.length == 0){
                beforeValue = "-";
            }else{ // 최근데이터 존재하지 않을 경우 "-" 처리
                beforeValue = beforeData[0].value.toFixed(2);
            }


            var sensorInfo = getSensorInfo(sensor); //sensor 정보 데이터
            naming = sensorInfo.naming;
            monitoring = sensorInfo.monitoring;
            legalStandard = sensorInfo.legalStandard;
            companyStandard = sensorInfo.companyStandard;
            managementStandard = sensorInfo.managementStandard;
            if(recentData.value < companyStandard && recentData.value >= managementStandard){
                standard = "관리기준 초과";
            }else if(recentData.value< legalStandard && recentData.value >= companyStandard){
                standard = "사내기준 초과";
            }else if(recentData.value >= legalStandard){
                standard = "법적기준 초과";
            }else if(recentData.value < managementStandard){
                standard = "정상";
            }else{
                standard = "-";
            }

            getData =({
                naming: naming, name:sensor,
                value:sensorValue, up_time: sensorUptime,
                legalStandard: legalStandard, companyStandard: companyStandard, managementStandard: managementStandard,
                beforeValue: beforeValue, monitoring: monitoring, standard : standard
        });
        }
        return getData;
    }

    /* 측정소명으로 센서 조회*/
    function getPlaceData(place){
        var getData = new Array();
        $.ajax({
            url:'getPlaceSensor',
            dataType: 'json',
            data:  {"place": place},
            async: false,
            success: function (data) {
                $.each(data, function (index, item) { //item (센서명)
                    getData.push(getSensorData(item));
                })
            },
            error: function (e) {

            }
        }); //ajax
        return getData;
    }

    /* 센서명으로 최근 데이터 조회 */
    function getMonitoring(sensor){
        var getData;
        $.ajax({
            url:'getMonitoring',
            dataType: 'text',
            data:  {"name": sensor},
            async: false,
            success: function (data) {
                getData = data;
            },
            error: function (e) {
                // 결과가 존재하지 않을 경우 null 처리
                getData = false;
            }
        }); //ajax
        return getData;
    }

    /* 센서명 이전 데이터 조회 */
    function getSensorBeforeData(sensor) {
        let result = new Array();
        $.ajax({
            url: 'getSensorBeforeData',
            dataType: 'json',
            data: {"sensor": sensor},
            async: false,
            success: function (data) { // from ~ to 또는 to-minute ~ now 또는 from ~ from+minute 데이터 조회
                result.push({up_time: moment(data.up_time).format('YYYY-MM-DD HH:mm:ss'), value: data.value});
            },
            error: function (e) {
                // 조회 결과 없을 때 return [];
            }
        }); //ajax
        return result;
    }

    /* 센서명으로 최근 데이터 조회 */
    function getSensorRecent(sensor){
        var getData;
        $.ajax({
            url:'getSensorRecent',
            dataType: 'json',
            data:  {"sensor": sensor},
            async: false,
            success: function (data) {
                var sensorInfo = getSensorInfo(sensor);
                var legalStandard = sensorInfo.legalStandard;
                var companyStandard = sensorInfo.companyStandard;
                var managementStandard = sensorInfo.managementStandard;
                var standard;
                if(data.value < companyStandard && data.value >= managementStandard){
                    standard = "관리기준 초과";
                }else if(data.value< legalStandard && data.value >= companyStandard){
                    standard = "사내기준 초과";
                }else if(data.value >= legalStandard){
                    standard = "법적기준 초과";
                }else if(data.value < managementStandard){
                    standard = "정상";
                }else{
                    standard = "-";
                }
                getData = {value: data.value, status: data.status, up_time:moment(data.up_time).format('YYYY-MM-DD HH:mm:ss'), standard: standard};
            },
            error: function (e) {
                // 결과가 존재하지 않을 경우 null 처리
                getData = {value: null, status: false, up_time:null};
            }
        }); //ajax
        return getData;
    }

    /* 센서명으로 센서정보 조회 */
    function getSensorInfo(sensor) {
        var getData;
        $.ajax({
            url:'getSensorInfo',
            dataType: 'json',
            data: {"sensor": sensor},
            async: false,
            success: function (data) {
                // 데이터가 0 또는 null 일 경우 "-" 으로 치환
                if(data.legalStandard == 0 || data.legalStandard == null){
                    data.legalStandard = "-";
                }
                if(data.companyStandard == 0 || data.companyStandard == null){
                    data.companyStandard = "-";
                }
                if(data.managementStandard == 0 || data.managementStandard == null){
                    data.managementStandard = "-";
                }
                getData = data;
            },
            error: function (e) {
                /* 결과가 존재하지 않을 경우 센서명만 전달 */
                getData = {"name": sensor, "naming": sensor,
                    "legalStandard": "-", "companyStandard": "-", "managementStandard": "-", "power": "off"}
            }
        }); //ajax
        return getData;
    }


    /* 센서명으로 from, to, minute 의 조건에 맞는 from ~ to 센서의 데이터 조회 */
    function getSensor(sensor, from_date, to_date, minute) {
        var getData = new Array();
        $.ajax({
            url:'getSensor',
            dataType: 'json',
            data: {"sensor": sensor, "from_date": from_date, "to_date": to_date, "minute": minute},
            async: false,
            success: function (data) { // from ~ to 또는 to-minute ~ now 또는 from ~ from+minute 데이터 조회
                var sensorInfo = getSensorInfo(sensor);
                var legalStandard = sensorInfo.legalStandard;
                var companyStandard = sensorInfo.companyStandard;
                var managementStandard = sensorInfo.managementStandard;
                $.each(data, function (index, item) {
                    if(item.value < companyStandard && item.value >= managementStandard){
                        standard = "관리기준 초과";
                    }else if(item.value< legalStandard && item.value >= companyStandard){
                        standard = "사내기준 초과";
                    }else if(item.value >= legalStandard){
                        standard = "법적기준 초과";
                    }else if(item.value < managementStandard){
                        standard = "정상";
                    }else{
                        standard = "-";
                    }
                    getData.push({x: moment(item.up_time).format('YYYY-MM-DD HH:mm:ss'), y: item.value.toFixed(2), standard:standard });
                })
            },
            error: function (e) {
                // 조회 결과 없을 때 return [];
            }
        }); //ajax
        return getData;
    }


    /* draw sensor table */
    function draw_place_table(data){
        $('#place-tbody-table').empty();
        const tbody = document.getElementById('place-tbody-table');
        for(let i=0; i<data.length; i++){
            const newRow = tbody.insertRow(tbody.rows.length);
            const newCeil0 = newRow.insertCell(0);
            const newCeil1 = newRow.insertCell(1);
            const newCeil2 = newRow.insertCell(2);
            const newCeil3 = newRow.insertCell(3);
            const newCeil4 = newRow.insertCell(4);
            const newCeil5 = newRow.insertCell(5);

            newCeil0.innerHTML = data[i].naming+'<input type="hidden" value="'+ data[i].name+'">';
            newCeil1.innerHTML = '<div class="bg-danger text-light">'+data[i].legalStandard+'</div>';
            newCeil2.innerHTML = '<div class="bg-warning text-light">'+data[i].companyStandard+'</div>';
            newCeil3.innerHTML = '<div class="bg-success text-light">'+data[i].managementStandard+'</div>';
            newCeil4.innerHTML = draw_beforeData(data[i].beforeValue, data[i].value);
            newCeil5.innerHTML = data[i].standard;

            if(data[i].value > data[i].legalStandard){
                // newCeil4.innerHTML = '<span class="text-danger fw-bold">' + draw_beforeData(data[i].beforeValue, data[i].value) + '</span>';
                newCeil5.innerHTML =  '<div class="bg-danger text-light">'+data[i].standard+'</div>';
            } else if( data[i].value > data[i].companyStandard){
                // newCeil4.innerHTML = '<span class="text-warning fw-bold">' + draw_beforeData(data[i].beforeValue, data[i].value) + '</span>';
                newCeil5.innerHTML =  '<div class="bg-warning text-light">'+data[i].standard+'</div>';
            } else if( data[i].value > data[i].managementStandard){
                // newCeil4.innerHTML = '<span class="text-success fw-bold">' + draw_beforeData(data[i].beforeValue, data[i].value) + '</span>';
                newCeil5.innerHTML =  '<div class="bg-success text-light">'+data[i].standard+'</div>';
            }

            $('#update').text(data[i].up_time);
        }
    }

    function draw_beforeData(fiveMinutes , now){
        if(fiveMinutes > now){
            return '<img src="static/images/down.jpg" class="img">' + now;
        } else if( now > fiveMinutes) {
            return '<img src="static/images/up.png" class="img">' + now;
        } else{
            return ' - ' + now;
        }
    }

    /* draw sensor time table */
    function draw_sensor_table(sensor_data_list) {

        $("#sensor-table").DataTable().clear();
        $("#sensor-table").DataTable().destroy();

        $('#sensor-table').dataTable({
            data: sensor_data_list,
            columns:[
                {"data": "x"},
                {"data": "y"},
                {"data": "standard"}
            ],
            // aLengthMenu: [10, 25, 50],
            search: false,
            searching: false,
            bInfo: false,
            ordering: true,
            pagingType: 'numbers',
            order:[[0, 'desc']],
            /*'rowCallback': function(row, data, index){
                if(sensor_data.legalStandard != "-"){
                    if(data.y >= sensor_data.legalStandard){
                        $(row).find('td:eq(2)').css('color', '#ff9d5a');
                        $(row).find('td:eq(2)').css('font-weight', 'bold');
                    }
                }
                if(sensor_data.companyStandard != "-"){
                    if(data.y < sensor_data.legalStandard && data.y >= sensor_data.companyStandard){
                        $(row).find('td:eq(2)').css('color', '#ffc55a');
                        $(row).find('td:eq(2)').css('font-weight', 'bold');
                    }
                }
                if(sensor_data.managementStandard != "-"){
                    if(data.y <= sensor_data.companyStandard && data.y > sensor_data.managementStandard){
                        $(row).find('td:eq(2)').css('color', '#a2d674');
                        $(row).find('td:eq(2)').css('font-weight', 'bold');
                    }
                }
            },*/
            "language": {
                "emptyTable": "데이터가 없어요.",
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
            dom: 'Bfrtip',
            buttons: [{
                extend: 'excelHtml5',
                autoFilter: true,
                sheetName: 'Exported data'
            }]
        });
    }

    /* draw chart */
    function draw_chart(sensor_data_list, sensor_data) {
        $("#chart").empty();
        new ApexCharts(document.querySelector("#chart"), setChartOption(sensor_data_list, sensor_data)).render();
    }

    /* chart Option Setting */
    function setChartOption(sensor_data_list, sensor_data){
        var options;
        if(sensor_data == null && sensor_data_list == null){
            options = {
                chart: {
                    height: '400px',
                },
                series: [
                    {
                        data: []
                    }
                ],
                yaxis: {
                    labels: {
                        show: true,
                        formatter: function (val) {
                            if (sensor_data_list === null || sensor_data_list.length === 0)
                                return 'No data'
                            else
                                return val
                        }
                    }
                },
            };
        }else{
            var min = 0;
            var max = sensor_data.managementStandard*2;
            options = {
                series: [{
                    name: sensor_data.naming,
                    data: sensor_data_list
                }],
                chart: {
                    height: '400px',
                    type: 'bar',
                    toolbar:{
                        show:true,
                        tools: {
                            download: true,
                            selection: true,
                            zoom: true,
                            zoomin: true,
                            zoomout: true,
                            pan: true,
                            reset: true,
                        },
                    },
                    animations: {
                        enabled: true,
                        easing: 'linear',
                        speed: 10,
                        animateGradually: {
                            enabled: true,
                            delay: 0
                        },
                        dynamicAnimation: {
                            enabled: true,
                            speed: 10
                        }
                    },
                },
                tooltip:{
                    enbaled: true,
                    x: {
                        show: true,
                        format: 'HH:mm',
                        formatter: undefined,
                    },
                },
                annotations: {
                    yaxis: [{
                        y: sensor_data.managementStandard,
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
                            y: sensor_data.companyStandard,
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
                            y: sensor_data.legalStandard,
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
                plotOptions: {
                    bar: {
                        colors: {
                            ranges: [{
                                from: min,
                                to: sensor_data.managementStandard-0.001,
                                color: '#97bef8'
                            }, { //관리
                                from: sensor_data.managementStandard,
                                to: sensor_data.companyStandard-0.001,
                                color: '#a2d674'
                            }, { //사내
                                from: sensor_data.companyStandard,
                                to: sensor_data.legalStandard-0.001,
                                color: '#ffc55a'
                            }, { //법적
                                from: sensor_data.legalStandard,
                                to: max,
                                color: '#ff9d5a'
                            }]
                        },
                        columnWidth: '30%'
                    },
                },
                stroke: {
                    width: 0,
                },
                dataLabels: {
                    enabled: false
                },
                fill: {
                    opacity: 1,
                },
                yaxis: {
                    tickAmount: 2,
                    decimalsInFloat: 2, //소수점아래
                    // min: min, //최소
                    // max: max //최대
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
                            hour: 'HH:mm'
                        },
                    },
                    tickPlacement: 'on',
                    axisBorder: {
                        show: true,
                        color: '#78909C',
                        height: 2,
                        width: '100%',
                        offsetX: 0,
                        offsetY: 0
                    },
                    axisTicks: {
                        show: true,
                        borderType: 'solid',
                        color: '#78909C',
                        height: 8,
                        offsetX: 0,
                        offsetY: 0
                    },
                }
            };
        }
        return options;
    }


</script>