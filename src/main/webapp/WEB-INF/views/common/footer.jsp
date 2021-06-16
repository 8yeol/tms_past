<%--
  Created by IntelliJ IDEA.
  User: kyua
  Date: 2021-04-13
  Time: 오후 5:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
</body>
</html>

<script>
    // 1024px 을 기준으로 속성값 적용
    var mql = window.matchMedia("screen and (max-width: 1024px)");
    mql.addListener(function(e) {
        //1024보다 작아지면
        if(e.matches) {
            $('#container').attr('class','container-fluid');
            $('.sign').html('<br>');
            $('#station1').css('width','100%');
            $('#station2').css('width','100%');

        //1024보다 커지면
        } else {
            $('#container').attr('class','container');
            $('.sign').html('');
            $('#station1').css('width','37%');
            $('#station2').css('width','61%');
        }
    });

    //모바일과 PC를 구분하여 속성값 적용
    var filter = "win16|win32|win64|mac";
    if(navigator.platform){
        //모바일
        if(0 > filter.indexOf(navigator.platform.toLowerCase())){
            $('#container').attr('class','container-fluid');
            $('.sign').html('<br>');
            $('#station1').css('width','100%');
            $('#station2').css('width','100%');

        //PC
        } else {
            $('#container').attr('class','container');
            $('.sign').html('');
            $('#station1').css('width','37%');
            $('#station2').css('width','61%');
        }
    }
</script>