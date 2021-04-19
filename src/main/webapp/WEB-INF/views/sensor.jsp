<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 3:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
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
    <c:forEach var="place" items="${place}">
        <%--    <c:out value="${place}"/>--%>
        <p id="place-name"><c:out value="${place.name}"/></p>
    </c:forEach>

    <table id="sensor-table">
        <thead>
            <tr>
                <th>항목</th>
                <th>측정값</th>
                <th>업데이트일</th>
            </tr>
        <thead>
    </table>
<%-- ************************************************************************************************************** --%>
    <div id="app">
        <div id="chart">
        </div>
    </div>

    <table id="sensor-table-time" class="display">
        <thead>
            <tr>
                <th>측정시간</th>
                <th>측정 값</th>
            </tr>
        </thead>
    </table>
<%-- ************************************************************************************************************** --%>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    var data1 = new Array();
    <c:forEach items="${sensors}" var="sName" varStatus="status">
        <c:set var="sIndex" value="sensor${status.index}"/>
        <c:forEach var="sensor" items="${requestScope[sIndex]}">
            <fmt:formatNumber value="${sensor.value}" var="sValue" pattern=".00"/>
            <fmt:formatDate value="${sensor.up_time}" var="sUp_time" type="DATE" pattern="yyyy-MM-dd HH:mm:ss"/>
            data1.push({name: "${sName}", value: "${sValue}", up_time: "${sUp_time}"});
        </c:forEach>
    </c:forEach>

    var table1 = $('#sensor-table').DataTable({
        paging: false,
        searching: false,
        select: true,
        data: data1,
        bPaginate: false,
        bInfo: false,
        columns: [
            {"data": "name"},
            {"data": "value"},
            {"data": "up_time"}
        ]
    });;

    $(document).ready(function () {
        $('#sensor-table').DataTable();
        $('#sensor-table-time').DataTable({
            aLengthMenu: [10, 25, 50]
        });
    }); //ready


    $("#sensor-table").on('click', 'tr', function(){
        var sensor_data = table1.row(this).data();
        var name = sensor_data.name;

        var sensor = new Array();
        var warning = 20; //경고값
        var hazard = 40; //위험값
        var min = 0; //chart - Y 최소값
        var max = hazard*2; //chart - Y 최대값

        var table2 = $("#sensor-table-time").DataTable();
        table2.destroy();
        $.ajax({
            url:'getSensorL',
            dataType: 'json',
            data: {"sensor": name, "limit": 30},
            async: true,
            success: function (data) {
                var result = data;
                for(var i=0; i<result.length; i++){
                    var s_uptime = format_time(new Date(Date.parse(result[i].up_time)));
                    var s_value = Number(result[i].value).toFixed(2);
                    sensor.push({x: s_uptime, y: s_value}); //chart data
                }
                $('#sensor-table-time').dataTable({
                    search: false,
                    data: sensor,
                    columns:[
                        {"data": "x"},
                        {"data": "y"}
                    ],
                    aLengthMenu: [10, 25, 50],
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
            },
            error: function (e) {
                console.log(e);
            }
        });
        /* chart 생성 */
        var options = {
            series: [{
                name: name,
                data: sensor
            }],
            chart: {
                height: 350,
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
                decimalsInFloat: 0, //소수점아래
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
        var chart = new ApexCharts(document.querySelector("#chart"), options);
        chart.render();

    });

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