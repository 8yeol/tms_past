<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 11:30
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

</style>

<body>

<div class="container gap-5">

    <h4 class="d-flex justify-content-start mt-5">회원관리</h4>
    <div class="row bg-light">
        <div class="col-xs-12">
            <table class="table table-striped">

                <thead>
                <tr>
                    <th>회원번호</th>
                    <th>ID</th>
                    <th>이름</th>
                    <th>등급</th>
                    <th>이메일</th>
                    <th>연락처</th>
                    <th>가입일</th>
                    <th>최종 로그인</th>
                    <th>가입승인</th>
                </tr>
                </thead>

                <tbody>
                <tr>
                    <td>1</td>
                    <td>Root</td>
                    <td>최고관리자</td>
                    <td>최고관리자</td>
                    <td>root@tms.com</td>
                    <td>000-0000-0000</td>
                    <td>2021-04-22 00:00:00</td>
                    <td>2021-04-22 00:00:00</td>
                    <td>
                        <button class="btn btn-success" data-toggle="modal" data-target="#okModal">승인</button>
                        <button class="btn btn-danger" data-toggle="modal" data-target="#noModal">거절</button>
                    </td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>dummy</td>
                    <td>dummy</td>
                    <td>dummy</td>
                    <td>dummy@dummy.com</td>
                    <td>000-0000-0000</td>
                    <td>2021-04-22 00:00:00</td>
                    <td>2021-04-22 00:00:00</td>
                    <td>
                        <button class="btn btn-success" data-toggle="modal" data-target="#okModal">승인</button>
                        <button class="btn btn-danger" data-toggle="modal" data-target="#noModal">거절</button>
                    </td>
                </tr>
                <tr>
                    <td>3</td>
                    <td>dummy</td>
                    <td>dummy</td>
                    <td>dummy</td>
                    <td>dummy@dummy.com</td>
                    <td>000-0000-0000</td>
                    <td>2021-04-22 00:00:00</td>
                    <td>2021-04-22 00:00:00</td>
                    <td>
                        <button class="btn btn-success" data-toggle="modal" data-target="#okModal">승인</button>
                        <button class="btn btn-danger" data-toggle="modal" data-target="#noModal">거절</button>
                    </td>
                </tr>
                <tr>
                    <td>4</td>
                    <td>dummy</td>
                    <td>dummy</td>
                    <td>dummy</td>
                    <td>dummy@dummy.com</td>
                    <td>000-0000-0000</td>
                    <td>2021-04-22 00:00:00</td>
                    <td>2021-04-22 00:00:00</td>
                    <td>
                        <button class="btn btn-success" data-toggle="modal" data-target="#okModal">승인</button>
                        <button class="btn btn-danger" data-toggle="modal" data-target="#noModal">거절</button>
                    </td>
                </tr>
                <tr>
                    <td>5</td>
                    <td>dummy</td>
                    <td>dummy</td>
                    <td>dummy</td>
                    <td>dummy@dummy.com</td>
                    <td>000-0000-0000</td>
                    <td>2021-04-22 00:00:00</td>
                    <td>2021-04-22 00:00:00</td>
                    <td>
                        <button class="btn btn-success" data-toggle="modal" data-target="#okModal">승인</button>
                        <button class="btn btn-danger" data-toggle="modal" data-target="#noModal">거절</button>
                    </td>
                </tr>
                </tbody>

            </table>
        </div>
    </div>

    <div class="row">
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
                <h3>@@@님 가입 승인하시겠습니까?</h3>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-success me-5">승인</button>
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
                <h3>@@@님 가입 거절하시겠습니까?</h3>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="button" class="btn btn-danger me-5">거절</button>
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

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>

<script>
    $(function () {
        $('.modal-dialog').draggable({handle: ".modal-header"});
    });
</script>






