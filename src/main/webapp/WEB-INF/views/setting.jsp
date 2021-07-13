<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<style>
    .bg-lightGray {
        background: #d3d3d3;
    }

    hr {
        color: white;
    }

    label {
        margin-bottom: 10px;
    }

    /* 데이터테이블 */
    .toolbar > b {
        font-size: 1.25rem;
    }

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
        border: 0px solid transparent !important;
        border-radius: 50px !important;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button.current,
    .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
        color: #fff !important;
        border: 0px !important;
        background: #97bef8 !important;
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
        border: 0px !important;
        background: #254069 !important;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button:active {
        outline: none;
        background-color: #2b2b2b;
        box-shadow: inset 0 0 3px #111;
    }

    #information_filter label {
        margin-bottom: 5px;
    }

    .userLog {
        font-size: 13px;
    }

    .userLog:hover {
        cursor: pointer;
        background-color: rgba(99, 130, 255, 0.3);
    }

    .dataTables_wrapper {
        min-height: 350px;
    }

    #member-Table select {
        color: #000;
        background-color: #f8f9fa;
        border-color: #aaa;
        border-radius: 2px;
        padding: 3px;
        width: 130px;
    }

    #groupTable {
        width: 100%;
        text-align: center;
    }

    #groupModal {
        min-width: 850px;
    }

    #groupModal > .modal-dialog {
        max-width: 850px !important;
    }

    .multiSelectBtn {
        margin: 100px 10px 0px 10px;
    }

    .multiSelectParent option {
        height: 45px;
        border-bottom: 3px solid gray;
        padding: 10px;
    }
    .multiSelectComboBox {
         width: 95%;
         margin:50px auto;
         display: flex;
         justify-content: center;
         background-color: white;
     }

    .multiSelectParent {
        padding: 15px 15px 0px 15px;
        margin-bottom: 10px;
        background-color: white;
        position: relative;
        display: block;
        min-width: 780px;
        height: 400px;
    }

    .multiSelectParent div {
        float: left;
    }

    .MultiSelecterModal {
        width: 350px;
        border-radius: 10px;
        background-color: rgba(99, 130, 255, 0.5);
        position: absolute;
        padding: 10px;
        top: 4%;
        left: 50%;
        transform: translate(-50%, -50%);
        text-align: center;
        color: white;
        font-weight: bold;
        display: none;
    }
    #monitoringSignModal{
        top: -7%;
    }

    .multiSelectBtn input[type=button] {
        width: 50px;
        height: 50px;
        color: rgb(99, 130, 255);
        font-weight: bold;
        font-size: 2rem;
        padding: 0;
    }

    .moveBtn {
        display: block;
    }

    .multiSelectBtn input[type=button]:hover {
        background-color: rgba(99, 130, 255, 0.3);
    }

    .multiSelect {
        width: 45%;
    }

    .multiSelect > select {
        height: 230px;
        border: 3px solid rgb(99, 130, 255);
    }

    .emissionsSpan {
        font-size: 0.9rem;
        margin: 10px 0px 10px 0px;
    }

    .groupSubTitle {
        position: relative;
        left: -15px;
    }

    svg:hover {
        cursor: pointer;
    }

    .tab {
        width: 70px;
        list-style: none;
        position: absolute;
        left: -81px;
        top:10px;
        margin: 0;
        padding: 0 10px 0;
    }

    .tab li {
        width: 70px;
        height: 80px;
        background-color: #ccc;
        color: #999;
        text-align: center;
        cursor: pointer;
    }

    .tab li:nth-child(1) {
        line-height: 80px;
    }

    .tab li:nth-child(2) {
        padding-top: 15px;
    }

    .tab li.on {
        background-color: #75ACFF;
        color: #fff;
    }

    .tab li:hover {
        background-color: #75ACFF;
        color: #fff;
    }
    #allPlaceCheck{
        width: 20px;
        height: 20px;
    }
    #allPlaceCheck:hover{
        cursor: pointer;
    }
    #checkLabel{
        font-size: 1.4rem;
        margin:0px 0px 0px 10px;
    }
    #nonCheckLabel{
        font-size: 1.4rem;
        margin:0px 0px 0px 10px;
        color: #777777;
    }
    #checkLabel:hover {
        cursor: pointer;
        color: #0d6efd;
    }
    #member, #group{
        height: 425px;
    }

    /* 반응형 미디어쿼리 */
    @media all and (max-width:989px) {
        .tab {
            left: unset;
            right: 0px;
            top: -60px;
            display: flex;
            width: 160px;
        }
        .tab li {
            width: 70px;
            height: 60px;
        }
        .tab li:nth-child(1) {
            line-height: 60px;
        }
        .tab li:nth-child(2) {
            padding-top: 10px;
        }
    }
</style>

<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/jquery-ui.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>
<script src="static/js/sweetalert2.min.js"></script>

