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
<script src="static/js/datepicker.min.js"></script>
<script src="static/js/datepicker.ko.js"></script>

<script src="static/js/vue.min.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/vue-apexcharts.js"></script>

<style>
    div.search {
        position: relative;
        left: 250px;
        top: -38px;
    }
</style>

<div class="container">
    <div class="row m-3 mt-4">
        <div class="col-3">
            <span class="fs-5 fw-bold">측정소</span>
            <div class="btn-group w-50 ms-3">
                <select name="place" id="place" class="btn btn-light" onchange="placeChange()">
                    <c:forEach var="place" items="${place}" varStatus="status">
                        <option value="${place}">${place}</option>
                    </c:forEach>
                </select>
            </div>

        </div>
        <div class="search">
            <span class="fs-5 fw-bold p-3">측정기간</span>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="day" id="week" checked>
                <label class="form-check-label" for="week">
                    일주일
                </label>
            </div>

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="day" id="month">
                <label class="form-check-label" for="month">
                    한 달
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

            <button type="button" class="btn btn-primary ms-3" onClick="search()">검색</button>
        </div>
    </div>

    <div class="row">
        <div class="col">

            <div class="row">
                <div class="col">
                    <div class="float-end">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" value="" id="off">
                            <label class="form-check-label fw-bold small" for="off">
                                Off 데이터 표시
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row bg-white">
                <div class="fs-6 fw-bold pt-3"> 측정소 1 - 먼지 </div>
                <div id="chart-line2"></div>
                <div id="chart-line"></div>

                <div class="row">
                    <div class="col">
                        <div class="float-end">
                            <button class="btn btn-outline-secondary">Download Excel</button>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col text-center">
                        table 영역
                    </div>
                </div>
            </div>

        </div>
        <div class="col-lg-2">
            <div class="mt-4 p-2 bg-white text-center">차트 항목 선택</div>

            <div class="border p-2 bg-white" id="items">


            </div>

        </div>
    </div>
</div>

<script charset="UTF-8">

    $( document ).ready(function() {
        //$("#date_start").val(getDays('week'));
        $("#date_start").val(getDays());
        $("#date_end").val(getDays());
        placeChange();
        search();
    });

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
            var sDay = sDate.val();
            if (flag && !isValidStr(sDay)) { //처음 입력 날짜 설정, update...
                var sdp = sDate.datepicker().data("datepicker");
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
            } else if(id == 'month'){
                $("#date_start").val(getDays('month'));
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
            data: {"name":place},
            success : function(data) { // 결과 성공 콜백함수
                for(let i=0;i<data.length;i++){
                    const tableName = data[i];
                    const category = findSensorCategory(tableName);

                    const innerHtml = "<div class='form-check mb-2'>" +
                        "<input class='form-check-input' type='radio' name='item' id='"+tableName+"' value='"+tableName+"'>" +
                        "<label class='form-check-label' for='"+tableName+"'>"+category+"</label>" +
                        "</div>"

                    const elem = document.createElement('div');
                    elem.innerHTML = innerHtml
                    document.getElementById('items').append(elem);
                }
                const item = $("input[name='item']").eq(0).val();
                $("#"+item).prop("checked",true);
            },
            error : function(request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
    }

    function findSensorCategory(tableName){
        if(tableName.includes('dust')==true){
            return "먼지";
        } else if(tableName.includes('NOx')==true){
            return "질소산화물";
        } else if(tableName.includes('CO')==true){
            return "일산화탄소";
        } else if(tableName.includes('HCL')==true){
            return "염산";
        } else if(tableName.includes('SOx')==true){
            return "황산화물";
        }
    }

    function search(){
        const date_start =  $('#date_start').val();
        const date_end = $('#date_end').val();
        const item = $('input[name="item"]:checked').val();
        const off = $('#off').is(":checked"); // false : 선택안됨(표시X) , true : 선택(표시)

        $('#chart-line2').empty();
        $('#chart-line').empty();

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
            success : function(data) { // 결과 성공 콜백함수
                //console.log(data);
                /*
                const times = [],values = [];
                for(let i=0; i<data.length; i++){
                    times.push(data[i].time);
                    values.push(data[i].value.toFixed(2));
                }
                */
                const options = {
                    series: [{
                        name:"먼지",
                        data: data
                    }],
                    chart: {
                        id: 'chart2',
                        type: 'line',
                        height: 350,
                        toolbar: {
                            autoSelected: 'pan',
                            show: false
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
                        type: 'datetime'
                    }
                };

                const chart = new ApexCharts(document.querySelector("#chart-line2"), options);
                chart.render();

                const optionsLine = {
                    series: [{
                        data: data
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
                            enabled: true,
                            xaxis: {
                                type: 'datetime'
                            }
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
                        tooltip: {
                            enabled: false
                        }
                    },
                    yaxis: {
                        tickAmount: 2
                    }
                };
                const chartLine = new ApexCharts(document.querySelector("#chart-line"), optionsLine);
                chartLine.render();

            },
            error : function(request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })

    }

    function getDays(dayType){
        let date = new Date();

        if(dayType == 'week'){
            date = new Date(date.setDate(date.getDate()-7));
        } else if(dayType == 'month'){
            date = new Date(date.setMonth(date.getMonth()-1));
        }

        const year = date.getFullYear();
        const month = ("0" + (1 + date.getMonth())).slice(-2);
        const day = ("0" + date.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }

</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />