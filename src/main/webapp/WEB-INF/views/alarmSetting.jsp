<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 11:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>


<style>
    .bg-lightGray {
        background: lightgrey;
    }

    .station:hover {
        background: #0275d8;
    }

    .ddd {
        height: 89%;
    }
    .time{
        width: 135px;
        height: 40px;
        font-size: 20px;
    }
    .checkBox{
        zoom: 1.5;
        margin-top: 5px;
    }
</style>
<body>


<div class="container">

    <div class="d-flex justify-content-end m-2">

        <h4 class="my-3 me-4">알림시간</h4>

        <div>
            <p class="text-secondary">Start Time</p>
            <input type="time" class="rounded btn-outline-primary me-4 time" id="startTime">
        </div>
        <div class="bg-dark me-4" style="width: 1px"></div>
        <div>
            <p class="text-secondary">End Time</p>
            <input type="time" class="rounded btn-outline-primary time" id="endTime">
        </div>

        <button class="btn-success fs-5 h-25 rounded ms-3 mt-3">설정</button>

    </div>

    <div class="row">
        <div class="col-md-3 bg-lightGray p-5 rounded">
            <h2 class="pb-3 text-center rounded p-2 station">측정소 1</h2>
            <h2 class="pb-3 text-center rounded p-2 station">측정소 2</h2>
            <h2 class="pb-3 text-center rounded p-2 station">측정소 3</h2>
        </div>
        <div class="col-md-9 ">
            <div class="d-flex justify-content-between bg-light border border-dark-1 p-1 rounded">
                <h2>알림 목록</h2>

                <div class="bg-light p-1">
                    <label class="label me-1">센서목록</label>
                    <input type="checkbox" class="check-box position-relative me-2" style="zoom: 1.5; top:3px;" id="chkAll">
                    <label class="label me-1">전체선택</label>
                    <button class="btn btn-primary px-3" id="bOn">ON</button>
                    <button class="btn btn-primary" id="bOff">OFF</button>
                </div>
            </div>

            <div class="border border-dark-1 bg-light d-flex justify-content-between">
                <table class="table border border-end-1 w-50">
                    <tbody>
                    <tr>
                        <td><input type="checkbox" class="checkBox"></td>
                        <td class="fs-5">먼지</td>
                        <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="checkBox"></td>
                        <td class="fs-5">질소산화물</td>
                        <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="checkBox"></td>
                        <td class="fs-5">염화수소</td>
                        <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="checkBox"></td>
                        <td class="fs-5">불화수소</td>
                        <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="checkBox"></td>
                        <td class="fs-5">암모니아</td>
                        <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="checkBox"></td>
                        <td class="fs-5">일산화탄소</td>
                        <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="checkBox"></td>
                        <td class="fs-5">산소</td>
                        <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" class="checkBox"></td>
                        <td class="fs-5">아황산가스</td>
                        <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                    </tr>
                    </tbody>
                </table>

                    <table class="table w-50">
                        <tbody>
                        <tr>
                            <td><input type="checkbox" class="checkBox"></td>
                            <td class="fs-5">온도</td>
                            <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="checkBox"></td>
                            <td class="fs-5">온도</td>
                            <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="checkBox"></td>
                            <td class="fs-5">노내온도1</td>
                            <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="checkBox"></td>
                            <td class="fs-5">노내온도2</td>
                            <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="checkBox"></td>
                            <td class="fs-5">노내온도3</td>
                            <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="checkBox"></td>
                            <td class="fs-5">노내온도4</td>
                            <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" class="checkBox"></td>
                            <td class="fs-5">온도</td>
                            <td><div class="form-check form-switch fs-4"> <input class="form-check-input alarmSlide" type="checkbox"></div></td>
                        </tr>
                        </tbody>
                    </table>

            </div>
        </div>
    </div>

    <h3 class="d-flex justify-content-start my-3">이벤트 로그 알림 설정</h3>
    <div class="row bg-lightGray p-3 d-flex justify-content-between rounded">

        <div class="w-50">
            <h5 class="d-flex justify-content-start">로그인 / 로그아웃</h5>
            <div class="col-md-6 bg-light d-flex justify-content-between py-3 px-5 w-auto rounded ddd">
                <div>
                    <h4>로그인</h4>
                    <h4>로그아웃</h4>
                </div>

                <div>
                    <div class="form-check form-switch fs-4">
                        <input class="form-check-input" type="checkbox" id="loginSwitch">
                    </div>
                    <div class="form-check form-switch fs-4 mt-3">
                        <input class="form-check-input" type="checkbox" id="logoutSwitch">
                    </div>
                </div>
            </div>
        </div>

        <div class="w-50">
            <h5 class="d-flex justify-content-start">컨트롤</h5>
            <div class="col-md-6 bg-light d-flex justify-content-between py-3 px-5 w-auto rounded">
                <div>
                    <h4>페이지 이동</h4>
                    <h4>알림 설정 변경</h4>
                    <h4>기준 값 설정 변경</h4>
                    <h4>모니터링 on/off 변경</h4>
                    <h4>파일 다운로드 로그</h4>
                    <h4>측정자료 검색</h4>
                </div>

                <div>
                    <div class="form-check form-switch fs-4">
                        <input class="form-check-input" type="checkbox">
                    </div>
                    <div class="form-check form-switch fs-4 mt-3">
                        <input class="form-check-input" type="checkbox">
                    </div>
                    <div class="form-check form-switch fs-4 mt-3">
                        <input class="form-check-input" type="checkbox">
                    </div>
                    <div class="form-check form-switch fs-4 mt-3">
                        <input class="form-check-input" type="checkbox">
                    </div>
                    <div class="form-check form-switch fs-4 mt-3">
                        <input class="form-check-input" type="checkbox">
                    </div>
                    <div class="form-check form-switch fs-4 mt-3">
                        <input class="form-check-input" type="checkbox">
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>


<script charset="UTF-8">

    //체크박스 전체 선택, 해제
    $('#chkAll').click(function () {
        if($('#chkAll').is(":checked")){
            $(".checkBox").prop("checked", true);
        }
        else{
            $(".checkBox").prop("checked", false);
        }

    });

    $('#bOn').click(function () {
        if( $(".checkBox").is(":checked")){
            $(".alarmSlide").prop("checked", true);
        }
    });

    $('#bOff').click(function () {
        if( $(".checkBox").is(":checked")){
            $(".alarmSlide").prop("checked", false);
        }
    });
</script>






