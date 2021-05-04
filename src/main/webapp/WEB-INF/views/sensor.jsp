<%-- http://localhost:8090/sensor?place=point1 --%>
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

    /* 데이터 테이블 */
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


<div class="container">


    <div class="row">

        <div class="col-md-2 bg-lightGray rounded-0 pt-5 px-0" style="margin-top: 32px; text-align: -webkit-center;">
            <ul id="place_name">
            <c:forEach var="place" items="${place}" varStatus="cnt">
                <li class="place-item btn bg-lightGray d-block fs-3 mt-3 me-3" id="${place.name}">
                    <span>${place.name}</span>
                </li>
                <hr style="height: 2.5px;">
            </c:forEach>
            </ul>
        </div>

        <div class="col-md-10 bg-light rounded p-0">
            <div class="d-flex justify-content-end bg-grayblue">
                <span class="fs-7 mb-2"> 마지막 업데이트 : </span>
                <span class="mb-2" id="update" style="margin-left: 5px;"></span>
            </div>

            <span class="fs-3 fw-bold d-flex justify-content-center bg-lightGray" id="title">temp</span>


            <table id="place-table">
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
            </table>

            <hr>

            <div class="d-flex justify-content-between">
                <div class="d-flex radio">
                    <span class="me-3" id="radio_text" style="margin-left: 10px;">센서명 - 최근 1시간 자료</span>
                    <input class="form-check-input" type="radio" name="chartRadio" id="hourRadio" checked >
                    <span class="me-2">1시간</span>
                    <input class="form-check-input" type="radio" name="chartRadio" id="dayRadio" >
                    <span>하루</span>
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
    $("#place-table").on('click', 'tr', function(){
        sensor_data = place_table.row(this).data();
        getData2(sensor_data);
    });

    function getData(place_name, sensor_naming){
        var place_data = getPlaceData(place_name); // 최근데이터, 60분전데이터, 정보
        place_table = draw_place_table(place_data);
        // $('#sensorInfo2').text("(경고:"+warning + "/ 위험:"+danger + ")");
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
        if(!sensor_naming){
            var sensor_data = place_table.row(0).data();
            getData2(sensor_data);
        }else{
            for(var i=0; i<place_data.length; i++){
                if(sensor_naming == place_data[i].naming){
                    var sensor_data = place_data[i];
                }
            }
            getData2(sensor_data);
        }
    }

    function getData2(sensor_data) {
        var sensor_name = sensor_data.name;
        var sensor_time_length;
        var textTime;
        if($("input[id=hourRadio]:radio" ).is( ":checked")){
            sensor_time_length = 60;
            textTime = "1시간";
        } else{
            sensor_time_length = 1440;
            textTime = "하루";
        }
        $("#radio_text").text(sensor_data.naming+ " - 최근 " + textTime + " 자료") ;

        var sensor_data_list = getSensor(sensor_name, "", "", sensor_time_length);
        $('#update').text(sensor_data_list[0].x);
        draw_chart(sensor_data_list, sensor_data);
        draw_sensor_table(sensor_data_list);

        $("#standard_text").text(sensor_data.legal_standard+"/"+sensor_data.company_standard+"/"+sensor_data.management_standard+" mg/Sm³ 이하");
        setTimeout(function interval_getData2() {
            clearTimeout(interval2);
            console.log("g2: "+interval2);
            var sensor_data_list_recent = getSensor(sensor_name, "", "", 1);
            if(sensor_data_list_recent.length != 0){ // null = []
                if(sensor_data_list[0].x != sensor_data_list_recent[0].x){
                    sensor_data_list.unshift(sensor_data_list_recent[0]);
                    // sensor_data_list.pop();
                    draw_sensor_table(sensor_data_list);
                    draw_chart(sensor_data_list, sensor_data);
                }
            }
            interval2 = setTimeout(interval_getData2, 5000);
        }, 0);

    }


    /* 측정소명으로 센서명 조회*/
    function getPlaceData(place){
        var getData = new Array();
        $.ajax({
            url:'getPlaceSensor',
            dataType: 'json',
            data:  {"place": place},
            async: false,
            success: function (data) {
                $.each(data, function (index, item) { //item (센서명)
                    var Onoff = getPower(item);
                    if(Onoff == "on"){
                        var sensor = getSensorRecent(item); // item의 최근데이터
                        if(sensor.value == 0 || sensor.value == null){ //null 일때
                            sensor_value = "-"; // "-" 출력(datatable)
                        }else{
                            sensor_value = sensor.value.toFixed(2);
                            up_time = moment(sensor.up_time).format('YYYY-MM-DD HH:mm:ss');
                        }

                        var b5_sensor = getSensor(item, "", "", 10); //item의 10분전 데이터
                        if(b5_sensor.length != 0){ // 최근데이터 값 - 9:59분전 데이터
                            b5_value = (b5_sensor[(b5_sensor.length)-1].y);
                            com_value = (sensor.value - b5_value);
                        }else{ // 최근데이터 존재하지 않을 경우 "-" 처리
                            b5_value = "-";
                            com_value = "-";
                        }


                        var sensorInfo = getSensorInfo(item); //item의 정보 데이터
                        naming = sensorInfo.naming;
                        legal_standard = sensorInfo.legal_standard;
                        company_standard = sensorInfo.company_standard;
                        management_standard = sensorInfo.management_standard;
                        power = sensorInfo.power;
                        if(sensor.value < company_standard && sensor.value >= management_standard){
                            standard = "관리기준 초과";
                        }else if(sensor.value< legal_standard && sensor.value >= company_standard){
                            standard = "사내기준 초과";
                        }else if(sensor.value >= legal_standard){
                            standard = "법적기준 초과";
                        }else if(sensor.value < management_standard){
                            standard = "정상";
                        }else{
                            standard = "-";
                        }
                        getData.push({
                            naming: naming, name:item,
                            value:sensor_value, up_time: up_time,
                            legal_standard: legal_standard, company_standard: company_standard, management_standard: management_standard,
                            b5_value: b5_value,power: power, standard : standard
                        });
                    }
                })
            }
        }); //ajax
        // console.log(getData);
       // console.log("data "+$(row).find('td:eq(4)').val());
        return getData;
    }

    /* 센서명으로 최근 데이터 조회 */
    function getPower(sensor){
        var getData;
        $.ajax({
            url:'getPower',
            dataType: 'text',
            data:  {"name": sensor},
            async: false,
            success: function (data) {
                getData = data;
            },
            error: function (e) {
                // console.log("getSensorRecent Error");
                // 결과가 존재하지 않을 경우 null 처리
                getData = "off";
            }
        }); //ajax
        return getData;
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
                getData = data;
            },
            error: function (e) {
                // console.log("getSensorRecent Error");
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
                if(data.legal_standard == 0 || data.legal_standard == null){
                    data.legal_standard = "-";
                }
                if(data.company_standard == 0 || data.company_standard == null){
                    data.company_standard = "-";
                }
                if(data.management_standard == 0 || data.management_standard == null){
                    data.management_standard = "-";
                }
                getData = data;
            },
            error: function (e) {
                // console.log("getSensorInfo Error");
                /* 결과가 존재하지 않을 경우 센서명만 전달 */
                getData = {"name": sensor, "naming": sensor,
                    "legal_standard": "-", "company_standard": "-", "management_standard": "-", "power": "off"}
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
                var legal_standard = sensorInfo.legal_standard;
                var company_standard = sensorInfo.company_standard;
                var management_standard = sensorInfo.management_standard;
                $.each(data, function (index, item) {
                    if(item.value < company_standard && item.value >= management_standard){
                        standard = "관리기준 초과";
                    }else if(item.value< legal_standard && item.value >= company_standard){
                        standard = "사내기준 초과";
                    }else if(item.value >= legal_standard){
                        standard = "법적기준 초과";
                    }else if(item.value < management_standard){
                        standard = "정상";
                    }else{
                        standard = "-";
                    }
                    getData.push({x: moment(item.up_time).format('YYYY-MM-DD HH:mm:ss'), y: item.value.toFixed(2), standard:standard });
                })
            },
            error: function (e) {
                // console.log("getSensor Error");
                // 조회 결과 없을 때 return [];
            }
        }); //ajax
        return getData;
    }


    /* draw sensor table */
    function draw_place_table(data){
        $("#place-table").DataTable().clear();
        $("#place-table").DataTable().destroy();
        console.log(data);
        var table = $('#place-table').DataTable({
            paging: false,
            searching: false,
            select: true,
            data: data,
            bPaginate: false,
            bInfo: false,
            order:[[0, 'asc']],
            columns: [
                {"data": "naming"},
                {"data": "legal_standard"},
                {"data": "company_standard"},
                {"data": "management_standard"},
                {"data": "value"},
                {"data": "standard"}
            ],
            'rowCallback': function(row, data, index){
                if(data.legal_standard != "-"){
                    $(row).find('td:eq(1)').css('background-color', '#ff9d5a');
                    if(data.value >= data.legal_standard){
                        $(row).find('td:eq(4)').css('color', '#ff9d5a');
                        $(row).find('td:eq(4)').css('font-weight', 'bold');
                        $(row).find('td:eq(5)').css('color', '#ff9d5a');
                        $(row).find('td:eq(5)').css('font-weight', 'bold');
                    }
                }
                if(data.company_standard != "-"){
                    $(row).find('td:eq(2)').css('background-color', '#ffc55a');
                    if(data.value < data.legal_standard && data.value >= data.company_standard){
                        $(row).find('td:eq(4)').css('color', '#ffc55a');
                        $(row).find('td:eq(4)').css('font-weight', 'bold');
                        $(row).find('td:eq(5)').css('color', '#ffc55a');
                        $(row).find('td:eq(5)').css('font-weight', 'bold');
                    }
                }
                if(data.management_standard != "-"){
                    $(row).find('td:eq(3)').css('background-color', '#a2d674');
                    if(data.value <= data.company_standard && data.value > data.management_standard){
                        $(row).find('td:eq(4)').css('color', '#a2d674');
                        $(row).find('td:eq(4)').css('font-weight', 'bold');
                        $(row).find('td:eq(5)').css('color', '#a2d674');
                        $(row).find('td:eq(5)').css('font-weight', 'bold');
                    }
                }

                if(data.value < data.b5_value){
                    $(row).find('td:eq(4)').prepend('<img src="static/images/down.jpg" class="img">');
                }else if(data.value > data.b5_value){
                    $(row).find('td:eq(4)').prepend('<img src="static/images/up.png" class="img">');
                }else{
                    $(row).find('td:eq(4)').prepend(' <b>ㅡ</b> ');
                }

            },
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
        });
        return table;
    }

    /* 센서명으로 최근 데이터 조회 */
    function getPower(sensor){
        var getData;
        $.ajax({
            url:'getPower',
            dataType: 'text',
            data:  {"name": sensor},
            async: false,
            success: function (data) {
                getData = data;
            },
            error: function (e) {
                // console.log("getSensorRecent Error");
                // 결과가 존재하지 않을 경우 null 처리
                getData = "off";
            }
        }); //ajax
        return getData;
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
                if(sensor_data.legal_standard != "-"){
                    if(data.y >= sensor_data.legal_standard){
                        $(row).find('td:eq(2)').css('color', '#ff9d5a');
                        $(row).find('td:eq(2)').css('font-weight', 'bold');
                    }
                }
                if(sensor_data.company_standard != "-"){
                    if(data.y < sensor_data.legal_standard && data.y >= sensor_data.company_standard){
                        $(row).find('td:eq(2)').css('color', '#ffc55a');
                        $(row).find('td:eq(2)').css('font-weight', 'bold');
                    }
                }
                if(sensor_data.management_standard != "-"){
                    if(data.y <= sensor_data.company_standard && data.y > sensor_data.management_standard){
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
        var min = 0;
        var max = sensor_data.management_standard*2;
        var options = {
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
                    y: sensor_data.management_standard,
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
                    y: sensor_data.company_standard,
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
                    y: sensor_data.legal_standard,
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
                            to: sensor_data.management_standard-0.001,
                            color: '#97bef8'
                        }, { //관리
                            from: sensor_data.management_standard,
                            to: sensor_data.company_standard-0.001,
                            color: '#a2d674'
                        }, { //사내
                            from: sensor_data.company_standard,
                            to: sensor_data.legal_standard-0.001,
                            color: '#ffc55a'
                        }, { //법적
                            from: sensor_data.legal_standard,
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
        return options;
    }


</script>