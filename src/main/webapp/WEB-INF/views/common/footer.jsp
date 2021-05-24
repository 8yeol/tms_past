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


    var mql = window.matchMedia("screen and (max-width: 1024px)");
    mql.addListener(function(e) {
        if(e.matches) {
            $('#container').attr('class','container-fluid');
            $('.sign').html('<br>');
        } else {
            $('#container').attr('class','container');
            $('.sign').html('');
        }
    });

    var filter = "win16|win32|win64|mac";
    if(navigator.platform){
        if(0 > filter.indexOf(navigator.platform.toLowerCase())){
            $('#container').attr('class','container-fluid');
            $('.sign').html('<br>');
        } else {
            $('#container').attr('class','container');
            $('.sign').html('');
        }
    }

</script>