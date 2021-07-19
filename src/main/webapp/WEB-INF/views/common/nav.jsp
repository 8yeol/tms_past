<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 5:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="static/js/fontawesome.js"></script>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

<style>
    @font-face {
        font-family: notoSansKR;

        src: url("static/fonts/NotoSansKR-Regular.otf");
    }

    body {
        background-color: #EDF2F8;
        font-family : notoSansKR;
    }
    .alarmCount{
        position: absolute;
        top: 0px;
        left: 18px;
        background-color: red;
        width: 20px;
        height: 20px;
        border-radius: 10px;
        color: white;
        line-height: 20px;
        padding-right:7px;
        display: none;
        font-size: 0.9rem;
    }


    @media (min-width: 990px) {
        .alarmCount{
            position: absolute;
            top: 0px;
            left: 18px;
            background-color: red;
            width: 20px;
            height: 20px;
            border-radius: 10px;
            color: white;
            line-height: 20px;
            padding-right:7px;
            display: none;
            font-size: 0.9rem;
        }
        #mobile{
            display: none;
        }

        #topMenu {
            height: 35px;
        }

        #topMenu ul { /* 메인 메뉴 안의 ul을 설정함: 상위메뉴의 ul+하위 메뉴의 ul */
            list-style-type: none;
            margin: 0px;
            padding: 0px;
        }

        #topMenu ul li { /* 메인 메뉴 안에 ul 태그 안에 있는 li 태그의 스타일 적용(상위/하위메뉴 모두) */
            color: white;
            float: left;
            line-height: 35px;
            vertical-align: middle;
            text-align: center;
            position: relative;
        }

        #topMenu ul li a {
            font-size: 1.4rem;
            margin-top: 10px;
        }
        #topMenu ul li ul li a{
            font-size: 1.1rem;
        }
        .messageText{
            text-align: center;
            font-size: 0.9rem;
            padding-top: 10px;
            padding-bottom: 10px;
            color: white;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .menuLink, .submenuLink { /* 상위 메뉴와 하위 메뉴의 a 태그에 공통으로 설정할 스타일 */
            text-decoration: none;
            display: block;
            width: 150px;
            font-size: 12px;
            font-weight: normal;
        }

        .menuLink { /* 상위 메뉴의 글씨색을 흰색으로 설정 */
            color: white;
        }

        .topMenuLi:hover .menuLink { /* 상위 메뉴의 li에 마우스오버 되었을 때 스타일 설정 */
            color: #F7C259;
            font-weight: bold;
        }

        .shortLink { /* 좀 더 긴 메뉴 스타일 설정 */
            width: 100px;
        }

        .submenuLink { /* 하위 메뉴의 a 태그 스타일 설정 */
            color: #ffffff;
            margin-right: -1px; /* [변경] 위 칸의 하단 테두리와 아래칸의 상단 테두리가 겹쳐지도록 설덩 */
        }

        .submenu { /* 하위 메뉴 스타일 설정 */
            text-align: center;
            position: absolute;
            left: -100%;
            top: 43px;
            height: 0px;
            overflow: hidden;
            transition: height .3s;
            -webkit-transition: height .3s;
            -moz-transition: height .3s;
            -o-transition: height .3s;
            width: 100%; /* [변경] 가로 드랍다운 메뉴의 넓이 */
        }
        .shortSubmenu{
            position: absolute;
            left:-50%;
            top: 43px;
            height: 0px;
            overflow: hidden;
            transition: height .3s;
            -webkit-transition: height .3s;
            -moz-transition: height .3s;
            -o-transition: height .3s;
            width: 100%; /* [변경] 가로 드랍다운 메뉴의 넓이 */
            /*border: 1px solid red;*/
        }

        .longSubmenu{
            position: absolute;
            left: -200%;
            top: 43px;
            height: 0px;
            overflow: hidden;
            transition: height .3s;
            -webkit-transition: height .3s;
            -moz-transition: height .3s;
            -o-transition: height .3s;
            width: 100%; /* [변경] 가로 드랍다운 메뉴의 넓이 */
            /*border: 1px solid red;*/
        }

        .submenu li .customSubmenu li{
            display: inline-block; /* [변경] 가로로 펼쳐지도록 설정 */
        }

        .topMenuLi:hover .stan_sub { /* 상위 메뉴에 마우스 모버한 경우 그 안의 하위 메뉴 스타일 설정 */
            height: 50px; /* [변경] 높이를 32px로 설정 */
            line-height: 50px;
            width: 450px;
            background: #75ACFF;
            border-radius: 5px;
            z-index: 500;
        }

        .topMenuLi:hover .short_sub { /* 상위 메뉴에 마우스 모버한 경우 그 안의 하위 메뉴 스타일 설정 */
            position: absolute;
            left: -50%;
            top: 43px;
            height: 50px; /* [변경] 높이를 32px로 설정 */
            width: 300px;
            background: #75ACFF;
            border-radius: 5px;
            z-index: 500;
        }

        .topMenuLi:hover .long_sub { /* 상위 메뉴에 마우스 모버한 경우 그 안의 하위 메뉴 스타일 설정 */
            position: absolute;
            left: -200%;
            top: 43px;
            height: 50px; /* [변경] 높이를 32px로 설정 */
            background: #75ACFF;
            width: 750px;
            border-radius: 5px;
            z-index: 500;
        }


        .submenuLink:hover, li.active>a { /* 하위 메뉴의 a 태그의 마우스 오버 스타일 설정 */
            color: #F7C259;
            font-weight: bold;
        }
        /* 드롭다운 버튼 style*/
        .dropbtn {
            color: white;
            background: none;
            padding: 16px;
            font-size: 16px;
            border: none;
        }

        .dropdown {
            position: relative;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f1f1f1;
            min-width: 160px;
            box-shadow: 0px 16px 32px 0px rgba(0,0,0,0.5);
            z-index: 2;
        }

        .dropdown-content span {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .dropdown-content a:hover {
            background-color: #ddd;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .message {
            color: black;
            display: none;
            position: absolute;
            top: 60px;
            right: 5px;
            min-width: 300px;
            min-height: 70px;
            z-index: 1;
        }

        div .alarm{
            width: 21px;
            height: 23px;
            margin-top: 17px;
        }
        .alarmbtn {
            background: none;
            border: none;
        }
    }

    @media (max-width: 990px) {
        .swal2-popup{width: 50rem !important;}
        #swal2-content{font-size: 2rem;}
        #swal2-title{font-size: 3rem;}
        .swal2-actions button{width: 300px;font-size: 2rem!important; }

        .alarmCount{
            position: absolute;
            top: 0px;
            left: 18px;
            background-color: red;
            width: 20px;
            height: 20px;
            border-radius: 10px;
            color: white;
            line-height: 20px;
            padding-right:7px;
            display: none;
            font-size: 0.9rem;
        }
        #desktop{
            display: none;
        }
        .messageText{
            text-align: center;
            font-size: 0.9rem;
            padding-top: 10px;
            padding-bottom: 10px;
            color: white;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .message {
            color: black;
            display: none;
            position: absolute;
            top: 60px;
            right: 5px;
            min-width: 300px;
            min-height: 70px;
            z-index: 1;
        }
        .sidebar {
            height: 100%;
            width: 250px;
            position: absolute;
            z-index: 1;
            top: 0;
            left: -250px;
            background-color: #0051c4;
            overflow-x: hidden;
            padding-top: 60px;
            transition: 0.5s;
        }
        .sidebar a {
            padding: 8px 8px 8px 32px;
            text-decoration: none;
            font-size: 25px;
            color: #ffffff;
            display: block;
            transition: 0.3s;
        }
        .sidebar button {
            padding: 8px 8px 8px 32px;
            text-decoration: none;
            font-size: 25px;
            color: #ffffff;
            display: block;
            transition: 0.3s;
            border: none;
            background: none;
        }

        .sidebar .closebtn {
            position: absolute;
            top: 0;
            right: 25px;
            font-size: 36px;
            margin-left: 50px;
        }

        .openbtn {
            font-size: 20px;
            cursor: pointer;
            background-color: #094db3;
            color: white;
            padding: 10px 15px;
            border: none;
        }

        #main {
            transition: margin-left .5s;
        }

        @media screen and (max-height: 450px) {
            .sidebar {padding-top: 15px;}
            .sidebar a {font-size: 18px;}
        }

        .dropdown {
            position: relative;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #235dc4;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
        }
        .dropdown-content a {
            color: #ffffff;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }
        .dropdown-content a:hover {
            background-color: #f1f1f1
        }
        .dropdown:hover .dropdown-content {
            display: block;
        }

        .dropbtn {
            color: white;
            background: none;
            padding: 16px;
            font-size: 16px;
            border: none;
        }

        .message {
            color: black;
            display: none;
            position: absolute;
            top: 80px;
            right: 100px;
            min-width: 250px;
            min-height: 70px;
            z-index: 1;
        }

        div .alarm{
            width: 25px;
            height: 28px;
            margin-top: 18px;
        }

        .alarmbtn {
            background: none;
            border: none;
        }
    }
    .opacity {
        opacity: 0.9;
    }
    #parentDivAlarm{
        position: relative !important;
    }
</style>

<header class="p-4 bg-primary text-white" id="desktop">
    <div class="container">
        <div class="d-flex justify-content-between">
            <div class="d-flex justify-content-around">
                <c:choose>
                    <c:when test="${member.state eq 1}">
                        <a href="<%=cp%>/dashboard" class="mb-2 mb-lg-0 text-white text-decoration-none fs-3 pe-5 fw-bold">
                            대기 TMS 관제 시스템
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="<%=cp%>/monitoring" class="mb-2 mb-lg-0 text-white text-decoration-none fs-3 pe-5 fw-bold">
                            대기 TMS 관제 시스템
                        </a>
                    </c:otherwise>
                </c:choose>

                <nav id="topMenu">
                    <ul id="menu">
                        <li class="topMenuLi"><a class="menuLink fw-bold" href="<%=cp%>/dashboard" id="dashboard">대시보드</a></li>
                        <li class="topMenuLi"><a class="menuLink shortLink fw-bold" href="<%=cp%>/alarm" id="alarm">알림</a></li>
                        <li class="topMenuLi"><a class="menuLink fw-bold" href="<%=cp%>/monitoring" id="monitoring">모니터링</a>
                            <ul class="submenu short_sub">
                                <li><a href="<%=cp%>/monitoring" class="submenuLink" style="margin-left: 20px;">실시간 모니터링</a></li>
                                <li><a href="<%=cp%>/sensor" class="submenuLink" style="width: 130px;">상세화면</a></li>
                            </ul>
                        </li>
                        <li class="topMenuLi"><a class="menuLink fw-bold" href="<%=cp%>/dataInquiry" id="statistics">분석 및 통계</a>
                            <ul class="submenu short_sub">
                                <li><a href="<%=cp%>/dataInquiry" class="submenuLink ">측정자료 조회</a></li>
                                <li><a href="<%=cp%>/dataStatistics" class="submenuLink ">통계자료 조회</a></li>
                            </ul>
                        </li>
                        <li class="topMenuLi"><a class="menuLink fw-bold" href="<%=cp%>/stationManagement" id="setting">환경설정</a>
                            <ul class="submenu long_sub">
                                <li><a href="<%=cp%>/stationManagement" class="submenuLink ">측정소 관리</a></li>
                                <li><a href="<%=cp%>/sensorManagement" class="submenuLink ">센서 관리</a></li>
                                <li><a href="<%=cp%>/alarmManagement" class="submenuLink ">알림 설정</a></li>
                                <li><a href="<%=cp%>/emissionsManagement" class="submenuLink ">배출량 관리</a></li>
                                <li><a href="<%=cp%>/setting" class="submenuLink ">설정</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav>
            </div>

            <div class="text-end" style="display: inline-flex; position: relative">
                <div class="dropdown">
                    <button class="dropbtn rounded" id="dropBtn"><i class="fas fa-caret-down"></i></button>
                    <div class="dropdown-content text-start">
                        <a href="<%=cp%>/myPage">마이페이지</a>
                        <a href="<%=cp%>/logout">로그아웃</a>
                    </div>
                </div>

                <div id="parentDivAlarm">
                    <button class="alarmbtn" onclick="messageOpen()"><img class="alarm" src="static/images/bellOn.png"></button>
                    <div class="alarmCount"></div>
                </div>

                <div class="message text-start" style="padding: 10px;">
                    <div class="dangerOuter opacity"></div>
                    <div class="warningOuter opacity"></div>
                    <div class="cautionOuter opacity"></div>
                </div>
            </div>

        </div>
    </div>
</header>

<header class="p-4 bg-primary text-white" id="mobile">
    <div id="mySidebar" class="sidebar">
        <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>
        <a class="fw-bold mt-5" href="<%=cp%>/dashboard">대시보드</a>
        <a class="fw-bold mt-1" href="<%=cp%>/alarm">알림</a>
        <div class="dropdown">
            <button class="dropbtn fw-bold mt-1 d-block">모니터링</button>
            <div class="dropdown-content ms-4">
                <a href="<%=cp%>/monitoring" class="fs-6 fw-bold">실시간 모니터링</a>
                <a href="<%=cp%>/sensor" class="fs-6 fw-bold">상세화면</a>
            </div>
        </div>
        <div class="dropdown">
            <button class="dropbtn fw-bold mt-1 d-block">분석 및 통계</button>
            <div class="dropdown-content ms-4">
                <a href="<%=cp%>/dataInquiry" class="fs-6 fw-bold">측정자료 조회</a>
                <a href="<%=cp%>/dataStatistics" class="fs-6 fw-bold">통계자료 조회</a>
            </div>
        </div>
        <div class="dropdown">
            <button class="dropbtn fw-bold mt-1 d-block">설정</button>
            <div class="dropdown-content ms-4">
                <a href="<%=cp%>/stationManagement" class="fs-6 fw-bold">측정소 관리</a>
                <a href="<%=cp%>/sensorManagement" class="fs-6 fw-bold">센서 관리</a>
                <a href="<%=cp%>/alarmManagement" class="fs-6 fw-bold">알림 설정</a>
                <a href="<%=cp%>/emissionsManagement" class="fs-6 fw-bold">배출량 관리</a>
                <a href="<%=cp%>/setting" class="fs-6 fw-bold">설정</a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="d-flex justify-content-between">
            <div id="main">
                <button class="openbtn rounded" onclick="openNav()">&#9776;</button>
            </div>
            <div class="d-flex justify-content-between ms-5">
                <a href="<%=cp%>/monitoring" class="mb-2 mb-lg-0 text-white text-decoration-none fs-2 pe-5 fw-bold">
                    대기 TMS 관제 시스템
                </a>
            </div>
            <div class="text-end" style="display: inline-flex">
                <div class="dropdown">
                    <button class="dropbtn rounded fs-5 fw-bold" id="m_dropBtn"><i class="fas fa-caret-down"></i></button>
                    <div class="dropdown-content text-start">
                        <a href="<%=cp%>/myPage" class="fs-6 fw-bold">마이페이지</a>
                        <a href="<%=cp%>/logout" class="fs-6 fw-bold">로그아웃</a>
                    </div>
                </div>

                <div style="position: relative;">
                    <button class="alarmbtn" onclick="messageOpen()"><img class="alarm" src="static/images/bellOn.png"></button>
                    <div class="alarmCount"></div>
                </div>

                <div class="message text-start" style="padding: 10px;">
                    <div class="dangerOuter opacity"></div>
                    <div class="warningOuter opacity"></div>
                    <div class="cautionOuter opacity"></div>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
    let intervalAlarm=null;

    $(document).ready(function () {
        if (typeof getCookie('isAlarm') == 'undefined') {
            getAlarm();
            setCookie('isAlarm', 'true', 1);
        }

        if (getCookie('isAlarm') == 'true') {
            $('.alarm').attr('src', "static/images/bellOn.png");
            getAlarm();
            intervalAlarm = setInterval(function () {
                    getAlarm();
                }
                , 5000);

        }else{
            $('.alarm').attr('src', "static/images/bellOff.png");
            getAlarm();
            alarmEmpty();
            intervalAlarm = setInterval(function () {
                    getAlarm();
                    alarmEmpty();
                }
                , 5000);
        }
    });

    function alarmEmpty(){
        $('.dangerOuter').html('');
        $('.warningOuter').html('');
        $('.cautionOuter').html('');
        $('.message').css('display', 'none');
    }

    function getAlarm(){
        alarmEmpty();
        $('.alarmCount').css('display', 'none');
        $('.alarmCount').text('');

        //그룹 측정소에서 ON된 센서 추출
        $.ajax({
            url: '<%=cp%>/getAlarmData',
            dataType: 'json',
            async: false,
            success: function (data) {
                const arr = data.excess;
                let message;
                let count=0;
                if(arr != undefined){
                    for(let i=0; i<arr.length; i++){
                        if(arr[i].state == true){
                            const excess = arr[i].classification;
                            const place = arr[i].place;
                            const naming = arr[i].naming;
                            const value = arr[i].value;
                            let innerHTML ;

                            if(excess == "danger" ){
                                innerHTML =  '<span class="messageText danger" style="background-color:#dc3545;">'
                                innerHTML += '<span  id="dangerInner" style="margin-right: 10px;display: block">법적기준 초과</span>'+place +' - '+naming+' ('+value+')<br></span>';
                                $('.dangerOuter').append(innerHTML);
                                $('.danger').css('display', 'block');
                                $('.message').css('display', 'block');
                                count++;
                            }else if(excess == "warning"){
                                innerHTML =  '<span class="messageText warning" style="background-color:#ffc107;">'
                                innerHTML += '<span  id="warningInner" style="margin-right: 10px;display: block">사내기준 초과</span>'+place +' - '+naming+' ('+value+')<br></span>';
                                $('.warningOuter').append(innerHTML);
                                $('.warning').css('display', 'block');
                                $('.message').css('display', 'block');
                                count++;
                            }else if(excess == "caution"){
                                innerHTML =  '<span class="messageText caution" style="background-color:rgb(25, 135, 84);">'
                                innerHTML += '<span id="warningInner" style="margin-right: 10px;display: block">관리기준 초과</span>'+place +' - '+naming+' ('+value+')<br></span>';
                                $('.cautionOuter').append(innerHTML);
                                $('.caution').css('display', 'block');
                                $('.message').css('display', 'block');
                                count++;
                            }
                        }
                    }
               }
                if(count != 0){
                    $('.alarmCount').text(count);
                    $('.alarmCount').css('display', 'block');
                }
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }

    function openNav() {
        document.getElementById("mySidebar").style.left = "0px";
        $('#mySidebar').height( document.documentElement.clientHeight );
    }
    function closeNav() {
        document.getElementById("mySidebar").style.left = "-250px";
    }

    $( document ).ready(function() {
        var settings = {"url": "<%=cp%>/getUsername", "method": "POST",};
        $.ajax(settings).done(function (name) {
            $('#dropBtn').prepend(name+" 님");
            $('#m_dropBtn').prepend(name+" 님");
            getRank();
        });
    });

    function getRank() {
        var settings = {"url": "<%=cp%>/getRank", "method": "POST",};
        $.ajax(settings).done(function (rank) {
            if(!rank.dashboard)
                $('#dashboard').hide();
            if(!rank.alarm)
                $('#alarm').hide();
            if(!rank.monitoring)
                $('#monitoring').hide();
            if(!rank.statistics)
                $('#statistics').hide();
            if(!rank.setting)
                $('#setting').hide();
        });
    }

    /**
     * 쿠키 값 가져오는 메소드
     */
    function getCookie(cookie_name) {
        var x, y;
        var val = document.cookie.split(';');

        for (var i = 0; i < val.length; i++) {
            x = val[i].substr(0, val[i].indexOf('='));
            y = val[i].substr(val[i].indexOf('=') + 1);
            x = x.replace(/^\s+|\s+$/g, ''); // 앞과 뒤의 공백 제거하기
            if (x == cookie_name) {
                return unescape(y); // unescape로 디코딩 후 값 리턴
            }
        }
    }
    /**
     * 쿠키 값 저장하는 메소드 (이름, 값, 저장일수)
     */
    function setCookie(cookie_name, value, days) {
        var exdate = new Date();
        exdate.setDate(exdate.getDate() + days);
        // 설정 일수만큼 현재시간에 만료값으로 지정

        //var cookie_value = escape(value) + ((days == null) ? '' : '; expires=' + exdate.toUTCString());
        document.cookie = cookie_name + '=' + value;
    }

    function messageOpen() {
       if(getCookie('isAlarm') == 'true'){
           $('.alarm').attr('src', "static/images/bellOFF.png");
           setCookie('isAlarm', 'false', 1);
           clearInterval(intervalAlarm);
           $('.message').css('display', 'none');
       }else{
           $('.alarm').attr('src', "static/images/bellOn.png");
           getAlarm();
           setCookie('isAlarm', 'true', 1);
           intervalAlarm = setInterval(function (){
                   getAlarm();}
               , 5000);
       }
    }

    function messageOpen2() {
        $('.message').css('display', 'block');
    }

    var current_page_URL = location.href; //현재 URL 주소
    $("#menu a").each(function() { //menu a 태그의 주소
        if ($(this).attr("href") !== "#") { // 주소링크가 # 아닐때
            var target_URL = $(this).prop("href"); // 이벤트 발생 a태그의 모든 주소들
            if(current_page_URL.includes("?") == true){
                current_page_URL = current_page_URL.split("?")[0];
            }
            if (target_URL == current_page_URL ) { // 현재 URL 주소와 클릭된 주소가 같다면
                $(this).parent().find('.submenu').children('li').first().addClass('active'); //클래스 active 추가
                $(this).parentsUntil('#menu').addClass('active'); //클래스 active 추가
                return false; //종료
            }
        }
    });
</script>
