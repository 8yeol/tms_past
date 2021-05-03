<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
<link rel="stylesheet" href="static/css/jquery.dataTables.min.css">

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="static/js/jquery.dataTables.min.js"></script>

<style>
    .bg-lightGray {
        background: lightgrey;
    }

    hr {
        color: white;
    }
</style>

<script type="text/javascript">
    jQuery(function ($) {
        $("#member-Table").DataTable({
            "language": {
                "emptyTable": "데이터가 없어요.",
                "lengthMenu": "페이지당 _MENU_ 개씩 보기",
                "info": "현재 _START_ - _END_ / _TOTAL_건",
                "infoEmpty": "데이터 없음",
                "infoFiltered": "( _MAX_건의 데이터에서 필터링됨 )",
                "search": "전체검색 : ",
                "zeroRecords": "일치하는 데이터가 없어요.",
                "loadingRecords": "로딩중...",
                "processing": "잠시만 기다려 주세요...",
                "paginate": {
                    "next": "다음",
                    "previous": "이전"
                },
            },
            pageLength: 10
        });
    });
</script>
<body>

<div class="container">

    <h3 class="d-flex justify-content-start mt-5 mb-3 fw-bold">환경설정 > 설정</h3>
    <div class="row bg-light rounded py-3 px-5">
        <h4 class="d-flex justify-content-start">회원관리</h4>
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
                    <tr class="text-center" style="font-size: 14px">
                        <td>${cnt.index+1}</td>
                        <td>${mList.id}</td>
                        <td>${mList.name}</td>
                        <c:choose>
                            <c:when test="${mList.state eq '0'}">
                                <td class="text-danger">거절</td>
                            </c:when>
                            <c:when test="${mList.state eq '1'}">
                                <td>가입대기</td>
                            </c:when>
                            <c:when test="${mList.state eq '2'}">
                                <td>일반</td>
                            </c:when>
                            <c:when test="${mList.state eq '3'}">
                                <td>관리자</td>
                            </c:when>
                            <c:when test="${mList.state eq '4'}">
                                <td>최고 관리자</td>
                            </c:when>
                        </c:choose>
                        <td>${mList.email}</td>
                        <td>${mList.tel}</td>
                        <td><fmt:formatDate value="${mList._id.date}" pattern="yyyy년 MM월 dd일 hh시"/></td>


                        <c:choose>
                            <c:when test="${mList.joined != null}">
                                <td><fmt:formatDate value="${mList.joined}" pattern="yyyy년 MM월 dd일 hh시"/></td>
                            </c:when>
                            <c:otherwise>
                                <td></td>
                            </c:otherwise>
                        </c:choose>

                        <td><%--최종로그인--%></td>
                        <c:choose>
                            <c:when test="${mList.state eq '1'}">
                                <td>
                                    <button class="btn btn-success py-0 px-2" style="font-size: 12px;"
                                            data-toggle="modal" data-target="#okModal"
                                            onclick="ID_Set('${mList.id}')">승인
                                    </button>
                                    <button class="btn btn-danger py-0 px-2" style="font-size: 12px;"
                                            data-toggle="modal" data-target="#noModal"
                                            onclick="ID_Set('${mList.id}')">거절
                                    </button>
                                </td>
                            </c:when>
                            <c:when test="${mList.state eq '2' || mList.state eq '3' || mList.state eq '4'}">
                                <td>
                                    <i class="fas fa-edit d-flex justify-content-center btn p-0" data-toggle="modal"
                                       data-target="#managementModal" onclick="ID_Set('${mList.id}')"></i>
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

        <h4 class="d-flex justify-content-start">권한관리</h4>
        <div class="d-flex mt-1 p-0">

            <div class="col-md-3">
                <div class="bg-lightGray p-4 me-4 fw-bold h-100">
                    <div class="d-flex justify-content-start">
                        <input type="radio" class="form-check-input me-2" name="grandRadio" id="root"
                               onclick="rankRadioChanged(id)" checked>
                        <p>최고 관리자</p>
                    </div>
                    <div class="d-flex justify-content-start mt-4">
                        <input type="radio" class="form-check-input me-2" name="grandRadio" id="admin"
                               onclick="rankRadioChanged(id)">
                        <p>관리자</p>
                    </div>
                    <div class="d-flex justify-content-start mt-4">
                        <input type="radio" class="form-check-input me-2" name="grandRadio" id="normal"
                               onclick="rankRadioChanged(id)">
                        <p>일반</p>
                    </div>
                </div>
            </div>

            <div class="col-md-9">
                <div class="bg-lightGray p-4 d-flex justify-content-between fw-bold">
                    <div>
                        <div class="d-flex justify-content-start">
                            <input type="checkbox" class="form-check-input me-2 " id="dashBoardChk">
                            <p>대시보드 메뉴 열람</p>
                        </div>
                        <div class="d-flex justify-content-start mt-4">
                            <input type="checkbox" class="form-check-input me-2" id="alarmChk">
                            <p>알림 메뉴 열람</p>
                        </div>
                        <div class="d-flex justify-content-start mt-4">
                            <input type="checkbox" class="form-check-input me-2" id="monitoringChk">
                            <p>모니터링 메뉴 열람</p>
                        </div>
                        <div class="d-flex justify-content-start mt-4">
                            <input type="checkbox" class="form-check-input me-2" id="statisticsChk">
                            <p>분석 및 통계 메뉴 열람</p>
                        </div>
                        <div class="d-flex justify-content-start mt-4">
                            <input type="checkbox" class="form-check-input me-2" id="settingChk">
                            <p>환경설정 메뉴 열람</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-end">
                        <button class="btn btn-primary align-text-bottom me-2 mb-2 py-1 px-3 fw-bold fs-6" onclick="rankSettingSave()">저장</button>
                    </div>
                </div>
            </div>

        </div>

    </div>
    <%--권한관리 DIV--%>

</div>

<%--    <div class="row">
        <h4 class="d-flex justify-content-start mt-5">연간 배출 허용 기준 설정</h4>
        <div class="col-xs-12 bg-light">
            <table class="table table-striped">

                <thead>
                <tr>
                    <th>NO</th>
                    <th>코드</th>
                    <th>항목명</th>
                    <th>연간 배출 허용 기준</th>
                    <th>배출 허용 기준 농도</th>
                    <th>산출식(참고용)</th>
                    <th>관리</th>
                </tr>
                </thead>

                <tbody>
                <tr>
                    <th>1</th>
                    <td>TSP</td>
                    <td>먼지</td>
                    <td>1,500,000,000</td>
                    <td>15</td>
                    <td>일일유량x배출허용기준초과농도x10⁶</td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#deleteModal"></i>
                    </td>
                </tr>
                <tr>
                    <th>2</th>
                    <td>SO2</td>
                    <td>아황산가스</td>
                    <td>1,500,000,000</td>
                    <td>50</td>
                    <td>일일유량x배출허용기준초과농도x10⁶x76%22.4</td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#deleteModal"></i>
                    </td>
                </tr>
                <tr>
                    <th>3</th>
                    <td>NOX</td>
                    <td>질소산화물</td>
                    <td>1,500,000,000</td>
                    <td>25</td>
                    <td>일일유량x배출허용기준초과농도x10⁶x46%22.4</td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#deleteModal"></i>
                    </td>
                </tr>
                <tr>
                    <th>4</th>
                    <td>dummy</td>
                    <td>Dummy</td>
                    <td>1,500,000,000</td>
                    <td>25</td>
                    <td>일일유량x배출허용기준초과농도x10⁶</td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#deleteModal"></i>
                    </td>
                </tr>
                <tr>
                    <th>4</th>
                    <td>dummy</td>
                    <td>Dummy</td>
                    <td>1,500,000,000</td>
                    <td>25</td>
                    <td>일일유량x배출허용기준초과농도x10⁶</td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#deleteModal"></i>
                    </td>
                </tr>
                <tr>
                    <th>5</th>
                    <td>dummy</td>
                    <td>Dummy</td>
                    <td>1,500,000,000</td>
                    <td>25</td>
                    <td>일일유량x배출허용기준초과농도x10⁶</td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#deleteModal"></i>
                    </td>
                </tr>
                <tr>
                    <th>6</th>
                    <td>dummy</td>
                    <td>Dummy</td>
                    <td>1,500,000,000</td>
                    <td>25</td>
                    <td>일일유량x배출허용기준초과농도x10⁶</td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#deleteModal"></i>
                    </td>
                </tr>
                <tr>
                    <th>7</th>
                    <td>dummy</td>
                    <td>Dummy</td>
                    <td>1,500,000,000</td>
                    <td>25</td>
                    <td>일일유량x배출허용기준초과농도x10⁶</td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#deleteModal"></i>
                    </td>
                </tr>
                </tbody>

            </table>
        </div>
    </div>--%>

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
                <button type="button" class="btn btn-success me-5" data-dismiss="modal" value="1"
                        onclick="sing_Up(value)">승인
                </button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
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
                <button type="button" class="btn btn-danger me-5" data-dismiss="modal" value="0"
                        onclick="sing_Up(value)">거절
                </button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
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
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
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
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
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
                    <button class="btn btn-secondary fw-bold fs-4 px-5 mt-3" data-toggle="modal"
                            data-target="#userGrantManagementModal">회원 권한 관리
                    </button>
                    <button class="btn btn-primary fw-bold fs-4 px-5 mt-3" data-toggle="modal"
                            data-target="#userPwdmodal">회원 비밀번호 초기화
                    </button>
                    <button class="btn btn-danger fw-bold fs-4 px-5 mt-3" data-toggle="modal"
                            data-target="#userExpulsionmodal">회원 추방
                    </button>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">확인</button>
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
                <button type="button" class="btn btn-primary me-5" data-dismiss="modal" onclick="resetPassword()">초기화
                </button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
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
                <h5 class="modal-title">회원 추방</h5>
            </div>
            <div class="modal-body d-flex justify-content-center">
                <div class="text-center">
                    <p class="fs-3 fw-bold">회원을 추방 하시겠습니까?</p>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-danger me-5" data-dismiss="modal" onclick="kickMember()">추방
                </button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
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
                    <button class="btn btn-secondary fw-bold fs-4 px-5 mt-3" data-dismiss="modal" value="2"
                            onclick="gave_Rank(value)">일반회원 등급부여
                    </button>
                    <button class="btn btn-secondary fw-bold fs-4 px-5 mt-3" data-dismiss="modal" value="3"
                            onclick="gave_Rank(value)">관리자 등급부여
                    </button>
                    <button class="btn btn-secondary fw-bold fs-4 px-5 mt-3" data-dismiss="modal" value="4"
                            onclick="gave_Rank(value)">최고관리자 등급부여
                    </button>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">확인</button>
            </div>
        </div>
    </div>
</div>

<%--                                           ↑↑↑ 모달영역 ↑↑↑                                                              --%>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>

<script>
    $(document).ready(function () {
        rankRadioChanged("root"); //기본값
    }); //ready

    var ID = ""; //사용자 ID 변수
    var rName = "root"; // 권한관리 name 변수 기본값 root

    function ID_Set(str_id) {
        ID = str_id;
    }// row 의 승인 및 거절 버튼 클릭시 전역변수 ID에 해당row 의 ID가 저장됨

    function sing_Up(iNumber) {
        var settings = {
            "url": "http://localhost:8090/signUp?id=" + ID + "&iNumber=" + iNumber,
            "method": "POST"
        };
        $.ajax(settings).done(function (response) {
            alert(response);
            location.reload();
        });
    }           // sing_Up

    function gave_Rank(value) {
        var settings = {
            "url": "http://localhost:8090/gaveRank?id=" + ID + "&value=" + value,
            "method": "POST"
        };
        $.ajax(settings).done(function (response) {
            alert(response);
            location.reload();
        });
    }           // gave_Rank

    function resetPassword() {
        var settings = {
            "url": "http://localhost:8090/resetPassword?id=" + ID,
            "method": "POST"
        };
        $.ajax(settings).done(function (response) {
            alert(response);
            location.reload();
        });
    }           // gave_Rank

    function kickMember() {
        var settings = {
            "url": "http://localhost:8090/kickMember?id=" + ID,
            "method": "POST"
        };
        $.ajax(settings).done(function (response) {
            alert(response);
            location.reload();
        });
    }           // kickMember

    function rankRadioChanged(name) {
        rName = name;
        <c:forEach items="${rank_managements}" var="rank_managements">
        var rankName = "${rank_managements.name}";
        if (name == rankName) {
            $("#dashBoardChk").prop("checked", ("${rank_managements.dashboard}" == "true") ? true : false);
            $("#alarmChk").prop("checked", ("${rank_managements.alarm}" == "true") ? true : false);
            $("#monitoringChk").prop("checked", ("${rank_managements.monitoring}" == "true") ? true : false);
            $("#statisticsChk").prop("checked", ("${rank_managements.statistics}" == "true") ? true : false);
            $("#settingChk").prop("checked", ("${rank_managements.setting}" == "true") ? true : false);
        }
        </c:forEach>
    }       //rankRadioChanged

    function rankSettingSave(){
        var dashboard = $('#dashBoardChk').prop("checked");
        var alarm = $('#alarmChk').prop("checked");
        var monitoring = $('#monitoringChk').prop("checked");
        var statistics = $('#statisticsChk').prop("checked");
        var setting = $('#settingChk').prop("checked");
        var settings = {
            "url": "http://localhost:8090/rankSettingSave",
            "method": "POST",
            "headers": {
                "accept": "application/json",
                "content-type": "application/json;charset=UTF-8"
            },
            "data": "{\r\n    \"name\": \""+rName+"\"," +
                "\r\n    \"dashboard\": "+dashboard+"," +
                "\r\n    \"alarm\": "+alarm+"," +
                "\r\n    \"monitoring\": "+monitoring+"," +
                "\r\n    \"statistics\": "+statistics+"," +
                "\r\n    \"setting\": "+setting+"\r\n}",
        };
        $.ajax(settings).success(function (response) {
            alert("권한관리 설정이 저장되었습니다.");
            location.reload();
        });
    }       //rankSettingSave


    $(function () {
        $('.modal-dialog').draggable({handle: ".modal-header"});
    });         // modal drag and drop move


</script>






