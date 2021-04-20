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

<div class="container">
    <%-- ************************************************************************************************************** --%>
    <div class="row bg-secondary offset-md-9">
        마지막 업데이트 :
    </div>
    <div class="row p-5">
        ${param.place}
<%--        <c:forEach var="place" items="${place}">--%>
<%--            <c:out value="${place.name}"/>--%>
<%--        </c:forEach>--%>
    </div>
    <div class="row bg-warning h-75">
        <div class="col-md-6">
            <%-- 센서 최근 테이블--%>
            <div class="table-responsive bg-secondary col-md-12">
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
        <div class="bg-secondary col-md-6">
            <div id="chart" class="col-md-12">
            </div>
            <%-- 차트에 해당하는 테이블 --%>
            <table id="sensor-table-time" class="table-responsive col-md-12">
                <thead>
                <tr>
                    <th>측정시간</th>
                    <th>측정 값</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
    <%-- ************************************************************************************************************** --%>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    var warning, hazard;
    var min, max;
    var table1, table2, chart1;
    var data = [];
    $(document).ready(function () {
        table1 = draw_sensor_table(getSensorData());
        table2 = draw_sensor_time_table();
        chart1 = draw_chart(data);
        chart1.render();
    }); //ready


    $("#sensor-table").on('click', 'tr', function(){
        var limit = 10;

        /* table 1 - get Sensor Name */
        var sensor_data = table1.row(this).data();
        var name = sensor_data.name;
        /* get Sensor Data */
        var sensor_data = getSensor(name, limit);

        /* chart 1 draw */
        chart1.destroy();
        chart1 = draw_chart(sensor_data);
        chart1.render();
        /* table 2 draw */
        var table2 = $("#sensor-table-time").DataTable();
        table2.destroy();
        table2 = draw_sensor_time_table(sensor_data);

        setInterval(function () {
            /* 최근 데이터 조회 */
            var sensor_data_recent = getSensor(name, 1);
            if(sensor_data[0].x != sensor_data_recent[0].x){
                sensor_data.unshift(sensor_data_recent[0]); //배열의 0번째로 삽입
                sensor_data.pop(); //배열의 마지막 삭제

                /* chart 1 draw */
                chart1.destroy();
                chart1 = draw_chart(sensor_data);
                chart1.render();

                /* table 2 draw */
                var table2 = $("#sensor-table-time").DataTable();
                table2.destroy();
                table2 = draw_sensor_time_table(sensor_data);
            }
        }, 1000);

    });

    /* select * from sensor where name = ? order by up_time desc limit = ? */
    function getSensor(name, limit) {
        var getData = new Array();
        $.ajax({
            url:'getSensorL',
            dataType: 'json',
            data: {"sensor": name, "limit": limit},
            async: false,
            before: function(){

            },
            complete: function(){

            },
            success: function (data) {
                var result = data;
                for(var i=0; i<result.length; i++){
                    var s_uptime = format_time(new Date(Date.parse(result[i].up_time)));
                    var s_value = Number(result[i].value).toFixed(2);
                    getData.push({x: s_uptime, y: s_value}); //chart data
                }
            },
            fail: function(){

            },
            error: function (e) {
                console.log(e);
            }
        }); //ajax
        return getData;
    }


    function getSensorData() {
        var data = new Array();
        <c:forEach items="${sensors}" var="sName" varStatus="status">
            <c:set var="sIndex" value="sensor${status.index}"/>
            <c:forEach var="sensor" items="${requestScope[sIndex]}">
                <fmt:formatNumber value="${sensor.value}" var="sValue" pattern=".00"/>
                <fmt:formatDate value="${sensor.up_time}" var="sUp_time" type="DATE" pattern="yyyy-MM-dd HH:mm:ss"/>
                data.push({name: "${sName}", value: "${sValue}", up_time: "${sUp_time}"});
            </c:forEach>
        </c:forEach>
        return data;
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
            columns: [
                {"data": "name"},
                {"data": "value"},
                {"data": "up_time"}
            ]
        });;
        return table;
    }

    /* draw sensor time table */
    function draw_sensor_time_table(data) {
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
                if(data.y>=hazard){
                    $(row).find('td:eq(1)').css('color', 'red');
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
        var hazard = 30;
        var min = 0;
        var max = hazard*2;
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
                            to: hazard-0.001,
                            color: '#f5dc48'
                        }, {
                            from: hazard,
                            to: max,
                            color: '#eb7170'
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

    /* yyyy-mm-dd hh:mm:ss 포맷 변경*/
    function format_time(time) {
        var f_time = time;
        var year = f_time.getFullYear();
        var month = f_time.getMonth();
        if(month<10){
            month = "0"+month;
        }
        var day = f_time.getDay();
        if(day<10){
            day = "0"+day;
        }
        var hh = f_time.getHours();
        if(hh<10){
            hh = "0"+hh;
        }
        var mm = f_time.getMinutes();
        if(mm<10){
            mm = "0"+mm;
        }
        var ss = f_time.getSeconds();
        if(ss<10){
            ss = "0"+ss;
        }
        return year+"-"+month+"-"+day+" "+hh+":"+mm+":"+ss;
    }
</script>