<div class="container" id="container">
    <div class="row1 mt-4 mb-4">
        <span style=" font-size: 27px;font-weight: bold">환경설정 > 설정</span>
    </div>

    <div class="row bg-light rounded py-3" style="margin-left: 1px; position: relative;"> <%-- 상단 콘텐츠 div --%>

        <%-- tab 클릭시 li.on 회원관리는 #member 모니터링그룹관리는 #group 디스플레이 변경--%>
        <ul class="tab">
            <li class="on" onclick="tabClick(this, 'member')">회원관리</li>
            <li class="" onclick="tabClick(this, 'group')">모니터링그룹관리</li>
        </ul>
        <%--        <h4 class="d-flex justify-content-start">회원관리</h4>--%>
        <div id="member" style="display: block" class="tabDiv">
        <div style="height: 50px;"><span style=";font-size: 22px; font-weight: bold;padding: 0px 20px 20px 10px;height: 20px;">회원관리</span></div>
        <div class="col-xs-12">
            <table class="table table-striped" id="member-Table">

                    <thead>
                    <tr class="text-center">
                        <th style="padding:10px 0px 10px 0px;">ID</th>
                        <th style="padding:10px 0px 10px 0px;">이름</th>
                        <th style="padding:10px 0px 10px 0px;">권한</th>
                        <th style="padding:10px 0px 10px 0px;">이메일</th>
                        <th style="padding:10px 0px 10px 0px;">연락처</th>
                        <th style="padding:10px 0px 10px 0px;">부서명</th>
                        <th style="padding:10px 0px 10px 0px;">모니터링 그룹</th>
                        <th style="padding:10px 0px 10px 0px;">가입일</th>
                        <th style="padding:10px 0px 10px 0px;">관리</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach items="${members}" var="mList" varStatus="cnt">
                        <tr class="text-center userLog" onclick="userLog('${mList.id}')">
                            <form id="${mList.id}" method="post" action="<%=cp%>/log">   <!-- tr 클릭시 log페이지 이동하는 폼-->
                                <input type="hidden" value="${mList.id}" name="id">
                            </form>
                            <td>${mList.id}</td>
                            <td>${mList.name}</td>
                            <c:choose>
                                <c:when test="${mList.state eq '5'}">
                                    <td class="text-danger">거절</td>
                                </c:when>
                                <c:when test="${mList.state eq '4'}">
                                    <td>가입대기</td>
                                </c:when>
                                <c:when test="${mList.state eq '3'}">
                                    <td onclick="event.cancelBubble=true"><select id='state${mList.id}' onclick="select_state(this,${mList.state})" onchange="gave_rank(this)">
                                        <option value='${mList.state}'
                                                selected="selected">일반</option>
                                    </select></td>
                                </c:when>
                                <c:when test="${mList.state eq '2'}">
                                    <td onclick="event.cancelBubble=true"><select id='state${mList.id}' onclick="select_state(this,${mList.state})" onchange="gave_rank(this)">
                                        <option value='${mList.state}'
                                                selected="selected">관리자</option>
                                    </select></td>
                                </c:when>
                                <c:when test="${mList.state eq '1'}">
                                    <td onclick="event.cancelBubble=true"><select id='state${mList.id}' onclick="select_state(this,${mList.state})" onchange="gave_rank(this)">
                                        <option value='${mList.state}'
                                                selected="selected">최고 관리자</option>
                                    </select></td>
                                </c:when>
                            </c:choose>
                            <td>${mList.email}</td>
                            <td>${mList.tel}</td>
                            <td>${mList.department}</td>
                            <td onclick="event.cancelBubble=true">
                            <c:choose>
                                <c:when test="${mList.state == 1}">
                                <select id='monitoringGroup${mList.id}' disabled="disabled" onclick="select_group(this,'${mList.monitoringGroup}')" onchange="updateMember('${mList.id}', this)">
                                    <option value='${mList.monitoringGroup}'
                                            selected="selected">${mList.monitoringGroup}</option>
                                </select></td>
                                </c:when>
                                <c:otherwise>
                                <select id='monitoringGroup${mList.id}' onclick="select_group(this,'${mList.monitoringGroup}')" onchange="updateMember('${mList.id}', this)">
                                    <option value='${mList.monitoringGroup}'
                                            selected="selected">${mList.monitoringGroup}</option>
                                </select></td>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${mList.joined != null}">
                                    <td><fmt:formatDate value="${mList.joined}" pattern="YYYY-MM-dd HH:mm:ss"/></td>
                                </c:when>
                                <c:otherwise>
                                    <td></td>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${mList.state eq '4'}">
                                    <td onclick="event.cancelBubble=true">

                                        <button class="btn btn-success py-0 px-2" style="font-size: 12px;"
                                                data-bs-toggle="modal" data-bs-target="#okModal"
                                                onclick="Info_Set('${mList.id}')">승인
                                        </button>
                                        <button class="btn btn-danger py-0 px-2" style="font-size: 12px;"
                                                data-bs-toggle="modal" data-bs-target="#noModal"
                                                onclick="Info_Set('${mList.id}')">거절
                                        </button>
                                    </td>
                                </c:when>
                                <c:when test="${(mList.state eq '1' || mList.state eq '2' || mList.state eq '3') and (member.id != mList.id)}">
                                    <td onclick="event.cancelBubble=true">
                                        <i class="fas fa-edit btn p-0" data-bs-toggle="modal"
                                           data-bs-target="#managementModal"
                                           onclick="Info_Set('${mList.id}','${mList.state}','${mList.name}')"></i>
                                    </td>
                                </c:when>
                                <c:otherwise>
                                    <td></td>
                                </c:otherwise>
                            </c:choose>
                        </tr>
                    </c:forEach>
                    </tbody>

                </table>
            </div>
        </div>
