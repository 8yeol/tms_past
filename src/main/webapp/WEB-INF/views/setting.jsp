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

    .userLog {
        font-size: 13px;
    }

    .userLog:hover {
        cursor: pointer;
        background-color: rgba(99, 130, 255, 0.3);
    }

    .dataTables_wrapper {
        min-height: 550px;
    }
</style>

<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="static/css/sweetalert2.min.css">
<script src="static/js/common/common.js"></script>
<script src="static/js/jquery-ui.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>
<script src="static/js/sweetalert2.min.js"></script>

<div class="container">
    <div class="row1 mt-4 mb-4">
        <span style=" font-size: 27px;font-weight: bold">환경설정 > 설정</span>
    </div>
    <div class="row bg-light rounded py-3 px-5">

        <%--        <h4 class="d-flex justify-content-start">회원관리</h4>--%>
        <span style=";font-size: 22px; font-weight: bold;padding: 0px 20px 20px 10px;">회원관리</span>
        <div class="col-xs-12">
            <table class="table table-striped" id="member-Table">

                <thead>
                <tr class="text-center">
                    <th>번호</th>
                    <th>ID</th>
                    <th>이름</th>
                    <th>등급</th>
                    <th>이메일</th>
                    <th>연락처</th>
                    <th>가입신청일</th>
                    <th>가입승인일</th>
                    <th>최종 로그인</th>
                    <th>관리</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${members}" var="mList" varStatus="cnt">
                    <tr class="text-center userLog" onclick="userLog('${mList.id}')">
                        <form id="${mList.id}" method="post" action="<%=cp%>/log">   <!-- tr 클릭시 log페이지 이동하는 폼-->
                            <input type="hidden" value="${mList.id}" name="id">
                        </form>
                        <td>${cnt.index+1}</td>
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
                                <td>일반</td>
                            </c:when>
                            <c:when test="${mList.state eq '2'}">
                                <td>관리자</td>
                            </c:when>
                            <c:when test="${mList.state eq '1'}">
                                <td>최고 관리자</td>
                            </c:when>
                        </c:choose>
                        <td>${mList.email}</td>
                        <td>${mList.tel}</td>
                        <td><fmt:formatDate value="${mList._id.date}" pattern="yyyy년 MM월 dd일 HH시"/></td>


                        <c:choose>
                            <c:when test="${mList.joined != null}">
                                <td><fmt:formatDate value="${mList.joined}" pattern="yyyy년 MM월 dd일 HH시"/></td>
                            </c:when>
                            <c:otherwise>
                                <td></td>
                            </c:otherwise>
                        </c:choose>

                        <c:choose>
                            <c:when test="${mList.lastLogin != null}">
                                <td><fmt:formatDate value="${mList.lastLogin}" pattern="yyyy년 MM월 dd일 HH시"/></td>
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
                                       onclick="Info_Set('${mList.id}','${mList.state}')"></i>
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
    <%--회원관리 DIV--%>

    <div class="row bg-light rounded mt-3 py-3 px-5">

        <span style=";font-size: 22px; font-weight: bold;padding: 0px 20px 20px 10px;">권한관리</span>
        <div class="d-flex mt-1 p-0">

            <div class="col-md-3">
                <div class="bg-lightGray p-4 me-4 fw-bold h-100">
                    <div class="d-flex justify-content-start">
                        <input type="radio" class="form-check-input me-2" name="grandRadio" id="root"
                               onclick="rankRadioChanged(id)" checked>
                        <label for="root">최고 관리자</label>
                    </div>
                    <div class="d-flex justify-content-start mt-4">
                        <input type="radio" class="form-check-input me-2" name="grandRadio" id="admin"
                               onclick="rankRadioChanged(id)">
                        <label for="admin">관리자</label>
                    </div>
                    <div class="d-flex justify-content-start mt-4">
                        <input type="radio" class="form-check-input me-2" name="grandRadio" id="normal"
                               onclick="rankRadioChanged(id)">
                        <label for="normal">일반</label>
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

</div>


<%--                                           ↓↓↓ 모달영역 ↓↓↓                                                              --%>


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

<!-- editModal -->
<div class="modal" id="editModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">센서 수정</h5>
            </div>
            <div class="modal-body d-flex justify-content-evenly">
                <div>
                    <h4>코드</h4>
                    <h4>항목명</h4>
                    <h4>연간배출 허용기준</h4>
                    <h4>배출허용 기준농도</h4>
                    <h4>산출식</h4>
                </div>
                <div>
                    <input type="text" class="text-secondary d-block mb-2">
                    <input type="text" class="text-secondary d-block mb-2">
                    <input type="text" class="text-secondary d-block mb-2">
                    <input type="text" class="text-secondary d-block mb-2">
                    <input type="text" class="text-secondary d-block ">
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5">수정</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>


<!-- deleteModal -->
<div class="modal" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">항목 삭제</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <h3>@@@ 정말 삭제하시겠습니까?</h3>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-danger me-5">삭제</button>
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
                <h5 class="modal-title">회원 관리</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <div class="text-center">
                    <c:set var="member" value="${member}"/>
                    <c:if test="${member.state == '1'}">
                        <button class="btn btn-secondary fw-bold fs-4 px-5 mt-3" data-bs-toggle="modal"
                                data-bs-target="#userGrantManagementModal">회원 권한 관리
                        </button>
                    </c:if>
                    <button class="btn btn-primary fw-bold fs-4 px-5 mt-3" data-bs-toggle="modal"
                            data-bs-target="#userPwdmodal">회원 비밀번호 초기화
                    </button>
                    <button class="btn btn-danger fw-bold fs-4 px-5 mt-3" data-bs-toggle="modal"
                            data-bs-target="#userExpulsionmodal">회원 제명
                    </button>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">확인</button>
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
                <h5 class="modal-title">비밀번호 초기화</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <div class="text-center">
                    <p class="fs-3 fw-bold">비밀번호를 초기화 하시겠습니까?</p>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-primary me-5" data-bs-dismiss="modal" onclick="resetPassword()">초기화
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
                    <p class="fs-3 fw-bold">회원을 제명 하시겠습니까?</p>
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
<!-- userGrantManagementModal -->
<div class="modal" id="userGrantManagementModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">회원 권한 관리</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <div class="text-center">
                    <button class="btn btn-secondary fw-bold fs-4 px-5 mt-3" data-bs-dismiss="modal" value="3"
                            onclick="gave_Rank(value)">일반회원 등급부여
                    </button>
                    <button class="btn btn-secondary fw-bold fs-4 px-5 mt-3" data-bs-dismiss="modal" value="2"
                            onclick="gave_Rank(value)">관리자 등급부여
                    </button>
                    <button class="btn btn-secondary fw-bold fs-4 px-5 mt-3" data-bs-dismiss="modal" value="1"
                            onclick="gave_Rank(value)">최고관리자 등급부여
                    </button>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">확인</button>
            </div>
        </div>
    </div>
</div>
<%--                                           ↑↑↑ 모달영역 ↑↑↑                                                              --%>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>

    $("#member-Table").DataTable({
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
        pageLength: 10,
        info: false,
        lengthChange : false,
    });

    var ID = ""; //데이터테이블 해당항목의 ID정보
    var state = ""; //해당항목의 등급 정보
    var rName = "root"; // 권한관리영역 checkBox 변수
    var user_state = "${member.state}"; // 페이지에 접근한 유저의 등급정보
    var user_id = "${member.id}"; // 페이지에 접근한 유저의 ID

    $(document).ready(function () {
        rankRadioChanged("root"); //기본값
    }); //ready

    function Info_Set(str_id, str_state) {
        ID = str_id;
        state = str_state;
    }// row 의 승인 및 거절 버튼 클릭시 전역변수 ID에 해당row 의 ID가 저장됨

    function sing_Up(iNumber) {
        var content = ID;
        if (iNumber == "1") {
            content += " 계정 가입승인 ";
        } else {
            content += " 계정 가입거절 ";
        }
        var settings = {
            "url": "<%=cp%>/signUp?id=" + ID + "&iNumber=" + iNumber,
            "method": "POST"
        };
        $.ajax(settings).done(function (response) {
            if (iNumber == "1") {
                inputLog(ID, "가입 승인 처리", "회원관리"); // 대상자로그
            } else {
                inputLog(ID, "가입 거부 처리", "회원관리");
            }
            inputLog(user_id, content, "회원관리"); // 관리자로그
            success(response);
            setTimeout(function () {
                location.reload();
            }, 2000);
        })
    }           // sing_Up

    function gave_Rank(value) {
        var str = (value == 1) ? "최고관리자 등급 " : (value == 2) ? "관리자 등급 " : "일반 등급 ";
        var settings = {
            "url": "<%=cp%>/gaveRank?id=" + ID + "&value=" + value,
            "method": "POST"
        };
        $.ajax(settings).done(function (response) {
            inputLog(ID, str + "변경", "권한관리");
            inputLog(user_id, ID + " 계정 " + str + "변경 처리", "권한관리");
            success(response);
            setTimeout(function () {
                location.reload();
            }, 2000);
        });
    }           // gave_Rank

    function resetPassword() {
        if (state == '1') {
            warning("최고관리자의 비밀번호는 초기화하실수 없습니다.");
            return;
        } else {
            var settings = {
                "url": "<%=cp%>/resetPassword?id=" + ID,
                "method": "POST"
            };
            $.ajax(settings).done(function (response) {
                inputLog(ID, "비밀번호 초기화", "회원관리");
                inputLog(user_id, ID + " 계정 비밀번호 초기화 처리", "회원관리");
                Swal.fire({
                    icon: 'success',
                    title: '비밀번호 초기화가 완료되었습니다.',
                    text: "임시비밀번호 : "+ response
                })
            });
        }
    }           // resetPassword

    function kickMember() {
        if (state == '1') {
            warning("최고관리자는 제명하실수 없습니다.");
            return;
        } else {
            var settings = {
                "url": "<%=cp%>/kickMember?id=" + ID,
                "method": "POST"
            };
            $.ajax(settings).done(function (response) {
                inputLog(user_id, ID + " 계정 제명처리", "회원관리");
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
            if(rName == "root"){
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
            for(var i=0; i < strs.length; i++){
                if(strs[i] != ""){
                    inputLog(user_id, content + strs[i], "권한관리");
                }
            }
            success("권한관리 설정이 저장되었습니다.");

            setTimeout(function () {
                location.reload();
            }, 2000);
        });
    }       //rankSettingSave


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


</script>






