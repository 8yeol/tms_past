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
                <span class="fs-5 fw-bold p-3">업데이트일</span>
                <div class="form-check form-check-inline" >
                    <input id="update" class="btn btn-light" value="" readonly>
                </div>
            </div>
        </div>

        <hr>

        <div class="row">
            <div class="col">
                <div class="row">
                    <div class="col">
                        <div class="float-start">
                            <div class="fs-5 fw-bold mb-2" id="title"> </div>
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
    var warning, danger;
    var min, max;
    var table1, table2, chart1;
    var data = [];
    var interval;

    var place, sensor;
    var update;

    $(document).ready(function () {
        place = $("#place").val();
        sensor = "tmsWP0005_CO_01";
        $('#title').text(place + " - " + sensor);

        table1 = draw_sensor_table(getReadyData());

        data = getSensor(sensor, "", "", 60);

        chart1 = draw_chart(data);
        chart1.render();

        // $("#sensor-table-time").DataTable().clear();
        // $("#sensor-table-time").DataTable().destroy();
        table2 = draw_sensor_time_table(data);
    }); //ready

    function changePlace() {
        place = $("#place").val();

        var chageData = getPlaceChangeData(place);
        var sensor = chageData[0].name;
        console.log(sensor);
        $('#title').text(place + " - " + chageData[0].naming);

        $("#sensor-table").DataTable().clear();
        $("#sensor-table").DataTable().destroy();
        table1 = draw_sensor_table(getPlaceChangeData(place));

        var sensor_data = getSensor(sensor, "", "", 60);
        console.log(sensor_data)
        $("#chart").empty();
        chart1 = draw_chart(sensor_data);
        chart1.render();

        $("#sensor-table-time").DataTable().clear();
        $("#sensor-table-time").DataTable().destroy();
        table2 = draw_sensor_time_table(sensor_data);
    }


    $("#sensor-table").on('click', 'tr', function(){
        /* table 1 - get Sensor Name */
        var sensor_data = table1.row(this).data();
        var sensor = sensor_data.name;
        $('#title').text(place + " - " + sensor_data.naming);
        /* get Sensor Data */

        var sensor_data = getSensor(sensor, "", "", 60);

        /* chart 1 draw */
        $("#chart").empty();
        chart1 = draw_chart(sensor_data);
        chart1.render();

        /* table 2 draw */
        $("#sensor-table-time").DataTable().clear();
        $("#sensor-table-time").DataTable().destroy();
        table2 = draw_sensor_time_table(sensor_data);
        // 실시간 데이터 처리 (setInterval)
        // interval 변수 - 처음 클릭 시 underfined / 두번째 부터 number type으로 변수 저장되어 clear 후에 interval 실행
        clearInterval(interval);
        interval = setInterval(function () {
                console.log("-");
            /* 최근 데이터 조회 */
            var sensor_data_recent = getSensor(sensor, "", "", 60);
            if(sensor_data[0].x != sensor_data_recent[0].x){
                console.log("Interver excute");
                sensor_data.unshift(sensor_data_recent[0]); //배열의 0번째로 삽입
                sensor_data.pop(); //배열의 마지막 삭제

                /* chart 1 draw */
                $("#chart").empty();
                chart1 = draw_chart(sensor_data_recent);
                chart1.render();

                /* table 2 draw */
                $("#sensor-table-time").DataTable().clear();
                $("#sensor-table-time").DataTable().destroy();
                table2 = draw_sensor_time_table(sensor_data_recent);
            }
        }, 5000);
    });

    /* 처음 로딩시 model 로 넘겨받은 센서 데이터 가져옴 - table1의 데이터*/
    function getReadyData() {
        var getData = new Array();
        <c:forEach items="${sensors}" var="sName" varStatus="status">
        <c:set var="Index">${status.index}</c:set>
        <fmt:formatNumber value="${sensor[Index].value}" var="sValue" pattern=".00"/>
        <fmt:formatDate value="${sensor[Index].up_time}" var="sUp_time" type="DATE" pattern="yyyy-MM-dd HH:mm:ss"/>
            <c:if test="${not empty sensor_info[Index].naming}">
        getData.push({naming: "${sensor_info[Index].naming}", name:"${sName}", value:"${sValue}", up_time: "${sUp_time}"});
            </c:if>
            <c:if test="${empty sensor_info[Index].naming}">
        getData.push({naming: "${sName}", name:"${sName}", value:"${sValue}", up_time: "${sUp_time}"});
            </c:if>
        </c:forEach>
        return getData;
    }



    /* 측정소가 바뀐 데이터 조회*/
    function getPlaceChangeData(place){
        var getData = new Array();
        /* 측정소에 따라 센서명을 가져와 data 생성*/
        $.ajax({
            url:'getPlaceSensor',
            dataType: 'json',
            data:  {"name": place},
            async: false,
            success: function (data) {
                $.each(data, function (index, item) {
                    var sensor = getSensorRecent(item);
                    var sensorInfo = getSensorInfo(item);
                    if(sensorInfo == null && sensor == null){
                        getData.push({naming: item, value: "", up_time: ""});
                    }else if (sensorInfo == null && sensor != null){
                        getData.push({naming: item, name:item, value:sensor.value.toFixed(2), up_time: moment(sensor.up_time).format('YYYY-MM-DD HH:mm:ss')});
                    }else if(sensorInfo != null && sensor != null){
                        getData.push({naming: sensorInfo.naming, name:item, value:sensor.value.toFixed(2), up_time: moment(sensor.up_time).format('YYYY-MM-DD HH:mm:ss'),
                            warning: sensorInfo.warning, danger: sensorInfo.danger, substitution: sensorInfo.substitution});
                    }
                })
            },
            error: function (e) {
                console.log(e);
                getData.push({naming: "", value: "", up_time: ""});
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
            fail: function(){

            },
            error: function (e) {
                console.log(e);
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
                console.log(e);
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
            before: function(){

            },
            complete: function(){

            },
            success: function (data) {
                $.each(data, function (index, item) {
                    getData.push({x: moment(item.up_time).format('YYYY-MM-DD HH:mm:ss'), y: item.value.toFixed(2)});
                })
            },
            fail: function(){

            },
            error: function (e) {
                console.log(e);
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
            order:[[0, 'desc']],
            columns: [
                {"data": "naming"},
                {"data": "value"},
                {"data": "up_time"}
            ]
        });
        return table;
    }

    /* draw sensor time table */
    function draw_sensor_time_table(data) {
        var warning = 15;
        var danger = 30;
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
    function draw_chart(data) {
        var chart = new ApexCharts(document.querySelector("#chart"), setChartOption(data));
        //chart.render();
        return chart;
    }

    /* chart Option Setting */
    function setChartOption(data){
        var warning = 15;
        var danger = 30;
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
                max: max, //최대
                formatter: function (val) {
                    if(data == undefined || data.length === 0) {return 'No data'}
                    else {return val};
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