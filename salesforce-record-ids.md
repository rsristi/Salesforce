


### Salesforce 15 digit vs 18 Digit Record ID

Salesforce provides case-sensitive and case-insensitive versions of the same globally unique id.

Excel formula to convert 15 digit case-sensitive to 18 case-insensitive =CONCATENATE(A1,MID("ABCDEFGHIJKLMNOPQRSTUVWXYZ012345",BIN2DEC(TEXT(SUMPRODUCT((CODE(MID(A1,{1,2,3,4,5},1))>64)*(CODE(MID(A1,{1,2,3,4,5},1))<91),{1,10,100,1000,10000}),"00000"))+1,1),MID("ABCDEFGHIJKLMNOPQRSTUVWXYZ012345",BIN2DEC(TEXT(SUMPRODUCT((CODE(MID(A1,{6,7,8,9,10},1))>64)*(CODE(MID(A1,{6,7,8,9,10},1))<91),{1,10,100,1000,10000}),"00000"))+1,1),MID("ABCDEFGHIJKLMNOPQRSTUVWXYZ012345",BIN2DEC(TEXT(SUMPRODUCT((CODE(MID(A1,{11,12,13,14,15},1))>64)*(CODE(MID(A1,{11,12,13,14,15},1))<91),{1,10,100,1000,10000}),"00000"))+1,1))

Links
https://eltoro.secure.force.com/HowDoIConvertAnIdFrom15To18Characters
