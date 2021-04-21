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
    .mg1{
        margin-right: 22px;
    }
    .mg2{
        margin-right: 123px;
    }
</style>


<div class="container">

    <div class="row">

        <div class="d-flex justify-content-between my-3">
            <h3>센서 관리</h3>

            <button class="btn btn-success">센서 추가</button>
        </div>

        <div class="col-xs-12 bg-light rounded border border-dark-1 my-1 d-flex justify-content-center">

            <div>
                <div class="d-flex justify-content-center my-2 ">
                    <h4 class="me-3 ms-5">분류</h4>
                    <select name="dropdown1" class="btn-secondary rounded-3">
                        <option value="1">전체</option>
                        <option value="2">먼지</option>
                        <option value="3">아황산가스</option>
                    </select>

                    <h4 class="mx-5">측정소</h4>
                    <select name="dropdown2" class="btn-secondary rounded-3">
                        <option value="1">전체</option>
                        <option value="2">측정소1</option>
                        <option value="3">측정소2</option>
                    </select>
                </div>

                <div class="d-flex justify-content-center my-2">
                    <h4 class="me-3">센서관리ID</h4>
                    <input type="text" class="text-secondary rounded-3 mg1">

                    <h4 class="me-3">테이블명</h4>
                    <input type="text" class="text-secondary rounded-3">
                </div>

                <div class="d-flex justify-content-center my-2">
                    <h4 class="me-3">업데이트일</h4>
                    from<input type="date" name="date1" class="text-secondary rounded-3">
                    <p class="mx-2">ㅡ</p>
                    to<input type="date" name="date2" class="text-secondary rounded-3 mg2">
                </div>
            </div>

            <button class="btn btn-success ms-5 my-auto px-4 fs-6">검색</button>

        </div>

        <div class="col-xs-12 bg-light rounded border border-dark-1">
            <table class="table table-striped">
                <thead>
                <tr>
                    <th scope="col">순번</th>
                    <th scope="col">분류</th>
                    <th scope="col">한글명</th>
                    <th scope="col">센서관리ID</th>
                    <th scope="col">테이블명</th>
                    <th scope="col">업데이트</th>
                    <th scope="col">측정소</th>
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
                    <td>Otto</td>
                    <td>@mdo</td>
                </tr>
                <tr>
                    <th scope="row">2</th>
                    <td>Jacob</td>
                    <td>Thornton</td>
                    <td>@fat</td>
                    <td>Thornton</td>
                    <td>@fat</td>
                    <td>Thornton</td>
                    <td>@fat</td>
                    <td>Jacob</td>
                </tr>
                <tr>
                    <th scope="row">3</th>
                    <td colspan="2">Larry the Bird</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                </tr>
                <tr>
                    <th scope="row">4</th>
                    <td colspan="2">Larry the Bird</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
                    <td>Thornton</td>
                    <td>@twitter</td>
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


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



