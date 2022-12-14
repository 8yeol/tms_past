<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>


<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="static/css/datepicker.min.css">
<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="stylesheet" href="static/css/page/alarm.css">

<script src="static/js/common/common.js"></script>
<script src="static/js/lib/moment.min.js"></script>
<script src="static/js/lib/apexcharts.min.js"></script>
<script src="static/js/lib/jquery.dataTables.min.js"></script>
<script src="static/js/lib/datepicker.min.js"></script>
<script src="static/js/lib/datepicker.ko.js"></script>
<script src="static/js/lib/sweetalert2.min.js"></script>

<div class="container" id="container">
    <div class="row m-3 mt-3 ms-1">
        <span class="fs-4 fw-bold">알림</span>
    </div>

    <div class="row m-3 mt-3 bg-light ms-1" style="position: relative" id="mainDiv">

        <ul class="tab">
            <c:if test="${group.groupNum == 1}">
                <c:forEach var="place" items="${allPlace}" varStatus="staus">
                    <li class="" onclick="tabClick(this, '${place.name}')">${place.name}</li>
                </c:forEach>
            </c:if>
            <c:if test="${group.groupNum != 1}">
                <c:forEach var="place" items="${group.monitoringPlace}" varStatus="staus">
                     <li class="" onclick="tabClick(this, '${place}')">${place}</li>
                </c:forEach>
            </c:if>
        </ul>

        <div class="row p-3 pb-0 ms-1">
            <div class="col-auto fs-5 fw-bold">
                알림 목록 <button class="btn" onclick="search('refresh')"> <i class="fas fa-sync-alt"></i> </button>
            </div>
            <div class="col" style="text-align: right;margin-right: 20px;">
                <div class="search">
                    <span class="fs-5 fw-bold p-3 f-sizing">검색기간</span>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="s_day" id="s_day" checked>
                        <label class="form-check-label" for="s_day">
                            오늘
                        </label>
                    </div>

                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="s_day" id="s_week">
                        <label class="form-check-label" for="s_week">
                            일주일
                        </label>
                    </div>

                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="s_day" id="s_custom">
                        <label class="form-check-label" for="s_custom">
                            사용자 정의
                        </label>
                    </div>
                    <a class="sign"></a><a class="sign"></a>
                    <input type="text" id="date_start" class="text-center p-1" disabled  autocomplete="off">
                    <label class="ms-3 me-3">-</label>
                    <input type="text" id="date_end" class="text-center p-1" disabled  autocomplete="off">

                    <button type="button" class="btn btn-primary ms-3" onClick="search()">검색</button>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col p-3" id="alarmTable">
                <table id="information" class="table table-bordered table-hover text-center mb-0" he>
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
            <div id="chart"></div>
        </div>
    </div>
</div>


