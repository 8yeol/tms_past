<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 5:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    body{
        background-color:#EDF2F8;
    }
</style>

<header class="p-3 bg-primary text-white">
    <div class="container">
        <div class="d-flex align-items-center">
            <a href="#" class="mb-2 mb-lg-0 text-white text-decoration-none fs-3">
                대기 TMS 관제 시스템
            </a>

            <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 mb-md-0">
                <li><a href="/" class="nav-link px-2 text-white">대시보드</a></li>
                <li><a href="#" class="nav-link px-2 text-white">모니터링</a></li>
                <li><a href="#" class="nav-link px-2 text-white">분석 및 통계</a></li>
                <li><a href="#" class="nav-link px-2 text-white">알림</a></li>
                <li><a href="/stationManagement" class="nav-link px-2 text-white">환경설정</a></li>
            </ul>

            <div class="text-end">
                <div class="dropdown">
                    <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
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
</header>