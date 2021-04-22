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
                        <button class="btn btn-success">승인</button>
                        <button class="btn btn-danger">거절</button>
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
                        <button class="btn btn-success">승인</button>
                        <button class="btn btn-danger">거절</button>
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
                        <button class="btn btn-success">승인</button>
                        <button class="btn btn-danger">거절</button>
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
                        <button class="btn btn-success">승인</button>
                        <button class="btn btn-danger">거절</button>
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
                        <button class="btn btn-success">승인</button>
                        <button class="btn btn-danger">거절</button>
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
                        <i class="fas fa-edit me-2"></i>
                        <i class="fas fa-times"></i>
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
                        <i class="fas fa-edit me-2"></i>
                        <i class="fas fa-times"></i>
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
                        <i class="fas fa-edit me-2"></i>
                        <i class="fas fa-times"></i>
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
                        <i class="fas fa-edit me-2"></i>
                        <i class="fas fa-times"></i>
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
                        <i class="fas fa-edit me-2"></i>
                        <i class="fas fa-times"></i>
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
                        <i class="fas fa-edit me-2"></i>
                        <i class="fas fa-times"></i>
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
                        <i class="fas fa-edit me-2"></i>
                        <i class="fas fa-times"></i>
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
                        <i class="fas fa-edit me-2"></i>
                        <i class="fas fa-times"></i>
                    </td>
                </tr>
                </tbody>

            </table>
        </div>
    </div>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>

<script charset="UTF-8">
</script>






