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
</style>

<div class="container">
    <%-- ************************************************************************************************************** --%>
    <div class="row">
        <div class="col-12 bg-gradient p-4 mt-4 ms-3 bg-skyblue rounded">
            <div class="col-6 ms-3 add-bg">
                <div class="col-md-12">
                    <span class="fs-5 fw-bold">측정소</span>
                    <div class="btn-group w-50 ms-3">
                        <select id="place" class="btn btn-light" onchange="changePlace()">
                            <c:forEach var="place" items="${place}">
                                <option value="${place.name}">${place.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <hr>

    <div class="row">
        <div class="col">
            <div class="row">
                <div class="col-6">
                    <div class="float-start">
                        <span class="fs-5 fw-bold mb-2" id="title"> </span>
                    </div>
                </div>
                <div class="col-3">
                    <div class="float-start">
                        <span class="fs-5 fw-bold mb-2" id="sensorInfo1"> </span>
                        <span class="fs-7 mb-2" id="sensorInfo2"> </span>
                    </div>
                </div>
                <div class="col-3">
                    <div>
                        <span class="fs-7 mb-2"> 업데이트 : </span>
                        <span class="fs-5 mb-2" id="update"> </span>
                    </div>
                </div>
            </div>
            <div class="row h-75 mt-4">
                <div class="col-md-6">
                    <%-- 센서 최근 테이블--%>
                    <div class="table-responsive bg-gradient col-md-12">
                        <table id="place-table">
                            <thead>
                            <tr>
                                <th>항목</th>
                                <th>측정값</th>
                                <th>업데이트</th>
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
                    <table id="sensor-table" class="table-responsive bg-success bg-gradient col-md-12 mt-1">
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
    var place_table, sensor_table, sensor_chart;
    var interval1, interval2;

    $(document).ready(function () {
        changePlace();
    }); //ready

    function changePlace() {
        getData();
    }

    $("#place-table").on('click', 'tr', function(){
        var sensor_data = place_table.row(this).data();
        getData2(sensor_data.name);
    });

    function getData(){
        var place_name = $("#place").val(); // 측정소명
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
            interval1 = setTimeout(interval_getData, 2000);
        }, 0);
        var sensor_data = place_table.row(0).data();
        getData2(sensor_data.name);
    }
    function getData2(sensor_name) {
        var sensor_data_list = getSensor(sensor_name, "", "", "60");
        draw_chart(sensor_data_list);
        draw_sensor_table(sensor_data_list);

        setTimeout(function interval_getData2() {
            clearTimeout(interval2);
            console.log("g2: "+interval2);
            var sensor_data_list_recent = getSensor(sensor_name, "", "", 1);
            if(sensor_data_list_recent.length != 0){ // null = []
                if(sensor_data_list[0].x != sensor_data_list_recent[0].x){
                    sensor_data_list.unshift(sensor_data_list_recent[0]);
                    // sensor_data_list.pop();
                    draw_sensor_table(sensor_data_list);
                    draw_chart(sensor_data_list);
                }
            }
            interval2 = setTimeout(interval_getData2, 2000);
        }, 0);

    }


    /* 측정소가 바뀐 데이터 조회*/
    function getPlaceData(place){
        var getData = new Array();
        $.ajax({
            url:'getPlaceSensor',
            dataType: 'json',
            data:  {"place": place},
            async: false,
            success: function (data) {
                /* 센서명 구함 -> 센서명으로부터 최근데이터, 센서정보 구함 */
                $.each(data, function (index, item) {
                    var sensor = getSensorRecent(item);
                    // console.log(sensor);
                    var sensorInfo = getSensorInfo(item);
                    // console.log(sensorInfo);
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
                $.each(data, function (index, item) {
                    getData.push({x: moment(item.up_time).format('YYYY-MM-DD HH:mm:ss'), y: item.value});
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
    function draw_sensor_table(data) {

        $("#sensor-table").DataTable().clear();
        $("#sensor-table").DataTable().destroy();

        $('#sensor-table').dataTable({
            data: data,
            columns:[
                {"data": "x"},
                {"data": "y"}
            ],
            // aLengthMenu: [10, 25, 50],
            search: false,
            searching: false,
            bInfo: false,
            ordering: true,
            pagingType: 'numbers',
            order:[[0, 'desc']],
            'rowCallback': function(row, data, index){
                // console.log(row);
                // console.log(data.y);
                // if(data.y>=danger){
                //     $(row).find('td:eq(1)').css('color', '#f54264');
                // }
                // if(data.y <= danger && data.y>=warning){
                //     $(row).find('td:eq(1)').css('color', '#ffb607');
                // }
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
        $("#chart").empty();
        new ApexCharts(document.querySelector("#chart"), setChartOption(data)).render();
    }

    /* chart Option Setting */
    function setChartOption(data){
        // console.log(data);
        var min = 0;
        var max = 30*2;
        var options = {
            series: [{
                // name: name,
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
                    animations:{
                        enabled: false,
                        speed:1500
                    }
                },
                tooltip:{
                    enabled: false
                }
            },
            /*plotOptions: {
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
            },*/
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


</script>

