array		dcd		17, 24, 25, 35
			
			ldr		r3, =array	; get starting addr.
			mov		r4, #0		; set array index
			
			ldr		r1, [r3, r4]	; load first element of array
			
			add		r4, r4, #4	; update array index
			ldr		r2, [r3, r4]	; load second element of array
			
			bl		procedure_call	; call test procedure
			
			sub		r5, r4, #20	; do any operation
			
			end		; Exit cleanly
			
procedure_call
			adds		r0, r1, r2	; do any operation
			mov		r15, r14        ; restore program counter
