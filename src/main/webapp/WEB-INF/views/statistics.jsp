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
    h1 {
        text-align: left;
    }


</style>


<div class="container">

    <div class="row d-flex justify-content-center">

        <div class="col-xs-12 d-flex justify-content-center">

            <select name="dropdown1" class="btn-primary rounded-3 p-2 m-2">
                <option value="1">측정소1</option>
                <option value="2">측정소2</option>
                <option value="3">측정소3</option>
            </select>

            <select name="dropdown2" class="btn-primary rounded-3 p-2 m-2">
                <option value="dust">먼지</option>
                <option value="bad">나쁜거</option>
                <option value="rad">방사능</option>
            </select>

        </div>

    </div>


    <div class="row" >

        <div class="col-md-6 bg-light rounded">
            <h1>최근 24시간 자료</h1>
            <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
        </div>

        <div class="col-md-6 bg-light rounded">
            <h1>최근 24시간 상세정보</h1>
            <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
            <h4 class="text-end">①②③④⑤</h4>
        </div>

    </div>


    <div class="row mt-1">

        <div class="col-md-6 bg-light rounded">
            <h1>연도별 통계</h1>
            <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
        </div>

        <div class="col-md-6 bg-light rounded">
            <h1>연도별 통계</h1>
            <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
            <h4 class="text-end">①②③④⑤</h4>
        </div>

    </div>


</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



