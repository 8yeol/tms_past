<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

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
                    <p class="fs-1 mb-0" id="statusPercent"></p>
                    <hr class="m-0">
                    <p id="statusMore"></p>
                </div>
                <div class="col">
                    <p class="fs-6">정상 : <a style="text-align: right" id="statusOn"></a></p>
                    <p class="fs-6">통신불량 : <a style="text-align: right" id="statusOff"></a></p>
                    <p class="fs-6">모니터링 OFF : <a style="text-align: right" id="monitoringOff"></a></p>
                </div>
            </div>
        </div>
        <div class="col bg-white" style="margin-left: 5px;">
            <div class="row">
                <div class="col">
                    <span class="fs-6 fw-bold">법적기준</span>
                </div>
                <div class="col">
                    <span class="fs-6 fw-bold">사내기준</span>
                </div>
                <div class="col">
                    <span class="fs-6 fw-bold">관리기준</span>
                </div>
            </div>
            <div class="row h-75">
                <%-- 법적 기준 --%>
                <div class="col border-right">
                    <div class="row text-center">
                        <div class="col">
                            <img src="/static/images/sad.png" class="emoji">
                        </div>
                        <div class="col">
                            <p class="fs-1 mb-0" id="legal_standard_text_A"></p>
                            <hr class="m-0">
                            <p id="legal_standard_text_B"></p>
                        </div>
                    </div>
                </div>
                <%-- 사내 기준 --%>
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
                <%-- 관리 기준 --%>
                <div class="col">
                    <div class="row text-center">
                        <div class="col">
                            <img src="/static/images/sceptic.png" class="emoji">
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

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    let INTERVAL;

    $(document).ready(function () {
        getData();
        // flashing();
    });

    // 센서명 클릭 이벤트 -> 상세페이지 이동
    $("#place_table").on('click', 'tbody tr', function () {
        const placeName = $(this).parents('#place_table div').eq(0).children().eq(0).children().eq(0).text();
        const sensorName = $(this).find('td').eq(0).text();
        location.replace("/sensor?place=" + placeName + "&sensor=" + sensorName);
    });

    // 점멸 효과
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

    /* 대시보드 */
    function draw_sensor_info(data) {
        var sensorMonitoringOn=0, sensorMonitoringOff=0, sensorStatusSuccess=0, sensorStatusFail=0, legalSCount =0, companySCount =0, managementSCount=0;
        for(var i=0; i<data.length; i++){
            for(var z=0; z<data[i].length; z++){
                sensorData = data[i][z];
                monitoring = sensorData.monitoring;
                status = sensorData.status;
                value = sensorData.value;
                legalStandard = sensorData.legalStandard;
                companyStandard = sensorData.companyStandard;
                managementStandard = sensorData.managementStandard;
                if(monitoring){
                    sensorMonitoringOn +=1;
                }else{
                    sensorMonitoringOff +=1;
                }
                if(status){
                    sensorStatusSuccess +=1;
                    if(value > legalStandard){
                        legalSCount +=1;
                    }else if(value > companyStandard){
                        companySCount +=1;
                    }else if(value > managementStandard){
                        managementSCount +=1;
                    }
                }else{
                    sensorStatusFail += 1;
                }
            }
        }
        $("#statusPercent").text(((sensorStatusSuccess / (sensorStatusSuccess + sensorStatusFail)).toFixed(2) * 100).toFixed(0) + "%");
        $("#statusMore").text(sensorStatusSuccess + " / " + (sensorStatusSuccess + sensorStatusFail));
        $("#statusOn").text(sensorStatusSuccess);
        $("#statusOff").text(sensorStatusFail);
        $("#monitoringOff").text(sensorMonitoringOff);
        $("#legal_standard_text_A").text(((legalSCount / (sensorStatusSuccess + sensorStatusFail)) * 100).toFixed(0) + "%");
        $("#legal_standard_text_B").text(legalSCount + " / " + (sensorStatusSuccess + sensorStatusFail));
        $("#company_standard_text_A").text(((companySCount / (sensorStatusSuccess + sensorStatusFail)) * 100).toFixed(0) + "%");
        $("#company_standard_text_B").text(companySCount + " / " + (sensorStatusSuccess + sensorStatusFail));
        $("#management_standard_text_A").text(((managementSCount / (sensorStatusSuccess + sensorStatusFail)) * 100).toFixed(0) + "%");
        $("#management_standard_text_B").text(managementSCount + " / " + (sensorStatusSuccess + sensorStatusFail));
    }


    function getData() {
        setTimeout(function interval_getData() { //실시간 처리위한 setTimeout
            const placeName = getPlace(); // 전체 측정소 이름 구함 (조건: 파워 On, 모니터링 True)
            draw_place_table_frame(placeName); // 측정소별 센서의 테이블 틀 생성 (개수에 따른 유동적으로 크기 변환)
            const placeData = new Array();
            for (let i = 0; i < placeName.length; i++) {
                clearTimeout(INTERVAL); // 실행중인 interval 있다면 삭제
                const data = getPlaceData(placeName[i]); //측정소 별 센서 데이터 (최근데이터, 이전데이터, 정보)
                draw_place_table(data, i); // 로딩되면 테이블 생성
                placeData.push(data); //측정소 별 센서 데이터 통합
                setTimeout(function () {
                    draw_sensor_info(placeData); // 대시보드 생성(가동률, 법적기준 정보 등)
                }, 0);
                INTERVAL = setTimeout(interval_getData, 1000);
            }
        }, 0);
    }

    // 전체 측정소 이름 구함 (조건: 파워 On, 모니터링 True)
    function getPlace(){
        const placeName = new Array();
        $.ajax({
            url: '<%=cp%>/getPlaceList',
            dataType: 'json',
            async: false,
            success: function (data) {
                $.each(data, function (index, item) { //item (센서명)
                    monitoring = item.monitoring;
                    if(monitoring){
                       placeName.push(item.name);
                    }else{

                    }
                })

            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
        return placeName;
    }

    /* 측정소별 센서의 테이블 틀 생성 (개수에 따른 유동적으로 크기 변환)*/
    function draw_place_table_frame(placeName) {
        $('#place_table').empty();
        var col_md_size;
        for(var i=0; i<placeName.length; i++){
            if(placeName.length%2==0){ //짝수개
                col_md_size = 6;
            }else if(placeName.length%2==1){ //홀수개
                col_md_size = 12;
            }

            $('#place_table').append("<div class='col-md-"+col_md_size+" mb-3 mt-2'>" +
                "<div class='bg-info m-2 text-center'><span class='fs-5'>"+placeName[i]+"</span></div>" +
                "<div class='2 text-end'>업데이트 :<span class='small' id=update-"+i+">"+"</span></div>" +
                "<table class='table table-bordered table-hover text-center'>" +
                "<thead>" +
                "<tr class='add-bg-color'>" +
                "<th>항목</th>" +
                "<th>법적기준</th>" +
                "<th>사내기준</th>" +
                "<th>관리기준</th>" +
                "<th>실시간</th>" +
                "</tr>" +
                "</thead>"+
                "<tbody id='sensor-table-"+i+"'>"+
                "</tbody>" +
                "</table>" +
                "</div>");
        }
    }

    /* 측정소의 최근, 이전, 정보데이터 구함 (조건: 센서의 모니터링 On)*/
    function getPlaceData(place) {
        const getData = new Array();
        $.ajax({  //측정소의 센서명을 구함
            url: 'getPlaceSensor',
            dataType: 'json',
            data: {"place": place},
            async: false,
            success: function (data) {
                $.each(data, function (index, item) { //item (센서명) : 센서의 최근데이터, 이전 데이터, 정보들을 구함
                    var Monitoring = getMonitoring(item); //모니터링 On
                    if(Monitoring){
                        /* 센서의 최근 데이터 */
                        var recentData = getSensorRecent(item);
                        if(recentData.value == 0 || recentData.value == null){ //null 일때
                            recentData.value = "-"; // "-" 출력(datatable)
                        }else{
                            status = recentData.status; //센서의 상태
                            if(status){ //양호
                                sensorValue = recentData.value.toFixed(2);
                                sensorUptime = moment(recentData.up_time).format('YYYY-MM-DD HH:mm:ss');
                            }else{ //불량
                                recentData.value = "-"; // "-" 출력(datatable)
                                sensorUptime = moment(recentData.up_time).format('YYYY-MM-DD HH:mm:ss');
                            }
                        }
                        /* 센서의 이전 데이터 */
                        var beforeData = getSensorBeforeData(item); //sensor 이전 데이터
                        if(beforeData.length == 0){
                            beforeValue = "-";
                        }else{ // 최근데이터 존재하지 않을 경우 "-" 처리
                            beforeValue = beforeData.value.toFixed(2);
                        }

                        /* 센서의 정보 데이터 */
                        var sensorInfo = getSensorInfo(item);
                        naming = sensorInfo.naming;
                        monitoring = sensorInfo.monitoring; //모니터링 정보
                        legalStandard = sensorInfo.legalStandard;
                        companyStandard = sensorInfo.companyStandard;
                        managementStandard = sensorInfo.managementStandard;

                        if(recentData.value > legalStandard){
                            standard = "법적기준 초과";
                        }else if(recentData.value > companyStandard){
                            standard = "사내기준 초과";
                        }else if(recentData.value > managementStandard){
                            standard = "관리기준 초과";
                        }else if(recentData.value <= managementStandard){
                            standard = "정상";
                        }else{
                            standard = "-";
                        }

                        getData.push({
                            naming: naming, name:item.name,
                            value:sensorValue, up_time: sensorUptime,
                            legalStandard: legalStandard, companyStandard: companyStandard, managementStandard: managementStandard,
                            beforeValue: beforeValue, monitoring: monitoring, standard : standard, status: status
                        });
                    }
                });
            },
            error: function () {
            }
        });
        return getData;
    }

    // 모니터링 on/off 조회 - getPlaceData 사용
    function getMonitoring(sensor) {
        let result;
        $.ajax({
            url: 'getMonitoring',
            dataType: 'text',
            data: {"name": sensor},
            async: false,
            success: function (data) {
                result = data;
            },
            error: function (e) {
                result = false;
            }
        });
        return result;
    }

    // 최근 데이터 조회 - getPlaceData 사용
    function getSensorRecent(sensor) {
        let result;
        $.ajax({
            url: 'getSensorRecent',
            dataType: 'json',
            data: {"sensor": sensor},
            async: false,
            success: function (data) {
                result = data;
            },
            error: function (e) {
                result = {value: null, status: false, up_time: null};
            }
        });
        return result;
    }

    /* 센서명 이전 데이터 조회 - getPlaceData 사용 */
    function getSensorBeforeData(sensor) {
        let result;
        $.ajax({
            url: 'getSensorBeforeData',
            dataType: 'json',
            data: {"sensor": sensor},
            async: false,
            success: function (data) { // from ~ to 또는 to-minute ~ now 또는 from ~ from+minute 데이터 조회
                result = ({up_time: moment(data.up_time).format('YYYY-MM-DD HH:mm:ss'), value: data.value});
            },
            error: function (e) {
                // console.log("getSensor Error");
                // 조회 결과 없을 때 return [];
            }
        }); //ajax
        return result;
    }

    /* 센서명으로 센서정보 조회 - getPlaceData 사용  */
    function getSensorInfo(sensor) {
        let result;
        $.ajax({
            url: 'getSensorInfo',
            dataType: 'json',
            data: {"sensor": sensor},
            async: false,
            success: function (data) {
                // 데이터가 0 또는 null 일 경우 "-" 으로 치환
                if (data.legalStandard == 999 || data.legalStandard == null) {
                    data.legalStandard = "-";
                }
                if (data.companyStandard == 999 || data.companyStandard == null) {
                    data.companyStandard = "-";
                }
                if (data.managementStandard == 999 || data.managementStandard == null) {
                    data.managementStandard = "-";
                }
                result = data;
            },
            error: function (e) {
                // console.log("getSensorInfo Error");
                /* 결과가 존재하지 않을 경우 센서명만 전달 */
                result = {
                    "name": sensor, "naming": sensor,
                    "legalStandard": "-", "companyStandard": "-", "managementStandard": "-", "power": "off"
                }
            }
        });
        return result;
    }

    /* 테이블 생성 */
    function draw_place_table(data, index) {
        $('#sensor-table-' + index).empty();
        const tbody = document.getElementById('sensor-table-' + index);
        if(data.length == 0){
            const newRow = tbody.insertRow(tbody.rows);
            const newCeil0 = newRow.insertCell();
            newCeil0.innerHTML = '<div>'+'noData'+'</div>';
            newCeil0.colSpan = 5;
            $("#update-" + index).text("-");
        }else{
            for (let i = 0; i < data.length; i++) {
                const newRow = tbody.insertRow(tbody.rows.length);
                const newCeil0 = newRow.insertCell(0);
                const newCeil1 = newRow.insertCell(1);
                const newCeil2 = newRow.insertCell(2);
                const newCeil3 = newRow.insertCell(3);
                const newCeil4 = newRow.insertCell(4);
                newCeil0.innerHTML = data[i].naming;
                newCeil1.innerHTML = '<div class="bg-danger text-light">'+data[i].legalStandard+'</div>';
                newCeil2.innerHTML = '<div class="bg-warning text-light">'+data[i].companyStandard+'</div>';
                newCeil3.innerHTML = '<div class="bg-success text-light">'+data[i].managementStandard+'</div>';

                if(data[i].value > data[i].legalStandard){
                    newCeil4.innerHTML = '<span class="text-danger fw-bold">' + draw_beforeDate(data[i].beforeValue, data[i].value) + '</span>';
                } else if( data[i].value > data[i].companyStandard){
                    newCeil4.innerHTML = '<span class="text-warning fw-bold">' + draw_beforeDate(data[i].beforeValue, data[i].value) + '</span>';
                } else if( data[i].value > data[i].managementStandard){
                    newCeil4.innerHTML = '<span class="text-success fw-bold">' + draw_beforeDate(data[i].beforeValue, data[i].value) + '</span>';
                } else{
                    newCeil4.innerHTML = draw_beforeDate(data[i].beforeValue, data[i].value);
                }

                $("#update-" + index).text(moment(data[i].up_time).format('YYYY-MM-DD HH:mm:ss'));
            }
        }
    }

    /* 최근, 이전데이터 비교하여 이미지 생성*/
    function draw_beforeDate(A , B){
        if(A > B){
            return '<img src="static/images/down.jpg" class="img">' + B;
        } else if( B > A) {
            return '<img src="static/images/up.png" class="img">' + B;
        } else{
            return B;
        }
    }
</script>