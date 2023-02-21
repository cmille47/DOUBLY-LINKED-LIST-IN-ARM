			;##########################################
			;		Lab 01 skeleton
			;##########################################
			 
data_to_sort	dcd		5, 10, 7, 7, 7, 8, 2, 10, 11, 11
list_elements	dcd		10
			
main
			ldr		r3, =data_to_sort   ; r3 <= Load the starting address of the first
			;		element of the array of numbers into r3
			ldr		r4, =list_elements  	   ; r4 <= address of number of elements in the list
			ldr		r4, [r4]          			   ; r4 <= number of elements in the list
			
			
			add		r5, r3, #400	 ; r5 <= location of first element of linked list - "head pointer"
			;		(note that I assume it is at a "random" location
			;		beyond the end of the array.)
			;#################################################################################
			;		Include any setup code here prior to loop that loads data elements in array
			;#################################################################################
			;		create head node
			;		STRUCTURE OF NODE: prev data, next
			;		e.g.:
			;		0x200 contains prev node addr
			;		0x204 contains data element
			;		0x208 contain next node addr

			;		STRUCTURE OF DOUBLY LINKED LIST
			;		has a symbolic head and tail that hold no values
			;		but exist such that pointer errors are avoided such that 
			;		swapping/deleting elements can be generalized without regard of special cases
			;		e.g.: head <-> element1 <-> ... <-> elementn <-> tail
 			
			mov		r6, r5 ;  initialize prev to r5 (head node)
			mov		r0, #0 ;  intialize r0 as 0 register
			
			str		r0, [r5] 		; head.prev = 0 (NULL)
			add		r7, r5, #32		; allocate nextnode addr in r7
			str		r7, [r5, #8]	; head.next = r7 = curr

			
			mov		r2, #0 ; use r2 as loop counter;
			
			;#################################################################################
			;		Start a loop here to load elements in the array and add them to a linked list
			;#################################################################################
loop
			cmp		r2, r4 ; i < n_elements
			bge		end_loop
			bl		insert_element
			add		r2, r2, #1 ; i++
			bl		loop
			
			
end_loop
			;		need to set tail node and clean up hanging pointers
								 ; at this point, r7 is the tail
			str		r6, [r7]	 ; tail.prev = last inserted node (r6)
			str		r0, [r7, #8] ; tail.next = 0 (NULL)
			mov		r10, r7      ; r10 will hold the tail address
			ldr		r7, [r5, #8] ; reset r7 --> r7 = head.next 
			mov		r6, r5		 ; r6 = head
			b		sort		 ; sort newly formed doubly linked list
			
			;#################################################################################
			;		Add insert, swap, delete functions
			;#################################################################################
insert_element
			ldr		r1, [r3]      ; load in element
								  ; NOTE: r7 = curr from above
			str		r6, [r7]	  ; curr.prev = r6 
			str		r1, [r7, #4]  ; curr.data = element
			add		r8, r7, #32   ; initialize mem address for next node
			str		r8, [r7, #8]  ; curr.next = r8
			add		r3, r3, #4    ; i++ for array index (4 bytes per index so increment by 4)
			mov		r6, r7		  ; prev = curr
			add		r7, r7, #32   ; r7 = curr.next mem addr
			mov		r15, r14	  ; return
			
sort
			cmp		r6, r5      ; check if prev ==  head
			beq		skip		; if so swapping done for r7. Go to skip
			cmp		r7, r10     ; check if curr == tail
			beq		deletion	; if so, swapping is done. List ordered. Go to deletion for duplicate elements
			ldr		r1, [r6, #4] ; r1 = prev.val
			ldr		r2, [r7, #4] ; r2 = curr.val
			cmp		r1, r2       ; if r1 (prior val) > r2 (curr val) swap
			bgt		swap		
			ble		skip		 ; else skip 
			b		sort
			
			
swap ;swap curr and prev node.
			mov		r12, r7 		; r12 = temp_curr = curr
			mov		r11, r6 		; r11 = temp_prev = prev
			ldr		r9, [r11]		; r9 = temp_prev.prev
			ldr		r13, [r12, #8] 	; r13 = temp_curr.next

									; BEGIN SWAPPING HERE
			str		r12, [r9, #8]	; temp_prev.prev.next = curr
			str		r11, [r13]     	; temp_curr.next.prev = temp_prev
			
			str		r9, [r12]		; temp_curr.prev = temp_prev.prev
			str		r12, [r11]		; temp_prev.prev = temp_curr
			str		r13, [r11, #8]  ; temp_prev.next = temp_curr.next
			str		r11, [r12, #8]	; temp_curr.next = temp_prev
			
			mov		r6, r9			; prev = prev.prev, need to move r6 to be previous of curr
			b		sort
			
skip ; moves r6, r7 each to there next nodes to continue processing of list
			mov		r6, r7			; prev = curr
			ldr		r7, [r7, #8]    ; curr = curr.next
			b		sort
			
deletion							; initalize r7 as head.next for delete_loop. Do check on list
			ldr		r7, [r5, #8]	; curr = head.next
			cmp		r7, r10			; if curr == tail, no real nodes (head <-> tail) jump to done. 
			beq		done
			
delete_loop							; loop through list, remove any nodes w/ duplicate values
			ldr		r7, [r7, #8]	; curr = curr.next
			cmp		r7, r10			; if curr == tail, all nodes processed. done
			beq		done			
			ldr		r6, [r7]		; prev = curr.prev
			ldr		r2, [r6, #4]	
			ldr		r1, [r7, #4]
			cmp		r1, r2			; if prev.val == curr.val go to delete
			beq		delete
			b		delete_loop
			
delete								; if prev (n-1) and curr (n) have same val, delete curr (n) node
			ldr		r11, [r7, #8]	; r11 = curr.next
			str		r11, [r6, #8]	; prev.next = curr.next
			str		r6 , [r11]  	; curr.next.prev = prev
			b		delete_loop
			
done