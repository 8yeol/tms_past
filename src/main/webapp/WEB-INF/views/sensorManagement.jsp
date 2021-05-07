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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
<link rel="stylesheet" href="static/css/sweetalert2.min.css">

<script src="static/js/sweetalert2.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js"></script>

<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="static/js/common/common.js"></script>
<script src="static/js/moment.min.js"></script>


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

    .label {
        width: 100px;
        font-size: 1.3rem;
    }

    .saveBtn {
        float: right;
        margin-right: 100px;
        background-color: #0275d8;
        color: white;
        width: 110px;
        height: 35px;
        font-size: 1.3rem;

    }
</style>
<body>

<div class="container">
    <div class="row">

        <div class="d-flex justify-content-between my-3">
            <h3>센서 관리</h3>
        </div>

        <div class="col-xs-12 bg-light rounded border border-dark-1 my-1 text-center">

            <form id="saveForm">
                <div class="pt-3 pe-5 margin-l">
                    <label class="me-3 col-xs-3 label">센서명</label>
                    <input type="text" class="text-secondary rounded-3  dd mg1 col-xs-3" name="managementId">
                    <label class="me-3 col-xs-3 w-10 label">분류</label>
                    <input type="text" class="text-secondary rounded-3 dd col-xs-3" name="classification">
                </div>
                <div class="pt-2 pe-5 margin-l">
                    <label class="me-3 col-xs-3 w-10 label">한글명</label>
                    <input type="text" class="text-secondary rounded-3  dd mg1 col-xs-3" name="naming" id="naming" readonly>
                    <label class="me-3 col-xs-3 w-10 label">테이블명</label>
                    <input type="text" class="text-secondary rounded-3 dd col-xs-3" name="tableName">
                </div>
                <div class="pt-2 pe-5 pb-3 margin-l" style="float: left;margin-left: 326px;">
                    <label class="me-3 col-xs-3 w-10 label">측정소</label>
                    <input type="text" class="text-secondary rounded-3  dd mg1 col-xs-3" name="place">
                </div>
            </form>
            <button class="saveBtn" onclick="saveSensor()">센서 추가</button>

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
                <tbody id="tbody">
                 <!-- script -->
                </tbody>
            </table>
            <c:if test="${empty sensorList}">
                <div class="text-center p-5 " id="nullSensor">
                    <h4><b>[센서 추가]</b> 에서 관리할 센서를 추가 해주세요.</h4>
                </div>
            </c:if>
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
        //초기 데이터 셋팅
        getSensor();

        //키보드 입력시 검사하여 한글명 자동완성
        $("input[name='managementId']").bind('keyup', function (e) {
            console.log(this.value);
            $("#naming").val(findSensorCategory(this.value));
        });

        $('.modal-dialog').draggable({handle: ".modal-header"});
    });


    //데이터 가져와서 그리기
    function getSensor(){
        $.ajax({
            url: 'getSensorList',
            type: 'POST',
            async: false,
            cache: false,
            success: function (data) {
                drawTable(data)
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        });
    }

    //데이터 저장후 그리기
    function saveSensor(){
        var form = $('#saveForm').serialize();

        $.ajax({
            url: 'saveSensor',
            type: 'POST',
            async: false,
            cache: false,
            data:form,
            success: function (data) {
                drawTable(data)
                Swal.fire({
                    icon: 'success',
                    title: '센서 추가',
                    text: '관리 항목에 센서가 추가 되었습니다.'
                })
                $("input[type=text]").val("");
            },
            error: function (request, status, error) { // 결과 에러 콜백함수
                console.log(error)
            }
        });
    }

    //테이블 모두 삭제하고 새로운 데이터로 다시 그립니다.
    function drawTable(data) {
        $('#nullSensor').remove();
        $('#tbody').children().remove();

        for (i = 0; i < data.length; i++) {
            if(data.status==false){
                var status = '<i class="fas fa-circle ms-4 text-danger"></i>'
            }else{
                var status = '<i class="fas fa-circle ms-4 text-success"></i>'
            }

            var innerHTML = "";
            innerHTML = " <tr>" +
                " <th>" + (i + 1) + "</th>" +
                " <td>" + data[i].classification + "</td>" +
                " <td>" + data[i].naming + "</td>" +
                " <td>" + data[i].managementId+ "</td>" +
                " <td>" + data[i].tableName + "</td>" +
                " <td>" +moment(data[i].upTime).format('YYYY-MM-DD HH:mm:ss') + "</td>" +
                " <td>" + data[i].place + "</td>" +
                " <td>" +status+ "</td>" +
                "<td>"+
                '<i class="fas fa-edit me-2" data-toggle="modal" data-target="#editModal"></i>'+
                '<i class="fas fa-times" data-toggle="modal" data-target="#checkModal"></i>'+
                '</td>'+
                "</tr>";
            $('#tbody').append(innerHTML);
        }
    }

</script>






