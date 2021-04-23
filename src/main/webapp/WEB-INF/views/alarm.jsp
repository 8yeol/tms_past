<%--
  Created by IntelliJ IDEA.
  User: sjku
  Date: 2021-04-21
  Time: 오전 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<style>
</style>


<div class="container">

    <div class="row m-1">
        <div class="col-md-6 bg-light rounded">
            <div class="d-flex justify-content-between">
                <h3>Sensor</h3>
                <h5>업데이트 : 1234-12-12</h5>
            </div>
            <div>
                <table class="table">
                    <tbody>
                    <tr>
                        <td><i class="fas fa-circle text-danger"></i></td>
                        <td><span class="text-danger">위험</span></td>
                        <td>2021-01-01 02:50:08 측정소01 먼지 센서 기준 값 초과 (21.96)</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle text-danger"></i></td>
                        <td><span class="text-warning">경고</span></td>
                        <td>2021-01-01 02:50:08 측정소01 먼지 센서 기준 값 초과 (16.02)</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle text-dark"></i></td>
                        <td><span class="text-dark">정상화</span></td>
                        <td>2021-01-01 02:50:08 측정소01 먼지 센서 기준 값 정상화</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle invisible"></i></td>
                        <td><span class="text-dark">정상화</span></td>
                        <td>2021-01-01 02:50:08 측정소01 먼지 센서 기준 값 정상화</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle invisible"></i></td>
                        <td><span class="text-dark">정상화</span></td>
                        <td>2021-01-01 02:50:08 측정소01 먼지 센서 기준 값 정상화</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle invisible"></i></td>
                        <td><span class="text-dark">정상화</span></td>
                        <td>2021-01-01 02:50:08 측정소01 먼지 센서 기준 값 정상화</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle invisible"></i></td>
                        <td><span class="text-dark">정상화</span></td>
                        <td>2021-01-01 02:50:08 측정소01 먼지 센서 기준 값 정상화</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle invisible"></i></td>
                        <td><span class="text-dark">정상화</span></td>
                        <td>2021-01-01 02:50:08 측정소01 먼지 센서 기준 값 정상화</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle invisible"></i></td>
                        <td><span class="text-dark">정상화</span></td>
                        <td>2021-01-01 02:50:08 측정소01 먼지 센서 기준 값 정상화</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle invisible"></i></td>
                        <td><span class="text-dark">정상화</span></td>
                        <td>2021-01-01 02:50:08 측정소01 먼지 센서 기준 값 정상화</td>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>
        <div class="col-md-6 bg-light rounded">
            <div class="d-flex justify-content-between">
                <h3>센서 알림 현황</h3>
                <div class="radio">
                    <input type="radio" name="group1" class="me-1 form-check-input" checked> 연도별
                    <input type="radio" name="group1" class="me-1 form-check-input"> 월 별
                    <input type="radio" name="group1" class="me-1 form-check-input"> 일 별
                </div>
            </div>
            <div>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
            </div>
        </div>
    </div>

    <div class="row m-1">

        <div class="col-md-6 bg-light rounded">
            <div class="d-flex justify-content-between">
                <h3>Event</h3>
                <h5>업데이트 : 1234-12-12</h5>
            </div>
            <div>
                <table class="table">
                    <tbody>
                    <tr>
                        <td><i class="fas fa-circle text-danger"></i></td>
                        <td><span>로그인</span></td>
                        <td>2021-01-01 13:05:14</td>
                        <td>admin(관리자) 로그인</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle"></i></td>
                        <td><span>알림 설정</span></td>
                        <td>2021-01-01 13:05:14</td>
                        <td>admin(관리자) 측정소01 - 산소 알림 ON</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle"></i></td>
                        <td><span>기준값 변경</span></td>
                        <td>2021-01-01 13:05:14</td>
                        <td>admin(관리자) 산소알림 기준값 변경(15->17)</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle"></i></td>
                        <td><span>알림 설정</span></td>
                        <td>2021-01-01 13:05:14</td>
                        <td>admin(관리자) 측정소01 - 산소 알림 ON</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle"></i></td>
                        <td><span>알림 설정</span></td>
                        <td>2021-01-01 13:05:14</td>
                        <td>admin(관리자) 측정소01 - 산소 알림 ON</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle"></i></td>
                        <td><span>알림 설정</span></td>
                        <td>2021-01-01 13:05:14</td>
                        <td>admin(관리자) 측정소01 - 산소 알림 ON</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle"></i></td>
                        <td><span>알림 설정</span></td>
                        <td>2021-01-01 13:05:14</td>
                        <td>admin(관리자) 측정소01 - 산소 알림 ON</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle"></i></td>
                        <td><span>알림 설정</span></td>
                        <td>2021-01-01 13:05:14</td>
                        <td>admin(관리자) 측정소01 - 산소 알림 ON</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle"></i></td>
                        <td><span>알림 설정</span></td>
                        <td>2021-01-01 13:05:14</td>
                        <td>admin(관리자) 측정소01 - 산소 알림 ON</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-circle"></i></td>
                        <td><span>알림 설정</span></td>
                        <td>2021-01-01 13:05:14</td>
                        <td>admin(관리자) 측정소01 - 산소 알림 ON</td>
                    </tr>



                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-md-6 bg-light rounded">
            <div class="d-flex justify-content-between">
                <h3>이벤트 현황</h3>
                <div class="radio">
                    <input type="radio" name="group2" class="me-1 form-check-input" checked> 연도별
                    <input type="radio" name="group2" class="me-1 form-check-input"> 월 별
                    <input type="radio" name="group2" class="me-1 form-check-input"> 일 별
                </div>
            </div>
            <div>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
                <hr>
            </div>
        </div>

    </div>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>



