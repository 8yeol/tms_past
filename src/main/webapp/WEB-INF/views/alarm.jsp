<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 10:40
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

    <div class="row m-1">
        <div class="col-md-6 bg-light rounded">
            <div class="d-flex justify-content-between">
                <h3>Sensor</h3>
                <h3>업데이트 : 1234-12-12</h3>
            </div>
            <div>
                <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
            </div>
        </div>
        <div class="col-md-6 bg-light rounded">
            <div class="d-flex justify-content-between">
                <h3>센서 알림 현황</h3>
                <div class="radio">
                    <input type="radio" name="group1" class="me-1"> 연도별
                    <input type="radio" name="group1" class="me-1"> 월 별
                    <input type="radio" name="group1" class="me-1"> 일 별
                </div>
            </div>
            <div>
                <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
            </div>
        </div>
    </div>

    <div class="row m-1">

        <div class="col-md-6 bg-light rounded">
            <div class="d-flex justify-content-between">
                <h3>Event</h3>
                <h3>업데이트 : 1234-12-12</h3>
            </div>
            <div>
                <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
            </div>
        </div>

        <div class="col-md-6 bg-light rounded">
            <div class="d-flex justify-content-between">
                <h3>이벤트 현황</h3>
                <div class="radio">
                    <input type="radio" name="group2" class="me-1"> 연도별
                    <input type="radio" name="group2" class="me-1"> 월 별
                    <input type="radio" name="group2" class="me-1"> 일 별
                </div>
            </div>
            <div>
                <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
            </div>
        </div>

    </div>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



