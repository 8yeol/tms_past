<%--
  Created by IntelliJ IDEA.
  User: hsheo
  Date: 2021-04-19
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

</style>
<div class="container">
    <div class="row m-3">
        <div class="col fs-4 fw-bold">측정소 등록 및 측정소별 항목 등록</div>
    </div>

    <div class="row p-3" style="height: 70%; background: lightgray">
        <div class="col-3 border-end" style="width: 35%;">
            <div>
            <span class="fw-bold">측정소 관리</span>
            <input type="button" value="추가">
            <input type="button" value="삭제">
            </div>
            <div class="text-center">
                <table  width="100%">
                        <tr style = "border-bottom: black solid 2px;">
                            <th><input name="placeall" class="form-check-input" type = checkbox onclick="placeAll(this)"></th>
                            <th>측정소 명</th>
                            <th>업데이트</th>
                            <th>모니터링 사용</th>
                        </tr>

                        <c:forEach var="place" items="${place}" varStatus="status">
                         <tr onclick="placeChange('${place.name}')">
                            <td><input class="form-check-input" name="place" type = checkbox onclick="checkPlaceAll()"></td>
                            <td id="${place.name}" >
                                <span id="place${status.index}"><c:out value="${place.name}"/></span>
                            </td>
                            <td><c:out value="${place.up_time}"/></td>
                            <td><c:out value="${place.power}"/></td>
                         </tr>
                        </c:forEach>
                </table>
            </div>
        </div>
        <div class="col-3" style="width: 65%; border: dodgerblue solid 1px; background: white">

            <div>
            <c:forEach var="place" items="${place}" varStatus="status">
            <span class="fw-bold">${place.name} 상세설정</span>
            <span class="fw-bold">측정소 모니터링</span>

            <label class="switch">
                <input id="monitor" value="${place.power}" type="checkbox">
                <span class="slider round"></span>
            </label>
            </c:forEach>
            <br>
            <input type="button" value="추가">
            <input type="button" value="삭제">
            </div>
            <table style="text-align: center; width: 100%">
                    <tr id="c" style="border-bottom: black solid 2px; width: 100%; display: flex; ">
                        <th style="width:5%;"><input name="selectall" class="form-check-input" type = checkbox onclick="selectAll(this)"></th>
                        <th style="width:15%;">측정항목</th>
                        <th style="width:24%;">관리ID</th>
                        <th style="width:14%;">법적기준</th>
                        <th style="width:14%;">사내기준</th>
                        <th style="width:14%;">관리기준</th>
                        <th style="width:14%;">모니터링</th>
                    </tr>
                    <tr id="items" style="width: 100%">

                    </tr>

            </table>
        </div>

    </div>


</div>
<script>
    $( document ).ready(function() {

        placeChange($("#place0").text());
        monitoring();

        $('#itmes').insertAfter('#c');

    });

    function monitoring() {
        if(document.getElementById('monitor').val() =='on'){
            document.getElementById('monitor').
        }

    }
    //센서 체크박스 전체 선택, 해제
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

    //측정소 체크박스 전체 선택, 해제
    function checkPlaceAll()  {
        // 전체 체크박스
        const checkboxes
            = document.querySelectorAll('input[name="place"]');
        // 선택된 체크박스
        const checked
            = document.querySelectorAll('input[name="place"]:checked');
        // select all 체크박스
        const placeAll
            = document.querySelector('input[name="placeall"]');

        if(checkboxes.length === checked.length)  {
            placeAll.checked = true;
        }else {
            placeAll.checked = false;
        }

    }

    function placeAll(placeAll)  {
        const checkboxes
            = document.getElementsByName('place');

        checkboxes.forEach((checkbox) => {
            checkbox.checked = placeAll.checked
        })
    }
    //측정소 변경
    function placeChange(name) {
        const place = name;
        //$('#station').text(name); //측정소명 span에 넣기
        $("#items").empty();

        $.ajax({
            url: '<%=cp%>/getPlaceSensor',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"place": place},
            success: function (data) {
                for (let i = 0; i < data.length; i++) {
                    const tableName = data[i];
                    const category = findSensorCategory(tableName);
                    const power = findPower(tableName);
                    const legal = findLegal(tableName);
                    const company = findCompany(tableName);
                    const management = findManagement(tableName);

                    const innerHtml =
                        "<td style='width:5%;'><input class='form-check-input' type='checkbox' id='" + tableName + "a' name='item' value='" + tableName + "' onclick='checkSelectAll()'></td>" +
                        "<td style='width:15%;'><label class='form-check-label' for='" + tableName + "a'>" + category + "</label></td>" +
                        "<td style='width:24%;'><label class='form-check-label' for='" + tableName + "a'>" + tableName + "</label></td>" +
                        "<td style='width:14%;'><input style = 'width:80%; height: 34px;' class='form-check-input' type='text' id='" + tableName + "l' value='" + legal + "' ></td>" +
                        "<td style='width:14%;'><input style = 'width:80%; height: 34px;' class='form-check-input' type='text' id='" + tableName + "c' value='" + company + "' ></td>" +
                        "<td style='width:14%;'><input style = 'width:80%; height: 34px;' class='form-check-input' type='text' id='" + tableName + "m' value='" + management + "' ></td>" +
                        "<td style='width:14%;'><label class='switch'>" +
                        "<input id='" + tableName + "' type='checkbox' name='status' " + power + ">" +
                        "<div class='slider round'></div>" +
                        "</label></td>"


                    const elem = document.createElement('tr');
                    elem.innerHTML = innerHtml;
                    document.getElementById('items').append(elem);


                }

            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
    }
    function findPower(tableName) {
        let test;
        $.ajax({
            url: '<%=cp%>/getPower',
            type: 'POST',
            dataType: 'text',
            async: false,
            cache: false,
            data: {"name":tableName},
            success : function(data) {
                console.log(data);
                if(data == "on"){
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
    function findLegal(tableName) {
        console.log(tableName);

        let test;
        $.ajax({
            url: '<%=cp%>/getLegal',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"name":tableName},
            success : function(data) {
                console.log(data);
                if(data == 0){
                 test = "";
                }else{
                    test = data;
                }

            },
            error : function(request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return test;
    }
    function findCompany(tableName) {

        let test;
        $.ajax({
            url: '<%=cp%>/getCompany',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"name":tableName},
            success : function(data) {
                console.log(data);
                if(data == 0){
                    test = "";
                }else{
                    test = data;
                }

            },
            error : function(request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return test;
    }
    function findManagement(tableName) {
        let test;
        $.ajax({
            url: '<%=cp%>/getManagement',
            type: 'POST',
            dataType: 'json',
            async: false,
            cache: false,
            data: {"name":tableName},
            success : function(data) {
                console.log(data);
                if(data == 0){
                    test = "";
                }else{
                    test = data;
                }

            },
            error : function(request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })
        return test;
    }


</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />