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
        width: 1300px;
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

    #information {
        margin-top: 35px;
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
                <tbody id="informationBody">
                    <tr>
                        <td>2020</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                    </tr>
                    <tr>
                        <td>2020</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td>11</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>
                <tfoot>
                <tr>
                    <td>증감률</td>
                    <td>11</td>
                    <td>11</td>
                    <td>11</td>
                    <td>11</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
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
        const place = $("#place").val();
        const item = $("#items").val();

        $(".placeAndItem").text("["+place + " - " + findSensorCategory(item) +"] ");
        //쿼리문 결과 넣어주기
        $.ajax({
            url: '<%=cp%>/addStatisticsData',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place":place,
            "item":item},
            success : function(data) {
                console.log(data);
            },
            error : function(request, status, error) {
                console.log(error)
            }
        })
    }

    const options = {
        series: [{
            name: '2020',
            data: [44, 55, 57, 56, 61, 58, 63, 60, 66, 63, 60, 66]
        }, {
            name: '2021',
            data: [76, 85, 101, 98, null, null, null, null, null, null, null, null]
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

</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



