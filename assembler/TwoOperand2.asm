# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
in R1        #add 5 in R1
in R2        #add 19 in R2
in R3        #FFFF
in R4        #F320
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
MoV R3,R5    #R5 = FFFF , flags no change
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
ADD R1,R4    #R4= F325 , C-->0, N-->1, Z-->0
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
SUB R5,R4    #R4= 0CDA , C-->1, N-->0,Z-->0
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
AND R6,R4    #R4= 0000 , C-->no change, N-->0, Z-->1
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
OR  R2,R1    #R1=1D  , C--> no change, N-->0, Z--> 0
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
SHL R2,2     #R2=64  , C--> 0, N -->0 , Z -->0
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
SHR R2,3     #R2=0C  , C -->1, N-->0 , Z-->0
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
Add R2,R3    #R3=0C  (C,N,Z =0)
