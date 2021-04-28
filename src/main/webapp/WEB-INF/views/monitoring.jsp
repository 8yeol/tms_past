<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String Date = new java.text.SimpleDateFormat("yyyy년 MM월 dd일 hh:mm:ss").format(new java.util.Date());
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>

<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<script src="static/js/vue.min.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/vue-apexcharts.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>
<script src="static/js/moment.min.js"></script>


<style>
    div{
        padding: 1px;
    }
    h1{
        text-align: center;
    }
</style>

<style>
    table#sensor-table thead, table#sensor-table-time thead { /* 테이블 제목 셀 배경, 글자색 설정 */
        background-color: #97bef8;
        color: #fff;
    }

    div.bg-skyblue { /* param.place 배경, 글자색 설정 */
        background-color: #094EB5;
        color: #fff;
    }
</style>


<div class="container">
    <div class="row">
        <div class="col-12 bg-gradient mt-4 p-4 bg-skyblue rounded">
            <div class="col-6 ms-3 add-bg">
                <div class="col-md-12">
                    <span class="fs-5 fw-bold">측정소</span>
                    <div class="btn-group w-50 ms-3">
                        <select id="place" class="btn btn-light" onchange="changePlace()">
                            <c:forEach var="place" items="${place}">
                                <option value="${place.name}">${place.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        현재시간 : <span id="time"></span>
                        업데이트시간 : <span id="update"></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row mt-4">
        <div class="col-md-12 h-75">
            <table id="sensor-table" class="w-100">
                <thead>
                <tr>
                    <th width="12%">항목</th>
                    <th width="8%">실시간</th>
                    <th width="8%">5분전</th>
                    <th width="5%">증감</th>
                    <th width="5%">법적기준</th>
                    <th width="5%">사내기준</th>
                    <th width="5%">관리기준</th>
<%--                    <th width="5%">상태</th>--%>
                    <th width="12%">업데이트</th>
                </tr>
                <thead>
            </table>
        </div>
</div>
<%-- <c:forEach var="place" items="${place}">
<div class="col-md-6 p-3"> &lt;%&ndash; place col-md-12 / col-md-6 / col-md-4 &ndash;%&gt;
    <div class="row bg-light rounded">
        <div class="col-xs-12">
            <h1 class="bg-secondary rounded mt-1">${place.name}</h1>
        </div>
        <table id="sensor-table">
            <thead>
            <tr>
                <th>구분</th>
                <th>항목</th>
                <th>실시간</th>
                <th>5분전</th>
                <th>증감</th>
            </tr>
            <thead>
        </table>
    </div>
</div>
</c:forEach>--%>
</div>
<%--<div class="row">
<div class="col-xs-12 d-flex justify-content-between bg-light rounded mt-3">
    <div class="flex-fill d-flex justify-content-around">
        <h3> <i class="fas fa-square text-dark"></i> 장비정상</h3>
        <h3> <i class="fas fa-square text-secondary"></i> 교정중</h3>
        <h3> <i class="fas fa-square text-warning"></i> 경고</h3>
        <h3> <i class="fas fa-square text-danger"></i> 위험</h3>
        <h3> <i class="fas fa-square text-success"></i> 장비이상</h3>
    </div>

</div>
</div>--%>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



<script>
    var interval;
    var element, shown;
    $(document).ready(function () {
            getData();
            // flashing();
    }); //ready

    function changePlace() {
        getData();
        // flashing();
    }

    /* 본문 점멸 효과 */
    function flashing(){
        element = $(".row ");
        setTimeout(function flashInterval() {
            setTimeout(function () {
                element.css({"opacity": 0});
            },0);
            setTimeout(function () {
                element.css({"opacity": 1});
            },200); //0.2초 숨김
            setTimeout(flashInterval, 1000); //0.8초 보여줌
        }, 0)
    }

    function getData(){
        var place_name = $("#place").val(); // 측정소명
        var place_data = getPlaceData(place_name); // 최근데이터, 10분전데이터, 정보
        draw_place_table(place_data); // 로딩되면 테이블 생성
        setTimeout(function interval_getData() { //실시간 처리위해 setTimeout
            clearTimeout(interval); // 실행중인 interval 있다면 삭제
            console.log(interval);
            var date = new Date(); //현재시간간            $("#time").text(moment(date).format('YYYY-MM-DD HH:mm:ss'));
            var place_data_recent = getPlaceData(place_name);
            for (var i = 0; i < place_data.length; i++) {
                if (place_data[i].up_time != place_data_recent[i].up_time) {
                    place_data[i].b5_value = place_data_recent[i].b5_value;
                    place_data[i].com_value = place_data_recent[i].com_value;
                    place_data[i].value = place_data_recent[i].value;
                    place_data[i].up_time = place_data_recent[i].up_time;

                    $("#update").text(moment(place_data_recent[i].up_time).format('YYYY-MM-DD HH:mm:ss'));
                    draw_place_table(place_data);
                }
            }
            interval = setTimeout(interval_getData, 1000);
        }, 0);
    }

    /* 측정소명으로 센서명을 구하고 센서명으로 센서의 최근데이터, 10분전 데이터, 정보들을 리턴*/
    function getPlaceData(place) {
        var getData = new Array();
        $.ajax({  //측정소의 센서명을 구함
           url:'getPlaceSensor',
           dataType:'json',
           data: {"place": place},
           async: false,
           success: function (data) {
               $.each(data, function (index, item) { //item (센서명)
                   var sensor = getSensorRecent(item); // item의 최근데이터
                   if(sensor.value == 0 || sensor.value == null){
                       sensor_value = "-";
                   }else{
                       sensor_value = sensor.value;
                       up_time = moment(sensor.up_time).format('YYYY-MM-DD HH:mm:ss');
                   }

                   var b5_sensor = getSensor(item, "", "", 10); //item의 10분전 데이터
                   if(b5_sensor.length != 0){ // 최근데이터 값 - 5분전 데이터
                       b5_value = (b5_sensor[(b5_sensor.length)-1].value).toFixed(3);
                       com_value = (sensor.value - b5_value).toFixed(3);
                   }else{ // 최근데이터 존재하지 않을 경우 "-" 처리
                       b5_value = "-";
                       com_value = "-";
                   }

                   var sensorInfo = getSensorInfo(item); //item의 정보 데이터
                       naming = sensorInfo.naming;
                       legal_standard = sensorInfo.legal_standard;
                       company_standard = sensorInfo.company_standard;
                       management_standard = sensorInfo.management_standard;
                       power = sensorInfo.power;
                   /* power on 출력 */
                   if(power == "on"){
                       getData.push({
                           naming: naming, name:item,
                           value:sensor_value, up_time: up_time,
                           legal_standard: legal_standard, company_standard: company_standard, management_standard: management_standard, power: power,
                           b5_value: b5_value, com_value: com_value
                       });
                   }
                   /* power off 출력 */
                   if(power == "off"){
                       getData.push({
                           naming: naming, name:item,
                           value: sensor_value, up_time: up_time,
                           legal_standard: legal_standard, company_standard: company_standard, management_standard: management_standard, power: power,
                           b5_value: b5_value, com_value: com_value
                       });
                   }
               });
           },
            error: function () {
               console.log("getPlaceData error");
            }
        });//ajax
        return getData;
    }

    /* 센서명으로 최근 데이터 조회 */
    function getSensorRecent(sensor){
        var getData;
        $.ajax({
            url:'getSensorRecent',
            dataType: 'json',
            data:  {"sensor": sensor},
            async: false,
            success: function (data) {
                getData = data;
            },
            error: function (e) {
                // console.log("getSensorRecent Error");
                // 결과가 존재하지 않을 경우 null 처리
                getData = {value: null, status: false, up_time:null};
            }
        }); //ajax
        return getData;
    }

    /* 센서명으로 from, to, minute 의 조건에 맞는 from ~ to 센서의 데이터 조회 */
    function getSensor(sensor, from_date, to_date, minute) {
        var getData = new Array();
        $.ajax({
            url:'getSensor',
            dataType: 'json',
            data: {"sensor": sensor, "from_date": from_date, "to_date": to_date, "minute": minute},
            async: false,
            success: function (data) { // from ~ to 또는 to-minute ~ now 또는 from ~ from+minute 데이터 조회
                $.each(data, function (index, item) {
                    getData.push({up_time: moment(item.up_time).format('YYYY-MM-DD HH:mm:ss'), value: item.value});
                })
            },
            error: function (e) {
                // console.log("getSensor Error");
                // 조회 결과 없을 때 return [];
            }
        }); //ajax
        return getData;
    }

    /* 센서명으로 센서정보 조회 */
    function getSensorInfo(sensor) {
        var getData;
        $.ajax({
            url:'getSensorInfo',
            dataType: 'json',
            data: {"sensor": sensor},
            async: false,
            success: function (data) {
                // 데이터가 0 또는 null 일 경우 "-" 으로 치환
                if(data.legal_standard == 0 || data.legal_standard == null){
                    data.legal_standard = "-";
                }
                if(data.company_standard == 0 || data.company_standard == null){
                    data.company_standard = "-";
                }
                if(data.management_standard == 0 || data.management_standard == null){
                    data.management_standard = "-";
                }
                getData = data;
            },
            error: function (e) {
                // console.log("getSensorInfo Error");
                /* 결과가 존재하지 않을 경우 센서명만 전달 */
                getData = {"name": sensor, "naming": sensor,
                    "legal_standard": "-", "company_standard": "-", "management_standard": "-", "power": "off"}
            }
        }); //ajax
        return getData;
    }


    /* place_table 생성 */
    function draw_place_table(data){
        $("#sensor-table").DataTable().clear();
        $("#sensor-table").DataTable().destroy();

        $('#sensor-table').DataTable({
            paging: false,
            searching: false,
            select: true,
            bPaginate: false,
            bInfo: false,
            data: data,
            order:[[0, 'desc']],
            columns: [
                {"data": "naming"},
                {"data": "value"},
                {"data": "b5_value"},
                {"data": "com_value"},
                {"data": "legal_standard"},
                {"data": "company_standard"},
                {"data": "management_standard"},
                // {"data": "power"},
                {"data": "up_time"},
            ],
            'rowCallback': function(row, data, index){
                if(data.legal_standard){
                    $(row).find('td:eq(4)').css('background-color', '#fff390');
                    if(data.value >= data.legal_standard){
                        $(row).find('td:eq(1)').css('background-color', '#fff390');
                    }
                }
                if(data.company_standard){
                    $(row).find('td:eq(5)').css('background-color', '#ff909b');
                    if(data.value >= data.company_standard){
                        $(row).find('td:eq(1)').css('background-color', '#ff909b');
                    }
                }
                if(data.management_standard){
                    $(row).find('td:eq(6)').css('background-color', '#fbb333');
                    if(data.value >= data.management_standard){
                        $(row).find('td:eq(1)').css('background-color', '#fbb333');
                    }
                }
                if(data.legal_standard == "-" || data.company_standard == "-" || data.management_standard == "-"){
                    $(row).find('td:eq(1)').css('background-color', '#fefefe');
                }
                if(data.value> b5_value){
                    $(row).find('td:eq(1)').prepend("▼");
                }else if(data.value < b5_value){
                    $(row).find('td:eq(1)').prepend("▲");

                }
            },
            "language": {
                "emptyTable": "데이터가 없어요.",
                "lengthMenu": "페이지당 _MENU_ 개씩 보기",
                "info": "현재 _START_ - _END_ / _TOTAL_건",
                "infoEmpty": "데이터 없음",
                "infoFiltered": "( _MAX_건의 데이터에서 필터링됨 )",
                "search": "에서 검색: ",
                "zeroRecords": "일치하는 데이터가 없어요.",
                "loadingRecords": "로딩중...",
                "processing":     "잠시만 기다려 주세요...",
                "paginate": {
                    "next": "다음",
                    "previous": "이전"
                }
            },
        });
    }

</script>