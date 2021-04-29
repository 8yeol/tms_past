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

<script src="static/js/common/common.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/moment.min.js"></script>

<style>
    .add-bg {
        background-color: #fff;
        width: 100%;
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

<div class="container">
    <div class="row  ms-3 mt-4">
        <div class="col text-end">
            <p class="small m-0"> 마지막 업데이트 : <span class="small fw-bold" id="update"> </span></p>
        </div>
    </div>
    <div class="row ms-3 mt-2 p-3 add-bg">
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
        </div>
    </div>

    <hr>

    <div class="row">
        <div class="col bg-white">
            <span class="fs-5 fw-bold add-margin title-span"><span class="placeAndItem"></span>월별 배출량 추이 </span>
            <div id="chart" class="p-3 mt-5 mb-5"></div>
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
        $("#update").text(moment(new Date()).format('YYYY-MM-DD HH:mm:ss'));
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
                    const html = "<option value='"+tableName+"'>"+category+"</option>"
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
        //const place = $("#place").val();
        const item = $("#items").val();
        //$(".placeAndItem").text("["+place + " - " + findSensorCategory(item) +"] ");
        const thisYear = new Date().getFullYear();
        const previousYear = thisYear-1;

        let thisYearData = [],previousYearData = [];

        for(let i=1; i>=0; i--){
            let year = thisYear;
            year = year-i;

            $.ajax({
                url: '<%=cp%>/addStatisticsData',
                type: 'POST',
                dataType: 'json',
                async: false,
                cache: false,
                data: {"item":item,
                    "year":year},
                success : function(data) {
                    if(i==0){
                        thisYearData.push(data);
                    } else {
                        previousYearData.push(data);
                    }
                },
                error : function(request, status, error) {
                    console.log(error)
                }
            })
        }
        addChart(previousYear, thisYear, previousYearData[0], thisYearData[0]);
        addTable(previousYear, thisYear, previousYearData[0], thisYearData[0]);
    }

    function addChart(previousYear, thisYear, previousYearData, thisYearData){
        $('#chart').empty();

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
                        return Math.round(value);
                    }
                }
            },
            fill: {
                opacity: 1
            },
            tooltip: {
                y: {
                    formatter: function (value) {
                        return Math.round(value) + " kg"
                    }
                }
            }
        };

        const chart = new ApexCharts(document.querySelector("#chart"), options);
        chart.render();
    }

    function addTable(previousYear, thisYear, previousYearData, thisYearData){
        $('#information > tbody').empty();

        const previousYearSum = addMonthlyData(previousYear, previousYearData);
        const thisYearSum = addMonthlyData(thisYear, thisYearData);

        let innerHtml;
        // 증감률
        $('#information > tfoot').empty();
        innerHtml = "";
        innerHtml += '<tr>'
        innerHtml += '<td>증감률</td>';
        for(let i = 0 ;i <thisYearData.length;i++){
            if(previousYearData[i] != null || thisYearData[i] == null){
                let increase = addIncrease(previousYearData[i], thisYearData[i]);
                innerHtml += '<td>' + increase + '</td>'
            } else{
                innerHtml += '<td> 100 % </td>';
            }
        }
        if( previousYearSum != 0 || thisYearSum == 0){
            let increase = addIncrease(previousYearSum, thisYearSum);
            innerHtml += '<td>' + increase + '</td>';
        }else{
            innerHtml += '<td> 100 % </td>';
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
        let increase = Math.ceil(((thisYear - previousYear)/previousYear))*100;
        if(isNaN(increase)){
            return '-';
        }
        return increase.toFixed(2) + ' %';
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



