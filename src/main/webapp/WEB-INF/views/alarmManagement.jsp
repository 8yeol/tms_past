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
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<script src="static/js/sweetalert2.min.js"></script>


<div class="container">

    <div class="col" style="font-weight: bolder;margin: 30px 0px; font-size: 27px">
        환경설정 > 알림설정
    </div>
    <div class="row bg-light rounded" ><span style=";font-size: 23px; font-weight: bolder;padding: 20px 20px 20px 40px;">알림설정</span></div>
  <c:forEach var="place" items="${place}" varStatus="status"> <!--JSTL 반복문 시작 -->
    <div class="row bg-light rounded" id="placeDiv${status.index}" style="border-bottom:2px solid silver;padding:16px 16px 40px 16px;">



        <div class="col-3" style="width: 45%;">
            <span style="font-size: 18px; margin-left: 130px;"class="placeName" id="place${status.index}">${place}</span>
                <div id="items${status.index}">
                        <%-- script --%>
                </div>
        </div>
        <div class="col-3" style="width: 30%"><div class="a1" id="alarm${status.index}"></div></div>
        <div class="col-3 end" style="width: 25%;">
            <button type="button" class="btn btn-primary" onClick="insert(${status.index})">저장</button>
            <button type="button" class="cancleBtn" onClick="cancle(${status.index})">취소</button>

        </div>


    </div>
    </c:forEach> <!--JSTL 반복문 종료 -->
    <h6>* 알림을 받을 측정항목을 선택해 주세요. [환경설정 > 측정소 관리]에서 설정된 항목의 기준 값 미달 혹은 초과하는 경우 알림이 발생합니다.</h6>
</div>
<script>

    $(document).ready(function() {

        let placeLength = ${place.size()};

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
     innerHTMLTimePicker += '<div><span class="textSpanParent">알림 시간</span></div>';
     innerHTMLTimePicker += '<div><span class="textSpan">From </span><input type="text" id="start'+idx+'" name="start" class="timePicker" readonly/></div>';
     innerHTMLTimePicker += '<div><span class="textSpan">To </span><input type="text" id="end'+idx+'" name="end" class="timePicker" readonly/></div>';


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


                 const innerHtml =
                     "<label style='font-size: 18px;' class='form-check-label' for='"+tableName+"'>"+category+"</label>" +
                     "<label class='switch'>"+
                     "<input id='"+tableName+"' name='status"+idx+"' type='checkbox'  "+checked+">"+
                     "<div class='slider round'></div>"+
                     "</label>"


                 const elem = document.createElement('div');
                 elem.setAttribute('class','label-form')
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
    if(start =="" || end ==""){
        Swal.fire({
            icon: 'warning',
            title: '경고',
            text: '알림시간을 입력해주세요.'

        })
        return false;

    }

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
    Swal.fire({
        icon: 'success',
        title: '저장완료'
    })

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