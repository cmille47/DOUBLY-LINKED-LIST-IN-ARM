		
		mov		r3, #50	    ; initialize r3 to 50
		mov		r4, #100    ; initialize r4 to 100
		
		mov		r0, #-7	    ; initialize r0 to -7
		mov		r1, #-7	    ; initialize r1 to -7
		cmp		r0, r1	    ; set flags
		
		beq		next	    ; if r0 and r1 equal, goto end
		
		add		r2, r3, r4  ; this instruction will be skipped
		
next		cmp		r3, r4      ; compare r3 and r4
		blt		next1       ; if r3 < r4 -- it is -- goto next1
		
		add		r2, r3, r4  ; this instruction will be skipped
		
next1	bge		stop        ; if r3 >= r4, goto the end; still use same condition codes
		
		add		r2, r3, r4  ; this instruction will NOT be skipped
		
stop
		end
