<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 11:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    pageContext.setAttribute("br", "<br/>");
    pageContext.setAttribute("cn", "\n");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="static/css/datepicker.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js"></script>

<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script src="static/js/datepicker.min.js"></script>
<script src="static/js/datepicker.ko.js"></script>


<style>
    .mg1 {
        margin-right: 50px;
    }

    .mdd {
        text-align-last: center;
        width: 223px;
        height: 31px;
    }

    .dd {
        text-align-last: center;
        width: 150px;
        height: 30px;
    }
</style>
<body>

<div class="container">
    <div class="row">

        <div class="d-flex justify-content-between my-3">
            <h3>센서 관리</h3>
            <!-- Button trigger modal -->
            <button class="btn btn-success" data-toggle="modal" data-target="#addModal">센서 추가</button>
        </div>

        <div class="col-xs-12 bg-light rounded border border-dark-1 my-1 d-flex justify-content-center">

            <div>
                <div class="d-flex justify-content-center my-2 ">
                    <h4 class="me-3 ms-5 ">분류</h4>
                    <select name="dropdown1" class="btn-secondary rounded-3 dd">
                        <option value="1">전체</option>
                        <option value="2">먼지</option>
                        <option value="3">아황산가스</option>
                    </select>

                    <h4 class="mx-5">측정소</h4>
                    <select name="dropdown2" class="btn-secondary rounded-3 dd">
                        <option value="1">전체</option>
                        <option value="2">측정소1</option>
                        <option value="3">측정소2</option>
                    </select>
                </div>

                <div class="d-flex justify-content-center my-2">
                    <h4 class="me-3">센서관리ID</h4>
                    <input type="text" class="text-secondary rounded-3  dd mg1">

                    <h4 class="me-3">테이블명</h4>
                    <input type="text" class="text-secondary rounded-3 dd">
                </div>

                <div class="d-flex justify-content-center my-2">
                    <h4 class="me-3">업데이트일</h4>
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
                </div>
            </div>

            <button class="btn btn-success ms-5 my-auto px-4 fs-6">검색</button>

        </div>

        <div class="col-xs-12 bg-light rounded border border-dark-1">
            <table class="table table-striped">
                <thead>
                <tr>
                    <th scope="col">순번<i class="fas fa-sort"></i></th>
                    <th scope="col">분류<i class="fas fa-sort"></i></th>
                    <th scope="col">한글명<i class="fas fa-sort"></i></th>
                    <th scope="col">센서관리ID<i class="fas fa-sort"></i></th>
                    <th scope="col">테이블명<i class="fas fa-sort"></i></th>
                    <th scope="col">업데이트<i class="fas fa-sort"></i></th>
                    <th scope="col">측정소<i class="fas fa-sort"></i></th>
                    <th scope="col">통신상태</th>
                    <th scope="col">관리</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th scope="row">1</th>
                    <td>Mark</td>
                    <td>Otto</td>
                    <td>@mdo</td>
                    <td>Mark</td>
                    <td>Otto</td>
                    <td>@mdo</td>
                    <td><i class="fas fa-circle ms-4 text-success"></i></td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#checkModal"></i>
                    </td>
                </tr>
                <tr>
                    <th scope="row">2</th>
                    <td>Jacob</td>
                    <td>Thornton</td>
                    <td>@fat</td>
                    <td>Thornton</td>
                    <td>@fat</td>
                    <td>Thornton</td>
                    <td><i class="fas fa-circle ms-4 text-danger"></i></td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#checkModal"></i>
                    </td>
                </tr>
                <tr>
                    <th scope="row">3</th>
                    <td colspan="2">Larry the Bird</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td><i class="fas fa-circle ms-4 text-success"></i></td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#checkModal"></i>
                    </td>
                </tr>
                <tr>
                    <th scope="row">4</th>
                    <td colspan="2">Larry the Bird</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td><i class="fas fa-circle ms-4 text-success"></i></td>
                    <td>
                        <i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>
                        <i class="fas fa-times" data-toggle="modal" data-target="#checkModal"></i>
                    </td>
                </tr>
                <tr>
                    <th scope="row">5</th>
                    <td colspan="2">Larry the Bird</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                </tr>
                <tr>
                    <th scope="row">6</th>
                    <td colspan="2">Larry the Bird</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                </tr>
                <tr>
                    <th scope="row">7</th>
                    <td colspan="2">Larry the Bird</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                </tr>
                <tr>
                    <th scope="row">8</th>
                    <td colspan="2">Larry the Bird</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                </tr>
                <tr>
                    <th scope="row">9</th>
                    <td colspan="2">Larry the Bird</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- addModal -->
<div class="modal" id="addModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">센서 추가</h5>
            </div>
            <div class="modal-body d-flex justify-content-evenly">
                <div>
                    <h4>분류</h4>
                    <h4>한글명</h4>
                    <h4>센서관리ID</h4>
                    <h4>테이블명</h4>
                </div>
                <div>
                    <select name="modalDropdown1" class="btn-secondary rounded-3 mdd mb-2">
                        <option value="1">전체</option>
                        <option value="2">먼지</option>
                        <option value="3">아황산가스</option>
                    </select>
                    <input type="text" class="text-secondary d-block mb-2">
                    <input type="text" class="text-secondary d-block mb-2">
                    <input type="text" class="text-secondary d-block ">
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5">추가</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- editModal -->
<div class="modal" id="editModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">@@@ 센서 수정</h5>
            </div>
            <div class="modal-body d-flex justify-content-evenly">
                <div>
                    <h4>분류</h4>
                    <h4>한글명</h4>
                    <h4>센서관리ID</h4>
                    <h4>테이블명</h4>
                </div>
                <div>
                    <select name="modalDropdown1" class="btn-secondary rounded-3 mdd mb-2">
                        <option value="1">전체</option>
                        <option value="2">먼지</option>
                        <option value="3">아황산가스</option>
                    </select>
                    <input type="text" class="text-secondary d-block mb-2">
                    <input type="text" class="text-secondary d-block mb-2">
                    <input type="text" class="text-secondary d-block ">
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5">수정</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- checkModal -->
<div class="modal" id="checkModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">센서 삭제</h5>
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


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
<script>
    $(function () {
        $('.modal-dialog').draggable({handle: ".modal-header"});
    });
</script>

<script charset="UTF-8">

    $('#btn1').click(function () {
        var modalDiv = $('#myModal');
        modalDiv.modal({backdrop: false, show: true});
        $('.modal-dialog').draggable({handle: ".modal-header"});
    });


    $(document).ready(function () {
        $("#date_start").val(getWeekAgo());
        $("#date_end").val(getToday());
    });

    $("#date_start").datepicker({
        language: 'ko',
        maxDate: new Date()
        //timepicker: true,
        //timeFormat: "hh:ii AA"
    });
    $("#date_end").datepicker({
        language: 'ko',
        maxDate: new Date()
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

    $("input:radio[name=day]").click(function () {

        $("#date_start").val("");
        $("#date_end").val("");

        const id = $(this).attr('id');

        if (id == 'custom') {
            $("#date_start").attr('disabled', false);
            $("#date_end").attr('disabled', false);
        } else {
            $("#date_start").attr('disabled', true);
            $("#date_end").attr('disabled', true);

            $("#date_end").val(getToday());

            if (id == 'week') {
                $("#date_start").val(getWeekAgo());
            } else if (id == 'month') {
                $("#date_start").val(getMonthAgo());
            }

        }
    });

    $('#placeName').click(function () {
        const placeName = 'point1';
        // $(this).val();

        $.ajax({
            url: '<%=cp%>/getPalceSensor',
            type: 'POST',
            dataType: 'text',
            async: false,
            cache: false,
            data: {"name": placeName},
            success: function (data) { // 결과 성공 콜백함수
                console.log(data);
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })

    });

    function search() {
        const date_start = $('#date_start').val();
        const date_end = $('#date_end').val();
        const item = 'tmsWP001_dust_01'; // $('input:radio[name="item"]:checked').val();
        const off = $('#off').is(":checked"); // false : 선택안됨(표시X) , true : 선택(표시)

        $.ajax({
            url: '<%=cp%>/scarchChart',
            type: 'POST',
            dataType: 'text',
            async: false,
            cache: false,
            data: {
                "date_start": date_start,
                "date_end": date_end,
                "item": item,
                "off": off,
            },
            success: function (data) { // 결과 성공 콜백함수
                console.log(data);
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        })

    }

    function getToday() {
        const date = new Date();
        const year = date.getFullYear();
        const month = ("0" + (1 + date.getMonth())).slice(-2);
        const day = ("0" + date.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }

    function getMonthAgo() {
        const date = new Date();

        const oneMonthAgo = new Date(date.setMonth(date.getMonth() - 1));

        const year = oneMonthAgo.getFullYear();
        const month = ("0" + (1 + oneMonthAgo.getMonth())).slice(-2);
        const day = ("0" + oneMonthAgo.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }

    function getWeekAgo() {
        const date = new Date();

        const oneMonthAgo = new Date(date.setDate(date.getDate() - 7));

        const year = oneMonthAgo.getFullYear();
        const month = ("0" + (1 + oneMonthAgo.getMonth())).slice(-2);
        const day = ("0" + oneMonthAgo.getDate()).slice(-2);

        return year + "-" + month + "-" + day;
    }
</script>






