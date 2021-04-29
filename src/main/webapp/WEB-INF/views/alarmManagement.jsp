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
<script src="static/js/common/common.js"></script>
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
        display: none;
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
            <input type="text" id="start" name="start" class="timepicker">&nbsp;&nbsp;&nbsp;
            <input type="text" id="end" name="end"  class="timepicker">
            <button type="button" class="btn btn-primary ms-3" onClick="insert()">설정</button>
        </div>

    </div>

    <div class="row p-3 bg-light rounded" style="height: 70%">
        <div class="col-3 border-end" style="width: 25%; background: lightgray;">
            <div class="text-center" style="margin-top: 50px;">

                <c:forEach var="place" items="${place}" varStatus="status">
                    <div name="place" id="${place}" onclick="placeChange('${place}')">
                        <span id="place${status.index}">${place}</span>
                    </div>
                </c:forEach>

            </div>
        </div>
        <div class="col-3" style="width: 75%;">
            <span class="fw-bold">센서 목록</span>
            <input id="chk_all" class="form-check-input" name="selectall" type = checkbox style="width: 20px; height: 20px;" onclick="selectAll(this)">
            <span>전체선택</span>
            <input id="bOn" type="button" value="ON">
            <input id="bOff" type="button" value="OFF">
                <div class="text-center">
                    <div class="border p-2 bg-white h-75" id="items">
                        <%-- script --%>
                    </div>

                </div>
        </div>
    </div>
    <br>
    <h6>* 웹 페이지 또는 다운받은 앱에서 알림을 받을 측정항목을 선택해주세요. [측정소 관리]에서 설정된 항목의 기준 값 미달 혹은 초과하는 경우 알림이 발생합니다.</h6>
</div>

<script>

    $( document ).ready(function() {

        placeChange($("#place0").text());

    });
 //시작시간 설정
 $('#start').timepicker({
        timeFormat:'H:i',
        'interval' : 30,
        'minTime':'00:00',
        'maxTime':'23:30',
        'scrollbar': true,
        'dropdown':false
    }) //stime 시작 기본 설정
        .on('changeTime',function() {                           //stime 을 선택한 후 동작
            var from_time = $("input[name='start']").val(); //stime 값을 변수에 저장
            $('#end').timepicker('option','minTime', from_time);//etime의 mintime 지정
            if ($('#end').val() && $('#end').val() < from_time) {
                $('#end').timepicker('setTime', from_time);
//etime을 먼저 선택한 경우 그리고 etime시간이 stime시간보다 작은경우 etime시간 변경
            }
        });
 //종료시간 설정
  $('#end').timepicker({timeFormat:'H:i','interval' : 30,'minTime':'00:00','maxTime':'23:30','scrollbar': true});//etime 시간 기본 설정

 //체크박스 전체 선택, 해제
    function checkSelectAll()  {
        // 전체 체크박스
        const checkboxes
            = document.querySelectorAll('input[name="item"]');
        // 선택된 체크박스
        const checked
            = document.querySelectorAll('input[name="item"]:checked');
        // select all 체크박스
        const selectAll
            = document.querySelector('input[name="selectall"]');

        if(checkboxes.length === checked.length)  {
            selectAll.checked = true;
        }else {
            selectAll.checked = false;
        }

    }

    function selectAll(selectAll)  {
        const checkboxes
            = document.getElementsByName('item');

        checkboxes.forEach((checkbox) => {
            checkbox.checked = selectAll.checked
        })
    }

//측정소 변경
 function placeChange(name){
     const place = name;

     $("#items").empty();

     $.ajax({
         url: '<%=cp%>/getPlaceSensor',
         type: 'POST',
         dataType: 'json',
         async: false,
         cache: false,
         data: {"place":place},
         success : function(data) {
             for(let i=0;i<data.length;i++){
                 const tableName = data[i];
                 const category = findSensorCategory(tableName);
                 const checked = findSensorAlarm(tableName);

                 const innerHtml = "<div class='form-check mb-2'>" +
                     "<input class='form-check-input' type='checkbox' id='"+tableName+"a' name='item' value='"+tableName+"' onclick='checkSelectAll()'>" +
                     "<label class='form-check-label' for='"+tableName+"a'>"+category+"</label>" +
                     "<label class='switch'>"+
                     "<input id='"+tableName+"' type='checkbox' name='status' "+checked+">"+
                     "<div class='slider round'></div>"+
                     "</label>"+
                     "</div>"

                 const elem = document.createElement('div');
                 elem.innerHTML = innerHtml;
                 document.getElementById('items').append(elem);


                 //Off 버튼 클릭
                 $('#bOff').click(function () {
                     var num = $(".switch").size();
                     for (var i = 0; i <num; i++) {
                         if($('#'+data[i]+'a').is(":checked")){
                             $('#'+data[i]).prop("checked", false);
                         }
                     };
                 });
                 //On 버튼 클릭
                 $('#bOn').click(function () {
                     var num = $(".switch").size();
                     for (var i = 0; i <num; i++) {
                         if($('#'+data[i]+'a').is(":checked")){
                             $('#'+data[i]).prop("checked", true);
                         }
                     };
                 });
             }


         },
         error : function(request, status, error) { // 결과 에러 콜백함수
             console.log(error)
         }
     })
     //알림시간 입력
     $.ajax({
         url: '<%=cp%>/getPlaceSensor',
         type: 'POST',
         dataType: 'json',
         async: false,
         cache: false,
         data: {"place":place},
         success : function(data) {
             for (let i = 0; i <1; i++) {
                 const time = data[0];
                 const start =  findStartTime(time);
                 const end = findEndTime(time);
                 document.getElementById("start").value = start;
                 document.getElementById("end").value = end;

             }
         },
         error : function(request, status, error) { // 결과 에러 콜백함수
             console.log(error)
         }
     })

 }
    //sensor_alarm status 값 불러오기
    function findSensorAlarm(tableName) {

     let test;
        $.ajax({
            url: '<%=cp%>/getSensorAlarm',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"name":tableName},
            success : function(data) {
                if(data == true){
                    test = "checked";
                }else{
                    test = "";
                }

            },
            error : function(request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return test;
    }
    //알림 시작시간
 function findStartTime(time) {

    let test;
    $.ajax({
        url: '<%=cp%>/getStartTime',
        type: 'POST',
        dataType: 'text',
        async: false,
        cache: false,
        data: {"name":time},
        success : function(data) {
            test = data;

        },
        error : function(request, status, error) { // 결과 에러 콜백함수
            console.log(error)
        }
    })
    return test;
 }
    //알림 종료시간
    function findEndTime(time) {

        let test;
        $.ajax({
            url: '<%=cp%>/getEndTime',
            type: 'POST',
            dataType: 'text',
            async: false,
            cache: false,
            data: {"name":time},
            success : function(data) {
                test = data;
            },
            error : function(request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return test;
    }

//알림설정 값 저장
function insert() {
    var checkedItem = new Array();
    var uncheckItem = new Array();
    $("input:checkbox[name=status]:checked").each(function(){
        checkedItem.push($(this).attr('id'));
    });
    $("input:checkbox[name=status]:not(:checked)").each(function(){
        uncheckItem.push($(this).attr('id'));
    });

    const start = $("#start").val();
    const end = $("#end").val();

    for(let i=0; i<checkedItem.length; i++){
            let item = checkedItem[i];

            $.ajax({
                url: '<%=cp%>/saveAlarm',
                type: 'POST',
                dataType: 'json',
                async: false,
                cache: false,
                data: {"item":item,
                    "stime":start,
                    "etime":end,
                    "status":"true"
                },
                success : function(data) {
                    console.log(data);
                },
                error : function(request, status, error) {
                    console.log(error)
                }
            })
    }
    for(let i=0; i<uncheckItem.length; i++){
        let item = uncheckItem[i];

        $.ajax({
            url: '<%=cp%>/saveAlarm',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"item":item,
                "stime":start,
                "etime":end,
                "status":"false"
            },
            success : function(data) {
                console.log(data);
            },
            error : function(request, status, error) {
                console.log(error)
            }
        })
    }
    alert("설정 완료");
}

</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />