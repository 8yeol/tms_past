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
<%-- export excel --%>
<script src="static/js/jszip.min.js"></script>
<script src="static/js/dataTables.buttons.min.js"></script>
<script src="static/js/buttons.html5.min.js"></script>
<script src="static/js/moment.min.js"></script>

<style>
    table#sensor-table thead, table#sensor-table-time thead { /* 테이블 제목 셀 배경, 글자색 설정 */
        background-color: #97bef8;
        color: #fff;
    }

    div.bg-skyblue { /* param.place 배경, 글자색 설정 */
        background-color: #094EB5;
        color: #fff;
    }
</style>

<div class="container">
    <%-- ************************************************************************************************************** --%>
        <div class="bg-gradient p-4 mt-4 ms-3 bg-skyblue">
            <div class="ms-3 add-bg">
                <span class="fs-5 fw-bold add-margin">측정소</span>
                <div class="btn-group w-50 ms-3">
                    <select id="place" class="btn btn-light" onchange="changePlace()">
                        <c:forEach var="place" items="${place}">
                            <option value="${place.name}">${place.name}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>

        <hr>

        <div class="row">
            <div class="col">
                <div class="row">
                    <div class="col-9">
                        <div class="float-start">
                            <div class="fs-5 fw-bold mb-2" id="title"> </div>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="float-start">
                            <div class="fs-5 fw-bold mb-2" id="update"> </div>
                        </div>
                    </div>
                </div>
                <div class="row h-75 mt-4">
                    <div class="col-md-6">
                        <%-- 센서 최근 테이블--%>
                        <div class="table-responsive bg-success bg-gradient col-md-12">
                            <table id="sensor-table">
                                <thead>
                                <tr>
                                    <th>항목</th>
                                    <th>측정값</th>
                                    <th>업데이트일</th>
                                </tr>
                                <thead>
                            </table>
                        </div>
                    </div>
                    <%-- 차트 --%>
                    <div class="col-md-6">
                        <div id="chart" class="col-md-12 mb-4">
                        </div>

                        <hr>
                        <%-- 차트의 데이터 테이블 --%>
                        <table id="sensor-table-time" class="table-responsive bg-success bg-gradient col-md-12 mt-1">
                            <thead>
                            <tr>
                                <th>측정시간</th>
                                <th>측정 값</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    <%-- ************************************************************************************************************** --%>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    var table1, table2, chart1;
    var interval;

    $(document).ready(function () {
        var place = $("#place").val(); // 측정소명
        var place_data =getPlaceData(place); //측정소 정보 조회

        $("#sensor-table").DataTable().clear();
        $("#sensor-table").DataTable().destroy();
        table1 = draw_sensor_table(place_data);

        var sensor_data = table1.row(0).data(); //테이블1의 첫번째 행 센서데이터 정보
        var sensor_naming = sensor_data.naming; //테이블1의 첫번째 행 센서데이터 한글명
        var sensor_name = sensor_data.name; //테이블1의 첫번째 행 센서명(테이블명)
        var warning = sensor_data.warning;
        var danger = sensor_data.danger;
        var substitution = sensor_data.substitution;

        $('#title').text(place + " - " + sensor_naming + " (기준값 - 경고:"+warning + "/ 위험:"+danger + ")"); // 선택된 값 #title 에 출력

        var sensor_data = getSensor(sensor_name, "", "", 60); //한시간 전의 센서 데이터 조회
        $('#update').text("업데이트일 : "+ sensor_data[0].x);
        $("#chart").empty();
        chart1 = draw_chart(sensor_data, warning, danger, substitution);
        chart1.render();

        $("#sensor-table-time").DataTable().clear();
        $("#sensor-table-time").DataTable().destroy();
        table2 = draw_sensor_time_table(sensor_data, warning, danger, substitution);

        clearInterval(interval);

        interval = setInterval(function () {
            var date = new Date();
            console.log(interval);
            if(date.getSeconds() == 0 ){
                /* 최근 센서의 데이터 조회 */
                var place_data_recent = getPlaceData(place);
                for(var i=0; i<place_data.length; i++) {
                //최신데이터와 데이터 비교 //같지않다면
                    if(place_data[i].value != place_data_recent[i].value) {
                        place_data[i].value = place_data_recent[i].value;
                        place_data[i].up_time = place_data_recent[i].up_time;
                    }
                }

                /* 최근 센서 데이터 조회 */
                var sensor_data_recent = getSensor(sensor_name, "", "", 60);
                if(sensor_data[0].x != sensor_data_recent[0].x){
                    $('#update').text("업데이트일 : "+ sensor_data_recent[0].x);
                    /* table 1 draw */
                    $("#sensor-table").DataTable().clear();
                    $("#sensor-table").DataTable().destroy();
                    table1 = draw_sensor_table(place_data);

                    sensor_data.unshift(sensor_data_recent[0]); //배열의 0번째로 삽입
                    sensor_data.pop(); //배열의 마지막 삭제

                    /* chart 1 draw */
                    $("#chart").empty();
                    chart1 = draw_chart(sensor_data, warning, danger, substitution);
                    chart1.render();

                    /* table 2 draw */
                    $("#sensor-table-time").DataTable().clear();
                    $("#sensor-table-time").DataTable().destroy();
                    table2 = draw_sensor_time_table(sensor_data, warning, danger, substitution);
                }
            }
        }, 3000);

    }); //ready


    function changePlace() {
        clearInterval(interval);
        var place = $("#place").val(); // 측정소명
        var place_data =getPlaceData(place); //측정소 정보 조회

        $("#sensor-table").DataTable().clear();
        $("#sensor-table").DataTable().destroy();
        table1 = draw_sensor_table(place_data);
        var sensor_data = table1.row(0).data(); //테이블1의 첫번째 행 센서데이터 정보

        if(sensor_data == null){
            $('#title').text(place);

            $("#chart").empty();
            chart1 = draw_chart(null);

            $("#sensor-table-time").DataTable().clear();
            $("#sensor-table-time").DataTable().destroy();
            table2 = draw_sensor_time_table(null);
        }else{
            var sensor_naming = sensor_data.naming; //테이블1의 첫번째 행 센서데이터 한글명
            var sensor_name = sensor_data.name; //테이블1의 첫번째 행 센서명(테이블명)
            var warning = sensor_data.warning;
            var danger = sensor_data.danger;
            var substitution = sensor_data.substitution;
            $('#title').text(place + " - " + sensor_naming + " (기준값 - 경고:"+warning + "/ 위험:"+danger + ")");

            var sensor_data = getSensor(sensor_name, "", "", 60); //한시간 전의 센서 데이터 조회
            $('#update').text("업데이트일 : "+ sensor_data[0].x);

            $("#chart").empty();
            chart1 = draw_chart(sensor_data, warning, danger, substitution);
            chart1.render();

            $("#sensor-table-time").DataTable().clear();
            $("#sensor-table-time").DataTable().destroy();
            table2 = draw_sensor_time_table(sensor_data, warning, danger, substitution);

            clearInterval(interval);
            interval = setInterval(function () {
                console.log(interval);
                /* 최근 센서의 데이터 조회 */
                var place_data_recent = getPlaceData(place);
                for(var i=0; i<place_data.length; i++) {
                    //최신데이터와 데이터 비교 //같지않다면
                    if(place_data[i].value != place_data_recent[i].value) {
                        place_data[i].value = place_data_recent[i].value;
                        place_data[i].up_time = place_data_recent[i].up_time;
                    }
                }

                /* 최근 센서 데이터 조회 */
                var sensor_data_recent = getSensor(sensor_name, "", "", 60);
                if(sensor_data[0].x != sensor_data_recent[0].x){
                    $('#update').text("업데이트일 : "+ sensor_data_recent[0].x);
                    /* table 1 draw */
                    $("#sensor-table").DataTable().clear();
                    $("#sensor-table").DataTable().destroy();
                    table1 = draw_sensor_table(place_data);

                    sensor_data.unshift(sensor_data_recent[0]); //배열의 0번째로 삽입
                    sensor_data.pop(); //배열의 마지막 삭제

                    /* chart 1 draw */
                    $("#chart").empty();
                    chart1 = draw_chart(sensor_data, warning, danger, substitution);
                    chart1.render();

                    /* table 2 draw */
                    $("#sensor-table-time").DataTable().clear();
                    $("#sensor-table-time").DataTable().destroy();
                    table2 = draw_sensor_time_table(sensor_data, warning, danger, substitution);
                }
            }, 3000);
        }

    }


    $("#sensor-table").on('click', 'tr', function(){
        clearInterval(interval);
        var place = $("#place").val();
        var place_data = getPlaceData(place);

        var sensor_data = table1.row(this).data();
        var sensor_naming = sensor_data.naming; //테이블1의 선택된 행 센서데이터 이름
        var sensor_name = sensor_data.name; //테이블1의 선택된 행 센서명
        var warning = sensor_data.warning;
        var danger = sensor_data.danger;
        var substitution = sensor_data.substitution;
        $('#title').text(place + " - " + sensor_naming + " (기준값 - 경고:"+warning + "/ 위험:"+danger + ")");

        var sensor_data = getSensor(sensor_name, "", "", 60); //한시간 전의 센서 데이터 조회
        $('#update').text("업데이트일 : "+ sensor_data[0].x);
        $("#chart").empty();
        chart1 = draw_chart(sensor_data, warning, danger, substitution);
        chart1.render();

        $("#sensor-table-time").DataTable().clear();
        $("#sensor-table-time").DataTable().destroy();
        table2 = draw_sensor_time_table(sensor_data, warning, danger, substitution);

        interval = setInterval(function () {

            /* 최근 센서의 데이터 조회 */
            var place_data_recent = getPlaceData(place);
            for(var i=0; i<place_data.length; i++) {
                //최신데이터와 데이터 비교 //같지않다면
                if(place_data[i].value != place_data_recent[i].value) {
                    place_data[i].value = place_data_recent[i].value;
                    place_data[i].up_time = place_data_recent[i].up_time;
                }
            }

            /* 최근 센서 데이터 조회 */
            var sensor_data_recent = getSensor(sensor_name, "", "", 60);
            if(sensor_data[0].x != sensor_data_recent[0].x){
                $('#update').text("업데이트일 : "+ sensor_data_recent[0].x);
                /* table 1 draw */
                $("#sensor-table").DataTable().clear();
                $("#sensor-table").DataTable().destroy();
                table1 = draw_sensor_table(place_data);

                sensor_data.unshift(sensor_data_recent[0]); //배열의 0번째로 삽입
                sensor_data.pop(); //배열의 마지막 삭제

                /* chart 1 draw */
                $("#chart").empty();
                chart1 = draw_chart(sensor_data, warning, danger, substitution);
                chart1.render();

                /* table 2 draw */
                $("#sensor-table-time").DataTable().clear();
                $("#sensor-table-time").DataTable().destroy();
                table2 = draw_sensor_time_table(sensor_data, warning, danger, substitution);
            }
        }, 3000);
    });

    /* 처음 로딩시 model 로 넘겨받은 센서 데이터 가져옴 - table1의 데이터*/
    <%--function getReadyData() {--%>
    <%--    var getData = new Array();--%>
    <%--    <c:forEach items="${sensors}" var="sName" varStatus="status">--%>
    <%--    <c:set var="Index">${status.index}</c:set>--%>
    <%--    <fmt:formatNumber value="${sensor[Index].value}" var="sValue" pattern=".00"/>--%>
    <%--    <fmt:formatDate value="${sensor[Index].up_time}" var="sUp_time" type="DATE" pattern="yyyy-MM-dd HH:mm:ss"/>--%>
    <%--        <c:if test="${not empty sensor_info[Index].naming}">--%>
    <%--    getData.push({naming: "${sensor_info[Index].naming}", name:"${sName}", value:"${sValue}", up_time: "${sUp_time}"});--%>
    <%--        </c:if>--%>
    <%--        <c:if test="${empty sensor_info[Index].naming}">--%>
    <%--    getData.push({naming: "${sName}", name:"${sName}", value:"${sValue}", up_time: "${sUp_time}"});--%>
    <%--        </c:if>--%>
    <%--    </c:forEach>--%>
    <%--    return getData;--%>
    <%--}--%>


    /* 측정소가 바뀐 데이터 조회*/
    function getPlaceData(place){
        var getData = new Array();
        /* 측정소에 따라 센서명을 가져와 data 생성*/
        $.ajax({
            url:'getPlaceSensor',
            dataType: 'json',
            data:  {"place": place},
            async: false,
            success: function (data) {
                $.each(data, function (index, item) {
                    var sensor = getSensorRecent(item);
                    var sensorInfo = getSensorInfo(item);
                    if(sensorInfo == null && sensor == null){
                        getData = null;
                    }else if (sensorInfo == null && sensor != null){
                        getData.push({naming: item, name:item, value:sensor.value.toFixed(2), up_time: moment(sensor.up_time).format('YYYY-MM-DD HH:mm:ss'),
                            warning: 15, danger: 30, substitution: null});
                    }else if(sensorInfo != null && sensor != null){
                        getData.push({naming: sensorInfo.naming, name:item, value:sensor.value.toFixed(2), up_time: moment(sensor.up_time).format('YYYY-MM-DD HH:mm:ss'),
                            warning: sensorInfo.warning, danger: sensorInfo.danger, substitution: sensorInfo.substitution});
                    }
                })
            }
        }); //ajax
        return getData;
    }

    /* 센서명으로 최근 데이터 조회 */
    function getSensorRecent(sensor){
        var getData = new Array();
        $.ajax({
            url:'getSensorRecent',
            dataType: 'json',
            data:  {"sensor": sensor},
            async: false,
            success: function (data) {
                getData = data;
            },
            error: function (e) {
                getData = null;
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
                getData = data;
            },
            error: function (e) {
                getData = null;
            }
        }); //ajax
        return getData;
    }


    /* sensor name에 해당하는 테이블에 접근하여 chart에 사용하는 data 생성 */
    function getSensor(sensor, from_date, to_date, minute) {
        var getData = new Array();
        $.ajax({
            url:'getSensor',
            dataType: 'json',
            data: {"sensor": sensor, "from_date": from_date, "to_date": to_date, "minute": minute},
            async: false,
            success: function (data) {
                $.each(data, function (index, item) {
                    getData.push({x: moment(item.up_time).format('YYYY-MM-DD HH:mm:ss'), y: item.value.toFixed(2)});
                })
            },
            error: function (e) {
            }
        }); //ajax
        return getData;
    }


    /* draw sensor table */
    function draw_sensor_table(data){
        var table = $('#sensor-table').DataTable({
            paging: false,
            searching: false,
            select: true,
            data: data,
            bPaginate: false,
            bInfo: false,
            order:[[0, 'asc']],
            columns: [
                {"data": "naming"},
                {"data": "value"},
                {"data": "up_time"}
            ],
            'rowCallback': function(row, data, index){
                // console.log(data.y);
                if(data.value >= data.warning){
                    $(row).find('td:eq(1)').css('color', '#f54264');
                }
                if(data.value <= data.danger && data.value>=data.warning){
                    $(row).find('td:eq(1)').css('color', '#ffb607');
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

    /* draw sensor time table */
    function draw_sensor_time_table(data, warning, danger, substitution) {
        // if(warning == null){
        //     warning = 15;
        // }
        // if(danger == null){
        //     danger = 30;
        // }
        $('#sensor-table-time').dataTable({
            data: data,
            columns:[
                {"data": "x"},
                {"data": "y"}
            ],
            aLengthMenu: [10, 25, 50],
            search: false,
            searching: false,
            bInfo: false,
            ordering: true,
            pagingType: 'numbers',
            order:[[0, 'desc']],
            'rowCallback': function(row, data, index){
                // console.log(row);
                // console.log(data.y);
                if(data.y>=danger){
                    $(row).find('td:eq(1)').css('color', '#f54264');
                }
                if(data.y <= danger && data.y>=warning){
                    $(row).find('td:eq(1)').css('color', '#ffb607');
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
            dom: 'Bfrtip',
            buttons: [{
                extend: 'excelHtml5',
                autoFilter: true,
                sheetName: 'Exported data'
            }]
        });
    }

    /* draw chart */
    function draw_chart(data, warning, danger, substitution) {
        var chart;
        if(data == null){
            chart = null;
        }else{
            chart = new ApexCharts(document.querySelector("#chart"), setChartOption(data, warning, danger, substitution));
        }
        //chart.render();
        return chart;
    }

    /* chart Option Setting */
    function setChartOption(data, warning, danger, substitution){
        if(warning == null){
            warning = 15;
        }
        if(danger == null){
            danger = 30;
        }
        var min = 0;
        var max = danger*2;
        var options = {
            series: [{
                name: name,
                data: data
            }],
            chart: {
                height: 'auto',
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
                        reset: false,
                    },
                },
                tooltip:{
                    enabled: false
                }
            },
            plotOptions: {
                bar: {
                    colors: {
                        ranges: [{
                            from: min,
                            to: warning-0.001,
                            color: '#0015c4'
                        },{
                            from: warning,
                            to: danger-0.001,
                            color: '#ffb607'
                        }, {
                            from: danger,
                            to: max,
                            color: '#f54264'
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
                min: min, //최소
                max: max //최대
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
                    color: '#000000',
                    height: 10,
                    offsetX: 0,
                    offsetY: 0
                },
            }
        };
        return options;
    }


</script>