<%--            회원관리 div--%>
        <div id="group" style="display: none;"  class="tabDiv">
        <div style="height: 50px;">
            <span style=";font-size: 22px; font-weight: bold;padding: 0px 20px 20px 10px;">모니터링 그룹관리</span>
            <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#groupModal"
                    onclick="insertSetting()">그룹 추가</button>
        </div>
        <div style="width: 100%; height:350px;">
            <table class="table table-striped" id="groupTable">
                <thead>
                <tr>
                    <th>그룹명</th>
                    <th>회원</th>
                    <th>모니터링 <a class="sign"></a> 측정소</th>
                    <th>관리</th>
                </tr>
                </thead>

                    <tbody>
                    <c:forEach items="${group}" var="groupList" varStatus="idx">
                        <c:if test="${groupList.groupName != 'default'}">
                            <tr>
                                <td>${groupList.groupName}</td>
                                <td class="groupTd">${groupList.groupMember}</td>
                                <td class="groupPlace">${groupList.monitoringPlace}</td>
                                <td><i class="fas fa-edit btn p-0" data-bs-toggle="modal" data-bs-target="#groupModal"
                                       onclick="groupEditSetting(this, ${groupList.groupNum})"></i>&ensp;
                                    <c:if test="${groupList.groupName != 'ALL'}">
                                        <i class="fas fa-times" onclick="deleteModal(this, ${groupList.groupNum})"></i>
                                    </c:if>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        </div> <%-- 모니터링그룹 div --%>


    <div class="row bg-light" style="padding: 1rem 40px 25px; margin-left: 1px;margin-top: 15px; ">

        <span style=";font-size: 22px; font-weight: bold;padding: 0px 20px 20px 10px;">권한관리</span>
        <div class="d-flex mt-1 p-0">

            <div class="col-md-3">
                <div class="bg-lightGray p-4 me-4 fw-bold" style="height: 314px;">
                    <div class="d-flex justify-content-start">
                        <input type="radio" class="form-check-input me-2" name="grandRadio" id="root_radio" value="root"
                               onclick="rankRadioChanged(value)" checked>
                        <label for="root_radio" class="w-75">최고 관리자</label>
                    </div>
                    <div class="d-flex justify-content-start mt-4">
                        <input type="radio" class="form-check-input me-2" name="grandRadio" id="admin_radio"
                               value="admin" onclick="rankRadioChanged(value)">
                        <label for="admin_radio" class="w-75">관리자</label>
                    </div>
                    <div class="d-flex justify-content-start mt-4">
                        <input type="radio" class="form-check-input me-2" name="grandRadio" id="normal_radio"
                               value="normal" onclick="rankRadioChanged(value)">
                        <label for="normal_radio" class="w-75">일반</label>
                    </div>
                </div>
            </div>

            <div class="col-md-9">
                <div class="bg-lightGray p-4 d-flex justify-content-between fw-bold">
                    <div>
                        <div class="d-flex justify-content-start">
                            <input type="checkbox" class="form-check-input me-2 " id="dashBoardChk">
                            <label for="dashBoardChk">대시보드 메뉴 열람</label>
                        </div>
                        <div class="d-flex justify-content-start mt-4">
                            <input type="checkbox" class="form-check-input me-2" id="alarmChk">
                            <label for="alarmChk">알림 메뉴 열람</label>
                        </div>
                        <div class="d-flex justify-content-start mt-4">
                            <input type="checkbox" class="form-check-input me-2" id="monitoringChk">
                            <label for="monitoringChk">모니터링 메뉴 열람</label>
                        </div>
                        <div class="d-flex justify-content-start mt-4">
                            <input type="checkbox" class="form-check-input me-2" id="statisticsChk">
                            <label for="statisticsChk">분석 및 통계 메뉴 열람</label>
                        </div>
                        <div class="d-flex justify-content-start mt-4">
                            <input type="checkbox" class="form-check-input me-2" id="settingChk">
                            <label for="settingChk">환경설정 메뉴 열람</label>
                        </div>
                    </div>
                    <div class="d-flex align-items-end">
                        <c:set var="member" value="${member}"/>
                        <c:if test="${member.state == '1'}">
                            <button class="btn btn-primary align-text-bottom me-2 mb-2 py-1 px-3 fw-bold fs-6"
                                    onclick="rankSettingSave()">저장
                            </button>
                        </c:if>
                    </div>
                </div>
            </div>

        </div>

    </div>
    <%--권한관리 DIV--%>

</div> <%-- 상단 콘텐츠 div --%>


<%--                                           ↓↓↓ 모달영역 ↓↓↓                                                              --%>

<!-- groupModal -->
<div class="modal" id="groupModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h4 class="modal-title groupModalTitle">그룹 생성</h4>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <h3>그룹명</h3>
                <input type="text" style="width: 85%;margin-left: 20px;padding-left: 5px;" maxlength="70"
                       id="groupInput">
            </div>
            <div class="modal-body d-flex">
                <div style="width: 100%">

                    <div class="multiSelectParent">
                        <h3 class="fs-5 fw-bold groupSubTitle">그룹회원 관리</h3>
                        <div class="multiSelect">
                            <label><b>회원명</b></label>
                            <select multiple class="form-control scroll selectBox" id="lstBox3">
                                <!-- script -->
                            </select>
                        </div>

                        <div class="multiSelectBtn">
                            <input type='button' id='btnRight2' value='>' class="btn btn-default moveBtn"
                                   onclick="moveEvent('#lstBox3', '#lstBox4')"/>
                            <input type='button' id='btnLeft2' value='<' class="btn btn-default moveBtn"
                                   onclick="moveEvent('#lstBox4', '#lstBox3')"/>
                        </div>

                        <div class="multiSelect">
                            <label><b>그룹 회원</b></label>
                            <select multiple class="form-control scroll selectBox" id="lstBox4">
                                <!-- script -->
                            </select>
                        </div>

                        <div class="clearfix"></div>
                        <!-- MultiSelecter Modal-->
                        <div class="MultiSelecterModal" id="groupSignModal"></div>
                        <div class="emissionsSpan">* 그룹에 포함된 회원은 해당 그룹의 모니터링 측정소에 포함된 측정소만 모니터링 페이지에서 모니터링 가능합니다.</div>
                    </div>

                        <h3 class="fs-5 fw-bold groupSubTitle" style="padding-left: 20px;">모니터링 측정소</h3>
                    <div class="multiSelectParent" id="placeSelect">
                        <input type="checkbox" id="allPlaceCheck" class="allPlaceCheck">
                        <label for="allPlaceCheck" id="checkLabel"  class="allPlaceCheck"> 전체 측정소 모니터링</label>
                        <span class="allPlaceCheckSpan allPlaceCheck" style="display: block;font-size: 0.9rem;color:#db3535;font-weight: bold;margin-bottom: 10px;">
                            * 체크시 측정소 추가 여부와 상관없이 모든 측정소 모니터링</span>

                        <div class="multiSelect allCheckEvent">
                            <label><b>측정소명</b></label>
                            <select multiple class="form-control scroll selectBox" id="lstBox1">
                                <!-- script -->
                            </select>
                        </div>

                        <div class="multiSelectBtn allCheckEvent">
                            <input type='button' id='btnRight1' value='>' class="btn btn-default moveBtn"
                                   onclick="moveEvent('#lstBox1', '#lstBox2')"/>
                            <input type='button' id='btnLeft1' value='<' class="btn btn-default moveBtn"
                                   onclick="moveEvent('#lstBox2', '#lstBox1')"/>
                        </div>

                        <div class="multiSelect allCheckEvent">
                            <label><b>모니터링 측정소</b></label>
                            <select multiple class="form-control scroll selectBox" id="lstBox2">
                                <!-- script -->
                            </select>
                        </div>

                        <div class="clearfix"></div>
                        <!-- MultiSelecter Modal-->
                        <div class="MultiSelecterModal" id="monitoringSignModal"></div>
                        <div class="emissionsSpan allCheckEvent">* 그룹에 포함된 회원은 해당 그룹의 모니터링 측정소에 포함된 측정소만 모니터링 페이지에서 모니터링 가능합니다.</div>
                    </div>

                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal" id="gModalCancle">취소
                </button>
                <button type="button" id="saveBtn" class="btn btn-outline-primary" onclick="saveGroup('insert')">생성
                </button>
            </div>
        </div>
    </div>
</div>

<!-- okModal -->
<div class="modal" id="okModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">가입 승인</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <h3 id="okModal_Body">가입승인 하시겠습니까?</h3>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <h5 class="me-1">회원권한 : </h5>
                <select name="rank" id="rank" class="btn btn-light">
                    <option value="3">일반</option>
                    <option value="2">관리자</option>
                    <option value="1">최고 관리자</option>
                </select>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5" data-bs-dismiss="modal" value="1"
                        onclick="sing_Up(value)">승인
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<!-- noModal -->
<div class="modal" id="noModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">가입 거절</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <h3>가입거절 하시겠습니까?</h3>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-danger me-5" data-bs-dismiss="modal" value="0"
                        onclick="sing_Up(value)">거절
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>


<!-- managementModal -->
<div class="modal" id="managementModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title managementInfo_text">회원 관리</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <div class="text-center">
                    <button class="btn btn-outline-dark fw-bold fs-4 px-5 m-2 w-75" data-bs-toggle="modal"
                            data-bs-target="#userPwdmodal" data-bs-dismiss="modal">임시 비밀번호 발급
                    </button>
                    <button class="btn btn-outline-danger fw-bold fs-4 px-5 m-2 w-75" data-bs-toggle="modal"
                            data-bs-target="#userExpulsionmodal" data-bs-dismiss="modal">제명
                    </button>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<!-- userPwdmodal -->
<div class="modal" id="userPwdmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">임시 비밀번호 발급</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <div class="text-center">
                    <p class="fs-5 fw-bold tempPassword_text">의 비밀번호를 변경하시겠습니까?</p>
                    <small class="text-danger">* 발급된 임시 비밀번호로 로그인 가능하며, 해당 회원에게 임시 비밀번호를 알려주신 후, 마이페이지에서 비밀번호 변경을
                        요청해주세요.</small>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-primary me-5" data-bs-dismiss="modal" onclick="resetPassword()">
                    확인
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<!-- userExpulsionmodal -->
<div class="modal" id="userExpulsionmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">회원 제명</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <div class="text-center">
                    <p class="fs-3 fw-bold kick_text">을 제명 하시겠습니까?</p>
                    <small class="text-danger">* 회원과 관련된 모든 데이터가 삭제됩니다.</small>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-danger me-5" data-bs-dismiss="modal" onclick="kickMember()">제명
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>
<%--                                           ↑↑↑ 모달영역 ↑↑↑                                                              --%>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    $("#member-Table").DataTable({
        //     scrollX:true,
        //     scrollXInner:"130%",
        autoWidth: false,
        language: {
            emptyTable: "데이터가 없어요.",
            lengthMenu: "페이지당 _MENU_ 개씩 보기",
            info: "현재 _START_ - _END_ / _TOTAL_건",
            infoEmpty: "데이터 없음",
            infoFiltered: "( _MAX_건의 데이터에서 필터링됨 )",
            search: "전체검색 : ",
            zeroRecords: "일치하는 데이터가 없어요.",
            loadingRecords: "로딩중...",
            processing: "잠시만 기다려 주세요...",
            paginate: {
                "next": "다음",
                "previous": "이전"
            },
        },
        pageLength: 5,
        info: false,
        lengthChange: false,
        order: [7, 'asc']
    });

    $('#groupTable').DataTable({
        "columns": [
            {"width": "20%"},
            {"width": "35%"},
            {"width": "35%"},
            {"width": "10%"}
        ],
        autoWidth: false,
        language: {
            emptyTable: "데이터가 없어요.",
            lengthMenu: "페이지당 _MENU_ 개씩 보기",
            info: "현재 _START_ - _END_ / _TOTAL_건",
            infoEmpty: "데이터 없음",
            infoFiltered: "( _MAX_건의 데이터에서 필터링됨 )",
            search: "전체검색 : ",
            zeroRecords: "일치하는 데이터가 없어요.",
            loadingRecords: "로딩중...",
            processing: "잠시만 기다려 주세요...",
            paginate: {
                "next": "다음",
                "previous": "이전"
            },
        },
        pageLength: 5,
        info: false,
        lengthChange: false,
    });

    var ID = ""; //데이터테이블 해당항목의 ID정보
    var name = "";
    var state = ""; //해당항목의 등급 정보
    var rName = "root"; // 권한관리영역 checkBox 변수
    var user_state = "${member.state}"; // 페이지에 접근한 유저의 등급정보
    var user_id = "${member.id}"; // 페이지에 접근한 유저의 ID
    let memberList; // 모든 멤버리스트
    let placeList; // 모든 측정소 리스트


    $(document).ready(function () {
        rankRadioChanged("root"); //기본값
        $('.Modal').modal({keyboard: false, backdrop: 'static'}); // esc , 백스페이스 클릭방지
        substrArrayData();
        getMemberAndPlaceList();
        allPlaceCheck();
    }); //ready

    function Info_Set(str_id, str_state, str_name) {
        ID = str_id;
        state = str_state;
        name = str_name;
        textfield_management();
    }// row 의 승인 및 거절 버튼 클릭시 전역변수 ID에 해당row 의 ID가 저장됨

    function sing_Up(iNumber) {
        var content = ID;
        var rankLog = ($("#rank").val() == "1") ? " [최고 관리자] " : ($("#rank").val() == "2") ? " [관리자] " : " [일반] ";
        content += rankLog;
        (iNumber == "1") ? content += " 계정 가입 승인 " : content += " 계정 가입 거절 ";
        var settings = {
            "url": "<%=cp%>/signUp?id=" + ID + "&iNumber=" + iNumber + "&state=" + $("#rank").val(),
            "method": "POST"
        };
        $.ajax(settings).done(function (response) {
            (iNumber == "1") ? inputLog(ID, rankLog + "가입 승인", "회원") : inputLog(ID, "가입 거절", "회원"); //대상자 로그
            inputLog(user_id, content, "회원"); // 관리자로그
            success(response);
            setTimeout(function () {
                location.reload();
            }, 2000);
        })
    }           // sing_Up

    //권한 변경
    function gave_rank(select) {
        const id = select.id.replace('state','');
        const value = $("#"+select.id).val();

        if(user_state > value){
            Swal.fire({
                icon: 'warning',
                title: '권한이 없습니다.',
            })
            return;
        }

        const changeRank = (value == 1) ? "최고 관리자 " : (value == 2) ? "관리자 " : "일반 ";
        const pastRank = (state == 1) ? "최고 관리자 " : (state == 2) ? "관리자 " : "일반 ";
        const content = pastRank + "> " + changeRank + "권한변경";
        const settings = {
            "url": "<%=cp%>/gaveRank?id=" + id + "&value=" + value,
            "method": "POST"
        };
        $.ajax(settings).done(function (response) {
            inputLog(id, content, "회원");
            inputLog(user_id, id + " 계정 " + content + " 처리", "회원");
            success(response);
            setTimeout(function () {
                location.reload();
            }, 2000);
        });
    }

    function resetPassword() {
        if (state == '1') {
            warning("최고 관리자의 비밀번호는 초기화하실수 없습니다.");
            return;
        } else {
            var settings = {
                "url": "<%=cp%>/resetPassword?id=" + ID,
                "method": "POST"
            };
            $.ajax(settings).done(function (response) {
                inputLog(ID, "비밀번호 초기화", "회원");
                inputLog(user_id, ID + " 계정 비밀번호 초기화 처리", "회원");
                Swal.fire({
                    icon: 'success',
                    title: '임시 비밀번호가 발급되었습니다.',
                    text: response
                })
            });
        }
    }           // resetPassword

    function kickMember() {
        if (state == '1') {
            warning("최고 관리자는 제명하실수 없습니다.");
            return;
        } else {
            var settings = {
                "url": "<%=cp%>/kickMember?id=" + ID,
                "method": "POST"
            };
            $.ajax(settings).done(function (response) {
                inputLog(user_id, ID + " 계정 제명처리", "회원");
                success(response);
                setTimeout(function () {
                    location.reload();
                }, 2000);
            });
        }
    }           // kickMember

    function rankRadioChanged(name) {
        rName = name;
        <c:forEach items="${rank_managements}" var="rank_managements">
        var rankName = "${rank_managements.name}";
        if (rName == rankName) {
            $("#dashBoardChk").prop("checked", ("${rank_managements.dashboard}" == "true") ? true : false);
            $("#alarmChk").prop("checked", ("${rank_managements.alarm}" == "true") ? true : false);
            $("#monitoringChk").prop("checked", ("${rank_managements.monitoring}" == "true") ? true : false);
            $("#statisticsChk").prop("checked", ("${rank_managements.statistics}" == "true") ? true : false);
            $("#settingChk").prop("checked", ("${rank_managements.setting}" == "true") ? true : false);
            if (rName == "root") {
                $("#settingChk").prop("disabled", true);
            } else {
                $("#settingChk").prop("disabled", false);
            }
            $("#settingChk").click(function () {
                if ($("#settingChk").is(":checked") && rName == "normal") {
                    Swal.fire({
                        html: "환경설정 메뉴 열람 허용시 <br>일반 회원도 설정값을 변경할 수 있습니다. <br>일반 회원의 환경설정 메뉴 열람을 허용하시겠습니까?",
                        title: '경고',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: "확인",
                        cancelButtonColor: '#d33',
                        cancelButtonText: "취소",
                        reverseButtons: false,
                        preConfirm: (function () {
                            $("#settingChk").prop("checked", true);
                        }),
                    })
                    $("#settingChk").prop("checked", false);
                }
            })
        }
        </c:forEach>
    }       //rankRadioChanged

    function rankSettingSave() {
        var settings = {
            "url": "<%=cp%>/rankSettingSave",
            "method": "POST",
            "headers": {
                "accept": "application/json",
                "content-type": "application/json;charset=UTF-8"
            },
            "data": "{\r\n    \"name\": \"" + rName + "\"," +
                "\r\n    \"dashboard\": " + $('#dashBoardChk').prop("checked") + "," +
                "\r\n    \"alarm\": " + $('#alarmChk').prop("checked") + "," +
                "\r\n    \"monitoring\": " + $('#monitoringChk').prop("checked") + "," +
                "\r\n    \"statistics\": " + $('#statisticsChk').prop("checked") + "," +
                "\r\n    \"setting\": " + $('#settingChk').prop("checked") + "\r\n}",
        };
        $.ajax(settings).done(function (response) {
            var content = (rName == "root") ? "최고 관리자 - " : (rName == "admin") ? "관리자 - " : "일반유저 - ";
            var strs = response;
            for (var i = 0; i < strs.length; i++) {
                if (strs[i] != "") {
                    inputLog(user_id, content + strs[i], "회원");
                }
            }
            success("권한관리 설정이 저장되었습니다.");

            setTimeout(function () {
                location.reload();
            }, 2000);
        });
    }       //rankSettingSave

    function setSelectOption() {
        (state == "1") ? $('#root_select_item').prop("selected", true) : (state == "2") ? $('#admin_select_item').prop("selected", true) : $('#normal_select_item').prop("selected", true);
    }

    function textfield_management() {
        $(".managementInfo_text").html(name + " 회원 관리");
        $(".updateRank_text").html(name + " 회원 권한변경");
        $(".tempPassword_text").html(name + " 회원의 비밀번호를 <br>변경하시겠습니까?");
        $(".kick_text").html(name + " 회원을 <br>제명 하시겠습니까?");
    }

    $(function () {
        $('.modal-dialog').draggable({handle: ".modal-header"});
    });         // modal drag and drop move

    function userLog(id) {
        let frm = $('#' + id);
        frm.submit();
    }

    function warning(str) {
        Swal.fire('경고', str, 'warning');
    }

    function success(str) {
        Swal.fire('확인', str, 'success');
    }


    //선택된 옵션 이벤트 적용
    function moveEvent(from, to) {
        $('select').moveToListAndDelete(from, to);
    }

    //MultiSelecter 변경 이벤트
    $.fn.moveToListAndDelete = function (from, to) {
        let opts = $(from + ' option:selected');
        if (opts.length == 0) return;

        $(opts).remove();
        $(to).append($(opts).clone());
        MultiSelecterModal(opts, from);                       //Modal Event
    };

    function saveGroup(flag, groupNum) {
        let name = $('#groupInput').val().trim();
        if (name == '') {
            $('#groupInput').focus();
            warning('그룹명을 입력 하세요.');
            return;
        }

        let member = $('#lstBox4 option');
        let mList = new Array();
        for (i = 0; i < member.length; i++)
            mList.push(member.eq(i).val());

        let pList
        if($('#allPlaceCheck').is(':checked') == true || $('.allCheckEvent').css('display') == 'none'){
            pList = ["ALL"];
        }else{
            let place = $('#lstBox2 option');
            pList = new Array();
            for (i=0; i<place.length; i++)
                pList.push(place.eq(i).val());
        }

        if (flag == "insert") groupNum = -1;
        $.ajax({
            url: '<%=cp%>/saveGroup',
            type: 'POST',
            async: false,
            cache: false,
            data: {"name": name, "memList": mList, "placeList": pList, "flag": flag, "groupNum": groupNum},
            success: function (data) {
                if(data == 'fail'){
                    warning("이미 존재하는 그룹명 입니다.");
                }else {
                    $('#gModalCancle').trigger("click");
                    success('그룹이 저장 되었습니다.');
                    setTimeout(() => {
                        location.reload()
                    }, 1500);
                }
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }

    //MultiSelecter Modal
    function MultiSelecterModal(opts, from) {
        const plaModal = $('#monitoringSignModal');
        const memModal = $('#groupSignModal');

        if (from == '#lstBox3') {
            createModal(memModal, opts, ' 님이 <br> 그룹에 추가 되었습니다.', ' 님 외' + (opts.length - 1) + '명이 <br> 그룹에 추가 되었습니다. ');
        } else if (from == '#lstBox4') {
            createModal(memModal, opts, ' 님이 <br> 그룹에서 제외 되었습니다.', ' 님 외' + (opts.length - 1) + '명이 <br> 그룹에서 제외 되었습니다. ');
        } else if (from == '#lstBox1') {
            createModal(plaModal, opts, ' 측정소가 <br> 그룹에 추가 되었습니다.', ' 측정소 외' + (opts.length - 1) + '개가 <br> 그룹에 추가 되었습니다. ')
        } else if (from == '#lstBox2') {
            createModal(plaModal, opts, ' 측정소가 <br> 그룹에서 제외 되었습니다.', ' 측정소 외' + (opts.length - 1) + '개가 <br> 그룹에서 제외 되었습니다. ');
        }
    }

    function createModal(Modal, opts, length1, lengthLong) {
        if (opts.length == 1) {
            Modal.html(opts.text() + length1);
        } else if (opts.length > 1) {
            Modal.html(opts.eq(0).text() + lengthLong);
        } else{
            Modal.html(lengthLong);
        }
        Modal.finish().fadeIn(300).delay(2000).fadeOut(300);

        adminGroupCheck();
    }

    function adminGroupCheck(){
        let currentMember = $('#lstBox4 option');
        for (i=0; i<currentMember.length; i++){
            if($(currentMember[i]).attr('id') == 1) {
                $('#allPlaceCheck').prop('checked', true);
                $('#allPlaceCheck').prop('disabled', true);
                $('#checkLabel').attr('id', 'nonCheckLabel');
                optionDisabled(true);
                $('#monitoringSignModal').html('최고 관리자가 포함된 그룹은<br> 모든 측정소를 모니터링 합니다.');
                $('#monitoringSignModal').finish().fadeIn(300).delay(5000).fadeOut(300);
                return;
            }
        }
        $('#allPlaceCheck').prop('checked', false);
        $('#allPlaceCheck').prop('disabled', false);
        $('#nonCheckLabel').attr('id', 'checkLabel');
        optionDisabled(false);
        return;
    }

    //그룹회원, 측정소 배열 양끝에 대괄호 없애기
    //한개씩 꺼내서 문자열 만드는것보다 더 빠르고 편해 보임.
    function substrArrayData() {
        let groupMember = $('.groupTd');
        for (i = 0; i < groupMember.length; i++) {
            groupMember.eq(i).text(groupMember.eq(i).text().substr(1, groupMember.eq(i).text().length - 2));
        }

        let groupPlace = $('.groupPlace');
        for (i = 0; i < groupPlace.length; i++) {
            groupPlace.eq(i).text(groupPlace.eq(i).text().substr(1, groupPlace.eq(i).text().length - 2));
        }
    }

    //삭제 모달
    function deleteModal(obj, indexKey) {
        const name = $(obj).parent().parent().children().eq(0).html(); //-> tmsWP0001_NOX_01
        const key = indexKey;

        Swal.fire({
            icon: 'error',
            title: '그룹 삭제',
            text: '\'' + name + '\' 그룹을 삭제 하시겠습니까?',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed)
                deleteGroup(key);
        });
    }

    //그룹Key로 그룹삭제
    function deleteGroup(key) {
        $.ajax({
            url: '<%=cp%>/deleteGroup',
            type: 'POST',
            async: false,
            cache: false,
            data: {key: key},
            success: function () {
                success('삭제 되었습니다.');
                setTimeout(() => {
                    location.reload()
                }, 1500);
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }

    //그룹 수정시 모달 셋팅
    function groupEditSetting(obj, groupNum) {
        let groupMemList = $(obj).parent().parent().children().eq(1).text().split(',');
        let groupPlaList = $(obj).parent().parent().children().eq(2).text().split(',');
        let groupName = $(obj).parent().parent().children().eq(0).text();

        $('#groupInput').val(groupName);
        $('#placeSelect .allCheckEvent').css('display', 'block');
        $('#monitoringSignModal').css('top', '-7%');
        $('.allPlaceCheck').css('display', 'none');
        $('#allPlaceCheck').prop("checked", false);
        $('.selectBox').empty();
        $('.groupModalTitle').text('그룹 수정');
        $('#saveBtn').text('수정');
        $('#saveBtn').attr('onclick', 'saveGroup("edit")');
        $('#monitoringSignModal').finish().fadeOut(0);
        optionDisabled(false);

        if(groupMemList[0] !="") {
            let innerHTML;
            for (i = 0; i < groupMemList.length; i++) {
                groupMemList[i] = groupMemList[i].trim();
                innerHTML += '<option value="' + groupMemList[i] + '">' + groupMemList[i] + '</option>'
            }
            $('#lstBox4').append(innerHTML);
        }


        if(groupPlaList == "ALL") {
            $('#placeSelect .allCheckEvent').css('display', 'none');
            $('#monitoringSignModal').css('top', '40%');
            optionDisabled(true);
            $('#monitoringSignModal').html('모든 측정소를 모니터링 합니다.');
            $('#monitoringSignModal').finish().fadeIn(300)

        }else if(groupPlaList[0] !="") {
            let innerHTML2;
            for (i = 0; i < groupPlaList.length; i++) {
                groupPlaList[i] = groupPlaList[i].trim();
                innerHTML2 += '<option value="' + groupPlaList[i] + '">' + groupPlaList[i] + '</option>'
            }
            $('#lstBox2').append(innerHTML2);
        }

            let plaInnerHTML;
            for (i = 0; i < placeList.length; i++) {
                if (groupPlaList.includes(placeList[i]) == false) {
                    plaInnerHTML += '<option value="' + placeList[i] + '">' + placeList[i] + '</option>';
                }
            }
            $('#lstBox1').append(plaInnerHTML);


        let memInnerHTML;
        for (i = 0; i < memberList.length; i++) {
            if (memberList[i].monitoringGroup == "default" && groupPlaList != 'ALL' && memberList[i].state <=3 && memberList[i].state != 1) {
                memInnerHTML += '<option value="' + memberList[i].id + '">' + memberList[i].id + '</option>';
            }
            if (memberList[i].monitoringGroup == "default" && groupPlaList == 'ALL' && memberList[i].state <= 3) {
                memInnerHTML += '<option value="' + memberList[i].id + '">' + memberList[i].id + '</option>';
            }
        }
        $('#lstBox3').append(memInnerHTML);

        $('#saveBtn').attr('onclick', 'saveGroup("edit", ' + groupNum + ')');
    }

    //그룹 추가시 모달 셋팅
    function insertSetting() {

        $('#placeSelect .allCheckEvent').css('display', 'block');
        $('#monitoringSignModal').css('top', '-7%');
        $('.groupModalTitle').text('그룹 생성');
        $('#groupInput').val('');
        $('#saveBtn').text('생성');
        $('#saveBtn').attr('onclick', 'saveGroup("insert")');
        $('.selectBox').empty();
        $('.allPlaceCheck').css('display', 'inline-block');
        $('.allPlaceCheckSpan').css('display', 'block');
        $('#allPlaceCheck').prop("checked", false);
        $('#monitoringSignModal').finish().fadeOut(0);
        optionDisabled(false);
        let memInnerHTML;
        let plaInnerHTML;

        for (i = 0; i < memberList.length; i++) {
            if (memberList[i].monitoringGroup == "default" && memberList[i].state <=3) {
                memInnerHTML += '<option value="' + memberList[i].id +'" id="' + memberList[i].state + '">' + memberList[i].id + '</option>';
            }
        }
        $('#lstBox3').append(memInnerHTML);

        for (i = 0; i < placeList.length; i++) {
            plaInnerHTML += '<option value="' + placeList[i] + '">' + placeList[i] + '</option>';
        }
        $('#lstBox1').append(plaInnerHTML);
    }

    //그룹관리에 필요한 멤버리스트, 측정소 리스트
    function getMemberAndPlaceList() {
        $.ajax({
            url: '<%=cp%>/getMemberAndPlaceList',
            type: 'POST',
            async: false,
            cache: false,
            success: function (data) {
                memberList = data[0];
                placeList = data[1];
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }

    //회원관리, 그룹관리 탭 이벤트
    function tabClick(obj, divId) {
        $('.tab li').attr('class', '');
        $(obj).attr('class', 'on');

        $('.tabDiv').css('display', 'none');
        $('#' + divId).css('display', 'block');
    }

    //그룹추가에서 체크박스로 측정소영역 비활성화, 활성화
    function allPlaceCheck(){
        $("#allPlaceCheck").on({click: function() {
               if($(this).is(":checked") == true){
                   optionDisabled(true);
               }else{
                   optionDisabled(false);
               }
            }
        });
    }

    //그룹 추가,수정 모달에서 측정소 영역 비활성화
    function optionDisabled(flag){
        if(flag == true){
            $('.allCheckEvent label').css('color','#999');
            $('.allCheckEvent input[type=button]').css('color','#999');
            $('.allCheckEvent select').css('border','3px solid #999');
            $('.allCheckEvent input[type=button]').prop('disabled', true);
            $('.allCheckEvent select').prop('disabled', true);
            $('#monitoringSignModal').html('모든 측정소를 측정합니다.');
            $('#monitoringSignModal').finish().fadeIn(300).delay(3000).fadeOut(300);

        }else if (flag == false){
            $('.allCheckEvent label').css('color','black');
            $('.allCheckEvent input[type=button]').css('color','rgb(99, 130, 255)');
            $('.allCheckEvent select').css('border','3px solid rgb(99, 130, 255)');
            $('.allCheckEvent input[type=button]').prop('disabled', false);
            $('.allCheckEvent select').prop('disabled', false);
        }
    }

    //권한 selectbox
    function select_state(select, state) {
        Info_Set(user_id, state, name);
        const $target = $('#'+select.id);
        $target.empty();
        let innerHTML = "";
        if(state == 3){
            innerHTML ="<option value='3' selected='selected'>일반</option>" +
                "<option value='2'>관리자</option>" +
                "<option value='1'>최고 관리자</option>";
        }else if(state == 2){
            innerHTML ="<option value='3'>일반</option>" +
                "<option value='2' selected='selected'>관리자</option>" +
                "<option value='1'>최고 관리자</option>";
        }else{
            innerHTML ="<option value='3'>일반</option>" +
                "<option value='2'>관리자</option>" +
                "<option value='1' selected='selected'>최고 관리자</option>";
        }
        $target.append(innerHTML);
    }

    //모니터링 그룹 selectbox
    function select_group(select,name) {
        const $target = $('#'+select.id);
        $target.empty();
        let innerHTML = "";
        $.ajax({
            url: '<%=cp%>/getMonitoringGroup',
            dataType: 'json',
            async: false,
            cache: false,
            success: function (data) {
                for (let i = 0; i < data.length; i++) {
                    const group = data[i].groupName;
                    if (name == group){
                        innerHTML =
                            "<option value ='" + group + "' selected='selected'>" + group + "</option>";

                }else{
                        innerHTML =
                            "<option value ='" + group + "'>" + group + "</option>";
                    }
                    $target.append(innerHTML);
                }
            },
            error: function () {
            }
        });
    }

    //모니터링 그룹 변경 ajax
    function updateMember(id, select) {
        $.ajax({
            url: '<%=cp%>/memberGroupUpdate',
            type: 'POST',
            dataType: 'text',
            async: false,
            cache: false,
            data: {
                "id": id,
                "monitoringGroup": select.value
            },
            success: function (data) {
                if (data == "success") {
                    swal('success', '수정완료', '성공적으로 수정되었습니다.');
                    setTimeout(function () {
                        location.reload();
                    }, 2000);
                } else {
                    swal('warning', '수정실패');
                }
            },
            error: function (request, status, error) {
                swal('warning', '수정실패');
                console.log('member update error');
                console.log(error);
            }
        })
    }

    function swal(icon, title, text) {
        Swal.fire({
            icon: icon,
            title: title,
            text: text,
            timer: 2000
        })
    }


</script>






