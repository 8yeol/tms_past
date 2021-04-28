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
        <div class="col-12 bg-gradient p-4 mt-4 ms-3 bg-skyblue rounded">
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
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row mt-4 h-75">
        <div class="col-md-12">
            <table id="sensor-table">
                <thead>
                <tr>
                    <th>항목</th>
                    <th>실시간</th>
                    <th>5분전</th>
                    <th>증감</th>
                    <th>법적기준</th>
                    <th>사내기준</th>
                    <th>관리기준</th>
                    <th>상태</th>
                    <th>업데이트</th>
                </tr>
                <thead>
            </table>
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
</div>

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

    function flashing(){
        element = $(".row ");
        setTimeout(function A() {
            setTimeout(function () {
                element.css({"opacity": 0});
            },0);
            setTimeout(function () {
                element.css({"opacity": 1});
            },200); //0.2초 숨김
            setTimeout(A, 1000); //0.8초 보여줌
        }, 0)
    }


    function getData(){
        var places = new Array();
        <c:forEach items="${place}" var="place" varStatus="status">
            places.push("${place.name}");
        </c:forEach>
        console.log(places);

        var place = $("#place").val();
        var place_data = getPlaceData(place);
        draw_place_table(place_data);
        interval = setTimeout(function interval_getData() {
            console.log(interval);
            var date = new Date();
            $("#time").text(moment(date).format('YYYY-MM-DD HH:mm:ss'));

            var place_data_recent = getPlaceData(place);
            for (var i = 0; i < place_data.length; i++) {
                if (place_data[i].up_time != place_data_recent[i].up_time) {
                    place_data[i].b5_value = place_data_recent[i].b5_value;
                    place_data[i].com_value = place_data_recent[i].com_value;
                    place_data[i].value = place_data_recent[i].value;
                    place_data[i].up_time = place_data_recent[i].up_time;

                    draw_place_table(place_data);
                }
            }
            setTimeout(interval_getData, 1000);
        }, 0);
    }

    function getPlaceData(place) {
        var getData = new Array();

        $.ajax({ /* 측정소의 센서명 획득 */
           url:'getPlaceSensor',
           dataType:'json',
           data: {"place": place},
           async: false,
           success: function (data) {
               $.each(data, function (index, item) {
                   // console.log(item); //sensor name
                   var sensor = getSensorRecent(item);
                   // console.log(sensor);
                   var b5_sensor = getSensor(item, "", "", 10);
                   // console.log(b5_sensor);
                   var sensorInfo = getSensorInfo(item);
                   // console.log(sensorInfo);
                   // console.log("-----------------------------------------------------------------");
                   if(b5_sensor.length != 0){
                       b5_value = b5_sensor[(b5_sensor.length)-1].y;
                       com_value = (sensor.value - b5_value).toFixed(5);
                   }else{
                       b5_value = 0;
                       com_value = 0;
                   }
                   if(sensorInfo != null){
                       naming = sensorInfo.naming;
                       legal_standard = sensorInfo.legal_standard;
                       company_standard = sensorInfo.company_standard;
                       management_standard = sensorInfo.management_standard;
                       power = sensorInfo.power;
                   }
                   if(sensor.value == 0 || sensor.value == null){
                       sensor.value = 0;
                   }
                   if(power == "on"){
                       getData.push({
                           naming: naming, name:item,
                           value:sensor.value.toFixed(5), up_time: moment(sensor.up_time).format('YYYY-MM-DD HH:mm:ss'),
                           legal_standard: legal_standard, company_standard: company_standard, management_standard: management_standard, power: power,
                           b5_value: b5_value, com_value: com_value
                       });
                   }
                   if(power == "off"){
                       getData.push({
                           naming: naming, name:item,
                           value:sensor.value.toFixed(5), up_time: moment(sensor.up_time).format('YYYY-MM-DD HH:mm:ss'),
                           legal_standard: legal_standard, company_standard: company_standard, management_standard: management_standard, power: power,
                           b5_value: b5_value, com_value: com_value
                       });
                   }
               });
           },
            error: function () {
               console.log("error");
            }
        });//ajax
        return getData;
    }

    /* 센서명으로 최근 데이터 조회 */
    function getSensorRecent(sensor){
        var getData = new Array();
        $.ajax({
            url:'getSensorRecent',
            dataType: 'json',
            data:  {"sensor": sensor},
            async: false,
            success: function (data) {
                getData = data;
            },
            error: function (e) {
                console.log("getSensorRecent Error");
                getData.push({value: null, status: false, up_time:null})
            }
        }); //ajax
        return getData;
    }

    /* 센서명으로 센서정보 조회 */
    function getSensorInfo(sensor) {
        var getData;
        $.ajax({
            url:'getSensorInfo2',
            dataType: 'json',
            data: {"sensor": sensor, "power": "on"},
            async: false,
            success: function (data) {
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
                /* data 가 존재하지 않을 경우 */
                // console.log("getSensorInfo Error");
                getData = {"name": sensor, "naming": sensor,
                    "legal_standard": "-", "company_standard": "-", "management_standard": "-", "power": "off"}
            }
        }); //ajax
        return getData;
    }

    /* sensor name에 해당하는 테이블에 접근하여 chart에 사용하는 data 생성 */
    function getSensor(sensor, from_date, to_date, minute) {
        var getData = new Array();
        $.ajax({
            url:'getSensor',
            dataType: 'json',
            data: {"sensor": sensor, "from_date": from_date, "to_date": to_date, "minute": minute},
            async: false,
            success: function (data) {
                $.each(data, function (index, item) {
                    getData.push({x: moment(item.up_time).format('YYYY-MM-DD HH:mm:ss'), y: item.value.toFixed(5)});
                })
            },
            error: function (e) {
                console.log("getSensor Error");
            }
        }); //ajax
        return getData;
    }

    /* place*/
    function draw_place_table(data){

        clearTimeout(interval);
        $("#sensor-table").DataTable().clear();
        $("#sensor-table").DataTable().destroy();
        // console.log(data);
        var table = $('#sensor-table').DataTable({
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
                {"data": "power"},
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
                // if(data.status == false){
                //     $(row).css('background-color', '#9bff90');
                // }
                // if(data.value >= data.warning){
                //     $(row).find('td:eq(1)').css('color', '#f54264');
                // }
                // if(data.value <= data.danger && data.value>=data.warning){
                //     $(row).find('td:eq(1)').css('color', '#ffb607');
                // }
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