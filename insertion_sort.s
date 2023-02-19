			;##########################################
			;		Lab 01 skeleton
			;##########################################

data_to_sort  dcd     34, 23, 22, 8, 50, 74, 2, 1, 17, 40
list_elements dcd     10
			
main	    ldr	    r3, =data_to_sort   ; Load the starting address of the first
                                        ; of element of the array of numbers into r3
            ldr     r4, =list_elements  ; address of number of elements in the list
            ldr     r4, [r4]            ; number of elements in the list

			
	    add		r5, r3, #400	 ; location of first element of linked list - "head pointer"
			                 ; (note that I assume it is at a "random" location
                                        ; beyond the end of the array.)
			

            ;#################################################################################
            ;  Include any setup code here prior to loop that loads data elements in array
            ;#################################################################################

            ;#################################################################################
            ;  Start a loop here to load elements in the array and add them to a linked list
            ;#################################################################################
            add     r6, r6, #32         ; every time you create a new struct, add 32 to
                                        ; starting address of last struct to mimic
                                        ; non-contiguous memory locations
                                        ; I assume address of last struct is in r6
                                        ; you DO NOT need to make this assumption

            ;#################################################################################
            ;  Add insert, swap, delete functions
            ;#################################################################################


end
