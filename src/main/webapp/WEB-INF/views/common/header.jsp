<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 5:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<html>
<head>
    <title>TMS</title>
    <link rel="shortcut icon" href="#">
    <link rel="stylesheet" href="static/css/bootstrap.min.css">
    <link rel="stylesheet" href="static/css/common.css">
    <link rel="shortcut icon" href="static/images/favicon.ico" type="image/x-icon">

    <script src="static/js/lib/jquery-3.6.0.min.js"></script>
    <script src="static/js/lib/bootstrap.min.js"></script>
</head>
<style>
</style>
<body>

<jsp:include page="/WEB-INF/views/common/nav.jsp" />

