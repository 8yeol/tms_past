
// 비밀번호 체크 (6자리 이상 20자리 미만)
function passwordCheckMsg(){
    if($("#password").val().indexOf(" ") != -1){
        $("#passwordText").html("비밀번호에 공백이 포함되어있습니다.");
    } else if($("#password").val().length < 6 ){
        $("#passwordText").html("6자리 이상 입력해주세요.");
    } else if ($("#password").val().length > 20){
        $("#passwordText").html("20자리 이내로 입력해주세요.");
    } else {
        $("#passwordText").html("");
    }

    if ($("#password").val() != $("#passwordCheck").val()) {
        $("#passwordCheckText").html("비밀번호가 일치하지 않습니다.");
    } else {
        $("#passwordCheckText").html("");
    }
}

// 가입신청 비밀번호 체크
function passwordCheck(){
    if($("#password").val().indexOf(" ") != -1){
        swal('warning', '비밀번호형식 오류', '비밀번호에는 공백을 포함시킬수 없습니다.')
        return false;
    }else if($("#passwordText").text() != ""){
        $("#passwordText").focus();
        swal('warning', '비밀번호형식 오류', '6자리 이상 20자리 미만 비밀번호를 설정해주세요.')
        return false;
    }else if($("#passwordCheckText").text() != ""){
        $("#passwordCheck").focus();
        swal('warning', '비밀번호 오류', '비밀번호가 틀립니다. 다시 설정해주세요.')
        return false;
    } else{
        return true;
    }
}
