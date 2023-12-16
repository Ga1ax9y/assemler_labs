 org $8100
 ldx #$8200
 ldy #255
outer_loop:
	ldx #$8200
inner_loop:
	ldaa 0,x
	ldab 1,x
	cba
	bhi skip
	stab 0,x
	staa 1,x
skip:
	inx
	cmpx #$82ff
	bne inner_loop
	dey
	beq end
	bra outer_loop
end

 