<script>
    $( document ).ready(function() {
        $('.tab').children().eq(0).attr("class", "on");
        $("#date_start").val(getDays());
        $("#date_end").val(getDays());

        search();

        const placeName = $('.on').text();
        if($("input[id=week]:radio" ).is( ":checked")){
            const chartData = getWeekChartData(placeName);
            addChart(chartData);
        }
    });

    $("#date_start").datepicker({
        language:'ko',
        minDate: new Date("2021-05-12"),
        maxDate:new Date()
    });
    $("#date_end").datepicker({
        language:'ko',
        minDate: new Date("2021-05-12"),
        maxDate:new Date()
    });

    datePickerSet($("#date_start"), $("#date_end"), true); // 시작하는 달력 , 끝달력

    function datePickerSet(sDate, eDate, flag) {
        const sDay = sDate.val();
        const eDay = eDate.val();

        if (flag && !isValidStr(sDay) && !isValidStr(eDay)) { //처음 입력 날짜 설정, update...
            const sdp = sDate.datepicker().data("datepicker");
            sdp.selectDate(new Date(sDay.replace(/-/g, "/")));  //익스에서는 그냥 new Date하면 -을 인식못함 replace필요

            const edp = eDate.datepicker().data("datepicker");
            edp.selectDate(new Date(eDay.replace(/-/g, "/")));  //익스에서는 그냥 new Date하면 -을 인식못함 replace필요
        }

        //시작일자 세팅하기
        if (!isValidStr(eDay)) {
            sDate.datepicker({
                maxDate: new Date(eDay.replace(/-/g, "/"))
            });
        }

        sDate.datepicker({
            language: 'ko',
            autoClose: true,
            onSelect: function () {
                datePickerSet(sDate, eDate);
            }
        });

        //종료일자 세팅하기
        if (!isValidStr(sDay)) {
            eDate.datepicker({
                minDate: new Date(sDay.replace(/-/g, "/"))
            });
        }

        eDate.datepicker({
            language: 'ko',
            autoClose: true,
            onSelect: function () {
                datePickerSet(sDate, eDate);
            }
        });

        function isValidStr(str) {
            if (str == null || str == undefined || str == "")
                return true;
            else
                return false;
        }
    }

    $("input:radio[name=s_day]").click(function() {
        const $dates = $('#date_start, #date_end').datepicker();

        const id = $(this).attr('id');

        if(id == 's_custom'){
            $("#date_start").attr('disabled',false);
            $("#date_end").attr('disabled',false);
            $dates.datepicker('setDate',null);
        } else {
            $("#date_start").attr('disabled',true);
            $("#date_end").attr('disabled',true);
            $("#date_end").val(getDays());

            if(id == 's_week'){
                $("#date_start").val(getDays('week'));
            } else {
                $("#date_start").val(getDays());
            }
        }
    });

    //탭 이벤트
    function tabClick(obj, placeName) {
        $('.tab li').attr('class', '');
        $(obj).attr('class', 'on');
        $('#s_day').trigger('click');
        let chartData;
        if($("input[id=week]:radio" ).is( ":checked")){
            chartData = getWeekChartData(placeName);
        }else{
            chartData = getMonthChartData(placeName);
        }

        chartDataCheck(chartData);

        search();
    }

    function chartDataCheck(chartData){
        if(chartData.length != 0){
            addChart(chartData);
        }else{
            $("#chart").empty();
            $("#chart").append("<p style='text-align: center; padding-top: 150px'>센서 알림 현황이 없습니다.</p>");
        }
    }

    function getDays(dayType){
        if(dayType == 'week'){
            return moment(new Date()).subtract(7, 'd').format('YYYY-MM-DD');
        }
        return moment(new Date).format('YYYY-MM-DD');
    }

    function search(type){
        let from = $('#date_start').val();
        let to =$('#date_end').val();

        if(type=='refresh'){
            to = getDays();
            from = to;
            $("input:radio[id='s_day']").last().trigger('click');
        }

        if(from == "" || to == ""){
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '검색기간을 입력해주세요.'
            })
        }else{
            $.ajax({
                url: '<%=cp%>/getNotificationList',
                type: 'POST',
                dataType: 'json',
                async: false,
                cache: false,
                data: {
                    "from" : from,
                    "to" : to,
                    "placeName" : $('.on').text()
                },
                success : function(data) {
                    if(data.length != 0 && data != null){
                        $('#information').DataTable().clear();
                        $('#information').DataTable().destroy();

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

                            let notify;
                            if(data[i].grade==1){
                                notify = '법적기준 초과';
                            }else if(data[i].grade==2){
                                notify = '사내기준 초과';
                            }else if(data[i].grade==3){
                                notify = '관리기준 초과';
                            }

                            cell2.innerHTML = data[i].sensor + " 센서 " + notify;
                            //cell3.innerHTML = data[i].value.toFixed(2);
                            cell3.innerHTML = data[i].value;
                            cell4.innerHTML = moment(data[i].up_time).format('YYYY-MM-DD HH:mm:ss');
                            if(data[i].grade==1){
                                cell5.innerHTML = '<div class="bg-danger text-light">'+notify+'</div>'
                            }else if(data[i].grade==2){
                                cell5.innerHTML = '<div class="bg-warning text-light">'+notify+'</div>'
                            }else if(data[i].grade==3){
                                cell5.innerHTML = '<div class="bg-success text-light">'+notify+'</div>'
                            }
                        }

                        inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', "알림 목록 조회("+from+" ~ "+to+")","조회");
                        setDateTable();

                    }else{
                        $('#information').DataTable().clear();
                        $('#information').DataTable().destroy();
                        setDateTable();
                    }
                },
                error : function(request, status, error) {
                    console.log(error)
                }
            })
        }
    }

    function setDateTable(){
        $('#information').dataTable({
            lengthChange : false,
            pageLength: 10,
            info: false,
            order :[3, 'desc'],
            language: {
                emptyTable: "검색기간 내 알림 목록이 없습니다.",
                lengthMenu: "페이지당 _MENU_ 개씩 보기",
                info: "현재 _START_ - _END_ / _TOTAL_건",
                infoEmpty: "데이터 없음",
                infoFiltered: "( _MAX_건의 데이터에서 필터링됨 )",
                search: "테이블 내용 검색 : ",
                zeroRecords: "일치하는 데이터가 없어요.",
                loadingRecords: "로딩중...",
                processing: "잠시만 기다려 주세요...",
                paginate: {
                    next: "다음",
                    previous: "이전"
                },
            },
        });
    }


    $("input[name=day]").on('click' , function (){
        let chartData;
        if($("input[id=week]:radio" ).is( ":checked")){
            chartData = getWeekChartData();
        }else{
            chartData = getMonthChartData();
        }
        chartDataCheck(chartData);
    });

    /**
     * 일주일 ~ 현재 알림현황 리턴
     */
    function  getWeekChartData() {
        const place = $('.on')[0].innerText;
        let getData = new Array();
        $.ajax({  /* 현재 데이터 */
            url: '<%=cp%>/getNSNow',
            dataType: 'json',
            async: false,
            data: {"place": place},
           success: function (data) {
                if(data[1]!=null||data[2]!=null||data[3]!=null){
                    getData.push({day: data[0], legalCount:data[1]==null?0:data[1], companyCount:data[2]==null?0:data[2]
                        /*관리기준 임시삭제
                         , managementCount: data[3]==null?0:data[3]
                         */
                        });
                }
           }
        });
        $.ajax({ /* 일주일 ~ 전날 데이터 */
            url: '<%=cp%>/getNSWeek',
            dataType: 'json',
            data: {"place": place},
            async: false,
            success: function (data) {
                for(let i=0; i<data.length; i++){
                    getData.push({day: data[i].day, legalCount:data[i].legalCount, companyCount:data[i].companyCount
                        /* 관리기준 임시삭제
                         , managementCount: data[i].managementCount
                         */
                        });
                }
            }
        });
        if(getData.length == 0){
            getData = [];
        }
        return getData;
    }

    /**
     * 최근 12개
     * @returns {any[]}
     */
    function  getMonthChartData() {
        const place = $('.on')[0].innerText;
        const getData = new Array();
        $.ajax({
            url: '<%=cp%>/getNSMonth',
            dataType: 'json',
            async: false,
            data: {"place": place},
            success: function (data) {
                for(let i=0; i<data.length; i++){
                    getData.push({day: data[i].month, legalCount:data[i].legalCount, companyCount:data[i].companyCount
                        /* 관리기준 임시삭제
                         , managementCount: data[i].managementCount
                         */
                        });
                }
            },
            error: function (e) {
            }
        });
        return getData;
    }

    function addChart(chartData){
        const day = new Array();
        const legalCount = new Array();
        const companyCount = new Array();
        /*관리기준 임시삭제
         const managementCount = new Array();
         */
        for(let i=chartData.length-1; 0<=i; i--){
            day.push(chartData[i].day);
            legalCount.push(chartData[i].legalCount);
            companyCount.push(chartData[i].companyCount);
            /*관리기준 임시삭제
             managementCount.push(chartData[i].managementCount);
             */
        }
        const options = {
            series: [{
                name: '법적 기준 초과',
                data: legalCount
            }, {
                name: '사내 기준 초과',
                data: companyCount
            }
            /*관리기준 임시삭제
            , {
                name: '관리 기준 초과',
                data: managementCount
            }
             */
            ],
            colors: ['#F44336', '#ffc107', '#198754'],
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
                categories: day,
            },
            yaxis:{
                decimalsInFloat: 2,
                labels:{
                    show: true,
                    formatter: function(val){
                        return val;
                    }
                }
            },
            fill: {
                opacity: 1,
            },
            tooltip: {
                y: {
                    formatter: function (val) {
                        return val;
                    }
                }
            }
        };
        $("#chart").empty();
        const chart = new ApexCharts(document.querySelector("#chart"), options);
        chart.render();
    }
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>