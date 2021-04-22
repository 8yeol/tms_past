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
<script src="static/js/vue.min.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/vue-apexcharts.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>

<style>
    div.search {
        position: relative;
        left: 250px;
        top: -38px;
    }
    .toolbar {
        float: left;
    }
</style>


<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<script src="static/js/sweetalert2.min.js"></script>

<div class="container">
    <div class="row ms-3 mx-3 mt-4">
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

            <div class="row bg-white">

                <div id="chart-line2" class="mt-3"></div>
                <div id="chart-line"></div>

                <div class="row mt-3 border-top">
                    <div class="col mt-3">
                        <table id="information" class="table table-striped table-bordered table-hover text-center" >
                            <thead>
                            <tr>
                                <th>순번</th>
                                <th>값</th>
                                <th>상태</th>
                                <th>시간</th>
                            </tr>
                            </thead>
                            <!-- tbody 태그 필요 없다. -->
                        </table>
                    </div>
                </div>
            </div>

        </div>
        <div class="col-lg-2">
            <div class="mt-4 p-2 bg-white text-center">차트 항목 선택</div>

            <div class="border p-2 bg-white h-100" id="items">
                <%-- script --%>
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
        $("#information").DataTable();
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

    const table = $('#information').dataTable({
        dom: '<"toolbar">Bfrtip',
        buttons: [
            'copy', 'csv', 'excel', 'pdf', 'print'
        ]
    });

    $("div.toolbar").html('<b>상세보기</b>');

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

    $('#off').click(function(){
        search();
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

        search();
    }

    function changeItem(){
        search();
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

        const place = $("#place").val();
        const category = findSensorCategory(item);
        $('#title').text(place + " - " + category);

        if(date_start==""||date_end==""){
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '검색 날짜를 입력해주세요.'
            })
            return false;
        }

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
            success : function(data) {
                const options = {
                    series: [{
                        name:category,
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
                    }
                };

                const chart = new ApexCharts(document.querySelector("#chart-line2"), options);
                chart.render();

                // 여기 문제
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
                                type: 'datetime',
                                labels:{
                                    datetimeUTC:false
                                }
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
                const chartLine = new ApexCharts(document.querySelector("#chart-line"), optionsLine);
                chartLine.render();

            },
            error : function(request, status, error) {
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