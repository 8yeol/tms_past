<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-20
  Time: 오후 5:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<style>
    div {
        padding: 1px;
    }

    h1 {
        text-align: left;
    }

    .col-md-6 {
        text-align: center;
    }
</style>


<div class="container bg-white border border-dark">

    <div class="row d-flex justify-content-around border border-dark">

        <div class="col-xs-12 d-flex justify-content-center">
            <div class="dropdown pe-5">
                <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton1"
                        data-bs-toggle="dropdown" aria-expanded="false">
                    측정소1
                </button>
                <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                    <li><a class="dropdown-item" href="#">Action</a></li>
                    <li><a class="dropdown-item" href="#">Another action</a></li>
                    <li><a class="dropdown-item" href="#">Something else here</a></li>
                </ul>
            </div>

            <div class="dropdown">
                <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton2"
                        data-bs-toggle="dropdown" aria-expanded="false">
                    먼지
                </button>
                <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                    <li><a class="dropdown-item" href="#">Action</a></li>
                    <li><a class="dropdown-item" href="#">Another action</a></li>
                    <li><a class="dropdown-item" href="#">Something else here</a></li>
                </ul>
            </div>
        </div>

    </div>


    <div class="row" >

        <div class="col-md-6 border border-dark">
            <h1>최근 24시간 자료</h1>
            <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
        </div>

        <div class="col-md-6 border border-dark">
            <h1>최근 24시간 상세정보</h1>
            <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
            <h4 class="text-end">페이징처리</h4>
        </div>

    </div>


    <div class="row">

        <div class="col-md-6 border border-dark">
            <h1>연도별 통계</h1>
            <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
        </div>

        <div class="col-md-6 border border-dark">
            <h1>연도별 통계</h1>
            <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
            <h4 class="text-end">페이징처리</h4>
        </div>

    </div>


</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



