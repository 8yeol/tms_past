<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-30
  Time: 오전 9:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

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
        </div>
        <div class="row2">
            <span>* 설정된 연간 배출 허용 기준 값은 [대시보드 - 초과배출부과금 대상가스 모니터링]의 배출량 계산에 활용됩니다.</span>
        </div>
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
                <c:forEach items="${target}" var="target">
                    <c:if test="${target.status eq 'true'}">
                        <option id="${target.sensor}">${target.place} - ${target.sensor_naming}
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
                <c:forEach items="${target}" var="target">
                    <c:if test="${target.status eq 'false'}">
                        <option id="${target.sensor}">${target.place} - ${target.sensor_naming}
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
                <c:forEach items="${target2}" var="target2">
                    <c:if test="${target2.status eq 'true'}">
                        <option id="${target2.sensor}">${target2.place} -
                                ${target2.sensor_naming}
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
                <c:forEach items="${target2}" var="target2">
                    <c:if test="${target2.status eq 'false'}">
                        <option id="${target2.sensor}"> ${target2.place} - ${target2.sensor_naming}
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


</div>

<script>

    $(function () {     // modal drag and drop move
        $('.modal-dialog').draggable({handle: ".modal-header"});
    });

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
            Modal.html(opts.eq(0).text() + ' 센서 외' + (opts.length - 1) + '개가 <br> 모니터링 대상 가스에서 제외 되었습니다. ');
            fade(Modal);
        }
    }

    function optionCount_Insert(Modal, opts) {
        if (opts.length == 1) {
            Modal.html(opts.text() + ' 센서가 <br> 모니터링 대상 가스로 선택 되었습니다. ');
            fade(Modal);
        } else if (opts.length > 1) {
            Modal.html(opts.eq(0).text() + ' 센서 외' + (opts.length - 1) + '개가 <br> 모니터링 대상 가스로 선택 되었습니다. ');
            fade(Modal);
        }
    }

    //Modal FadeIn FadeOut
    function fade(Modal) {
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
