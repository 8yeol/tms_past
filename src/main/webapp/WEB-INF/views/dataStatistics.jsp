<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-20
  Time: 오후 5:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/sweetalert2.min.css">

<script src="static/js/common/common.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/moment.min.js"></script>
<script src="static/js/sweetalert2.min.js"></script>

<style>
    .add-bg {
        background-color: #fff;
        width: 102%;
        position: relative;
        left: -20px;
        top: -3px;
    }

    .add-bg-color {
        background-color: #97bef8;
        color: #fff;
    }

    .add-margin-right {
        margin-right: 15px;
    }

    .title-span {
        margin-left: 28px;
        position: relative;
        top: 30px;
    }

    .table-height {
        height: 290px;
    }
</style>

<div class="container"  id="container">
    <div class="row  ms-3 mt-4">
        <div class="col text-end">
            <p class="small m-0"> 업데이트 : <span class="small fw-bold" id="update"></span></p>
            <span class="text-primary" style="font-size: 0.8rem;"> * 매일 자정 전일 기준으로 통계값이 업데이트 됩니다.</span>
        </div>
    </div>
    <div class="row mt-2 p-3 add-bg" style="margin-left: 5px;">
        <div class="col text-center">
            <span class="fs-5 fw-bold">측정소</span>
            <div class="btn-group w-50 ms-3">
                <select name="place" id="place" class="btn btn-light" onchange="placeChange()">
                    <c:forEach var="place" items="${place}" varStatus="status">
                        <option value="${place}">${place}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="col text-center add-margin-right">
            <span class="fs-5 fw-bold">측정 항목</span>
            <div class="btn-group w-50 ms-3">
                <select name="items" id="items" class="btn btn-light" onchange="itemChange()">
                    <%--script--%>
                </select>
            </div>
            <p style="margin: 5px 95px 0px 0px; font-size: 0.8rem; text-align: right; color: red">* 배출량 추이는 질소산화물 센서에 한하여 조회 가능합니다.</p>
        </div>
    </div>

    <hr>

    <div class="row">
        <div class="col bg-white">
            <span class="fs-5 fw-bold add-margin title-span"><span class="placeAndItem"></span>월별 배출량 추이 </span>
            <div id="chart" class="p-3 mt-5 mb-5 text-center" style="height: 500px"></div>
        </div>
    </div>

    <hr class="mt-4 mb-4">

    <div class="row bg-white table-height">
        <span class="fs-5 fw-bold add-margin title-span"><span class="placeAndItem"></span>월별 배출량 통계 </span>
        <span class="small fw-bold text-end mt-4"> * 소수점은 반올림되어 계산됩니다. <br>[단위 : kg]</span>
        <div class="col p-3">
            <table id="information" class="table table-bordered table-hover text-center" >
                <thead class="add-bg-color">
                <tr>
                    <th>연도</th>
                    <th>1월</th>
                    <th>2월</th>
                    <th>3월</th>
                    <th>4월</th>
                    <th>5월</th>
                    <th>6월</th>
                    <th>7월</th>
                    <th>8월</th>
                    <th>9월</th>
                    <th>10월</th>
                    <th>11월</th>
                    <th>12월</th>
                    <th>합계</th>
                </tr>
                </thead>
                <tbody>
                    <%--script--%>
                </tbody>
                <tfoot>
                    <%--script--%>
                </tfoot>
            </table>
        </div>
    </div>

</div>

