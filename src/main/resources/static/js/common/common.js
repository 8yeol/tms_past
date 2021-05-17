// 테이블 명 넘겨주면 측정항목 리턴해주는 메소드
function findSensorCategory(tableName){
    let result;
    $.ajax({
        url: '/getSensorManagementId',
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

// 로그 생성
function inputLog(id,content,type){
    var settings = {
        "url": "http://localhost:8090/inputLog",
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