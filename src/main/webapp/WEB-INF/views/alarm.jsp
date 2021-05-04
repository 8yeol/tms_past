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
    .h-80{
        height: 80%;
    }
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
                <table id="information" class="table table-bordered table-hover text-center mb-0" >
                    <thead class="add-bg-color">
                    <tr>
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
    let table;
    //let TOTAL = 0, PREVIOUS_TOTAL = 0;
    function addTable(){
        $('#information').DataTable().clear();
        $('#information').DataTable().destroy();
/*

        $.ajax({
            url: '<%=cp%>/getNotificationTotal',
            type: 'POST',
            dataType: 'text',
            async: false,
            cache: false,
            data: {"pageNo":1},
            success : function(data) {
                TOTAL = data;
            },
            error : function(request, status, error) {
                console.log(error)
            }
        })

        if(TOTAL > PREVIOUS_TOTAL){

        }
*/

        //paging(TOTAL, 10, 5, 1)

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

                    if(minutes < 5){
                        cell1.innerHTML = "<span class='new'>N</span> " + data[i].place;
                    } else{
                        cell1.innerHTML = data[i].place;
                    }

                    cell2.innerHTML = data[i].sensor + " 센서 " + data[i].notify;
                    cell3.innerHTML = data[i].value.toFixed(2);
                    cell4.innerHTML = moment(data[i].up_time).format('YYYY-MM-DD HH:mm:ss');
                    cell5.innerHTML = data[i].notify;
                }
            },
            error : function(request, status, error) {
                console.log(error)
            }
        })

        table = $('#information').dataTable({
            lengthChange : false,
            pageLength: 10,
            info: false,
            order: false,
        });
    }
/*
    function paging(totalData, dataPerPage, pageCount, currentPage){

        console.log("currentPage : " + currentPage);

        const totalPage = Math.ceil(totalData/dataPerPage);    // 총 페이지 수
        const pageGroup = Math.ceil(currentPage/pageCount);    // 페이지 그룹

        console.log("pageGroup : " + pageGroup);

        let last = pageGroup * pageCount;    // 화면에 보여질 마지막 페이지 번호
        if(last > totalPage)
            last = totalPage;
        const first = last - (pageCount-1);    // 화면에 보여질 첫번째 페이지 번호
        const next = last+1;
        const prev = first-1;

        console.log("last : " + last);
        console.log("first : " + first);
        console.log("next : " + next);
        console.log("prev : " + prev);

        let html = "";

        if(prev > 0)
            html += "<a href=# id='prev'><</a> ";

        for(let i=first; i <= last; i++){
            html += "<a href='#' id=" + i + ">" + i + "</a> ";
        }

        if(last < totalPage)
            html += "<a href=# id='next'>></a>";

        $("#paging").html(html);    // 페이지 목록 생성
        $("#paging a").css("color", "black");
        $("#paging a#" + currentPage).css({"text-decoration":"none",
            "color":"red",
            "font-weight":"bold"});    // 현재 페이지 표시

        $("#paging a").click(function(){
            $('#information > tbody').empty();

            const $item = $(this);
            const $id = $item.attr("id");
            let selectedPage = $item.text();

            console.log(selectedPage)

            if($id == "next")    selectedPage = next;
            if($id == "prev")    selectedPage = prev;

            $.ajax({
                url: '<%=cp%>/notificationList',
                type: 'POST',
                dataType: 'json',
                async: false,
                cache: false,
                data: {"pageNo":selectedPage},
                success : function(data) {
                    const tbody = document.getElementById('informationBody');
                    for(let i=0; i<data.length; i++){
                        const row = tbody.insertRow( tbody.rows.length );
                        const cell1 = row.insertCell(0);
                        const cell2 = row.insertCell(1);
                        const cell3 = row.insertCell(2);
                        const cell4 = row.insertCell(3);
                        const cell5 = row.insertCell(4);
                        cell1.innerHTML = data[i].place;
                        cell2.innerHTML = data[i].sensor + " 센서 " + data[i].notify;
                        cell3.innerHTML = data[i].value.toFixed(2);
                        cell4.innerHTML = moment(data[i].up_time).format('YYYY-MM-DD HH:mm:ss');
                        cell5.innerHTML = data[i].notify;
                    }
                },
                error : function(request, status, error) {
                    console.log(error)
                }
            })

            paging(totalData, dataPerPage, pageCount, selectedPage);
        });

    }
*/

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



