			;##########################################
			;		Lab 01 skeleton
			;##########################################
			
data_to_sort	dcd		34, 34, 22, 8, 50, 74, 2, 1, 17, 40
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
			
			mov		r6, r5 ;  initialize prev to r5 (head node)
			mov		r0, #0 ;  intialize r0 as 0 register
			
			str		r0, [r5] 		;head.prev = 0 (NULL)
			add		r7, r5, #32		;allocate nextnode addr in r7
			str		r7, [r5, #8]	;head.next = r7
			;		need strictly head and pointer nodes => will be empty and exist to avoid any
			;		invalid memory accesses
			
			mov		r2, #0 ; use r2 as loop counter;
			;		r5 will forever hold the head address
			;		r7 = curr node addr
			;		r6 = prev node addr
			;		r1 = data_to_sort[i
			;		r8 = next node addr
			
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
			;sub		r7, r7, #32  ; need to deincrement by 32 bc insert_element increments end
			;		curr = tail
			str		r6, [r7]	 ; tail.prev = last inserted node
			str		r0, [r7, #8] ; tail.next = 0 (NULL)
			mov		r10, r7      ; r10 will hold the tail address
			ldr		r7, [r5, #8]
			mov		r6, r5
			b		sort
			
			;#################################################################################
			;		Add insert, swap, delete functions
			;#################################################################################
insert_element
			ldr		r1, [r3]      ; load in element
			;		curr = r7
			str		r6, [r7]	  ; curr.prev = r6 (which holds prev node addr)
			str		r1, [r7, #4]  ; curr.data = element
			add		r8, r7, #32   ; initialize next mem address for next node
			str		r8, [r7, #8]  ; curr.next = r8 = next mem addr
			add		r3, r3, #4    ; i++ for array index
			mov		r6, r7		  ; set prev equal to curr
			add		r7, r7, #32   ; set r7 to next node
			mov		r15, r14	  ; return
			
sort
			;		IMPLEMENT PROCEDURES TO SORT NEWLY FORMED DOUBLY LINKED LIST HERE
			cmp		r6, r5      ; check that curr != head
			beq		skip
			cmp		r7, r10
			beq		deletion
			ldr		r1, [r6, #4] ; r1 = prev.val
			ldr		r2, [r7, #4] ; r2 = curr.val
			cmp		r1, r2       ; if r1 (prior val) > r2 (curr val) swap
			bgt		swap
			ble		skip
			b		sort
			
			
swap ;swap curr and prev node.
			mov		r12, r7 		; r12 = temp_curr = curr
			mov		r11, r6 		; r11 =temp_prev = prev
			ldr		r9, [r11]		; r9 = temp_prev.prev
			ldr		r13, [r12, #8] 	; r13 = temp_curr.next
			str		r12, [r9, #8]	; temp_prev.prev.next = curr
			str		r11, [r13]     	; temp_curr.next.prev = temp_prev
			
			str		r9, [r12]		; temp_curr.prev = temp_prev.prev
			str		r12, [r11]		; temp_prev.prev = temp_curr
			str		r13, [r11, #8]  ; temp_prev.next = temp_curr.next
			str		r11, [r12, #8]	; temp_curr.next = temp_prev
			
			;mov		r7, r6			; curr = prev
			mov		r6, r9			; prev = prev.prev
			;mov		r15, r14		; return
			b		sort
			
skip
			mov		r6, r7			; prev = curr
			ldr		r7, [r7, #8]    ; curr = curr.next
			b		sort
			
deletion
			ldr		r7, [r5, #8]
			cmp		r7, r10
			beq		done
			
delete_loop
			ldr		r7, [r7, #8]
			cmp		r7, r10
			beq		done
			ldr		r6, [r7]
			ldr		r2, [r6, #4]
			ldr		r1, [r7, #4]
			cmp		r1, r2
			beq		delete
			b		delete_loop
			
delete
			ldr		r11, [r6]
			str		r11, [r7]
			str		r7 , [r11, #8]
			b		delete_loop
			
done