<script>
    $( document ).ready(function() {
        placeChange();
    });

    function placeChange(){
        const place = $("#place").val();

        $("#items").empty();

        $.ajax({
            url: '<%=cp%>/findSensorList',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place":place},
            success : function(data) {
                for(let i=0;i<data.length;i++){
                    const html = "<option value='"+data[i].tableName+"'>"+data[i].naming+"</option>"
                    $("#items").append(html);
                }
            },
            error : function(request, status, error) {
                console.log(error)
            }
        })
        itemChange();
    }

    function itemChange(){
        const item = $("#items").val();
        const itemName = $("#items option:checked").text();
        const thisYear = new Date().getFullYear();
        const previousYear = thisYear-1;

        if(item==null){
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '측정소에 등록된 \'질소산화물\' 센서가 없습니다.'
            })
        }

        let thisYearData = [],previousYearData = [];

            $.ajax({
                url: '<%=cp%>/getStatisticsData',
                type: 'POST',
                dataType: 'json',
                async: false,
                cache: false,
                data: {"sensor":item,
                    "thisYear":thisYear},
                success : function(data) {
                        if(data[0] != null) {
                            thisYearData.push(data[0].jan);
                            thisYearData.push(data[0].feb);
                            thisYearData.push(data[0].mar);
                            thisYearData.push(data[0].apr);
                            thisYearData.push(data[0].may);
                            thisYearData.push(data[0].jun);
                            thisYearData.push(data[0].jul);
                            thisYearData.push(data[0].aug);
                            thisYearData.push(data[0].sep);
                            thisYearData.push(data[0].oct);
                            thisYearData.push(data[0].nov);
                            thisYearData.push(data[0].dec);
                            $("#update").text(moment(data[0].updateTime).format('YYYY-MM-DD'));
                        }
                        if(data[1] != null) {
                            previousYearData.push(data[1].jan);
                            previousYearData.push(data[1].feb);
                            previousYearData.push(data[1].mar);
                            previousYearData.push(data[1].apr);
                            previousYearData.push(data[1].may);
                            previousYearData.push(data[1].jun);
                            previousYearData.push(data[1].jul);
                            previousYearData.push(data[1].aug);
                            previousYearData.push(data[1].sep);
                            previousYearData.push(data[1].oct);
                            previousYearData.push(data[1].nov);
                            previousYearData.push(data[1].dec);
                        }

                    inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', $("#place").val() + '-'+ itemName + ' 통계자료 조회','조회');
                },
                error : function(request, status, error) {
                    console.log(error);
                }
            });

        addChart(previousYear, thisYear, previousYearData, thisYearData);
        addTable(previousYear, thisYear, previousYearData, thisYearData);
    }

    function addChart(previousYear, thisYear, previousYearData, thisYearData){

        $('#chart').empty();

        if(thisYearData.length == 0){
            $('#chart').append("모니터링 가능한 월별 배출량 추이 데이터가 없습니다. <br> 월별 배출량 추이 데이터는 매일 자정 전일 기준으로 업데이트 되며, 해당 측정소에 유량 및 질소산화물 센서가 정상적으로 등록되어 있어야 이용 가능합니다.");
        } else{
            const options = {
                series: [{
                    name: previousYear,
                    data: previousYearData
                }, {
                    name: thisYear,
                    data: thisYearData
                }],
                chart: {
                    type: 'bar',
                    height: 500
                },
                legend:{
                    position : 'top'
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
                    categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                },
                yaxis: {
                    title: {
                        text: '(kg/월)'
                    },
                    labels:{
                        formatter: function(value){
                            return numberWithCommas(Math.round(value));
                        }
                    }
                },
                fill: {
                    opacity: 1
                },
                tooltip: {
                    y: {
                        formatter: function (value) {
                            return numberWithCommas(Math.round(value)) + " kg"
                        }
                    }
                }
            };

            const chart = new ApexCharts(document.querySelector("#chart"), options);
            chart.render();
        }
    }

    function addTable(previousYear, thisYear, previousYearData, thisYearData){
        $('#information > tbody').empty();

        if(previousYearData.length==0) {
            if(thisYearData.length==0){
                $('#information > tfoot').empty();
                $('#information > tbody').empty();

                const innerHtml = "<tr><td colspan='14'> 통계 데이터가 없습니다. <br> 통계 데이터는 매일 자정 전일 기준으로 업데이트 됩니다. </td></tr>";
                $('#information > tbody').append(innerHtml);
                return false
            }
            for(let i=0; i<12; i++){
                previousYearData.push(null);
            }
        }

        if(previousYearData.length != 0 && thisYearData.length == 0){
            for(let i=0; i<12; i++){
                thisYearData.push(null);
            }
        }

        const previousYearSum = addMonthlyData(previousYear, previousYearData);
        const thisYearSum = addMonthlyData(thisYear, thisYearData);

        let innerHtml;
        let increase;
        // 증감률
        $('#information > tfoot').empty();
        innerHtml = "";
        innerHtml += '<tr>'
        innerHtml += '<td>증감률</td>';
        for(let i = 0 ;i <thisYearData.length;i++){
            increase = addIncrease(previousYearData[i], thisYearData[i]);
            if(increase>0){
                innerHtml += '<td style="color:red" class="fw-bold">' + '+ ' + numberWithCommas(increase) + ' %</td>'
            }else if(increase<0){
                innerHtml += '<td style="color:blue" class="fw-bold">' + '- ' + Math.abs(numberWithCommas(increase)) + ' %</td>'
            }else{
                innerHtml += '<td>' + increase + '</td>'
            }
        }

        increase = addIncrease(previousYearSum, thisYearSum);
        if(increase>0){
            innerHtml += '<td style="color:red" class="fw-bold">' + '+ ' + numberWithCommas(increase) + ' %</td>'
        }else if(increase<0){
            innerHtml += '<td style="color:blue" class="fw-bold">' + '- ' +Math.abs(numberWithCommas(increase)) + ' %</td>'
        }else{
            innerHtml += '<td>' + increase + '</td>'
        }

        innerHtml += '</tr>';
        $('#information > tfoot:last').append(innerHtml);
    }

    // 월별 데이터 add
    function addMonthlyData(year, yearData){
        let sum = 0;
        let innerHtml = "";
        innerHtml += '<tr>'
        innerHtml += '<td>' + year+ '</td>';
        for(let i = 0 ;i <yearData.length;i++){
            let data = yearData[i]!=null?Math.round(yearData[i]):0;
            innerHtml += '<td>' + numberWithCommas(data) + '</td>';
            sum = sum + data;
        }
        innerHtml += '<td>' + numberWithCommas(sum) + '</td>';
        innerHtml += '</tr>';
        $('#information > tbody:last').append(innerHtml);
        return sum;
    }

    //증감률 계산
    function addIncrease(previousYear, thisYear){
        let increase = ((thisYear - previousYear)/previousYear)*100;
        if(isNaN(increase)){
            return '-';
        }
        if(increase==Infinity){
            return thisYear.toFixed();
        }
        return increase.toFixed(2);
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



