my_array	dcd		0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
		ldr		r3, =my_array	; get starting addr.
		mov		r4, #0		    ; set array index
		ldr		r5, [r3, #0]	; load 1ST element of array (my_array[0])
		
		ldr		r6, [r3, #4]	; load 2ND element of array (my_array[1]) --> add offset of 4
		
		add		r2, r3, #8	    ; add 8 to base array address
		ldr		r7, [r2]	    ; loads 3rd element of array (my_array[2])
		
		add		r1, r4, #3	    ; update array INDEX
		mov		r2, #4
		lsl		r9, r1, #2	    ; multiply array index by 4
		add		r9, r3, r9
		ldr		r8, [r9]	; load 4TH element of array (my_array[3])
		
		
		mov		r10, #16	    ; put number 16 in r10
		str		r10, [r3]	    ; update FIRST element of array
		end
