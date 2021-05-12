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
            <div class="d-flex justify-content-end">
                <span class="fs-7 mb-2">업데이트 : <a id="update"></a></span>
            </div>
            <span class="fs-4 fw-bold d-flex justify-content-center bg-lightGray" id="title"></span>
            <div id="place_table">
                <div class="col text-end align-self-end mt-2 mb-1"><span class="text-primary" style="font-size: 15%"> * 항목 클릭시 차트/표 값이 변경됩니다.</span></div>
                <table class="table table-bordered table-hover text-center">
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
                    <tbody id="place-tbody-table">
                        <%--script--%>
                    </tbody>
                </table>
            </div>
            <hr>
            <div class="d-flex justify-content-between">
                <div class="d-flex radio">
                    <span class="me-3 fs-5" id="radio_text" style="margin-left: 10px;"></span>
                    <div class="align-self-end">
                        <input class="form-check-input" type="radio" name="chartRadio" id="hourRadio" checked>
                        <label>&nbsp;최근 1시간</label> &emsp;
                        <input class="form-check-input" type="radio" name="chartRadio" id="dayRadio">
                        <label>&nbsp;최근 24시간</label>
                    </div>
                </div>
                <span class="text-primary" style="font-size: 15%"> * 5분 단위로 업데이트 됩니다.</span>
            </div>
            <%-- 차트 --%>
            <div id="chart"></div>
            <hr>
            <%-- 차트의 데이터 테이블 --%>
            <div class="d-flex fw-bold pos-a align-self-end">
                <div style="color: #000;  margin-right:5px" >법적/사내/관리 기준 -</div>
                <div id="standard_text" style="color: #000;"></div>
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
    var interval1, interval2;

    // 측정소 별 항목 데이터 전체 (기존 getData 함수명 변경)
    function getPlaceAllSensorData(place_name, sensor_naming){
        console.log('get place all sensor');
        try{
            // if 든 else 든 무조건 한번 실행시킬거면 if 문 앞에서 처리해줄 것
            const place_data = getPlaceData(place_name); // 최근 데이터, 직전 데이터, 기준값 등 받아오기 위함
            clearTimeout(interval1);
        if(place_data.length != 0){
            setTimeout(function interval_getData() {
                console.log("g1: "+interval1);
                draw_place_table(place_data);
                for (var i = 0; i < place_data.length; i++) {
                    var recentData = getSensorRecent(place_data[i].name)
                    if(place_data[i].up_time == recentData.up_time){
                        place_data[i].value = recentData.value;
                        place_data[i].up_time = recentData.up_time;
                    }
                }
                interval1 = setTimeout(interval_getData, 5000);
            }, 0);
            // $('#sensorInfo2').text("(경고:"+warning + "/ 위험:"+danger + ")");
            if (!sensor_naming) { //파라미터로 넘어오는 값이 없을 경우
                var sensor_data = place_data[0];
            } else {
                for (var i = 0; i < place_data.length; i++) {
                    if (sensor_naming == place_data[i].naming) {
                        var sensor_data = place_data[i];
                    }
                }
            }
        }
        getData2(sensor_data);
        }catch (e) {
            console.log(e);
        }
    }

    function getData2(sensor_data) {
        if(sensor_data==null||sensor_data==undefined||sensor_data.value== null){
            sensor_data = [];
        }
        clearTimeout(interval2);
        if(sensor_data.length!=0){
            let sensor_name = sensor_data.name;
            let sensor_time_length;

            if(document.getElementsByName("chartRadio")[0].checked){
                sensor_time_length = 1;
            }else{
                sensor_time_length = 24;
            }

            var sensor_data_list = getSensor(sensor_name, sensor_time_length);
           chart = setChartOption(sensor_data_list, sensor_data);

            $("#radio_text").text(sensor_data.naming); /*+ " - 최근 " + textTime + " 자료"*/
            $("#standard_text").text(sensor_data.legalStandard+"/"+sensor_data.companyStandard+"/"+sensor_data.managementStandard+" mg/Sm³ 이하");

                setTimeout(function interval_getData2() {
                    //test
                    var now =new Date();
                   console.log("g2: "+interval2);
                    chart.updateSeries([{
                        data: sensor_data_list
                    }]);
                    draw_sensor_table(sensor_data_list, sensor_data);
                    var sensor_data_list_recent = getSensorRecent(sensor_name);
                    if(sensor_data_list_recent.length != 0){ // null = []
                        // if(sensor_data_list[0].x != sensor_data_list_recent.up_time){
                        if(sensor_data_list[0].x != now){ //test
                            random = sensor_data_list_recent.value + Math.random(); //test
                            sensor_data_list.unshift({x:now, y: random, standard: null}); //test
                            // sensor_data_list.unshift({x:sensor_data_list_recent.up_time, y: sensor_data_list_recent.value, standard: null});
                            sensor_data_list.pop();
                        }
                    }
                    interval2 = setTimeout(interval_getData2, 5000);
                }, 0);
        } else{ // null 일 때
            draw_place_table(null);
            $("#chart").empty();
            // chart = setChartOption(null, null);
            // chart.updateSeries([{
            //     name: null,
            //     data: []
            // }])
            draw_sensor_table(null);
            $("#radio_text").text("-") ;
            $("#standard_text").text("");
        }
    }

    /* 센서명 이전 데이터 조회 */
    function getSensorBeforeData(sensor) {
        let result = new Array();
        $.ajax({
            url: 'getSensorBeforeData',
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

    /* chart Option Setting */
    function setChartOption(sensor_data_list, sensor_data){

        $("#chart").empty();

        let options;

        if(sensor_data == null || sensor_data_list == null){
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

        chart = new ApexCharts(document.querySelector("#chart"), options);
        chart.render();
        return chart;
    }


    $(document).ready(function () {
        /* URI로부터 파라미터 확인 */
        const url = new URL(window.location.href);
        const urlParams = url.searchParams;
        if(urlParams.has(('place')) && urlParams.has('sensor')){ //place와 sensor 파라미터가 있을 경우
            const place_name = urlParams.get('place');
            const sensor_naming = urlParams.get('sensor');
            $("#"+place_name).addClass('active');
            $('#title').text(place_name);
            getPlaceAllSensorData(place_name, sensor_naming);
        }else{ //파라미터가 없을 경우
            const place_name = "${place.get(0).name}"; // 기본값
            $("#place_name li").eq(0).addClass('active');
            $('#title').text(place_name);
            getPlaceAllSensorData(place_name);
        }
    }); //ready

    // 측정소 변경 이벤트
    $("#place_name").on('click', 'li', function () {
        const place_name = $(this).attr('id');
        $('#title').text(place_name);
        $("#place_name li").removeClass('active');
        $(this).addClass('active');
        getPlaceAllSensorData(place_name);
    });

    //측정소 전체 (상단 일반 테이블)
    function draw_place_table(data){
        try{
            $('#place-tbody-table').empty();
            if(data == null){
                const innerHtml = "<tr><td colspan='6'> 등록된 센서 데이터가 없습니다. </td></tr>";
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

                    newCeil0.innerHTML = data[i].naming+'<input type="hidden" value="'+ data[i].name+'">';
                    newCeil1.innerHTML = '<div class="bg-danger text-light">'+data[i].legalStandard+'</div>';
                    newCeil2.innerHTML = '<div class="bg-warning text-light">'+data[i].companyStandard+'</div>';
                    newCeil3.innerHTML = '<div class="bg-success text-light">'+data[i].managementStandard+'</div>';
                    newCeil4.innerHTML = draw_beforeData((data[i].beforeValue).toFixed(2), (data[i].value).toFixed(2));

                    if(data[i].value > data[i].legalStandard){
                        newCeil5.innerHTML =  '<div class="bg-danger text-light">'+"법적기준 초과"+'</div>';
                    } else if( data[i].value > data[i].companyStandard){
                        newCeil5.innerHTML =  '<div class="bg-warning text-light">'+"사내기준 초과"+'</div>';
                    } else if( data[i].value > data[i].managementStandard){
                        newCeil5.innerHTML =  '<div class="bg-success text-light">'+"관리기준 초과"+'</div>';
                    } else {
                        newCeil5.innerHTML =  "정상";
                    }
                    $('#update').text(data[i].up_time);
                }
            }
        }catch (e) {

        }
    }

    // 5분전 데이터와 비교해서 up/down 표시
    function draw_beforeData(beforeData , nowData){
        if(beforeData > nowData){
            return '<img src="static/images/down.jpg" class="img">' + nowData;
        } else if( nowData > beforeData) {
            return '<img src="static/images/up.png" class="img">' + nowData;
        } else{
            return ' - ' + nowData;
        }
    }

    // 측정소 명으로 센서 데이터 조회
    function getPlaceData(place){
        let result = new Array();
        $.ajax({
            url:'getPlaceSensor',
            dataType: 'json',
            data:  {"place": place},
            async: false,
            success: function (data) {
                $.each(data, function (index, item) { //item (센서명)
                    result.push(getSensorData(item));
                })
            },
            error: function (e) {

            }
        });
        return result;
    }

    // monitoring on/off 체크
    function getMonitoring(sensor){
        let result;
        $.ajax({
            url:'getMonitoring',
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

    // 센서 정보 조회
    function getSensorData(sensor){
        let result;
        const monitor = getMonitoring(sensor); //power on,off
        let sensorValue, sensorUptime, beforeValue;
        // monitor=='true' 체크
        if(monitor){
            // 최근 데이터
            const recentData = getSensorRecent(sensor);
            if(recentData.value == 0 || recentData.value == null){
                recentData.value = "-";
            }else{
                sensorValue = recentData.value;
                sensorUptime = moment(recentData.up_time).format('YYYY-MM-DD HH:mm:ss');
            }
            // 직전 데이터(up/down 표시하기 위함)
            const beforeData = getSensorBeforeData(sensor);
            if(beforeData.length == 0){
                beforeValue = "-";
            }else{ // 최근데이터 존재하지 않을 경우 "-" 처리
                beforeValue = beforeData[0].value;
            }

            const sensorInfo = getSensorInfo(sensor); //sensor 정보 데이터 (관리기준, 사내기준 등.. 받아오기 위함)
            const naming = sensorInfo.naming;
            const monitoring = sensorInfo.monitoring;
            const legalStandard = sensorInfo.legalStandard;
            const companyStandard = sensorInfo.companyStandard;
            const managementStandard = sensorInfo.managementStandard;
            const standard = recentData.standard;

            result =({
                naming: naming, name:sensor,
                value:sensorValue, up_time: sensorUptime,
                legalStandard: legalStandard, companyStandard: companyStandard, managementStandard: managementStandard,
                beforeValue: beforeValue, monitoring: monitoring
            });
        }
        return result;
    }

    // 최근 1시간 데이터 / 최근 24 시간 데이터 불러오기
    function getSensor(sensor_name, hour) {
        let result = new Array();
        if(sensor_name==undefined){
            console.log('get sensor null 처리');
            return null;
        }else{
            $.ajax({
                url:'getSensor',
                dataType: 'json',
                data: {"sensor": sensor_name, "hour": hour},
                async: false,
                success: function (data) {
                    $.each(data, function (index, item) {
                        result.push({x: item.up_time, y: item.value});
                    })
                },
                error: function (e) {
                    // 조회 결과 없을 때 return [];
                }
            });
        }
        return result;
    }

    // 최근 데이터 조회
    function getSensorRecent(sensor){
        let result;
        // 파라미터로 넘어오는 sensor 값이 null 일때 처리(측정소에 맵핑되어있는 센서값이 없는 경우)
        if(sensor==undefined){
            console.log('get sensor recent null 처리');
            return null;
        } else{
            $.ajax({
                url:'getSensorRecent',
                dataType: 'json',
                data:  {"sensor": sensor},
                async: false,
                success: function (data) {
                    result = {value: data.value, status: data.status, up_time:data.up_time};
                },
                error: function (e) {
                    // 결과가 존재하지 않을 경우 null 처리
                    result = {value: null, status: false, up_time:null};
                }
            });
        }
        return result;
    }

    function getSensorInfo(sensor) {
        let result;
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
                result = data;
            },
            error: function (e) {
                /* 결과가 존재하지 않을 경우 센서명만 전달 */
                result = {"name": sensor, "naming": sensor,
                    "legalStandard": "-", "companyStandard": "-", "managementStandard": "-", "power": "off"}
            }
        });
        return result;
    }

    // table 그리기
    function draw_sensor_table(sensor_data_list, sensor_data) {
        $("#sensor-table").DataTable().clear();
        $("#sensor-table").DataTable().destroy();
        if(sensor_data_list == null){
            arr = [];
        }else{
            var arr = new Array();
            for(var i=0; i<sensor_data_list.length; i++){
                if(sensor_data_list[i].y > sensor_data.legalStandard){
                    var standard = "법적기준 초과";
                }else if(sensor_data_list[i].y > sensor_data.companyStandard){
                    var standard = "사내기준 초과";
                }else if(sensor_data_list[i].y > sensor_data.managementStandard){
                    var standard = "관리기준 초과";
                }else if(sensor_data_list[i].y <= sensor_data.managementStandard){
                    var standard = "정상";
                }
                arr.push({x:moment(sensor_data_list[i].x).format('YYYY-MM-DD HH:mm:ss'), y:(sensor_data_list[i].y).toFixed(2), z: standard});
            }
        }

        $('#sensor-table').dataTable({
                data: arr,
                columns:[
                    {"data": "x"},
                    {"data": "y"},
                    {"data": "z"}
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
                    "emptyTable": "등록된 센서 데이터가 없습니다.",
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

    /* 차트 1시간 / 24시간 이벤트 */
    $("input[name=chartRadio]").on('click' , function (){
        if(document.getElementsByName("chartRadio")[0].checked){
            sensor_time_length = 1;
        }else{
            sensor_time_length = 24;
        }
        sensor_naming = $('#radio_text').text();
        var temp = $("#place-tbody-table > tr > td:contains('" + sensor_naming + "')");
        sensor_name = temp[0].childNodes[1].value;
        sensor_data = getSensorData(sensor_name);
        getData2(sensor_data);
    });

    /* 센서명 클릭 이벤트 */
    $("#place-tbody-table").on('click', 'tr', function(){
        const name = $(this).find('input').val();
        sensor_data = getSensorData(name);
        getData2(sensor_data);
    });


</script>