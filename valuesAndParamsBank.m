function [allModelValues,allTestValues,modelRepsNo,testRepsNo,degree,cropParam,ax] = valuesAndParamsBank(exercise,name)

choices = [exercise, name] ;

switch choices 
    case ['E1','Iga'] 
        allModelValues = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_1.txt' ) ; 
        allTestValues = readValues('Odczyty/E1/Iga/30-Dec-2020/Gyro_2.txt' ) ; 
        allTestValues = allTestValues(1:63930,:) ; 
        modelRepsNo = 5 ; testRepsNo = 204 ; 
        degree = 11 ; cropParam = 0.9 ; ax = 2 ; 
        
    case ['E2','Iga']       
        allModelValues = readValues('Odczyty/E2/Iga/21-Dec-2020/Gyro_1.txt' ) ; 
        allTestValues = readValues('Odczyty/E2/Iga/29-Dec-2020/Gyro_1.txt' ) ; 
        modelRepsNo = 4 ; testRepsNo = 29; 
        degree = 10 ; cropParam = 0.9 ; ax = 3 ; 

    case ['E3','Iga']
        allModelValues = readValues('Odczyty/E3/Iga/03-Jan-2021/Gyro_1.txt' ) ;
        allTestValues = readValues('Odczyty/E3/Iga/03-Jan-2021/Gyro_2.txt' ) ; 
        modelRepsNo = 5 ; testRepsNo = 59; 
        degree = 14; cropParam = 0.8 ; ax = 2 ; 
        
    case ['E3','Ewelina']  
        allModelValues = readValues('Odczyty/E3/Ewelina/09-Jan-2021/Gyro_1.txt' ) ;
        allModelValues = allModelValues(1:1323,:); 
        allTestValues = readValues('Odczyty/E3/Ewelina/09-Jan-2021/Gyro_3.txt' ) ; 
        modelRepsNo = 4 ; testRepsNo = 73 ; 
        degree = 16 ; cropParam = 0.6 ; ax = 2 ; 
end
end