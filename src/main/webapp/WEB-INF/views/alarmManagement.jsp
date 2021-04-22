<%--
  Created by IntelliJ IDEA.
  User: hsheo
  Date: 2021-04-21
  Time: 오전 11:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-timepicker/1.10.0/jquery.timepicker.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-timepicker/1.10.0/jquery.timepicker.css" />

<style>
    /* The switch - the box around the slider */
    .switch {
        position: relative;
        display: inline-block;
        width: 60px;
        height: 34px;
    }

    /* Hide default HTML checkbox */
    .switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    /* The slider */
    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        -webkit-transition: .4s;
        transition: .4s;
    }

    .slider:before {
        position: absolute;
        content: "";
        height: 26px;
        width: 26px;
        left: 4px;
        bottom: 4px;
        background-color: white;
        -webkit-transition: .4s;
        transition: .4s;
    }

    input:checked + .slider {
        background-color: #2196F3;
    }

    input:focus + .slider {
        box-shadow: 0 0 1px #2196F3;
    }

    input:checked + .slider:before {
        -webkit-transform: translateX(26px);
        -ms-transform: translateX(26px);
        transform: translateX(26px);
    }

    /* Rounded sliders */
    .slider.round {
        border-radius: 34px;
    }

    .slider.round:before {
        border-radius: 50%;
    }
    .a1 {
        display: inline-flex;
        justify-content: flex-end;
    }

    .a2 {
        display: inline-flex;
        justify-content: flex-end;
    }
    .ui-timepicker-wrapper{
        width: 223px;
    }

</style>

<div class="container">

    <div class="row m-3">
        <div class="col fs-4 fw-bold">알림 설정</div>
        <div class="a2"><span style="margin-right: 12.8%;">Start Time</span>
            <span style="margin-right: 18%;">End Time</span></div>

        <div class="a1"><span style="font-weight: bold; margin-top: 7px; margin-right: 10px;  font-size: 18px;">알림 시간</span>
            <input type="text" id="stime" name="stime" class="timepicker" placeholder="00:00 AM">&nbsp;&nbsp;&nbsp;
            <input type="text" name="etime" id="etime" class="timepicker" placeholder="00:00 AM">
            <button type="button" class="btn btn-primary ms-3" onClick="insert()">설정</button>
        </div>

    </div>

    <div class="row p-3 bg-light rounded" style="height: 70%">
        <div class="col-3 border-end" style="width: 25%; background: lightgray;">
            <div class="text-center" style="margin-top: 50px;">
                <table style="width: 100%;">
                    <form>
                        <c:forEach var="station" items="${station}">
                        <tr style="border-bottom: 2px solid black;">
                            <td style="font-size: 35px; font-weight: bold; padding-bottom: 10px; padding-left: 50px;"><c:out value="${station.name}"/></td>
                        </tr>
                        </c:forEach>
                    </form>
                </table>
            </div>
        </div>
        <div class="col-3" style="width: 75%;">
            <span class="fw-bold">센서 목록</span>
            <input id="chk_all" class="form-check-input" type = checkbox style="width: 20px; height: 20px;">
            <span>전체선택</span>
            <input type="button" value="ON">
            <input type="button" value="OFF">
            <div class="text-center">
                <table style="width: 100%;">

                    <c:forEach items="${sensorInfo}" varStatus="status">
                        <c:set var="sIndex" value="${status.index}"/>

                        <c:if test = "${sensorInfo[sIndex].naming ne null}">
                            <tr style="border-bottom: 2px solid darkgray;">
                            <td style="width: 10px; padding: 0px"><input id="chk" class="form-check-input" type = checkbox style="width: 20px; height: 20px; margin: 0px 10px"></td>
                            <td style="font-size: 25px; font-weight: bold; padding-bottom: 10px; padding-top: 10px; padding-left: 10px;"><c:out value="${sensorInfo[sIndex].naming}"/></td>
                            <td>
                                <label class="switch">
                                    <input type="checkbox">
                                    <span class="slider round"></span>
                                </label>
                            </td>
                            </tr>
                        </c:if>

                    </c:forEach>


                </table>
            </div>
        </div>
    </div>
    <br>
    <h6>* 웹 페이지 또는 다운받은 앱에서 알림을 받을 측정항목을 선택해주세요. [측정소 관리]에서 설정된 항목의 기준 값 미달 혹은 초과하는 경우 알림이 발생합니다.</h6>
</div>
<script>
 //시작시간 설정
 $('#stime').timepicker({
        timeFormat:'h:i A',
        'interval' : 30,
        'minTime':'00:00am',
        'maxTime':'11:30pm',
        'scrollbar': true,
        'dropdown':false
    }) //stime 시작 기본 설정
        .on('changeTime',function() {                           //stime 을 선택한 후 동작
            var from_time = $("input[name='stime']").val(); //stime 값을 변수에 저장
            $('#etime').timepicker('option','minTime', from_time);//etime의 mintime 지정
            if ($('#etime').val() && $('#etime').val() < from_time) {
                $('#etime').timepicker('setTime', from_time);
//etime을 먼저 선택한 경우 그리고 etime시간이 stime시간보다 작은경우 etime시간 변경
            }
        });
 //종료시간 설정
  $('#etime').timepicker({timeFormat:'h:i A','interval' : '30','minTime':'00:00am','maxTime':'11:30pm','scrollbar': true});//etime 시간 기본 설정

 //체크박스 전체 선택, 해제
 $('#chk_all').click(function () {
     if($('#chk_all').is(":checked")){
         $(".form-check-input").prop("checked", true);
     }
     else{
         $(".form-check-input").prop("checked", false);
     }

 })
/*    $('#placeName').click(function(){
     //const placeName = $('#placeName').val();
     var placeName = $(this).text();
     // $(this).val();

     $.ajax({
         url: '<%=cp%>/getSensorInfo',
         type: 'POST',
         dataType: 'text',
         async: false,
         cache: false,
         data: {"name":placeName},
         success : function(data) { // 결과 성공 콜백함수
             console.log(data);
         },
         error : function(request, status, error) { // 결과 에러 콜백함수
             console.log(error)
         }
     })

 });*/
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />