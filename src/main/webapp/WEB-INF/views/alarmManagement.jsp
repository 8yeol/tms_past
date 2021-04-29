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
<link rel="stylesheet" type="text/css" href="static/css/chung-timepicker.css">
<link rel="stylesheet" type="text/css" href="static/css/alarmManagement.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/chung-timepicker.js"></script>


<div class="container">

    <div class="row m-3">
        <div class="col fs-4 fw-bold">알림 설정</div>
    </div>

  <c:forEach var="place" items="${place}" varStatus="status"> <!--JSTL 반복문 시작 -->
    <div class="row p-3 bg-light rounded" id="placeDiv${status.index}" style="margin-top: 30px;border:3px solid silver;">

        <div name="place" id="${place}">
            <span class="placeName" id="place${status.index}">${place}</span>

            <div class="a1" id="alarm${status.index}">
            </div>
        </div>

        <div class="col-3" style="width: 75%;height:100%;">
             <form id="alarmform" action="" method="post">
                <div class="text-center" style="height: 99%;margin-top: 15px;" id="items${status.index}">
                        <%-- script --%>
                </div>
            </form>
        </div>
        <div class="buttonDiv">
            <button type="button" class="cancleBtn" onClick="cancle(${status.index})">취소</button>
            <button type="button" class="btn btn-primary ms-3" onClick="insert(${status.index})">설정</button>
        </div>
    </div>
    </c:forEach> <!--JSTL 반복문 종료 -->
    <br>
    <h6>* 웹 페이지 또는 다운받은 앱에서 알림을 받을 측정항목을 선택해주세요. [측정소 관리]에서 설정된 항목의 기준 값 미달 혹은 초과하는 경우 알림이 발생합니다.</h6>
</div>
<script>

    $( document ).ready(function() {

        const placeLength = ${place.size()};

        //저장소 DIV 반복 생성
        for(i =0 ; i<placeLength;i++) {
            placeMake($("#place"+i).text(), i);
        }

        //각각 타임피커 셋팅
        for(i =0 ; i<placeLength;i++) {
            $('#start' + i).chungTimePicker({ viewType: 1 });
            $('#end' + i).chungTimePicker({ viewType: 1 });
        }

    });

//측정소 생성
 function placeMake(name,idx){

     const place = name;
     const parentElem = $('#items'+idx);

     let innerHTMLTimePicker = "";
     innerHTMLTimePicker += '<span class="textSpanParent">알림 시간</span>';
     innerHTMLTimePicker += '<span class="textSpan">From </span><input type="text" id="start'+idx+'" name="start" class="timePicker" readonly/>';
     innerHTMLTimePicker += '<span class="textSpan">End </span><input type="text" id="end'+idx+'" name="end" class="timePicker" readonly/>';


     $('#alarm'+idx).append(innerHTMLTimePicker);

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
                 const checked = findNotification(tableName);


                 const innerHtml = "<div class='form-check mb-2'>" +
                     "<label class='form-check-label' for='"+tableName+"'>"+category+"</label>" +
                     "<label class='switch'>"+
                     "<input id='"+tableName+"' name='status"+idx+"' type='checkbox'  "+checked+">"+
                     "<div class='slider round'></div>"+
                     "</label>"+
                     "</div>"

                 const elem = document.createElement('div');
                 elem.setAttribute('class','form-check-div')
                 elem.innerHTML = innerHtml;
                 parentElem.append(elem);

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
                 $("#start"+idx).val(start);
                 $("#end"+idx).val(end);

             }
         },
         error : function(request, status, error) { // 결과 에러 콜백함수
             console.log(error)
         }
     })

 }
    //Notification_settings status 값 불러오기
    function findNotification(tableName) {

     let isChecked;
        $.ajax({
            url: '<%=cp%>/getNotification',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"name":tableName},
            success : function(data) {
                if(data == true){
                    isChecked = "checked";
                }else{
                    isChecked = "";
                }

            },
            error : function(request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return isChecked;
    }
    //알림 시작시간
 function findStartTime(time) {

    let sTime;
    $.ajax({
        url: '<%=cp%>/getStartTime',
        type: 'POST',
        dataType: 'text',
        async: false,
        cache: false,
        data: {"name":time},
        success : function(data) {
            sTime = data;
        },
        error : function(request, status, error) { // 결과 에러 콜백함수
            console.log(error)
        }
    })
    return sTime;
 }
    //알림 종료시간
    function findEndTime(time) {

        let eTime;

        $.ajax({
            url: '<%=cp%>/getEndTime',
            type: 'POST',
            dataType: 'text',
            async: false,
            cache: false,
            data: {"name":time},
            success : function(data) {
                eTime = data;
            },
            error : function(request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return eTime;
    }

//알림설정 값 저장
function insert(idx) {
    var checkedItem = new Array();
    var uncheckItem = new Array();
    $("input:checkbox[name=status"+idx+"]:checked").each(function(){
        checkedItem.push($(this).attr('id'));
    });
    $("input:checkbox[name=status"+idx+"]:not(:checked)").each(function(){
        uncheckItem.push($(this).attr('id'));
    });

    const start = $("#start"+idx).val();
    const end = $("#end"+idx).val();

    for(let i=0; i<checkedItem.length; i++){
            let item = checkedItem[i];

            $.ajax({
                url: '<%=cp%>/saveNotification',
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
            url: '<%=cp%>/saveNotification',
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
    //시작 시간이 종료시간보다 클때 endTime 변경
    //TimePicker 객체에서 아이디->인덱스 추출
    function changeEndTime(obj){
        let objId = obj.ele[0].id;               //console.log(objId) -> start0
        let idx = objId.replace(/[^0-9]/g,''); //console.log(idx) -> 0

        let stime = $('#start'+idx).val();
        let etime = $('#end'+idx).val();

        if(stime>etime){
            $('#end'+idx).val(stime);
        }
    }

    //임시로 설정한값 삭제후 다시 생성
    function cancle(idx){
        $('#alarm'+idx).empty();
        $('#items'+idx).empty();

        placeMake($("#place"+idx).text(), idx);
        $('#start' + idx).chungTimePicker({ viewType: 1 });
        $('#end' + idx).chungTimePicker({ viewType: 1 });
    }
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />