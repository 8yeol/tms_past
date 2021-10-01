<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-30
  Time: 오전 9:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<script src="static/js/jquery.dataTables.min.js"></script>
<script src="static/js/sweetalert2.min.js"></script>
<script src="static/js/common/common.js"></script>
<script src="static/js/jquery-ui.js"></script>
<script src="static/js/moment.min.js"></script>

<style>

    @media screen and (max-width: 1024px) {
        .multiSelectComboBox {
            flex-direction: column;
        }

        .multiSelectParent {
            margin: auto;
            margin-bottom: 20px;
        }

        .emissionsh4 {
            text-align: center;
            margin-top: 10px;
        }

        .emissionsSpan {
            margin-bottom: 1rem;
        }

        .row2 {
            margin-bottom: 20px;
            margin-left: -100px;
        }

        #gradeText {
            text-align: left !important;
            left: 20px;
        }
    }

    .emissionsSpan {
        margin-bottom: 20px;
        font-size: 0.85rem;
    }

    .multiSelectComboBox {
        width: 95%;
        margin: 30px auto;
        display: flex;
        justify-content: center;
    }

    .multiSelectParent {
        padding-left: 15px;
        padding-right: 15px;
        padding-top: 15px;
        position: relative;
        display: block;
        min-width: 660px;
        max-width: 660px;
    }

    .multiSelectParent div {
        float: left;
    }

    .multiSelectParent label {
        font-size: 1.2rem;
    }

    .multiSelectParent option {
        height: 45px;
        border-bottom: 3px solid gray;
        padding: 10px;
    }

    .MultiSelecterModal {
        width: 350px;
        border-radius: 10px;
        background-color: rgba(99, 130, 255, 0.7);
        position: absolute;
        padding: 10px;
        top: 60%;
        left: 50%;
        transform: translate(-50%, -50%);
        text-align: center;
        color: white;
        font-weight: bold;
        display: none;
    }

    .multiSelect {
        width: 275px;
        height: 250px;
    }

    .form-control {
        height: 200px;
        border: 3px solid rgb(99, 130, 255);
    }

    .multiSelectBtn {
        margin: 10px;
    }

    .multiSelectBtn input[type=button] {
        width: 50px;
        height: 50px;
        color: rgb(99, 130, 255);
        font-weight: bold;
        font-size: 2rem;
        padding: 0;
    }

    .multiSelectBtn input[type=button]:hover {
        background-color: rgba(99, 130, 255, 0.3);
    }

    .row1 {
        padding: 20px;
        float: left;
        width: 500px;
        font-size: 2rem;
    }

    .row2 {
        padding-top: 30px;
        float: right;
        width: 800px;
        text-align: end;
    }

    th {
        text-align: center;
    }

    td {
        text-align: center;
    }

    /* 데이터테이블 */
    label {
        margin-bottom: 10px;
    }

    .toolbar > b {
        font-size: 1.25rem;
    }

    /*.toolbar:after {content:""; display: block; clear: both;}*/

    .dataTables_wrapper .dataTables_paginate .paginate_button {
        box-sizing: border-box;
        display: inline-block;
        min-width: 1.5em;
        padding: 0.5em 1em;
        margin-left: 2px;
        text-align: center;
        text-decoration: none !important;
        cursor: pointer;
        *cursor: hand;
        color: #333 !important;
        border: 0px solid transparent;
        border-radius: 50px;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button.current,
    .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
        color: #fff !important;
        border: 0px;
        background: #97bef8;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button.disabled,
    .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:hover,
    .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:active {
        cursor: default;
        color: #666 !important;
        border: 1px solid transparent;
        background: transparent;
        box-shadow: none;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
        color: white !important;
        border: 0px;
        background: #254069;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button:active {
        outline: none;
        background-color: #2b2b2b;
        box-shadow: inset 0 0 3px #111;
    }

    #information_filter label {
        margin-bottom: 5px;
    }

    .buttons-excel {
        background-color: #000;
        color: #fff;
        border: 0px;
        border-radius: 5px;
        position: relative;
        margin-top: 2px;
    }

    .dt-buttons {
        margin: 0 10px;
        display: inline-block;
    }

    .dataTables_wrapper {
        min-height: 250px;
    }

    .moveBtn {
        display: block;
    }

    .multiSelectBtn {
        padding-top: 5rem;
    }

    th {
        padding: 0;
    }

    .inputColor {
        background-color: #DDDDDD;
    }

    .scroll {
        overflow-x: auto;
    }

    .scroll option {
        padding-right: 35px;
    }

    .inputDisabled {
        background-color: rgba(239, 239, 239, 0.3);
        border: 1px solid rgba(118, 118, 118, 0.3);
        pointer-events: none;
    }

    .tableWrap {
        min-height: 250px;
    }

    .tableWrap > table tr {
        height: 40px;
    }

    .tableWrap > table > tbody tr:last-child {
        border-bottom: 2px solid #212529;
    }

    #paging1, #paging2 {
        text-align: right;
    }

    #paging1 a, #paging2 a {
        display: inline-block;
        min-width: 1.5em;
        padding: 0.5em 1em;
        margin-left: 2px;
        text-align: center;
        text-decoration: none !important;
        cursor: pointer;
        *cursor: hand;
        color: #333 !important;
        background-color: #fff !important;
        border: 0px solid transparent !important;
        border-radius: 50px !important;
    }

    #paging1 a.current, #paging2 a.current,
    #paging1 a:hover, #paging2 a:hover {
        color: #fff !important;
        border: 0px !important;
        background: #97bef8 !important;
    }

    .btnTable td:last-child > input[type=button] {
        width: 55%;
        height: 80%;
        border: 2px solid #06357a;
        background-color: #fff;
        color: #06357a;
    }

    .btnTable td:last-child > input[type=button]:hover, .btnTable td:last-child > input[type=button].active {
        background-color: #06357a;
        color: #fff;
    }

    .btnTable td > input[type=text] {
        text-align: center;
        border: 1px solid #0d6efd;
    }
</style>

<div class="container" id="container">
    <div class="row" style="position:relative;">
        <div class="row1" style="padding: 20px 10px;">
            <span class="fs-4 fw-bold">환경설정 > 배출량 관리</span>
            <!-- <button data-bs-toggle="modal" data-bs-target="#addModal" onclick="insertSetting()"
                     style="background-color:green;color:white"> 추가 버튼
             </button> -->
        </div>

        <div style="width: fit-content; position: absolute; right: 10px; padding-top: 30px; text-align: end;">
            <span class="text-primary" style="font-size: 0.9rem;">* 배출량 모니터링은 측정소에 <b>유량</b> 및 <b>질소산화물</b> 센서가 정상적으로 등록된 경우 이용 가능합니다.</span>
        </div>

        <div class="col-xs-12 bg-light tableWrap" style="min-height: 300px;">
            <div class="pb-2 justify-content-between" style="display: flex">
                <h4 class="mt-2 fs-5 fw-bold" style="margin-left: 5px;">연간 배출 허용 기준 설정</h4>
            </div>
            <table class="table">
                <thead>
                <tr>
                    <th>측정소명</th>
                    <th>센서명</th>
                    <th>연간 배출 <a class="sign"></a>허용 기준</th>
                    <th>기준 농도</th>
                    <th>산출식(참고용)</th>
                    <th>최종 수정 날짜</th>
                    <th>관리</th>
                </tr>
                </thead>
                <tbody id="tbody" style="vertical-align: middle;">
<%--                <c:forEach items="${standard}" var="standard" varStatus="i">--%>

<%--                    <tr>--%>
<%--                        <td class="tableCode">${standard.place}</td>--%>
<%--                        <td class="tableNaming">${standard.naming}</td>--%>

<%--                        <c:choose>--%>
<%--                            <c:when test="${standard.emissionsStandard eq 0}">--%>
<%--                                <td></td>--%>
<%--                            </c:when>--%>
<%--                            <c:when test="${standard.emissionsStandard ne 0}">--%>
<%--                                <td><fmt:formatNumber value="${standard.emissionsStandard}"/></td>--%>
<%--                            </c:when>--%>
<%--                        </c:choose>--%>

<%--                        <c:choose>--%>
<%--                            <c:when test="${standard.densityStandard eq 0}">--%>
<%--                                <td></td>--%>
<%--                            </c:when>--%>
<%--                            <c:when test="${standard.densityStandard ne 0}">--%>
<%--                                <td>${standard.densityStandard}</td>--%>
<%--                            </c:when>--%>
<%--                        </c:choose>--%>

<%--                        <td>${standard.formula}</td>--%>
<%--                        <td><fmt:formatDate value="${standard.date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>--%>
<%--                        <td>--%>
<%--                            <c:if test="${state == 1}">--%>
<%--                                <i onclick="clickModal(this)" class="fas fa-edit me-2" data-bs-toggle="modal"--%>
<%--                                   data-bs-target="#addModal" id="${standard.tableName}"></i>--%>
<%--                                <!--<i class="fas fa-times" onclick="deleteModal(${standard.tableName})"></i>-->--%>
<%--                            </c:if>--%>
<%--                        </td>--%>
<%--                    </tr>--%>
<%--                </c:forEach>--%>
                </tbody>

            </table>
<%--            <!--  Standard == null -->--%>
<%--            <c:if test="${empty standard}">--%>
<%--                <div class="pt-4" style="text-align: center;font-size: 1.2rem;position: relative;top: -150px;"--%>
<%--                     id="nullStandard">--%>
<%--                    연간 배출 허용 기준이 없습니다. <br>--%>
<%--                    <b>환경 설정 - 센서 관리</b> 에서 센서를 추가 해주세요.--%>
<%--                </div>--%>
<%--            </c:if>--%>
            <div id="paging1">
            </div>
        </div>


        <div class="col-xs-12 bg-light" style="margin-top: 20px; min-height: 300px;">
            <div class="pb-2 justify-content-between" style="display: flex">
                <h4 class="mt-2 fs-5 fw-bold" style="margin-left: 5px;">연간 배출량 추이 관리</h4>
            </div>

            <span class="text-end w-100"
                  style="display: inline-block; margin-bottom: 5px; margin-right: 5px; font-size: .8rem">단위 : g</span>
            <div class="tableWrap w-100">
                <table class="table btnTable">
                    <thead>
                    <tr>
                        <th></th>
                        <th>1월</th>
                        <th>2월</th>
                        <th>3월</th>
                        <th>4월</th>
                        <th>5월</th>
                        <th>6월</th>
                        <th>7월</th>
                        <th>8월</th>
                        <th>9월</th>
                        <th>10월</th>
                        <th>11월</th>
                        <th>12월</th>
                        <th>관리</th>
                    </tr>
                    </thead>

                    <tbody id="tbody1">

                    </tbody>
                </table>
                <div id="hiddendiv"></div>
                <div id="paging2">
                </div>
            </div>

        </div>
    </div>

    <div class="col"
         style="color:red; font-size: 0.8rem; font-weight: normal;position: relative;top:20px;text-align: end"
         id="gradeText">
        * 배출량 모니터링 대상 설정은 '최고 관리자' 권한을 가진 회원만 가능합니다.
    </div>
    <!--멀티셀렉터 콤보박스 -->
    <div class="multiSelectComboBox bg-light">
        <div class="multiSelectParent bg-light">
            <h4 class="fs-5 fw-bold emissionsh4">배출량 추이 모니터링 대상 설정</h4><br>
            <div class="multiSelect">
                <label><b>전체 항목</b></label>
                <select multiple class="form-control scroll" id="lstBox1">
                    <c:forEach items="${emissions}" var="target">
                        <c:if test="${target.status eq 'false'}">
                            <option id="${target.sensor}" class="lstBox1Option">${target.place} - ${target.sensorNaming}
                            </option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>

            <div class="multiSelectBtn">
                <input type='button' id='btnRight' value='>' class="btn btn-default moveBtn"
                       onclick="moveEvent('#lstBox1', '#lstBox2')"/>
                <input type='button' id='btnLeft' value='<' class="btn btn-default moveBtn"
                       onclick="moveEvent('#lstBox2', '#lstBox1')"/>
            </div>

            <div class="multiSelect">
                <label><b>대상 가스</b></label>
                <select multiple class="form-control scroll" id="lstBox2">
                    <c:forEach items="${emissions}" var="target">
                        <c:if test="${target.status eq 'true'}">
                            <option id="${target.sensor}" class="lstBox2Option">${target.place} - ${target.sensorNaming}
                            </option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>
            <div class="clearfix"></div>

            <!-- MultiSelecter Modal-->
            <div class="MultiSelecterModal" id="emissionsModal"></div>
            <div class="emissionsSpan">* 설정된 배출량 추이 모니터링 대상가스는 [대시보드 - 측정소 통합 모니터링] 화면에 표시됩니다</div>
        </div>

        <div class="multiSelectParent bg-light">
            <h4 class="fs-5 fw-bold emissionsh4">연간 배출량 누적 모니터링 대상 설정</h4><br>
            <div class="multiSelect">
                <label><b>전체 항목</b></label>
                <select multiple class="form-control scroll" id="lstBox3">
                    <c:forEach items="${yearlyEmissions}" var="target2">
                        <c:if test="${target2.status eq 'false'}">
                            <option id="${target2.sensor}" class="lstBox3Option">${target2.place} -
                                    ${target2.sensorNaming}
                            </option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>

            <div class="multiSelectBtn">
                <input type='button' id='btnRight2' value='>' class="btn btn-default moveBtn"
                       onclick="moveEvent('#lstBox3', '#lstBox4')"/>
                <input type='button' id='btnLeft2' value='<' class="btn btn-default moveBtn"
                       onclick="moveEvent('#lstBox4', '#lstBox3')"/>
            </div>

            <div class="multiSelect">
                <label><b>대상 가스</b></label>
                <select multiple class="form-control scroll" id="lstBox4">
                    <c:forEach items="${yearlyEmissions}" var="target2">
                        <c:if test="${target2.status eq 'true'}">
                            <option id="${target2.sensor}" class="lstBox4Option"> ${target2.place}
                                - ${target2.sensorNaming}
                            </option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>

            <div class="clearfix"></div>
            <!-- MultiSelecter Modal-->
            <div class="MultiSelecterModal" id="yearlyEmissionsModal"></div>
            <div class="emissionsSpan">* 설정된 배출량 추이 모니터링 대상가스는 [대시보드 - 연간 배출량 누적모니터링] 화면에 표시됩니다</div>
        </div>
    </div>
</div>

</div>
<!-- addModal -->
<div class="modal" id="addModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">센서 수정</h5>
            </div>
            <div class="modal-body d-flex justify-content-evenly">
                <form id="addStandard" method="post" autocomplete="off">
                    <div class="row">
                        <div class="col text-center">
                            <!--<span class="text-danger"
                                  style="font-size: 15%"> * 설정된 코드와 항목명을 기준으로 모니터링 항목명(한글명)이 적용됩니다.</span>-->
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">측정소명</span>
                        </div>
                        <div class="col">
                            <input type="text" name="place" class="p-1 inputDisabled" readonly>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">센서명</span>
                        </div>
                        <div class="col">
                            <input type="text" name="naming" class="p-1 inputDisabled" readonly>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">연간배출 허용기준</span>
                        </div>
                        <div class="col">
                            <input type="text" name="standard" class="p-1">
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">배출허용 기준농도</span>
                        </div>
                        <div class="col">
                            <input type="text" name="percent" class="p-1">
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">산출식(참고용)</span>
                        </div>
                        <div class="col">
                            <input type="text" name="formula" class="p-1">
                        </div>
                    </div>
                    <input type="hidden" name="hiddenTableName"> <!-- 추가 수정 판별할 데이터 -->

                    <c:if test="${!empty param.tableName}"> <!--모달 띄울 데이터 -->
                        <input type="hidden" id="paramModalShow" value="${param.tableName}">
                    </c:if>
                </form>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5" onclick="editStandard()">수정</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>


</div>

