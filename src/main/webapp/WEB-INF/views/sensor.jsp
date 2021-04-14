<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 3:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<script src="static/js/vue.min.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/vue-apexcharts.js"></script>


<style>
    #chart {
        max-width: 650px;
        margin: 35px auto;
    }
</style>

<div class="container">
    Hello
    <div id="app">
        <div id="chart">
            <apexchart type="bar" height="350" :options="chartOptions" :series="series"></apexchart>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    new Vue({
        el: '#app',
        components: {
            apexchart: VueApexCharts,
        },
        data: {
            series: [{
                name: 'Yearly Profit',
                data: [{
                    x: '2021-02-26 17:50',
                    y: 9
                }, {
                    x: '2021-02-26 17:55',
                    y: 10
                }, {
                    x: '2021-02-26 18:00',
                    y: 13
                }, {
                    x: '2021-02-26 18:05',
                    y: 13
                }, {
                    x: '2021-02-26 18:10',
                    y: 13
                }, {
                    x: '2021-02-26 18:15',
                    y: 18,
                }, {
                    x: '2021-02-26 18:20',
                    y: 16,
                }, {
                    x: '2021-02-26 18:25',
                    y: 15,
                }, {
                    x: '2021-02-26 18:30',
                    y: 14
                }, {
                    x: '2021-02-26 18:35',
                    y: 14
                }]
            }],
            chartOptions: {
                chart: {
                    height: 350,
                    type: 'bar',
                },
                plotOptions: {
                    bar: {
                        colors: {
                            ranges: [{
                                from: 15,
                                to: 30,
                                color: '#EB8C87'
                            }, {
                                from: 12,
                                to: 14,
                                color: '#f5c932'
                            }, {
                                to: 12,
                                color: '#245ac4'
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
                yaxis: {
                    tickAmount: 2,
                    min: 0,
                    max: 30,
                },
                fill: {
                    opacity: 1,
                },
                xaxis: {

                    type: 'time'
                }
            },
        },
    })
</script>