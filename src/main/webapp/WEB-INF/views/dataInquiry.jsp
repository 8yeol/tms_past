<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-20
  Time: 오전 11:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<link rel="stylesheet" href="static/css/datepicker.min.css">
<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<script src="static/js/datepicker.min.js"></script>
<script src="static/js/datepicker.ko.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>
<script src="static/js/moment.min.js"></script>
<%--공통코드--%>
<script src="static/js/common/common.js"></script>

<style>
    .search {
        position: relative;
        left: 285px;
        top: -18px;
    }
    .picker {
        position: relative;
        top: 20px;
    }
    .toolbar {
        float: left;
    }
    .add-bg {
        background-color: #fff;
        width: 100%;
        position: relative;
        left: -20px;
        top: -3px;
    }
    .add-margin {
        margin-left: 28px;
    }
    .down {
        position: relative;
        top:-663px;
    }
    .add-bg-color {
        background-color: #97bef8;
        color: #fff;
    }
    .height {
        height: 1085px;
    }
    .add-margin-top {
        margin-top: 10px;
    }
    .sizing {
        width: 1087px;
        height: 638px;
    }
    label {
        margin-bottom: 5px;
    }

    /* 데이터테이블 */
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

    /* 미디어쿼리 */
    @media all and (max-width: 1399px) and (min-width: 1200px) {
        .sizing {width:937px;}
        body {font-size: 0.8rem;}
        .search {left:260px;}
    }
    @media all and (max-width: 1199px) and (min-width: 990px) {
        .sizing {width:787px;}
        body {font-size: 0.7rem;}
        .add-margin {margin-left: 5px;}
        .search {left:160px;}
        .f-sizing {font-size: 0.9rem!important;}
    }

    @media all and (max-width: 989px) {
        .sizing {width: 707px;top:120px;}
        .picker {width: 100%;}
        .add-margin {margin-left: 15px;}
        .search {left:0px;top:10px;}
        body {font-size: 0.8rem;}
        .f-sizing {font-size: 0.9rem!important;}
        .add-bg{width:720px; height: 120px;}
        #date_start, #date_end {width:120px;}
        .down {top:-1220px; width: 740px; height: 110px; padding-bottom: 20px;}
        .m-top{padding-top: 100px;}
    }
</style>


<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<script src="static/js/sweetalert2.min.js"></script>

<div class="container">
    <div class="ms-3 mt-3 add-bg row">
        <div class="col-3 picker">
            <span class="fs-5 fw-bold add-margin f-sizing">측정소</span>
            <div class="btn-group w-50 ms-3">
                <select name="place" id="place" class="btn btn-light" onchange="placeChange()">
                    <c:forEach var="place" items="${place}" varStatus="status">
                        <option value="${place}">${place}</option>
                    </c:forEach>
                </select>
            </div>

        </div>
        <div class="search">
            <span class="fs-5 fw-bold p-3 f-sizing">측정기간</span>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="day" id="day" checked>
                <label class="form-check-label" for="day">
                    오늘
                </label>
            </div>

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="day" id="week">
                <label class="form-check-label" for="week">
                    일주일
                </label>
            </div>

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="day" id="custom">
                <label class="form-check-label" for="custom">
                    사용자 정의
                </label>
            </div>

            <input type="text" id="date_start" class="text-center p-1" disabled>
            <label class="ms-3 me-3">-</label>
            <input type="text" id="date_end" class="text-center p-1" disabled>

            <button type="button" class="btn btn-primary ms-3" onClick="search(1)">검색</button>
        </div>
    </div>

    <hr class="mt-2 mb-2">

    <div class="row" style="margin-left: 1px;">
        <div class="col">
            <div class="row bg-white sizing">
                <div class="row add-margin-top">
                    <div class="col add-margin">
                        <div class="float-start">
                            <div class="fs-5 fw-bold mb-2" id="title"> </div>
                        </div>
                    </div>

                    <div class="col">
                        <div class="float-end">
                            <div class="form-check pt-2">
                                <input class="form-check-input" type="checkbox" value="" id="off">
                                <label class="form-check-label fw-bold small" for="off">
                                    Off 데이터 표시
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="chart-line2"></div>
                <div id="chart-line"></div>
            </div>
        </div>

    </div>

    <div class="row">
        <div class="col">
            <div class="row bg-white m-top" style="margin-left: 1px;">
                <div class="row ms-2">
                    <div class="col">
                        <table id="information" class="table table-striped table-bordered table-hover text-center" >
                            <thead class="add-bg-color">
                            <tr>
                                <th width="10%">순번</th>
                                <th width="20%">측정 값</th>
                                <th width="20%">관리등급</th>
                                <th width="20%">모니터링 여부</th>
                                <th width="30%">업데이트 시간</th>
                            </tr>
                            </thead>
                            <tbody id="informationBody">

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
        <div class="col-lg-2 down">
            <div class="mt-4 p-2 bg-white text-center">차트 항목 선택</div>

            <div class="border p-2 bg-white h-75" id="items">
                <%-- script --%>
            </div>
        </div>
    </div>
