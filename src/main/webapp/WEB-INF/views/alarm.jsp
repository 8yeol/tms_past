<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<script src="static/js/moment.min.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>

<style>
    .new {
        font-size: 14px;
        color: #fff;
        background-color: #db3535;
        border-radius: 50px;
        display: inline-block;
        width: 23px;
        height: 23px;
        margin-right: 5px;
    }

    /* 데이터테이블 */
    .toolbar>b {
        font-size: 1.25rem;
    }

    table thead {
        background-color: #97bef8;
        color: #fff;
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

    #information_filter label {
        margin-bottom: 5px;
    }
</style>
<div class="container">

    <div class="row m-3 mt-3 ms-1">
        <span class="fs-4 fw-bold">알림</span>
    </div>

    <div class="row m-3 mt-3 bg-light ms-1 h-80">
        <div class="row p-3 ms-1">
            <div class="col fs-5 fw-bold">
                알림 목록
            </div>
            <div class="col text-end">
                <span class="small">마지막 업데이트 : <span class="fw-bold" id="notify_info">업데이트 시간</span></span><br>
                <span class="text-primary" style="font-size: 15%"> * 5분 단위으로 업데이트 됩니다.</span>
            </div>
        </div>
        <div class="row">
            <div class="col p-3">
                <table id="information" class="table table-bordered table-hover text-center" >
                    <thead class="add-bg-color">
                    <tr>
                        <th>순번</th>
                        <th>측정소</th>
                        <th>알림내용</th>
                        <th>데이터</th>
                        <th>알림시간</th>
                        <th>구분</th>
                    </tr>
                    </thead>
                    <tbody id="informationBody">
                    <%--script--%>
                    </tbody>
                    <tfoot>
                    <%--script--%>
                    </tfoot>
                </table>
            </div>
        </div>
        <div class="row">
            <div class="col text-end me-2" id="paging">
                <%--script--%>
            </div>
        </div>

        <hr>

        <div class="row p-3 ms-1">
            <div class="col fs-5 fw-bold">
                센서 알림 현황
            </div>
            <div class="col text-end align-self-end mb-2">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="day" id="week" checked>
                    <label class="form-check-label" for="week">
                        일 별
                    </label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="day" id="month">
                    <label class="form-check-label" for="month">
                        월 별
                    </label>
                </div>
            </div>
        </div>
        <div class="row">
            <div id="chart">
        </div>
</div>

<script>
    $( document ).ready(function() {
        $("#notify_info").text(moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));
        $("#notify_chart").text(moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));
        addChart();
        addTable();
    });

    function addTable() {
        addTableData();
        // 매 5분마다 실행되게 하는 평션
        const FIVE_MINUTES = 5 * 60 * 1000;
        const timeSinceBoundary = new Date() % FIVE_MINUTES;
        const timeToSetInterval = timeSinceBoundary === 0 ? 0 : (FIVE_MINUTES - timeSinceBoundary);
        setTimeout(function () {
            setInterval(function () {
                addTableData();
            }, FIVE_MINUTES);
        }, timeToSetInterval);
    }

    function addTableData(){
        console.log(" 실행시간 : " + moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));

        $('#information').DataTable().clear();
        $('#information').DataTable().destroy();

        $.ajax({
            url: '<%=cp%>/notificationList',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {},
            success : function(data) {
                const tbody = document.getElementById('informationBody');
                for(let i=0; i<data.length; i++){
                    const row = tbody.insertRow( tbody.rows.length );
                    const cell1 = row.insertCell(0);
                    const cell2 = row.insertCell(1);
                    const cell3 = row.insertCell(2);
                    const cell4 = row.insertCell(3);
                    const cell5 = row.insertCell(4);

                    const now = moment();
                    const upTime = moment(new Date(data[i].up_time), 'YYYY-MM-DD HH:mm:ss');
                    const minutes = moment.duration(now.diff(upTime)).asMinutes();

                    if(minutes <= 5){
                        cell1.innerHTML = "<span class='new'>N</span> " + data[i].place;
                    } else{
                        cell1.innerHTML = data[i].place;
                    }

                    cell2.innerHTML = data[i].sensor + " 센서 " + data[i].notify;
                    cell3.innerHTML = data[i].value.toFixed(2);
                    cell4.innerHTML = moment(data[i].up_time).format('YYYY-MM-DD HH:mm:ss');
                    if(data[i].grade==1){
                        cell5.innerHTML = '<div class="bg-danger text-light">'+data[i].notify+'</div>'
                    }else if(data[i].grade==2){
                        cell5.innerHTML = '<div class="bg-warning text-light">'+data[i].notify+'</div>'
                    }else if(data[i].grade==3){
                        cell5.innerHTML = '<div class="bg-success text-light">'+data[i].notify+'</div>'
                    }else{
                        cell5.innerHTML = data[i].notify;
                    }
                }
            },
            error : function(request, status, error) {
                console.log(error)
            }
        })

        $('#information').dataTable({
            lengthChange : false,
            pageLength: 10,
            info: false,
            order: false,
        });

        $("#notify_info").text(moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));
    }

    function addChart(){
        const options = {
            series: [{
                name: 'Net Profit',
                data: [44, 55, 57, 56, 61, 58, 63, 60, 66]
            }, {
                name: 'Revenue',
                data: [76, 85, 101, 98, 87, 105, 91, 114, 94]
            }, {
                name: 'Free Cash Flow',
                data: [35, 41, 36, 26, 45, 48, 52, 53, 41]
            }],
            chart: {
                type: 'bar',
                height: 400
            },
            plotOptions: {
                bar: {
                    horizontal: false,
                    columnWidth: '55%',
                    endingShape: 'rounded'
                },
            },
            dataLabels: {
                enabled: false
            },
            stroke: {
                show: true,
                width: 2,
                colors: ['transparent']
            },
            xaxis: {
                categories: ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
            },
            yaxis: {
                title: {
                    text: '$ (thousands)'
                }
            },
            fill: {
                opacity: 1
            },
            tooltip: {
                y: {
                    formatter: function (val) {
                        return "$ " + val + " thousands"
                    }
                }
            }
        };
        const chart = new ApexCharts(document.querySelector("#chart"), options);
        chart.render();
    }
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



