 org $8200
 ldaa $8100
 ldab $8101
 mul
 std $8000
 ldaa $8102
 ldab $8000
 mul
 xgdx 
 ldaa $8102
 ldab $8001
 mul
 xgdy 
 sty $8002
 stx $8004
 sty $8009
 clc
 ldaa $8002
 adca $8005
 staa $8009
 ldaa #$0
 adca $8004
 staa $8008
 
 
 