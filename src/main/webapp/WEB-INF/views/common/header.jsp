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

    <script src="static/js/jquery-3.6.0.min.js"></script>
    <script src="static/js/bootstrap.min.js"></script>
</head>
<style>
</style>
<body>

<script>
    /*
    $(document).ready(function () {
        // 브라우저 지원 여부 체크
        if(!isMobile()){
            if (!("Notification" in window)) {
                alert("데스크톱 알림을 지원하지 않는 브라우저입니다.");
            } else{
                getNotificationPermission();

                setInterval(function () {
                    getNotificationPermission();
                }, 5000)
            }
        }
    });

    function isMobile(){
        const UserAgent = navigator.userAgent;

        if (UserAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null
            || UserAgent.match(/LG|SAMSUNG|Samsung/) != null) {
            return true;
        } else{
            return false;
        }
    }

    function getNotificationPermission() {
        // 데스크탑 알림 권한 요청
        Notification.requestPermission(function (result) {
            // 권한 거절
            if(result == 'denied') {
                alert('알림을 차단하셨습니다.\n브라우저의 사이트 설정에서 변경하실 수 있습니다.');
                return false;
            }
        });

        $.ajax({
            url: '<%=cp%>/getExcessSensor',
            dataType: 'json',
            async: false,
            success: function (data) {
                const arr = data.excess;

                if(arr != undefined){
                    for(let i=0; i<arr.length; i++){
                        const excess = arr[i].classification;
                        const place = arr[i].place;
                        const naming = arr[i].naming;
                        const value = arr[i].value;

                        if(excess == "danger" ){
                            notify(place +" - " + naming, "법적 기준 초과 ( " + value + " )");
                        }else if(excess == "warning"){
                            notify(place +" - " + naming, "사내 기준 초과 ( " + value + " )");
                        }else if(excess == "caution"){
                            notify(place +" - " + naming, "관리 기준 초과 ( " + value + " )");
                        }
                    }
                }

            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }

    // 알림 띄우기
    function notify(title, txt) {
        // 데스크탑 알림 요청
        const notification = new Notification( title, {
            icon: 'static/images/favicon.ico',
            body: txt,
        });

        notification.onclick = function () {
            window.open('http://localhost:8080/lghausys/dashboard');
        };

        // 3초뒤 알람 닫기
        setTimeout(function(){
            notification.close();
        }, 3000);
    }
    */
</script>
<jsp:include page="/WEB-INF/views/common/nav.jsp" />

