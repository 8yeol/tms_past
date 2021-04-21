<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-20
  Time: 오전 11:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<link rel="stylesheet" href="static/css/datepicker.min.css">
<script src="static/js/datepicker.min.js"></script>
<script src="static/js/datepicker.ko.js"></script>

<div class="container">
    <div class="row m-3 mt-4">
        <div class="col-3">
            <span class="fs-5 fw-bold">측정소</span>
            <div class="btn-group w-50 ms-3">
                <button class="btn btn-light dropdown-toggle" type="button" data-bs-toggle="dropdown" id="placeName">
                    선택
                </button>

                <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton" id="place">
                    <c:forEach var="place" items="${place}" varStatus="status">
                        <li class="dropdown-item" value="${place}">${place}</li>
                    </c:forEach>
                </ul>
            </div>

        </div>
        <div class="col">
            <span class="fs-5 fw-bold p-3">측정기간</span>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="day" id="week" checked>
                <label class="form-check-label" for="week">
                    일주일
                </label>
            </div>

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="day" id="month">
                <label class="form-check-label" for="month">
                    한 달
                </label>
            </div>

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="day" id="custom">
                <label class="form-check-label" for="custom">
                    사용자 정의
                </label>
            </div>

            <input type="text" id="date_start" class="text-center p-1" disabled>
            <label class="ms-3 me-3">-</label>
            <input type="text" id="date_end" class="text-center p-1" disabled>

            <button type="button" class="btn btn-primary ms-3" onClick="search()">검색</button>
        </div>
    </div>

    <div class="row">
        <div class="col">

            <div class="row">
                <div class="col">
                    <div class="float-end">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" value="" id="off">
                            <label class="form-check-label fw-bold small" for="off">
                                Off 데이터 표시
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row bg-white">
                <div id="chart-line2"> chart</div>
            </div>

        </div>
        <div class="col-lg-2">
            <div class="mt-4 p-2 bg-white text-center">차트 항목 선택</div>

            <div class="border p-2 bg-white">

                <div class="form-check mb-2">
                    <%--value 에 컬렉션 값 매핑 시켜줄 것--%>
                    <input class="form-check-input" type="radio" name="item" id="flexCheckDefault" value="먼지" checked>
                    <label class="form-check-label" for="flexCheckDefault">
                        먼지
                    </label>
                </div>
                <div class="form-check mb-2">
                    <input class="form-check-input" type="radio" name="item"  value="황산화물" id="flexCheckChecked">
                    <label class="form-check-label" for="flexCheckChecked">
                        황산화물
                    </label>
                </div>

            </div>

        </div>
    </div>
</div>

<script charset="UTF-8">

    $( document ).ready(function() {
        $("#date_start").val(getWeekAgo());
        $("#date_end").val(getToday());
    });

    $("#date_start").datepicker({
        language:'ko',
        maxDate:new Date()
        //timepicker: true,
        //timeFormat: "hh:ii AA"
    });
    $("#date_end").datepicker({
        language:'ko',
        maxDate:new Date()
        //timepicker: true,
        //timeFormat: "hh:ii AA"
    });

    datePickerSet($("#date_start"), $("#date_end"), true); //다중은 시작하는 달력 먼저, 끝달력 2번째

    function datePickerSet(sDate, eDate, flag) {

        //시작 ~ 종료 2개 짜리 달력 datepicker
        if (!isValidStr(sDate) && !isValidStr(eDate) && sDate.length > 0 && eDate.length > 0) {
            var sDay = sDate.val();
            var eDay = eDate.val();

            if (flag && !isValidStr(sDay) && !isValidStr(eDay)) { //처음 입력 날짜 설정, update...
                var sdp = sDate.datepicker().data("datepicker");
                sdp.selectDate(new Date(sDay.replace(/-/g, "/")));  //익스에서는 그냥 new Date하면 -을 인식못함 replace필요

                var edp = eDate.datepicker().data("datepicker");
                edp.selectDate(new Date(eDay.replace(/-/g, "/")));  //익스에서는 그냥 new Date하면 -을 인식못함 replace필요
            }

            //시작일자 세팅하기 날짜가 없는경우엔 제한을 걸지 않음
            if (!isValidStr(eDay)) {
                sDate.datepicker({
                    maxDate: new Date(eDay.replace(/-/g, "/"))
                });
            }

            sDate.datepicker({
                language: 'ko',
                autoClose: true,
                onSelect: function () {
                    datePickerSet(sDate, eDate);
                }
            });

            //종료일자 세팅하기 날짜가 없는경우엔 제한을 걸지 않음
            if (!isValidStr(sDay)) {
                eDate.datepicker({
                    minDate: new Date(sDay.replace(/-/g, "/"))
                });
            }
            eDate.datepicker({
                language: 'ko',
                autoClose: true,
                onSelect: function () {
                    datePickerSet(sDate, eDate);
                }
            });

            //한개짜리 달력 datepicker
        } else if (!isValidStr(sDate)) {
            var sDay = sDate.val();
            if (flag && !isValidStr(sDay)) { //처음 입력 날짜 설정, update...
                var sdp = sDate.datepicker().data("datepicker");
                sdp.selectDate(new Date(sDay.replace(/-/g, "/"))); //익스에서는 그냥 new Date하면 -을 인식못함 replace필요
            }


            sDate.datepicker({
                language: 'ko',
                autoClose: true
            });
        }


        function isValidStr(str) {
            if (str == null || str == undefined || str == "")
                return true;
            else
                return false;
        }
    }

    $("input:radio[name=day]").click(function() {

        $("#date_start").val("");
        $("#date_end").val("");

        const id = $(this).attr('id');

        if(id == 'custom'){
            $("#date_start").attr('disabled',false);
            $("#date_end").attr('disabled',false);
        } else {
            $("#date_start").attr('disabled',true);
            $("#date_end").attr('disabled',true);

            $("#date_end").val(getToday());

            if(id == 'week'){
                $("#date_start").val(getWeekAgo());
            } else if(id == 'month'){
                $("#date_start").val(getMonthAgo());
            }

        }
    });

    $('#placeName').click(function(){
        const placeName = 'point1';
        // $(this).val();

        $.ajax({
            url: '<%=cp%>/getPalceSensor',
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

    });

    function search(){
        const date_start =  $('#date_start').val();
        const date_end = $('#date_end').val();
        const item = 'tmsWP001_dust_01'; // $('input:radio[name="item"]:checked').val();
        const off = $('#off').is(":checked"); // false : 선택안됨(표시X) , true : 선택(표시)

        $.ajax({
            url: '<%=cp%>/scarchChart',
            type: 'POST',
            dataType: 'text',
            async: false,
            cache: false,
            data: {"date_start":date_start,
                "date_end":date_end,
                "item":item,
                "off":off,
            },
            success : function(data) { // 결과 성공 콜백함수
                console.log(data);
            },
            error : function(request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })

    }

    function getToday(){
        const date = new Date();
        const year = date.getFullYear();
        const month = ("0" + (1 + date.getMonth())).slice(-2);
        const day = ("0" + date.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }

    function getMonthAgo(){
        const date = new Date();

        const oneMonthAgo = new Date(date.setMonth(date.getMonth()-1));

        const year = oneMonthAgo.getFullYear();
        const month = ("0" + (1 + oneMonthAgo.getMonth())).slice(-2);
        const day = ("0" + oneMonthAgo.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }

    function getWeekAgo(){
        const date = new Date();

        const oneMonthAgo = new Date(date.setDate(date.getDate()-7));

        const year = oneMonthAgo.getFullYear();
        const month = ("0" + (1 + oneMonthAgo.getMonth())).slice(-2);
        const day = ("0" + oneMonthAgo.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />