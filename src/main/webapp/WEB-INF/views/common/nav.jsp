<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 5:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap');

    body {
        background-color: #EDF2F8;
        font-family: 'Noto Sans KR', sans-serif;
    }

    #topMenu {
        height: 30px;
    }

    #topMenu ul { /* 메인 메뉴 안의 ul을 설정함: 상위메뉴의 ul+하위 메뉴의 ul */
        list-style-type: none;
        margin: 0px;
        padding: 0px;
    }

    #topMenu ul li { /* 메인 메뉴 안에 ul 태그 안에 있는 li 태그의 스타일 적용(상위/하위메뉴 모두) */
        color: white;
        float: left;
        line-height: 30px;
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
        position: absolute;
        top: 50px;
        height: 0px;
        overflow: hidden;
        transition: height .3s;
        -webkit-transition: height .3s;
        -moz-transition: height .3s;
        -o-transition: height .3s;
        width: 5000px; /* [변경] 가로 드랍다운 메뉴의 넓이 */
    }
    .shortSubmenu{
        position: absolute;
        top: 50px;
        height: 0px;
        overflow: hidden;
        transition: height .3s;
        -webkit-transition: height .3s;
        -moz-transition: height .3s;
        -o-transition: height .3s;
        width: 5000px; /* [변경] 가로 드랍다운 메뉴의 넓이 */
    }

    .longSubmenu{
        position: absolute;
        top: 50px;
        height: 0px;
        overflow: hidden;
        transition: height .3s;
        -webkit-transition: height .3s;
        -moz-transition: height .3s;
        -o-transition: height .3s;
        width: 5000px; /* [변경] 가로 드랍다운 메뉴의 넓이 */
    }

    .submenu li .customSubmenu li{
        display: inline-block; /* [변경] 가로로 펼쳐지도록 설정 */
    }

    .topMenuLi:hover .submenu { /* 상위 메뉴에 마우스 모버한 경우 그 안의 하위 메뉴 스타일 설정 */
        height: 50px; /* [변경] 높이를 32px로 설정 */
        width: 450px;
        background: #75ACFF;
        border-radius: 5px;
        z-index: 500;
    }

    .topMenuLi:hover .shortSubmenu { /* 상위 메뉴에 마우스 모버한 경우 그 안의 하위 메뉴 스타일 설정 */
        height: 50px; /* [변경] 높이를 32px로 설정 */
        width: 300px;
        background: #75ACFF;
        border-radius: 5px;
        z-index: 500;
    }

    .topMenuLi:hover .longSubmenu { /* 상위 메뉴에 마우스 모버한 경우 그 안의 하위 메뉴 스타일 설정 */
        height: 50px; /* [변경] 높이를 32px로 설정 */
        width: 750px;
        background: #75ACFF;
        border-radius: 5px;
        z-index: 500;
    }


    .submenuLink:hover { /* 하위 메뉴의 a 태그의 마우스 오버 스타일 설정 */
        color: #F7C259;
        font-weight: bold;
    }


</style>

<header class="p-4 bg-primary text-white">
    <div class="container">
        <div class="d-flex justify-content-between">
            <div class="d-flex justify-content-around">
                <a href="/" class="mb-2 mb-lg-0 text-white text-decoration-none fs-3 pe-5 fw-bold">
                    대기 TMS 관제 시스템
                </a>

                <nav id="topMenu">
                    <ul>
                        <li class="topMenuLi"><a class="menuLink" href="/">대시보드</a>
                        </li>
                        <li class="topMenuLi"><a class="menuLink shortLink" href="/alarm">알림</a>

                        </li>
                        <li class="topMenuLi"><a class="menuLink" href="/monitoring">모니터링</a>
                            <ul class="shortSubmenu">
                                <li><a href="/monitoring" class="submenuLink">실시간 모니터링</a></li>
                                <li><a href="/sensor" class="submenuLink">상세화면</a></li>
                            </ul>
                        </li>
                        <li class="topMenuLi"><a class="menuLink" href="">분석 및 통계</a>
                            <ul class="submenu">
                                <li><a href="/dataInquiry" class="submenuLink ">측정자료 조회</a></li>
                                <li><a href="/dataStatistics" class="submenuLink ">통계자료 조회</a></li>
                            </ul>
                        </li>
                        <li class="topMenuLi"><a class="menuLink" href="">환경설정</a>
                            <ul class="longSubmenu">
                                <li><a href="/stationManagement" class="submenuLink ">측정소 관리</a></li>
                                <li><a href="/sensorManagement" class="submenuLink ">센서 관리</a></li>
                                <li><a href="/alarmSetting" class="submenuLink ">알림 설정ver2</a></li>
                                <li><a href="/alarmManagement" class="submenuLink " id="alarmManagement">알림 설정ver3</a></li>
                                <li><a href="/setting" class="submenuLink ">설정</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav>

            </div>

            <div class="text-end">
                <div class="dropdown">
                    <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton"
                            data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        관리자 님
                    </button>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                        <a class="dropdown-item" href="#">마이페이지</a>
                        <a class="dropdown-item" href="#">로그아웃</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

<%--    <form id="actionForm"  action="" method="get">

    </form>--%>
</header>


<script>
/*    var actionForm = $("#actionForm");
    $("#sensor").click(function (e) {
        var place = "point1";
        e.preventDefault();
        actionForm.append("<input type='text' name='place' value='"+ place +"'>");
        actionForm.attr("action", "/sensor");
        actionForm.submit();
    })*/

</script>