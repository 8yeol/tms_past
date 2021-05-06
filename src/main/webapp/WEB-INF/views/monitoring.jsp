<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>

<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<script src="static/js/vue.min.js"></script>
<script src="static/js/apexcharts.min.js"></script>
<script src="static/js/vue-apexcharts.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>
<script src="static/js/moment.min.js"></script>

<style>
    div {
        padding: 1px;
    }

    h1 {
        text-align: center;
    }

    .border-right {
        border-right-style: solid;
        border-right-color: #a9a9a9;
        border-right-width: 1px;
    }

    .img {
        width: 10px;
        height: 10px;
        margin-right: 10px;
    }

    .emoji {
        width: 60px;
        height: 60px;
        position: relative;
        top: 25px;
    }

    .add-bg-color {
        background-color: #97bef8;
        color: #fff;
    }
</style>


<div class="container">
    <div class="row m-3 mt-3">
        <div class="col">
            <span class="fs-4">모니터링 > 실시간 모니터링</span>
        </div>
        <div class="col text-end align-self-end">
            <span class="text-primary small"> * 5분 단위로 업데이트 됩니다.</span>
        </div>
    </div>
    <div class="row m-3 mt-3">
        <div class="col bg-white" style="margin-right: 5px;">
            <div class="row">
                <span class="fs-5 fw-bold">가동률</span>
            </div>
            <div class="row">
                <div class="col text-center">
                    <p class="fs-1 mb-0" id="power_text_A"></p>
                    <hr class="m-0">
                    <p id="power_text_B"></p>
                </div>
                <div class="col">
                    <p class="fs-6">정상 : <a style="text-align: right" id="status_on_text"></a></p>
                    <p class="fs-6">통신불량 : <a style="text-align: right" id="status_off_text"></a></p>
                    <p class="fs-6">모니터링 OFF : <a style="text-align: right" id="power_off_text"></a></p>
                </div>
            </div>
        </div>
        <div class="col bg-white" style="margin-left: 5px;">
            <div class="row">
                <div class="col">
                    <span class="fs-6 fw-bold">관리기준</span>
                </div>
                <div class="col">
                    <span class="fs-6 fw-bold">사내기준</span>
                </div>
                <div class="col">
                    <span class="fs-6 fw-bold">법적기준</span>
                </div>
            </div>
            <div class="row h-75">
                <div class="col border-right">
                    <div class="row text-center">
                        <div class="col">
                            <img src="/static/images/sceptic.png" class="emoji">
                        </div>
                        <div class="col">
                            <p class="fs-1 mb-0" id="legal_standard_text_A"></p>
                            <hr class="m-0">
                            <p id="legal_standard_text_B"></p>
                        </div>
                    </div>
                </div>
                <div class="col border-right">
                    <div class="row text-center">
                        <div class="col">
                            <img src="/static/images/thinking.png" class="emoji">
                        </div>
                        <div class="col">
                            <p class="fs-1 mb-0" id="company_standard_text_A"></p>
                            <hr class="m-0">
                            <p id="company_standard_text_B"></p>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="row text-center">
                        <div class="col">
                            <img src="/static/images/sad.png" class="emoji">
                        </div>
                        <div class="col">
                            <p class="fs-1 mb-0" id="management_standard_text_A"></p>
                            <hr class="m-0">
                            <p id="management_standard_text_B"></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row m-3 mt-3 bg-light">
        <div class="row m-3">
            <div class="col text-center border">
                <div class="row p-3">
                    <div class="col">
                        <span class="small fw-bold"><img src="static/images/up.png" class="img">직전 데이터보다 높아진 경우</span>
                    </div>
                    <div class="col">
                        <span class="small fw-bold"><img src="static/images/down.jpg" class="img">직전 데이터보다 낮아진 경우</span>
                    </div>
                    <div class="col">
                        <span class="small fw-bold"> <b> - </b> 직전 데이터와 같은 경우</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="row table m-3" id="place_table">
            <c:set var="plceSize" value="${place.size()}"/>
            <c:forEach var="places" items="${place}" varStatus="status">
            <c:choose>
                <c:when test="${placeSize%2==1}">
                    <div class="col-md-12 mb-3" >
                    <div class="bg-info m-2 text-center"><span class="fs-5">${places.name}</span></div>
                    <div class="2 text-end">업데이트 : <span class="small" id="update-${status.index}"></span></div>
                </c:when>
                <c:otherwise>
                    <div class="col-md-6 mb-3">
                    <div class="bg-info m-2 text-center"><span class="fs-5">${places.name}</span></div>
                    <div class="2 text-end">업데이트 : <span class="small" id="update-${status.index}"></span></div>
                </c:otherwise>
            </c:choose>
                   <table class="table table-bordered table-hover text-center">
                        <thead>
                        <tr class="add-bg-color">
                            <th>항목</th>
                            <th>법적기준</th>
                            <th>사내기준</th>
                            <th>관리기준</th>
                            <th>실시간</th>
                        </tr>
                        <thead>
                        <tbody id="sensor-table-${status.index}">
                            <%--script--%>
                        </tbody>
                    </table>
                </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    let INTERVAL;

    let status_true_count = 0, status_false_count = 0, power_on_count = 0, power_off_count = 0, legal_standard_count = 0, company_standard_count = 0, management_standard_count = 0;

    $(document).ready(function () {
        getData();
        // flashing();
    });

    // 모니터링 on 되어있는 측정소 명
    function getPlace(){
        const place_name = new Array();

        <c:forEach items="${place}" var="place" varStatus="status">
            place_name.push("${place.name}");
        </c:forEach>

        return place_name;
    }

    function getData() {

        const place_name = getPlace();

        var place_data = new Array(); //{최근데이터, 9:59 전 데이터, 센서 정보}

        for (var i = 0; i < place_name.length; i++) {
            place_data.push(getPlaceData(place_name[i])); // 데이터 조회(최근데이터, 10분전데이터, 정보)
            draw_place_table(place_data[i], i); // 로딩되면 테이블 생성

        }
        console.log(place_data);
        setTimeout(function interval_getData() { //실시간 처리위해 setTimeout
            // 위 for 문의 i가 0에서 넘어오지 않아 새로 생성
            var place_data_recent = new Array();
            for (var i = 0; i < place_name.length; i++) {
                clearTimeout(INTERVAL); // 실행중인 interval 있다면 삭제
                //console.log(place_name[i] + " : " + INTERVAL + "----------------------------------------------");
                place_data_recent.push(getPlaceData(place_name[i]));
                for (var z = 0; z < place_data[i].length; z++) {
                    if (place_data[i][z].up_time != place_data_recent[i][z].up_time) {
                        place_data[i][z].b5_value = place_data_recent[i][z].b5_value;
                        place_data[i][z].com_value = place_data_recent[i][z].com_value;
                        place_data[i][z].value = place_data_recent[i][z].value;
                        place_data[i][z].up_time = place_data_recent[i][z].up_time;
                        place_data[i][z].naming = place_data[i][z].naming;
                        place_data[i][z].name = place_data[i][z].name;

                        draw_place_table(place_data[i], i);

                    }
                }
                INTERVAL = setTimeout(interval_getData, 5000);
            }
            draw_place_info();
        }, 0);
    }

    function draw_place_info() {
        console.log('draw place info')
        $("#power_text_A").text(((status_true_count / (status_true_count + status_false_count)).toFixed(2) * 100).toFixed(0) + "%");
        $("#power_text_B").text(status_true_count + " / " + (status_false_count + status_true_count));
        $("#status_on_text").text(status_true_count + "개");
        $("#status_off_text").text(status_false_count + "개");
        $("#power_off_text").text(power_off_count + "개");
        $("#legal_standard_text_A").text(((legal_standard_count / (status_true_count + status_false_count)) * 100).toFixed(0) + "%");
        $("#legal_standard_text_B").text(legal_standard_count + " / " + (status_true_count + status_false_count));
        $("#company_standard_text_A").text(((company_standard_count / (status_true_count + status_false_count)) * 100).toFixed(0) + "%");
        $("#company_standard_text_B").text(company_standard_count + " / " + (status_true_count + status_false_count));
        $("#management_standard_text_A").text(((management_standard_count / (status_true_count + status_false_count)) * 100).toFixed(0) + "%");
        $("#management_standard_text_B").text(management_standard_count + " / " + (status_true_count + status_false_count));
    }

    /* 측정소명으로 센서명을 구하고 센서명으로 센서의 최근데이터, 10분전 데이터, 정보들을 리턴*/
    function getPlaceData(place) {
        var getData = new Array();
        $.ajax({  //측정소의 센서명을 구함
            url: 'getPlaceSensor',
            dataType: 'json',
            data: {"place": place},
            async: false,
            success: function (data) {
                $.each(data, function (index, item) { //item (센서명)
                    var Onoff = getPower(item);
                    if (Onoff == "on") {
                        power_on_count += 1;
                        var sensor = getSensorRecent(item); // item의 최근데이터
                        if (sensor.value == 0 || sensor.value == null) { //null 일때
                            sensor_value = "-"; // "-" 출력(datatable)
                        } else {
                            sensor_value = sensor.value.toFixed(2);
                            status = sensor.status;
                            up_time = moment(sensor.up_time).format('YYYY-MM-DD HH:mm:ss');
                        }

                        var b5_sensor = getSensor(item, "", "", 10); //item의 10분전 데이터
                        if (b5_sensor.length != 0) { // 최근데이터 값 - 9:59분전 데이터
                            b5_value = (b5_sensor[(b5_sensor.length) - 1].value).toFixed(3);
                            com_value = (sensor.value - b5_value).toFixed(3);
                        } else { // 최근데이터 존재하지 않을 경우 "-" 처리
                            b5_value = "-";
                            com_value = "-";
                        }

                        var sensorInfo = getSensorInfo(item); //item의 정보 데이터
                        var naming = sensorInfo.naming;
                        var legal_standard = sensorInfo.legalStandard;
                        var company_standard = sensorInfo.companyStandard;
                        var management_standard = sensorInfo.managementStandard;
                        var power = sensorInfo.power;

                        if (status == "true") {
                            status_true_count += 1;
                        } else {
                            status_false_count += 1;
                        }
                        if (sensor.value >= sensorInfo.legalStandard) {
                            legal_standard_count += 1;
                        }
                        if (sensor.value < sensorInfo.legalStandard && sensor.value >= sensorInfo.companyStandard) {
                            company_standard_count += 1;
                        }
                        if (sensor.value <= sensorInfo.companyStandard && sensor.value > sensorInfo.managementStandard) {
                            management_standard_count += 1;
                        }
                        /* power on 출력 */
                        if (power == "on") {
                            getData.push({
                                naming: naming,
                                name: item,
                                value: sensor_value,
                                up_time: up_time,
                                status: sensor.status,
                                legal_standard: legal_standard,
                                company_standard: company_standard,
                                management_standard: management_standard,
                                power: power,
                                b5_value: b5_value,
                                com_value: com_value
                            });
                        }
                    } else {
                        power_off_count += 1;
                    }
                    /* power off 출력 */
                    /*                   if(power == "off"){
                                           getData.push({
                                               naming: naming, name:item,
                                               value: sensor_value, up_time: up_time, status: sensor.status,
                                               legal_standard: legal_standard, company_standard: company_standard, management_standard: management_standard, power: power,
                                               b5_value: b5_value, com_value: com_value
                                           });
                                       }*/

                });
            },
            error: function () {
                console.log("getPlaceData error");
            }
        });//ajax
        return getData;
    }

    /* 센서명으로 최근 데이터 조회 */
    function getPower(sensor) {
        var getData;
        $.ajax({
            url: 'getPower',
            dataType: 'text',
            data: {"name": sensor},
            async: false,
            success: function (data) {
                getData = data;
            },
            error: function (e) {
                // console.log("getSensorRecent Error");
                // 결과가 존재하지 않을 경우 null 처리
                getData = "off";
            }
        }); //ajax
        return getData;
    }

    /* 센서명으로 최근 데이터 조회 */
    function getSensorRecent(sensor) {
        var getData;
        $.ajax({
            url: 'getSensorRecent',
            dataType: 'json',
            data: {"sensor": sensor},
            async: false,
            success: function (data) {
                getData = data;
            },
            error: function (e) {
                // console.log("getSensorRecent Error");
                // 결과가 존재하지 않을 경우 null 처리
                getData = {value: null, status: false, up_time: null};
            }
        }); //ajax
        return getData;
    }

    /* 센서명으로 from, to, minute 의 조건에 맞는 from ~ to 센서의 데이터 조회 */
    function getSensor(sensor, from_date, to_date, minute) {
        var getData = new Array();
        $.ajax({
            url: 'getSensor',
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
            url: 'getSensorInfo',
            dataType: 'json',
            data: {"sensor": sensor},
            async: false,
            success: function (data) {
                // 데이터가 0 또는 null 일 경우 "-" 으로 치환
                if (data.legalStandard == 0 || data.legalStandard == null) {
                    data.legalStandard = "-";
                }
                if (data.companyStandard == 0 || data.companyStandard == null) {
                    data.companyStandard = "-";
                }
                if (data.managementStandard == 0 || data.managementStandard == null) {
                    data.managementStandard = "-";
                }
                getData = data;
            },
            error: function (e) {
                // console.log("getSensorInfo Error");
                /* 결과가 존재하지 않을 경우 센서명만 전달 */
                getData = {
                    "name": sensor, "naming": sensor,
                    "legalStandard": "-", "companyStandard": "-", "managementStandard": "-", "power": "off"
                }
            }
        }); //ajax
        // console.log(getData);
        return getData;
    }







    /* 센서명 클릭 이벤트 */
    $("#place_table table").on('click', 'tr', function () {
        const place_div = $(this).parents('#place_table div').eq(0);
        const place_name = place_div.children().eq(0).children().eq(0).text();
        const sensor_naming = $(this).find('td').eq(0).text();
        location.replace("/sensor?place=" + place_name + "&sensor=" + sensor_naming);
    });

    /* 본문 점멸 효과 */
    function flashing() {
        const element = $(".row ");
        setTimeout(function flashInterval() {
            setTimeout(function () {
                element.css({"opacity": 0});
            }, 0);
            setTimeout(function () {
                element.css({"opacity": 1});
            }, 200); //0.2초 숨김
            setTimeout(flashInterval, 1000); //0.8초 보여줌
        }, 0)
    }

    function draw_place_table(data, index) {
        $('#sensor-table-' + index).empty();
        const tbody = document.getElementById('sensor-table-' + index);

        for (let i = 0; i < data.length; i++) {
            const newRow = tbody.insertRow(tbody.rows.length);
            const newCeil0 = newRow.insertCell(0);
            const newCeil1 = newRow.insertCell(1);
            const newCeil2 = newRow.insertCell(2);
            const newCeil3 = newRow.insertCell(3);
            const newCeil4 = newRow.insertCell(4);
            newCeil0.innerHTML = data[i].naming;
            newCeil1.innerHTML = data[i].legal_standard;
            newCeil2.innerHTML = data[i].company_standard;
            newCeil3.innerHTML = data[i].management_standard;

            if(data[i].value > data[i].legal_standard){
                newCeil4.innerHTML = '<span class="text-danger fw-bold">' + fiveMinutesAgo(data[i].b5_value, data[i].value) + '</span>';
            } else if( data[i].value > data[i].company_standard){
                newCeil4.innerHTML = '<span class="text-warning fw-bold">' + fiveMinutesAgo(data[i].b5_value, data[i].value) + '</span>';
            } else if( data[i].value > data[i].management_standard){
                newCeil4.innerHTML = '<span class="text-success fw-bold">' + fiveMinutesAgo(data[i].b5_value, data[i].value) + '</span>';
            } else{
                newCeil4.innerHTML = fiveMinutesAgo(data[i].b5_value, data[i].value);
            }

            $("#update-" + index).text(moment(data[i].up_time).format('YYYY-MM-DD HH:mm:ss'));
        }
    }

    function fiveMinutesAgo(fiveMinutes , now){
        if(fiveMinutes > now){
            return '<img src="static/images/down.jpg" class="img">' + now;
        } else if( now > fiveMinutes) {
            return '<img src="static/images/up.png" class="img">' + now;
        } else{
            return ' - ' + now;
        }
    }
</script>