// 테이블 명 넘겨주면 측정항목 리턴해주는 메소드
function findSensorCategory(tableName){
    if(tableName.includes('O2b')==true){
        return "산소";
    } else if(tableName.includes('NOX')==true){
        return "질소산화물";
    }
}


// 천자리 콤마 정규식
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}