</div>

<script charset="UTF-8">
    $( document ).ready(function() {
        $("#date_start").val(getDays());
        $("#date_end").val(getDays());
        placeChange();
        search(0);

        $("label>input").attr("placeholder","Search");

        $("#information_filter label")
            .contents()
            .filter(function () {
                // get only the text nodes
                return this.nodeType === 3 && this.nodeValue.trim() !== "";
            }).wrap("<p />");

        $("#information_filter label>p").remove();
    });

    function addTable(reference){
        $('#information').DataTable().clear();
        $('#information').DataTable().destroy();

        const management = reference.get("management");
        const company = reference.get("company");
        const legal = reference.get("legal");

        $.ajax({
            url: '<%=cp%>/searchInformatin',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"date_start":$('#date_start').val(),
                "date_end":$('#date_end').val(),
                "item":$('input[name="item"]:checked').val(),
                "off":$('#off').is(":checked")
            },
            success : function(data) {
                const tbody = document.getElementById('informationBody');

                for(let i=0; i<data.length; i++){
                    const row = tbody.insertRow( tbody.rows.length );
                    const cell1 = row.insertCell(0);
                    const cell2 = row.insertCell(1);
                    const cell3 = row.insertCell(2);
                    const cell4 = row.insertCell(3);
                    const cell5 = row.insertCell(4);
                    cell1.innerHTML = i+1;
                    let value = data[i].value.toFixed(2);
                    cell2.innerHTML = value;
                    let grade = '정상';
                    if(value > legal){
                        grade = '<div class="bg-danger text-light">법적기준 초과</div>';
                    } else if(value > company){
                        grade = '<div class="bg-warning text-light">사내기준 초과</div>';
                    } else if(value > management){
                        grade = '<div class="bg-success text-light">관리기준 초과</div>';
                    }
                    cell3.innerHTML = grade;
                    cell4.innerHTML = (data[i].status?"ON":"OFF");
                    cell5.innerHTML = moment(data[i].up_time).format('YYYY-MM-DD HH:mm:ss');
                }
            },
            error : function(request, status, error) {
                console.log(error)
            }
        })

        $('#information').dataTable({
            dom: '<"toolbar">Bfrtip',
            buttons: [
                'copy', 'csv', 'excel', 'pdf', 'print'
            ],
            "pageLength": 8
        });

        $("div.toolbar").html('<b>상세보기</b>');
    }

    $("#date_start").datepicker({
        language:'ko',
        maxDate:new Date()
        //timepicker: true,
        //timeFormat: "hh:ii AA"
    });
    $("#date_end").datepicker({
        language:'ko',
        maxDate:new Date()
        //timepicker: true,
        //timeFormat: "hh:ii AA"
    });

    datePickerSet($("#date_start"), $("#date_end"), true); // 시작하는 달력 , 끝달력

    function datePickerSet(sDate, eDate, flag) {
        if (!isValidStr(sDate) && !isValidStr(eDate) && sDate.length > 0 && eDate.length > 0) {
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

            //한개짜리 달력 datepicker
        } else if (!isValidStr(sDate)) {
            const sDay = sDate.val();
            if (flag && !isValidStr(sDay)) { //처음 입력 날짜 설정, update...
                const sdp = sDate.datepicker().data("datepicker");
                sdp.selectDate(new Date(sDay.replace(/-/g, "/"))); //익스에서는 그냥 new Date하면 -을 인식못함 replace필요
            }


            sDate.datepicker({
                language: 'ko',
                autoClose: true
            });
        }
        function isValidStr(str) {
            if (str == null || str == undefined || str == "")
                return true;
            else
                return false;
        }
    }

    $('#off').click(function(){
        search(1);
    });

    $("input:radio[name=day]").click(function() {
        $("#date_start").val("");
        $("#date_end").val("");

        const id = $(this).attr('id');

        if(id == 'custom'){
            $("#date_start").attr('disabled',false);
            $("#date_end").attr('disabled',false);
        } else {
            $("#date_start").attr('disabled',true);
            $("#date_end").attr('disabled',true);

            $("#date_end").val(getDays());

            if(id == 'week'){
                $("#date_start").val(getDays('week'));
            } else {
                $("#date_start").val(getDays());
            }
        }
    });

    function placeChange(){
        const place = $("#place").val();

        $("#items").empty();

        $.ajax({
            url: '<%=cp%>/getPlaceSensor',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place":place},
            success : function(data) {
                for(let i=0;i<data.length;i++){
                    const tableName = data[i];
                    const category = findSensorCategory(tableName);

                    const innerHtml = "<div class='form-check mb-2'>" +
                        "<input class='form-check-input' type='radio' name='item' id='"+tableName+"' value='"+tableName+"' onclick='changeItem()'>" +
                        "<label class='form-check-label' for='"+tableName+"'>"+category+"</label>" +
                        "</div>"

                    const elem = document.createElement('div');
                    elem.innerHTML = innerHtml
                    document.getElementById('items').append(elem);
                }
                const item = $("input[name='item']").eq(0).val();
                $("#"+item).prop("checked",true);
            },
            error : function(request, status, error) {
                console.log(error)
            }
        })
    }

    function changeItem(){
        search(1);
    }

    function search(flag){
        const date_start =  $('#date_start').val();
        const date_end = $('#date_end').val();
        const item = $('input[name="item"]:checked').val();
        const off = $('#off').is(":checked"); // false : 선택안됨(표시X) , true : 선택(표시)

        const place = $("#place").val();
        const category = findSensorCategory(item);
        $('#title').text(place + " - " + category);

        if(date_start==""||date_end==""){
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '검색 날짜를 입력해주세요.'
            })
        }

        $.ajax({
            url: '<%=cp%>/searchChart',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"date_start":date_start,
                "date_end":date_end,
                "item":item,
                "off":off,
            },
            success : function(data) {
                if(data.length==0){
                    Swal.fire({
                        icon: 'warning',
                        title: '경고',
                        text: '검색 결과가 없습니다.'
                    })
                    return false;
                }else{
                    const reference = getReferenceValue(item);
                    addChart(data, category, reference, flag);
                    addTable(reference);
                }
            },
            error : function(request, status, error) {
                console.log(error)
            }
        })
    }

    function getReferenceValue(tableName){
        let reference = new Map();
        $.ajax({
            url:'<%=cp%>/getReferenceValue',
            dataType: 'json',
            data:  {"tableName": tableName},
            async: false,
            success: function (data) {
                reference.set("management",data.management_standard);
                reference.set("company",data.company_standard);
                reference.set("legal",data.legal_standard);
            },
            error: function(request, status, error) {
                console.log(error)
            }
        });
        return reference;
    }

    let options = null, chart = null, optionsLine =null, chartLine =null;
    function addChart(data, category, reference, flag){
        if (flag==0){
            options = {
                series: [{
                    name: category,
                    data: data
                }],
                chart: {
                    id: 'chart2',
                    type: 'line',
                    height: 350,
                    toolbar: {
                        show: true,
                        tools: {
                            download:true
                        }
                    }
                },
                colors: ['#546E7A'],
                stroke: {
                    width: 3
                },
                dataLabels: {
                    enabled: false
                },
                fill: {
                    opacity: 1,
                },
                markers: {
                    size: 0
                },
                xaxis: {
                    type: 'datetime',
                    labels:{
                        datetimeUTC:false
                    }
                },
                yaxis:{
                    labels:{
                        formatter: function(value){
                            return value.toFixed(2);
                        }
                    }
                },
                annotations: {
                    yaxis: [
                        {
                            y: reference.get("management"),
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
                            y: reference.get("company"),
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
                            y: reference.get("legal"),
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
                        }
                    ]
                }
            };

            chart = new ApexCharts(document.querySelector("#chart-line2"), options);
            chart.render();

            // 여기 문제
            optionsLine = {
                series: [{
                    data : data
                }],
                chart: {
                    id: 'chart1',
                    height: 150,
                    type: 'area',
                    brush:{
                        target: 'chart2',
                        enabled: true
                    },
                    selection: {
                        enabled: true
                    },
                },
                colors: ['#008FFB'],
                fill: {
                    type: 'gradient',
                    gradient: {
                        opacityFrom: 0.91,
                        opacityTo: 0.1,
                    }
                },
                xaxis: {
                    type: 'datetime',
                    labels:{
                        datetimeUTC:false
                    },
                    tooltip: {
                        enabled: false
                    }
                },
                yaxis: {
                    tickAmount: 2,
                    labels:{
                        formatter: function(value){
                            return value.toFixed(2);
                        }
                    }
                }
            };
            chartLine = new ApexCharts(document.querySelector("#chart-line"), optionsLine);
            chartLine.render();
        }else{
            chart.updateSeries([{
                data : data
            }])
            chartLine.updateSeries([{
                data : data
            }])
            // brush 영역 초기화 해주기 위함
            chartLine.updateOptions({
               chart : {
                   brush:{
                       target: 'chart2',
                       enabled: true
                   }
               }
            })
        }
    }

    function getDays(dayType){
        if(dayType == 'week'){
            return moment(new Date()).subtract(7, 'd').format('YYYY-MM-DD');
        }
        return moment(new Date).format('YYYY-MM-DD');
    }

</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />