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
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="static/css/sweetalert2.min.css">

<script src="static/js/sweetalert2.min.js"></script>
<script src="static/js/common/common.js"></script>
<script src="static/js/popper.min.js"></script>
<script src="static/js/jquery-ui.js"></script>

<style>
    .multiSelectComboBox {
        margin-top: 60px;
        width: 100%;
        display: flex;
        justify-content: center;
        margin-bottom: -60px;
    }

    .multiSelectParent {
        margin-left: 30px;
        margin-right: 30px;
        position: relative;
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
        width: 300px;
        height: 55px;
        border-radius: 10px;
        background-color: rgba(99, 130, 255, 0.7);
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -40%);
        text-align: center;
        color: white;
        font-weight: bold;
        display: none;

    }

    .multiSelect {
        width: 280px;
        height: 400px;
    }

    .form-control {
        height: 300px;
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

</style>

<div class="container">
    <div class="row">
        <div class="row1">
            <span>연간 배출 허용 기준 설정</span>
            <button data-toggle="modal" data-target="#addModal" onclick="inputClean()"
                    style="background-color:green;color:white"> 추가
            </button>
        </div>
        <div class="row2">
            <span>* 설정된 연간 배출 허용 기준 값은 [대시보드 - 연간 배출량 누적 모니터링]의 누적 배출량 계산에 활용됩니다.</span>
        </div>
        <div class="col-xs-12 bg-light">
            <table class="table table-striped">

                <thead>
                <tr>
                    <th>코드</th>
                    <th>항목명</th>
                    <th>연간 배출 허용 기준</th>
                    <th>배출 허용 기준 농도</th>
                    <th>산출식(참고용)</th>
                    <th>관리</th>
                </tr>
                </thead>

                <tbody id="tbody">
                <c:forEach items="${standard}" var="standard" varStatus="i">
                    <tr>
                        <td>${standard.sensorCode}</td>
                        <td>${standard.sensorNaming}</td>
                        <td><fmt:formatNumber value="${standard.yearlyStandard}" groupingUsed="true"/></td>
                        <td>${standard.percent}</td>
                        <td>${standard.formula}</td>
                        <td>
                            <i onclick="editModalSetting(this)" class="fas fa-edit me-2"  data-bs-toggle="modal" data-bs-target="#addModal"></i>
                            <i class="fas fa-times" onclick="deleteModal(this)"></i>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>

            </table>
            <!--  Standard == null -->
            <c:if test="${empty standard}">
                    <div class="pt-4 pb-4" style="text-align: center;font-size: 1.2rem;"id="nullStandard">
                        연간 배출 허용 기준이 없습니다. <br>
                        <b>추가</b> 버튼으로 허용 기준을 설정 해주세요.
                    </div>
            </c:if>
        </div>
    </div>
</div>
</div>

<!--멀티셀렉터 콤보박스 -->
<div class="multiSelectComboBox">
    <div class="multiSelectParent">
        <h4>배출량 추이 모니터링 대상 설정</h4><br>
        <div class="multiSelect">
            <label><b>전체 항목</b></label>
            <select multiple class="form-control" id="lstBox1">
                <c:forEach items="${emissions}" var="target">
                    <c:if test="${target.status eq 'false'}">
                        <option id="${target.sensor}">${target.place} - ${target.sensorNaming}
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </div>

        <div class="multiSelectBtn">
            <br/><br/><br/><br/><br/>
            <input type='button' id='btnRight' value='>' class="btn btn-default"
                   onclick="moveEvent('#lstBox1', '#lstBox2')"/><br/>
            <input type='button' id='btnLeft' value='<' class="btn btn-default"
                   onclick="moveEvent('#lstBox2', '#lstBox1')"/><br/>
        </div>

        <div class="multiSelect">
            <label><b>대상 가스</b></label>
            <select multiple class="form-control" id="lstBox2">
                <c:forEach items="${emissions}" var="target">
                    <c:if test="${target.status eq 'true'}">
                        <option id="${target.sensor}">${target.place} - ${target.sensorNaming}
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </div>
        <div class="clearfix"></div>

        <!-- MultiSelecter Modal-->
        <div class="MultiSelecterModal" id="emissionsModal"></div>
    </div>

    <div class="multiSelectParent">
        <h4>연간 배출량 누적 모니터링 대상 설정</h4><br>
        <div class="multiSelect">
            <label><b>전체 항목</b></label>
            <select multiple class="form-control" id="lstBox3">
                <c:forEach items="${yearlyEmissions}" var="target2">
                    <c:if test="${target2.status eq 'false'}">
                        <option id="${target2.sensor}">${target2.place} -
                                ${target2.sensorNaming}
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </div>

        <div class="multiSelectBtn">
            <br/><br/><br/><br/><br/>
            <input type='button' id='btnRight2' value='>' class="btn btn-default"
                   onclick="moveEvent('#lstBox3', '#lstBox4')"/><br/>
            <input type='button' id='btnLeft2' value='<' class="btn btn-default"
                   onclick="moveEvent('#lstBox4', '#lstBox3')"/><br/>
        </div>

        <div class="multiSelect">
            <label><b>대상 가스</b></label>
            <select multiple class="form-control" id="lstBox4">
                <c:forEach items="${yearlyEmissions}" var="target2">
                    <c:if test="${target2.status eq 'true'}">
                        <option id="${target2.sensor}"> ${target2.place} - ${target2.sensorNaming}
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </div>

        <div class="clearfix"></div>
        <!-- MultiSelecter Modal-->
        <div class="MultiSelecterModal" id="yearlyEmissionsModal"></div>

    </div>
</div>
<div style="text-align: center;font-size: 0.95rem;">
    <span>* 설정된 배출량 추이 모니터링 대상가스는 [대시보드 - 측정소 통합 모니터링] 화면에 표시됩니다</span>
    <span style="margin-left: 60px;">* 설정된 배출량 추이 모니터링 대상가스는 [대시보드 - 연간 배출량 누적모니터링] 화면에 표시됩니다</span>
</div>

<!-- addModal -->
<div class="modal" id="addModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header justify-content-center">
                <h5 class="modal-title">센서 추가</h5>
            </div>
            <div class="modal-body d-flex justify-content-evenly">
                <form id="addStandard" method="post" autocomplete="off">
                    <div class="row">
                        <div class="col text-center">
                            <span class="text-danger" style="font-size: 15%"> * 설정된 코드와 항목명을 기준으로 모니터링 항목명(한글명)이 적용됩니다.</span>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">코드</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="code">
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">항목명</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="sensorName">
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">연간배출 허용기준</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="standard">
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">배출허용 기준농도</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="percent">
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col">
                            <span class="fs-5 fw-bold add-margin f-sizing">산출식(참고용)</span>
                        </div>
                        <div class="col">
                            <input type="text" class="text-secondary" name="formula">
                        </div>
                    </div>
                    <input type="hidden" name="hiddenCode"> <!-- 추가 수정 판별할 데이터 -->
                </form>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5" onclick="insert()">추가</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>


</div>

<script>
    $(function () {     // modal drag and drop move
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

    //기준 추가
    function insert() {
        var unComma = $("input[name='standard']").val().replace(/,/g, '');
        $("input[name='standard']").val(unComma);

        var form = $('#addStandard').serialize();
        standardAjax(form,"추가");
    }

    //기준 수정
    function editStandard() {
        var unComma = $("input[name='standard']").val().replace(/,/g, '');
        $("input[name='standard']").val(unComma);

        var form = $('#addStandard').serialize();
        standardAjax(form,"수정");
    }

    //editModal 선택값 셋팅
    function editModalSetting(obj) {
        $('.modal-title').html('센서 수정');
        $('.btn-success').html('수정');
        $('.btn-success').removeAttr("onclick");
        $('.btn-success').attr("onclick", "editStandard()");

        var tdList = $(obj).parent().parent().children()

        $("input[name='code']").val(tdList.eq(0).html());
        $("input[name='hiddenCode']").val(tdList.eq(0).html());
        $("input[name='sensorName']").val(tdList.eq(1).html());
        $("input[name='standard']").val(tdList.eq(2).html());
        $("input[name='percent']").val(tdList.eq(3).html());
        $("input[name='formula']").val(tdList.eq(4).html());
    }

    function standardAjax(form,str){
        $.ajax({
            url: 'saveEmissionsStandard',
            type: 'POST',
            async: false,
            cache: false,
            data: form,
            success: function (data) {
                drawTable(data);
                $('#addModal').modal('hide');

                Swal.fire({
                    icon: 'success',
                    title: str+' 완료',
                    text: '연간 배출 허용 기준이 '+str+'되었습니다.'
                })
                inputClean();
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        });
    }

    function deleteModal(obj){
        var code = $(obj).parent().parent().children().eq(0).html();  //console.log(code); -> NOX

        Swal.fire({
            icon: 'error',
            title: '삭제',
            text: '정말 삭제 하시겠습니까?',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {   //삭제 버튼 누를때
                deleteAjax(code);
            }
        });
    }

    function deleteAjax(code){
        $.ajax({
            url: 'deleteEmissionsStandard',
            type: 'POST',
            async: false,
            cache: false,
            data:  { code : code },
            success: function (data) {
                Swal.fire(
                    '삭제 완료',
                    '삭제 되었습니다.',
                    'warning'
                );
                drawTable(data);
            },
            error: function (request, status, error) {
                console.log(error)
            }
        });
    }


    //테이블 모두 삭제하고 새로운 데이터로 다시 그립니다.
    function drawTable(data) {
        $('#nullStandard').remove();
        $('#tbody').children().remove();

        for (i = 0; i < data.length; i++) {
            var innerHTML = "";
            innerHTML = " <tr>" +
                " <td>" + data[i].sensorCode + "</td>" +
                " <td>" + data[i].sensorNaming + "</td>" +
                " <td>" + numberWithCommas(data[i].yearlyStandard) + "</td>" +
                " <td>" + data[i].percent + "</td>" +
                " <td>" + data[i].formula + "</td>" +
                " <td>" +
                "<i class='fas fa-edit me-2'  data-bs-toggle='modal' data-bs-target='#addModal' onclick='editModalSetting(this)'></i>" +
                "<i class='fas fa-times' onclick='deleteModal(this)'></i>" +
                "</td>" +
                "</tr>";
            $('#tbody').append(innerHTML);
        }
    }

    //Modal 초기화
    function inputClean() {
        $('.modal-title').html('센서 추가');
        $('.btn-success').html('추가');
        $("input[type=text]").val("");
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
        Modal.fadeIn(300);
        Modal.delay(2000).fadeOut(300);
    }

    //센서 상태 업데이트
    function stateUpdate(sensor, isCollection) {
        $.ajax({
            url: '/emissionsState',
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
        })
    }
</script>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
