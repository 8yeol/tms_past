<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%-- status message --%>
<div class="status">
    <div>
        <p>측정기</p>
        <p id="measuring">정상</p>
    </div>
    <div>
        <p>자료수집기</p>
        <p id="dataLogger">정상</p>
    </div>
</div>

<script>
    function statusMouseOn(status1, status2){
        let status1_color, status2_color, status1_txt, status2_txt;

        if (status1 == 0) {
            status1_color = "#50e400";
            status1_txt = "정상";
        } else if ( status1 == 1 ) {
            status1_color = "#fcd521";
            status1_txt = "교정중";
        } else if ( status1 == 2 ) {
            status1_color = "#8600e4";
            status1_txt = "동작불량";
        } else if ( status1 == 4) {
            status1_color = "#ff1c1c";
            status1_txt = "전원단절";
        } else if ( status1 == 8 ) {
            status1_color = "#f49206";
            status1_txt = "보수중";
        }

        if (status2 == 0) {
            status2_color = "#50e400";
            status2_txt = "정상";
        } else if ( status2 == 1 ) {
            status2_color = "#8600e4";
            status2_txt = "동작불량";
        } else if ( status2 == 4) {
            status2_color = "#ff1c1c";
            status2_txt = "전원단절";
        }

        $("#measuring").text(status1_txt);
        $("#measuring").css('color', status1_color);
        $("#dataLogger").text(status2_txt);
        $("#dataLogger").css('color', status2_color);

        $(".status").show();
        const status = document.querySelector(".status");
        const mouseX = event.clientX;
        const mouseY = event.clientY;
        status.style.left = mouseX + 'px';
        status.style.top = mouseY + 'px';
    }

    function statusMouseOut(){
        $(".status").hide();
    }
</script>