<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-20
  Time: 오후 4:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String Date = new java.text.SimpleDateFormat("yyyy년 MM월 dd일 hh:mm:ss").format(new java.util.Date());
%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>


<style>
    div{
        padding: 1px;
    }
    h1{
        text-align: center;
    }
</style>

<div class="container">
    <div class="row">
        <div class="col-xs-12 d-flex justify-content-between bg-light rounded mt-3">
            <div class="flex-fill d-flex justify-content-around">
                <h3> <i class="fas fa-square text-dark"></i> 장비정상</h3>
                <h3> <i class="fas fa-square text-secondary"></i> 교정중</h3>
                <h3> <i class="fas fa-square text-warning"></i> 경고</h3>
                <h3> <i class="fas fa-square text-danger"></i> 위험</h3>
                <h3> <i class="fas fa-square text-success"></i> 장비이상</h3>
            </div>
            <div>
                <h4>현재시간 : <%=Date%></h4>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 p-3">
            <div class="row bg-light rounded">
                <div class="col-xs-12">
                    <h1 class="bg-secondary rounded mt-1">측정소1</h1>
                </div>
                <div class="col-md-6">
                    리스트 들어올곳1
                    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                    리스트 들어올곳1
                </div>
                <div class="col-md-6">
                    리스트 들어올곳2
                    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                    리스트 들어올곳2
                </div>
            </div>
        </div>
        <div class="col-md-4 p-3">
            <div class="row bg-light rounded">
                <div class="col-xs-12">
                    <h1 class="bg-secondary rounded mt-1">측정소2</h1>
                </div>
                <div class="col-md-6">
                    리스트 들어올곳1
                    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                    리스트 들어올곳1
                </div>
                <div class="col-md-6">
                    리스트 들어올곳2
                    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                    리스트 들어올곳2
                </div>
            </div>
        </div>
        <div class="col-md-4 p-3">
            <div class="row bg-light rounded">
                <div class="col-xs-12">
                    <h1 class="bg-secondary rounded mt-1">측정소3</h1>
                </div>
                <div class="col-md-6">
                    리스트 들어올곳1
                    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                    리스트 들어올곳1
                </div>
                <div class="col-md-6">
                    리스트 들어올곳2
                    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                    리스트 들어올곳2
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



