// 테이블 명 넘겨주면 측정항목 리턴해주는 메소드
function findSensorCategory(tableName){
    if(tableName.includes('dust')==true){
        return "먼지";
    } else if(tableName.includes('NOx')==true){
        return "질소산화물";
    } else if(tableName.includes('CO')==true){
        return "일산화탄소";
    } else if(tableName.includes('HCL')==true){
        return "염산";
    } else if(tableName.includes('SOx')==true){
        return "황산화물";
    }
}