<script>

    $(document).ready(function () {
        const dataPerpage = 3;
        const pageCount = 3;
        const currentPage = 1;
        const total1 = selectEmissionStandard(currentPage, dataPerpage);
        const total2 = selectMEmission(currentPage, dataPerpage);
        paging(total1, dataPerpage, pageCount, currentPage, 1);
        paging(total2, dataPerpage, pageCount, currentPage, 2);
    });
    $(function () {
        if ('${state}' != '1') optionDisabled();

        //배출량 모니터링대상 스크롤 길이만큼 옵션길이 적용
        $('.lstBox1Option').width(document.querySelector('#lstBox1').scrollWidth - 32);
        $('.lstBox2Option').width(document.querySelector('#lstBox2').scrollWidth - 32);
        $('.lstBox3Option').width(document.querySelector('#lstBox3').scrollWidth - 32);
        $('.lstBox4Option').width(document.querySelector('#lstBox4').scrollWidth - 32);

        // modal drag and drop move
        if ($('#paramModalShow').val() != null) {
            paramModal($('#paramModalShow').val());
        }

        $('.modal-dialog').draggable({handle: ".modal-header"});
        //콤마 자동 찍기, 숫자만 입력 가능
        $("input[name='standard']").bind('keyup', function (e) {
            var rgx1 = /\D/g;
            var rgx2 = /(\d+)(\d{3})/;
            var num = this.value.replace(rgx1, "");

            while (rgx2.test(num)) num = num.replace(rgx2, '$1' + ',' + '$2');
            this.value = num;
        });
        $("input[name='percent']").bind('keyup', function (e) {
            var rgx1 = /\D/g;
            var num = this.value.replace(rgx1, "");
            this.value = num;
        });
    });

    //그룹 추가,수정 모달에서 측정소 영역 비활성화
    function optionDisabled() {
        $('.multiSelectParent label').css('color', '#999');
        $('.multiSelectParent input[type=button]').css('color', '#999');
        $('.multiSelectParent select').css('border', '3px solid #999');
        $('.multiSelectParent input[type=button]').prop('disabled', true);
        $('.multiSelectParent select').prop('disabled', true);
    }

    //연간 배출 허용 기준 설정 조회
    function selectEmissionStandard(currentPage, dataPerPage) {
        const current = Number(currentPage);
        const dataPer = Number(dataPerPage);
        let total = 0;
        let html = "";
        $.ajax({
            url: '<%=cp%>/getEmissionStandard',
            dataType: 'json',
            async: false,
            cache: false,
            success: function (data) {
                total = data.length;
                $('#tbody').empty();
                if (data.length != 0) {
                    let current1 = (current - 1) * dataPer;
                    let dataPer1 = (current - 1) * dataPer + dataPer;
                    if (data.length < dataPer1) {
                        dataPer1 = data.length;
                    }
                    for (let i = current1; i < dataPer1; i++) {
                        if (data[i].emissionsStandard == 0) {
                            data[i].emissionsStandard = "";
                        }
                        if (data[i].densityStandard == 0) {
                            data[i].densityStandard = "";
                        }
                        let date = moment(data[i].date).format('yyyy-MM-dd HH:mm:ss');
                        html =
                            "<td class='tableCode'>" + data[i].place + "</td>" +
                            "<td class='tableNaming'>" + data[i].naming + "</td>" +
                            "<td>" + data[i].emissionsStandard + "</td>" +
                            "<td>" + data[i].densityStandard + "</td>" +
                            "<td>" + data[i].formula + "</td>" +
                            "<td>" + date + "</td>";
                        if ('${state}' == '1') {
                            html += "<td><i onclick='clickModal(this)' class='fas fa-edit me-2' data-bs-toggle='modal' data-bs-target='#addModal' id='" + data[i].tableName + "'></i></td>"
                        } else {
                            html += "<td></td>";
                        }
                        const elem = document.createElement('tr');
                        elem.innerHTML = html;
                        document.getElementById('tbody').append(elem);
                    }
                } else {
                    html =
                        "<td colspan='7' class='pt-4' style='text-align: center;font-size: 1.2rem;' id='nullStandard'>" +
                        "연간 배출 허용 기준이 없습니다. <br>" +
                        "<b>환경 설정 - 센서 관리</b> 에서 센서를 추가 해주세요." +
                        "</td>";

                    $('#tbody').append(html);
                }
            }, error: function () {
            }
        });
        return total;
    }

    //연간 배출량 추이 조회
    function selectMEmission(currentPage, dataPerPage) {
        const current = Number(currentPage);
        const dataPer = Number(dataPerPage);
        let total = 0;
        $.ajax({
            url: '<%=cp%>/getMonthlyEmission',
            dataType: 'json',
            async: false,
            cache: false,
            success: function (data) {
                total = data.length;
                $('#tbody1').empty();
                if (data.length != 0) {
                    let current1 = (current - 1) * dataPer;
                    let dataPer1 = (current - 1) * dataPer + dataPer;
                    if (data.length < dataPer1) {
                        dataPer1 = data.length;
                    }
                    for (let i = current1; i < dataPer1; i++) {
                        const innerHtml =
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].year + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].jan + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].feb + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].mar + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].apr + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].may + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].jun + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].jul + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].aug + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].sep + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].oct + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].nov + "</td>" +
                            "<td name='m" + i + "' style='width: 7%'>" + data[i].dec + "</td>" +
                            "<td><input type = 'button' id='b" + i + "' value='수정' onclick='dataUpdate(this, " + current + "," + dataPer + ")'></td>";
                        const elem = document.createElement('tr');
                        elem.setAttribute('id', 'data' + i);
                        elem.innerHTML = innerHtml;
                        document.getElementById('tbody1').append(elem);
                    }
                } else {
                    const none =
                        "<td colspan='14'>" +
                        "<div class='fw-bold' style='padding-top : 20px;'>등록된 데이터가 없습니다.</div>" +
                        "</td>";
                    $('#tbody1').append(none);
                }
            },
            error: function () {
            }
        });
        return total;
    }

    //배출량 추이관리 수정
    function dataUpdate(x, current, dataPer) {
        const dList = new Array();
        const id = x.id;
        const num = id.replace(/[^0-9]/g, '');
        $('td[name=m' + num + ']').each(function () {
            dList.push($(this).text());
        });
        $('#data' + num).empty();
        const innerHtml =
            "<td name='n" + num + "' style='width: 7%'>" + dList[0] + "</td>" +
            "<td style='width: 7%'><input id = 'n1' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[1] + "'></td>" +
            "<td style='width: 7%'><input id = 'n2' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[2] + "'></td>" +
            "<td style='width: 7%'><input id = 'n3' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[3] + "'></td>" +
            "<td style='width: 7%'><input id = 'n4' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[4] + "'></td>" +
            "<td style='width: 7%'><input id = 'n5' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[5] + "'></td>" +
            "<td style='width: 7%'><input id = 'n6' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[6] + "'></td>" +
            "<td style='width: 7%'><input id = 'n7' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[7] + "'></td>" +
            "<td style='width: 7%'><input id = 'n8' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[8] + "'></td>" +
            "<td style='width: 7%'><input id = 'n9' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[9] + "'></td>" +
            "<td style='width: 7%'><input id = 'n10' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[10] + "'></td>" +
            "<td style='width: 7%'><input id = 'n11' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[11] + "'></td>" +
            "<td style='width: 7%'><input id = 'n12' name='n" + num + "' style = 'width:80%; type='text' onchange='hiddendata(this)' value='" + dList[12] + "'></td>" +
            "<td><input type = 'button' value='확인' id='s" + num + "' onclick='savedata(" + num + "," + current + "," + dataPer + ")'></td>";
        $('#data' + num).append(innerHtml);
    }

    //수정데이터 저장
    function savedata(num, current, dataPer) {
        const dList = new Array();
        dList.push($('td[name=n' + num + ']').text());
        $('input[name=n' + num + ']').each(function () {
            dList.push($(this).attr('value'));
        });
        if ($('input[name=h' + num + ']').attr('value') != null) {
            $('input[name=h' + num + ']').each(function () {
                let id = $(this).attr('id');
                let num = id.replace(/[^0-9]/g, '');
                dList[num] = $(this).attr('value');
                $(this).remove();
            });
        }
        $.ajax({
            url: '<%=cp%>/saveMEmission',
            type: 'POST',
            async: false,
            cache: false,
            data: {"dList": dList},
            success: function (data) {
            },
            error: function () {
            }
        })
        selectMEmission(current, dataPer);
    }

    //수정한 데이터
    function hiddendata(x) {
        const id = x.id;
        const name = x.name;
        const num = id.replace(/[^0-9]/g, '');
        const namenum = name.replace(/[^0-9]/g, '');
        const value = document.getElementById(id).value;
        if (isNaN(value) == true) {
            Swal.fire({
                icon: 'warning',
                title: '경고',
                text: '문자 데이터를 입력할수 없습니다.'
            })
            document.getElementById(id).value = null;
            return false;
        }
        const innerHtml =
            "<input type='hidden' name='h" + namenum + "' id='h" + num + "' value='" + value + "'>";
        $('#hiddendiv').append(innerHtml);
    }

    // //기준 추가
    // function insert() {
    //
    //     var unComma = $("input[name='standard']").val().replace(/,/g, '');
    //     $("input[name='standard']").val(unComma);
    //
    //     var form = $('#addStandard').serialize();
    //     standardAjax(form, '추가')
    // }

    // function insertSetting() {
    //     $('.modal-title').html('센서 추가');
    //     $('.btn-success').html('추가');
    //     $('.btn-success').removeAttr("onclick");
    //     $('.btn-success').attr("onclick", "insert()");
    //     inputClean();
    // }

    //param 인자로 모달 생성
    function paramModal(tableName) {

        //테이블명으로 연간 배출 기준값 가져오기
        $.ajax({
            url: '<%=cp%>/getStandardValue',
            type: 'POST',
            async: false,
            cache: false,
            data: {tableName: tableName},
            success: function (data) {
                $("input[name='hiddenTableName']").val(tableName);
                $("input[name='place']").val(data.place);
                $("input[name='naming']").val(data.naming);
                $("input[name='standard']").val((data.emissionsStandard == 0) ? '' : data.emissionsStandard);
                $("input[name='percent']").val((data.densityStandard == 0) ? '' : data.densityStandard);
                $("input[name='formula']").val(data.formula);
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        });

        $('#addModal').modal('show');
    }

    //클릭하여 모달 생성
    function clickModal(obj) {
        editSetting(obj);
    }

    //editModal 선택값 셋팅
    function editSetting(obj) {
        let tdList = $(obj).parent().parent().children();
        let tableName = $(obj).attr('id');

        $("input[name='hiddenTableName']").val(tableName);
        $("input[name='place']").val(tdList.eq(0).html());
        $("input[name='naming']").val(tdList.eq(1).html());
        $("input[name='standard']").val(tdList.eq(2).html());
        $("input[name='percent']").val(tdList.eq(3).html());
        $("input[name='formula']").val(tdList.eq(4).html());
    }


    //기준 수정
    function editStandard() {
        valueCheck();

        var unComma = $("input[name='standard']").val().replace(/,/g, '');
        $("input[name='standard']").val(unComma);

        var form = $('#addStandard').serialize();
        standardAjax(form);
    }

    function standardAjax(form) {
        $.ajax({
            url: '<%=cp%>/saveEmissionsStandard',
            type: 'POST',
            async: false,
            cache: false,
            data: form,
            success: function (data) {
                //drawTable(data);
                $('#addModal').modal('hide');

                inputClean();

                $('#paramModalShow').remove();

                setTimeout(function () {
                    location.href = '<%=cp%>/emissionsManagement';
                }, 1500);

                Swal.fire({
                    icon: 'success',
                    title: '수정 완료',
                    text: '연간 배출 허용 기준이 수정 되었습니다.'
                })
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        });
    }

    // function deleteModal(tableName) {
    //     Swal.fire({
    //         icon: 'error',
    //         title: '삭제',
    //         text: '정말 삭제 하시겠습니까?',
    //         showCancelButton: true,
    //         confirmButtonColor: '#d33',
    //         confirmButtonText: '삭제',
    //         cancelButtonText: '취소'
    //     }).then((result) => {
    //         if (result.isConfirmed) {   //삭제 버튼 누를때
    //             deleteAjax(tableName);
    //         }
    //     });
    // }
    //
    // function deleteAjax(tableName) {
    //     $.ajax({
    //         url: '<%=cp%>/deleteEmissionsStandard',
    //         type: 'POST',
    //         async: false,
    //         cache: false,
    //         data: {tableName: tableName},
    //         success: function (data) {
    //             Swal.fire(
    //                 '삭제 완료',
    //                 '삭제 되었습니다.',
    //                 'warning'
    //             );
    //             drawTable(data);
    //         },
    //         error: function (request, status, error) {
    //             console.log(error)
    //         }
    //     });
    // }


    //테이블 모두 삭제하고 새로운 데이터로 다시 그립니다.
    // function drawTable(data) {
    //     $('#nullStandard').remove();
    //     $('#tbody').children().remove();
    //
    //     for (i = 0; i < data.length; i++) {
    //         let innerHTML = "";
    //         innerHTML = " <tr>" +
    //             " <td class='tableCode'>" + data[i].place + "</td>" +
    //             " <td class='tableNaming'>" + data[i].naming + "</td>" +
    //             " <td>" + numberWithCommas(data[i].emissionsStandard) + "</td>" +
    //             " <td>" + data[i].densityStandard + "</td>" +
    //             " <td>" + data[i].formula + "</td>" +
    //             " <td>" +
    //             "<i class='fas fa-edit me-2'  data-bs-toggle='modal' data-bs-target='#addModal' onclick='editSetting(this)' id='" + data[i].tableName + "'></i>" +
    //             //"<i class='fas fa-times' onclick='deleteModal('+data[i].tableName+')'></i>" +
    //             "</td>" +
    //             "</tr>";
    //         $('#tbody').append(innerHTML);
    //     }
    // }

    //Modal 초기화
    function inputClean() {
        $("input[type=text]").val("");
        $("input[type=hidden]").val("");
    }

    //입력값 체크
    function valueCheck() {
        let percent = $('input[name=percent]').val();
        let standard = $('input[name=standard]').val();

        if (percent == '') $('input[name=percent]').val(0);
        if (standard == '') $('input[name=standard]').val(0);
    }


    //선택된 옵션 이벤트 적용
    function moveEvent(from, to) {
        $('select').moveToListAndDelete(from, to);
    }

    //MultiSelecter 변경 이벤트
    $.fn.moveToListAndDelete = function (from, to) {
        let opts = $(from + ' option:selected');
        MultiSelecterModal(opts, from);                       //Modal Event

        if (from == '#lstBox1' || from == '#lstBox2') {       //배출량
            for (i = 0; i < opts.length; i++)
                stateUpdate(opts.eq(i).attr('id'), true);     // opts.eq(i).attr('id') ->tmsWP0001_NOX_01

        } else {                                              //연간 배출량
            for (i = 0; i < opts.length; i++)
                stateUpdate(opts.eq(i).attr('id'), false);    // opts.eq(i).attr('id') ->tmsWP0001_NOX_01
        }

        $(opts).remove();
        $(to).append($(opts).clone());
    };


    //MultiSelecter Modal
    function MultiSelecterModal(opts, from) {
        const eModal = $('#emissionsModal');
        const yeModal = $('#yearlyEmissionsModal');

        if (from == '#lstBox1') {
            optionCount_Insert(eModal, opts)
        } else if (from == '#lstBox2') {
            optionCount_Delete(eModal, opts);
        } else if (from == '#lstBox3') {
            optionCount_Insert(yeModal, opts)
        } else if (from == '#lstBox4') {
            optionCount_Delete(yeModal, opts);
        }
    }

    function optionCount_Delete(Modal, opts) {
        if (opts.length == 1) {
            Modal.html(opts.text() + ' 센서가 <br> 모니터링 대상 가스에서 제외 되었습니다. ');
            fade(Modal);
        } else if (opts.length > 1) {
            Modal.html(opts.eq(0).text() + ' 센서 외 ' + (opts.length - 1) + '개가 <br> 모니터링 대상 가스에서 제외 되었습니다. ');
            fade(Modal);
        }
    }

    function optionCount_Insert(Modal, opts) {
        if (opts.length == 1) {
            Modal.html(opts.text() + ' 센서가 <br> 모니터링 대상 가스로 선택 되었습니다. ');
            fade(Modal);
        } else if (opts.length > 1) {
            Modal.html(opts.eq(0).text() + ' 센서 외 ' + (opts.length - 1) + '개가 <br> 모니터링 대상 가스로 선택 되었습니다. ');
            fade(Modal);
        }
    }

    //Modal FadeIn FadeOut
    function fade(Modal) {
        Modal.finish();
        Modal.fadeIn(300).delay(2000).fadeOut(300);
    }

    //센서 상태 업데이트
    function stateUpdate(sensor, isCollection) {
        $.ajax({
            url: '<%=cp%>/emissionsState',
            type: 'POST',
            async: false,
            cache: false,
            data: {
                "sensor": sensor,
                "isCollection": isCollection,
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }

    // $(".table").DataTable({
    //     "columns" : [
    //         { "width" : "7%" },
    //         { "width" : "7%" },
    //         { "width" : "11%" },
    //         { "width" : "7%" },
    //         { "width" : "9%" },
    //         { "width" : "9%" },
    //         { "width" : "3%" }
    //     ],
    //     autoWidth: false,
    //     order: [[5, 'desc']],
    //     ordering: true,
    //     info: false,
    //     lengthChange : false,
    //     pageLength: 5,
    //     language : {
    //         "emptyTable": "데이터가 없어요.",
    //         "lengthMenu": "페이지당 _MENU_ 개씩 보기",
    //         "info": "현재 _START_ - _END_ / _TOTAL_건",
    //         "infoEmpty": "데이터 없음",
    //         "infoFiltered": "( _MAX_건의 데이터에서 필터링됨 )",
    //         "search": "전체검색 : ",
    //         "zeroRecords": "일치하는 데이터가 없어요.",
    //         "loadingRecords": "로딩중...",
    //         "processing": "잠시만 기다려 주세요...",
    //         "paginate": {
    //             "next": "다음",
    //             "previous": "이전"
    //         },
    //     },
    // });
    function paging(totalData, dataPerPage, pageCount, currentPage, tableNum) {
        const totalPage = Math.ceil(totalData / dataPerPage);    // 총 페이지 수
        const pageGroup = Math.ceil(currentPage / pageCount);    // 페이지 그룹
        let last = pageGroup * pageCount;    // 화면에 보여질 마지막 페이지 번호
        if (last > totalPage)
            last = totalPage;
        const first = last - (pageCount - 1);    // 화면에 보여질 첫번째 페이지 번호
        const next = last + 1;
        const prev = first - 1;

        let html = "";

        if (prev > 0) {
            html += "<a href=javascript:; id='start" + tableNum + "'>시작</a> ";
            html += "<a href=javascript:; id='prev" + tableNum + "'>이전</a> ";
        }

        for (let i = first; i <= last; i++) {
            if (i > 0) {
                html += "<a href='javascript:;' id=" + i + '_' + tableNum + ">" + i + "</a> ";  //href=javascript:; 페이지 이동없음
            }
        }

        if (last < totalPage) {
            html += "<a href=javascript:; id='next" + tableNum + "'>다음</a> ";
            html += "<a href=javascript:; id='end" + tableNum + "'>끝</a>";
        }

        $("#paging" + tableNum).html(html);    // 페이지 목록 생성
        $("#paging" + tableNum + " a").css("color", "#333");
        $("#paging" + tableNum + " a#" + currentPage + "_" + tableNum).css({
            "text-decoration": "none",
            "background-color": "#97bef8",
            "font-weight": "bold",
            "color": "#fff !important"
        });    // 현재 페이지 표시

        $("#paging" + tableNum + " a").click(function () {
            const $item = $(this);
            const $id = $item.attr("id");
            let selectedPage = $item.text();

            if ($id == "start" + tableNum) selectedPage = 1;
            if ($id == "next" + tableNum) selectedPage = next;
            if ($id == "prev" + tableNum) selectedPage = prev;
            if ($id == "end" + tableNum) selectedPage = totalPage;
            paging(totalData, dataPerPage, pageCount, selectedPage, tableNum);
            if (tableNum == 1) {
                selectEmissionStandard(selectedPage, dataPerPage);
            }else{
                selectMEmission(selectedPage, dataPerPage);
            }

        });

    }


</script>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
