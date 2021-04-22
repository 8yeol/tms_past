<%--
  Created by IntelliJ IDEA.
  User: hsheo
  Date: 2021-04-19
  Time: 오전 11:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<style>
    /* The switch - the box around the slider */
    .switch {
        position: relative;
        display: inline-block;
        width: 60px;
        height: 34px;
    }

    /* Hide default HTML checkbox */
    .switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    /* The slider */
    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        -webkit-transition: .4s;
        transition: .4s;
    }

    .slider:before {
        position: absolute;
        content: "";
        height: 26px;
        width: 26px;
        left: 4px;
        bottom: 4px;
        background-color: white;
        -webkit-transition: .4s;
        transition: .4s;
    }

    input:checked + .slider {
        background-color: #2196F3;
    }

    input:focus + .slider {
        box-shadow: 0 0 1px #2196F3;
    }

    input:checked + .slider:before {
        -webkit-transform: translateX(26px);
        -ms-transform: translateX(26px);
        transform: translateX(26px);
    }

    /* Rounded sliders */
    .slider.round {
        border-radius: 34px;
    }

    .slider.round:before {
        border-radius: 50%;
    }
</style>
<div class="container">
    <div class="row m-3">
        <div class="col fs-4 fw-bold">측정소 등록 및 측정소별 항목 등록</div>
    </div>

    <div class="row p-3 bg-light rounded">
        <div class="col-3 border-end" style="width: 35%;">
            <span class="fw-bold">측정소 관리</span>
            <input type="button" value="추가">
            <input type="button" value="삭제">
            <div class="text-center">
                <table style="border-bottom: 2px solid black;">
                    <form>
                        <tr>
                            <th><input class="all1" type = checkbox></th>
                            <th>측정소 명</th>
                            <th>업데이트</th>
                            <th>모니터링 사용</th>
                        </tr>

                        <td><input class="cha1" type = checkbox></td>
                        <td>name</td>
                        <td>update</td>
                        <td>use</td>
                    </form>
                </table>
            </div>
        </div>
        <div class="col-3">

            <span class="fw-bold">station 상세설정</span>
            <label class="switch">
                <input type="checkbox">
                <span class="slider round"></span>
            </label>
            <br>
            <input type="button" value="추가">
            <input type="button" value="삭제">
            <div class="text-center">
                <table style="border-bottom: 2px solid black;">
                    <form>
                        <tr>
                            <th><input class="all2" type = checkbox></th>
                            <th>측정항목</th>
                            <th>관리ID</th>
                            <th>경고</th>
                            <th>위험</th>
                            <th>대체값</th>
                            <th>모니터링</th>
                        </tr>


                        <td><input class="chb1" type = checkbox></td>
                        <td>name</td>
                        <td>ID</td>
                        <td><input value="warning"></td>
                        <td><input value="danger"></td>
                        <td><input value="replace"></td>
                        <td>
                            <label class="switch">
                                <input type="checkbox">
                                <span class="slider round"></span>
                            </label>
                        </td>

                    </form>

                </table>
            </div>
        </div>

    </div>


</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />