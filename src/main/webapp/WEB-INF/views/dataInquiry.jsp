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
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="stylesheet" href="static/css/page/dataInquiry.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/datepicker.min.js"></script>
<script src="static/js/datepicker.ko.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>
<script src="static/js/moment.min.js"></script>
<script src="static/js/common/common.js"></script>
<script src="static/js/sweetalert2.min.js"></script>
<%-- export excel --%>
<script src="static/js/jszip.min.js"></script>
<script src="static/js/dataTables.buttons.min.js"></script>
<script src="static/js/buttons.html5.min.js"></script>


<div class="container" id="container">
    <div class="ms-3 mt-3 add-bg row" id="searchDiv">
        <div class="col-3 picker">
            <span class="fs-5 fw-bold add-margin f-sizing">측정소</span>
            <div class="btn-group w-50 ms-3">
                <select name="place" id="place" class="btn btn-light" onchange="placeChange()" style="width: 150px;">
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

            <input type="text" id="date_start" class="text-center p-1" disabled  autocomplete="off">
            <label class="ms-3 me-3">-</label>
            <input type="text" id="date_end" class="text-center p-1" disabled  autocomplete="off">

            <button type="button" class="btn btn-primary ms-3" onClick="search(1)">검색</button>
        </div>
        <div class="row m-2 p-2">
            <div class="col text-end">
                <span class="text-primary" style="font-size: 0.8rem; margin-right: 20px;">* 검색기간이 7일 미만일 경우 5분 평균데이터, 7일 이상인 경우 30분 평균데이터로 표시됩니다.</span>
            </div>
        </div>
    </div>

    <hr class="mt-2 mb-2">

    <div class="row" style="margin-left: 1px; width: 720px;">
        <div class="col">
            <div class="row bg-white sizing">
                <div class="row add-margin-top">
                    <div class="col add-margin">
                        <div class="float-start">
                            <div class="fs-5 fw-bold mb-2" id="title" style="display: inline-block;"> </div> <span style="margin-left: 10px;">단위 : 111</span>
                        </div>
                    </div>

                    <div class="col">
                        <div class="float-end">
                            <div class="form-check pt-2">
                                <input class="form-check-input" type="checkbox" value="" id="off" checked>
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

    <div class="row" >
        <div class="col">
            <div class="row bg-white m-top" style="margin-left: 1px;">
                <div class="row ms-2">
                    <div class="col">
                        <table id="information" class="table table-striped table-bordered table-hover text-center" >
                            <thead class="add-bg-color">
                            <tr>
                                <th width="10%" style="padding:10px 2px 10px 2px;">순번</th>
                                <th width="20%" style="padding:10px 2px 10px 2px;">측정 값</th>
                                <th width="20%" style="padding:10px 2px 10px 2px;">상태</th>
                                <th width="20%" style="padding:10px 2px 10px 2px;">모니터링 여부</th>
                                <th width="30%" style="padding:10px 2px 10px 2px;">업데이트 시간</th>
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
            <div class="p-2 bg-white text-center">측정 항목 선택</div>

            <div class="p-2 bg-white h-fix" id="items">
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

    $("input:radio[name=day]").on('click',function() {
        const $dates = $('#date_start, #date_end').datepicker();

        const id = $(this).attr('id');

        if(id == 'custom'){
            $("#date_start").attr('disabled',false);
            $("#date_end").attr('disabled',false);
            $dates.datepicker('setDate',null);

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

    function getDays(dayType){
        if(dayType == 'week'){
            return moment(new Date()).subtract(7, 'd').format('YYYY-MM-DD');
        }
        return moment(new Date).format('YYYY-MM-DD');
    }

    function placeChange(){
        const place = $("#place").val();

        $("#items").empty();

        $.ajax({
            url: '<%=cp%>/findSensorListAll',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place":place},
            success : function(data) {
                for(let i=0;i<data.length;i++){

                    const innerHtml = "<div class='form-check mb-2'>" +
                        "<input class='form-check-input' type='radio' name='item' id='"+data[i].tableName+"' value='"+data[i].tableName+"' onclick='changeItem()'>" +
                        "<label class='form-check-label' for='"+data[i].tableName+"'>"+data[i].naming+"</label>" +
                        "</div>"

                    const elem = document.createElement('div');
                    elem.innerHTML = innerHtml
                    document.getElementById('items').append(elem);
                }
                const item = $("input[name='item']").eq(0).val();
                $("#"+item).prop("checked",true);
            },
            error : function(request, status, error) {
                console.log(' get place sensor error');
                console.log(error);
            }
        })
    }

    function search(flag){
        const date_start =  $('#date_start').val();
        const date_end = $('#date_end').val();
        let item = $('input[name="item"]:checked').val();
        const off = $('#off').is(":checked"); // false : 선택안됨(표시X) , true : 선택(표시)

        if(item==undefined){
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '해당 측정소에 등록된 센서가 없습니다.'
            })
            reset();
            return false;
        }

        if(date_start==""||date_end==""){
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '검색 날짜를 입력해주세요.'
            })
            return false;
        }

        const place = $("#place").val();
        const category = findSensorCategory(item);
        $('#title').text(place + " - " + category);

        const reference = getReferenceValue(item);

        $.ajax({
            url: '<%=cp%>/searchChart',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"date_start":date_start,
                "date_end":date_end,
                "item":item,
                "off":off
            },
            success : function(data) {
                if(data.length==0){
                    //addChart([], [], reference, 0);
                    if(chart!=null){
                        reset();
                    }
                    Swal.fire({
                        icon: 'warning',
                        title: '경고',
                        text: '해당 기간 내의 검색 결과가 없습니다.'
                    })
                    return false;
                }else{
                    addChart(data, category, reference, flag);
                }
                if(flag==0){
                    inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', place + '-'+ category + ' 측정자료 조회','조회');
                } else{
                    inputLog('${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.username}', place + '-'+ category + ' 측정자료 조회('+date_start+' ~ '+date_end+')','조회');
                }
            },
            error : function(request, status, error) {
                console.log('search off error');
                console.log(error)
            }
        })
        addTable(reference);
    }

    function getReferenceValue(tableName){
        let reference = new Map();
        $.ajax({
            url:'<%=cp%>/getSensorInfo',
            dataType: 'json',
            data:  {"sensor": tableName},
            async: false,
            success: function (data) {
                reference.set("management",data.managementStandard);
                reference.set("company",data.companyStandard);
                reference.set("legal",data.legalStandard);
            },
            error: function(request, status, error) {
                console.log('get reference value error');
                console.log(error)
            }
        });
        return reference;
    }

    function addTable(reference){
        $("#informationBody").empty();
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
                console.log('add table error');
                console.log(error)
            }
        })

        $('#information').dataTable({
            dom: '<"toolbar">Bfrtip',
            buttons: [{
                extend: 'excelHtml5',
                autoFilter: true,
                sheetName: 'Exported data',
                text:'엑셀 다운로드',
                filename: function(){
                    const d = moment(new Date()).format('YYYYMMDDHHmmss');
                    return d + '_' + $("#place").val() + '_' + $("label[for='"+$('input[name="item"]:checked').val()+"']").text();
                },
            }],
            lengthChange : false,
            pageLength: 7,
            order :[4, 'desc'],
            info: false,
            language: {
                emptyTable: "데이터가 없어요.",
                lengthMenu: "페이지당 _MENU_ 개씩 보기",
                info: "현재 _START_ - _END_ / _TOTAL_건",
                infoEmpty: "데이터 없음",
                infoFiltered: "( _MAX_건의 데이터에서 필터링됨 )",
                search: "전체검색 : ",
                zeroRecords: "일치하는 데이터가 없어요.",
                loadingRecords: "로딩중...",
                processing: "잠시만 기다려 주세요...",
                paginate: {
                    next: "다음",
                    previous: "이전"
                },
            },
        });

        $("div.toolbar").html('<b>상세보기</b>');
    }


    $('#off').click(function(){
        search(1);
    });


    function changeItem(){
        search(1);
    }

    function reset(){
        addChart([], [], [], 1);
        $('#information').DataTable().clear();
        $('#information').DataTable().destroy();
        const innerHtml = "<tr><td colspan='5'> 저장된 센서 데이터가 없습니다. </td></tr>";
        $('#information > tbody').append(innerHtml);
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
                    id: 'chart',
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
                                position: 'left',
                                offsetX: 0
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
                                position: 'left',
                                offsetX: 0
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
                                position: 'left',
                                offsetX: 0
                            }
                        }
                    ]
                },
                tooltip: {
                    enabled : true,
                    x: {
                        format : 'yyyy-MM-dd HH:mm'
                    }
                },
                xaxis: {
                    type: 'datetime',
                    labels: {
                        show: true,
                        datetimeUTC: false,
                        datetimeFormatter: {
                            year: 'yyyy년',
                            month: 'MM월',
                            day: 'dd일',
                            hour: 'HH:mm:ss',
                        },
                    },
                },
            };

            chart = new ApexCharts(document.querySelector("#chart-line2"), options);
            chart.render();

            optionsLine = {
                series: [{
                    data : data
                }],
                chart: {
                    id: 'chart2',
                    height: 150,
                    type: 'area',
                    brush:{
                        target: 'chart',
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
                },
                xaxis: {
                    type: 'datetime',
                    labels: {
                        show: true,
                        datetimeUTC: false,
                        datetimeFormatter: {
                            year: 'yyyy년',
                            month: 'MM월',
                            day: 'dd일',
                            hour: 'HH:mm:ss',
                        },
                    },
                },
            };
            chartLine = new ApexCharts(document.querySelector("#chart-line"), optionsLine);
            chartLine.render();
        }else{
            if(chart==null&&data.length!=0){
                search(0);
            }
            chart.updateSeries([{
                data : data
            }])

            chart.clearAnnotations();

            if(reference.length!=0){
                chart.updateOptions({
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
                                    position: 'left',
                                    offsetX: 0
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
                                    position: 'left',
                                    offsetX: 0
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
                                    position: 'left',
                                    offsetX: 0
                                }
                            }
                        ]
                    }
                })
            }

            chartLine.updateSeries([{
                data : data
            }])

            // brush 영역 초기화 해주기 위함
            chartLine.updateOptions({
               chart : {
                   brush:{
                       target: 'chart',
                       enabled: true
                   }
               }
            })
        }
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />