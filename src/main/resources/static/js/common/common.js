// context path
function getContextPath() {
    const hostIndex = location.href.indexOf( location.host ) + location.host.length;
    return location.href.substring( hostIndex, location.href.indexOf('/', hostIndex + 1) );
};

// 테이블 명 넘겨주면 측정항목 리턴해주는 메소드
function findSensorCategory(tableName){
    let result;
    $.ajax({
        url:getContextPath()+'/getSensorManagementId',
        type: 'POST',
        dataType: 'json',
        async: false,
        cache: false,
        data: {
            "name" : tableName
        },
        success : function(data) {
            result = data.naming;
        },
        error : function(request, status, error) {
            console.log(error)
        }
    })
    return result;
}

// 천자리 콤마 정규식
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// 이메일 형식 체크
function emailCheck(){
    const email_rule =  /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
    if(!email_rule.test($("#email").val())){
        $("#email").focus();
        swal('warning', '이메일 형식 오류', '이메일 형식에 맞게 입력해주세요.')
        return false;
    } else{
        return true;
    }
}

// 이메일 자동완성 도우미
function autoEmail(a, b) {
    const mailId = b.split('@'); // 메일계정의 ID만 받아와서 처리하기 위함
    const mailList = ['lghausys.com']; // 메일목록
    const availableCity = new Array; // 자동완성 키워드 리스트
    for (let i = 0; i < mailList.length; i++) {
        availableCity.push(mailId[0] + '@' + mailList[i]); // 입력되는 텍스트와 메일목록을 조합
    }
    $("#" + a).autocomplete({
        source: availableCity, // jQuery 자동완성에 목록을 넣어줌
        focus: function (event, ui) {
            return false;
        }
    });
}

// 전화번호 자동완성 도우미
function inputPhoneNumber(obj) {
    obj.value = obj.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
    const number = obj.value.replace(/[^0-9]/g, "");
    let phone = "";
    if (number.length < 4) {
        return number;
    } else if (number.length < 7) {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3);
    } else if (number.length < 11) {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3, 3);
        phone += "-";
        phone += number.substr(6);
    } else {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3, 4);
        phone += "-";
        phone += number.substr(7);
    }
    obj.value = phone;
}

// 로그 생성
function inputLog(id,content,type){
    var settings = {
        "url": getContextPath()+"/inputLog",
        "method": "POST",
        "headers": {
            "accept": "application/json",
            "content-type": "application/json;charset=UTF-8"
        },
        "data": "{\r\n    \"id\": \""+id+"\"," +
            "\r\n    \"content\": \""+content+"\"," +
            "\r\n    \"type\": \""+type+"\"\r\n}",
    };
    $.ajax(settings)
        .done(function (response) {
        })

}
//모든 공백 제거
function strReplace(str){
    return str.replace(/(\s*)/g, "");
}

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