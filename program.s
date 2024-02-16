.data
k: .word -2
new_line: .string "\n"
code: .string "E"
key: .string "ABA"
str: .string "Hello this is the password!!"
out: .string ""
.text
__start:
    la a0, str
    li a7, 4
    ecall #We print the starting string
    la a6, code
    loop_code:
    lb x1, 0(a6)
    beq x1, x0, end_total
    li x2, 65
    beq x1, x2, go_caesars
    li x2, 66
    beq x1, x2, go_blocks
    li x2, 67
    beq x1, x2, go_ocurrences
    li x2, 68
    beq x1, x2, go_dictionary
    li x2, 69
    beq x1, x2, go_inversion
    addi a6, a6, 1
    j loop_code
    
    go_caesars:
    jal x0, caesars
    ret_caesars:
    addi a6, a6, 1
    j loop_code
    
    go_blocks:
    jal x0, blocks
    ret_blocks:
    addi a6, a6, 1
    j loop_code
    
    go_ocurrences:
    jal x0, ocurrences
    ret_ocurrences:
    addi a6, a6, 1
    j loop_code
    
    go_dictionary:
    jal x0, dictionary
    ret_dictionary:
    addi a6, a6, 1
    j loop_code
    
    go_inversion:
    jal x0, inversion
    ret_inversion:
    addi a6, a6, 1
    j loop_code
    
    end_total:
    la a0, new_line #We print a new line
    li a7, 4
    ecall #We print the string
    andi x2, x2, 0
    la a6, code
    loop_end_total:
    lb x1, 0(a6)
    beq x1, x0, loop_decode
    addi x2, x2, 1
    addi a6, a6, 1
    j loop_end_total
    loop_decode:
    la a6, code
    add a6, a6, x2 #We start in the last char for the decode part
    addi a6, a6, -1
    lb x1, 0(a6)
    beq x1, x0, END
    li x3, 65
    beq x1, x3, decode_caesars
    li x3, 66
    beq x1, x3, decode_blocks
    li x3, 67
    beq x1, x3, decode_ocurrences
    li x3, 68
    beq x1, x3, decode_dictionary
    li x3, 69
    beq x1, x3, decode_inversion
    addi x2, x2, -1
    j loop_decode
    
    decode_caesars:
    mv x29, x2
    jal x0, d_caesars
    retd_caesars:
    mv x2, x29
    addi x2, x2, -1
    j loop_decode
    
    decode_blocks:
    mv x29, x2
    jal x0, d_blocks
    retd_blocks:
    mv x2, x29
    addi x2, x2, -1
    j loop_decode
    
    decode_ocurrences:
    mv x29, x2
    jal x0, d_ocurrences
    retd_ocurrences:
    mv x2, x29
    addi x2, x2, -1
    j loop_decode
    
    decode_dictionary:
    mv x29, x2
    jal x0, d_dictionary
    retd_dictionary:
    mv x2, x29
    addi x2, x2, -1
    j loop_decode
    
    decode_inversion:
    mv x29, x2
    jal x0, d_inversion
    retd_inversion:
    mv x2, x29
    addi x2, x2, -1
    j loop_decode
    
    END:
    li a7, 10 #Fin
    ecall
    
caesars:
    la a0, str
    la a2, k #We bring the value for k
    lb x6, 0(a2) #We chrage x6 with k
    andi x1, x1, 0 #Clear x1
    andi x2, x2, 0 #Clear x2
    loop_caesars1:
        lb x1, 0(a0) #We bring whatever a0 is pointing to x1
        beq x1, x0, fin_A #If it´s 0 then it´s the end of the string
        #Else, we continue
        li x3, 65
        blt x1, x3, not_character
        li x3, 91
        blt x1, x3, upper
        li x3, 97
        blt x1, x3, not_character
        li x3, 123
        blt x1, x3, lower
        not_character:
        sb x1, 0(a0) #We write the char to out as it is
        addi a0, a0, 1 #We read the next byte of input
        addi x2, x2, 1 #We add one to the counter
        j loop_caesars1
        upper:
        addi x5, x1, -65 #We substract 65 to the char
        add x4, x5, x6 #We add k
        blt x4, x0, rem_neg_may
        li x5, 26
        rem x5, x4, x5 #x4%26
        j continue_may
        rem_neg_may:
        li x5, 26
        add x5, x5, x4 #x5-x4
        continue_may:
        addi x5, x5, 65
        sb x5, 0(a0)
        addi a0, a0, 1 #We read the next byte of input
        addi x2, x2, 1 #We add one to the counter
        j loop_caesars1
        lower:
        addi x5, x1, -97 #We substract 97
        add x4, x5, x6 #We add x6
        blt x4, x0, rem_neg_min
        li x5, 26
        rem x5, x4, x5 #x4%26
        j continue_min
        rem_neg_min:
        li x5, 26
        add x5, x5, x4
        continue_min:
        addi x5, x5, 97
        sb x5, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_caesars1
    fin_A:
        la a0, new_line #We print a new line
        li a7, 4
        ecall #We print the input string that was overwritten
        la a0, str
        li a7, 4
        ecall #We print the string
jal x0, ret_caesars

d_caesars:
    la a0, str
    la a2, k
    lb x6, 0(a2)
    li x1, -1
    mul x6, x1, x6
    andi x1, x1, 0 #Clear x1
    andi x2, x2, 0 #Clear x2
    loop_caesars_d:
        lb x1, 0(a0)
        beq x1, x0, end_A_d
        #Si no seguimos
        li x3, 65
        blt x1, x3, not_character_d
        li x3, 91
        blt x1, x3, upper_d
        li x3, 97
        blt x1, x3, not_character_d
        li x3, 123
        blt x1, x3, lower_d
        not_character_d:
        sb x1, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_caesars_d
        upper_d:
        addi x5, x1, -65
        add x4, x5, x6
        blt x4, x0, rem_neg_may_d
        li x5, 26
        rem x5, x4, x5
        j continue_may_d
        rem_neg_may_d:
        li x5, 26
        add x5, x5, x4
        continue_may_d:
        addi x5, x5, 65
        sb x5, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_caesars_d
        lower_d:
        addi x5, x1, -97
        add x4, x5, x6
        blt x4, x0, rem_neg_min_d
        li x5, 26
        rem x5, x4, x5
        j continue_min_d
        rem_neg_min_d:
        li x5, 26
        add x5, x5, x4
        continue_min_d:
        addi x5, x5, 97
        sb x5, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_caesars_d
    end_A_d:
        la a0, new_line
        li a7, 4
        ecall
        la a0, str
        li a7, 4
        ecall 
jal x0, retd_caesars

blocks:
    la a2, key #Pointer to key
    andi x1, x1, 0 #Clear x1
    andi x2, x2, 0 #Clear x2
    get_key_length:
        lb x1, 0(a2) #We charge x1 with wahtever a0 has
        beq x1, x0, fin_B #End of string?
        addi a2, a2, 1
        addi x2, x2, 1 #We add one to the counter
        j get_key_length
    fin_B:
    la a1, str
    la a2, key
    mv x4, a2 #x4 will have the start of the string
    andi x1, x1, 0 #Clear x1
    andi x3, x3, 0 #Clear x3
    loop_B:
        lb x1, 0(a1) #a0 -> x1
        beq x1, x0, end_B #End of string?
        lb x3, 0(a2) #We charge x3 with the correct index of the key
        add x3, x3, x1 #We add the key char with the input string char
        li x5, 96
        rem x3, x3, x5 #x3%96
        addi x3, x3, 32
        sb x3, 0(a1)
        addi a1, a1, 1
        addi a2, a2, 1
        sub x5, a2, x4
        bge x5, x2, repetir_B #If the current psoition of the key char is greater than the key length?
        j loop_B
        repetir_B:
        mv a2, x4 #We point the pointer to the start of the string if it surpasses the key_length
        j loop_B
    end_B:
        la a0, new_line #New line
        li a7, 4
        ecall #Print
        la a0, str
        li a7, 4
        ecall #Print
jal x0, ret_blocks

d_blocks:
    la a2, key
    andi x1, x1, 0
    andi x2, x2, 0
    get_key_length_d:
        lb x1, 0(a2)
        beq x1, x0, fin_B_d
        addi a2, a2, 1
        addi x2, x2, 1
        j get_key_length_d
    fin_B_d:
    la a1, str
    la a2, key
    mv x4, a2
    andi x1, x1, 0
    andi x3, x3, 0
    loop_B_d:
        lb x1, 0(a1)
        beq x1, x0, end_B_d
        lb x3, 0(a2)
        addi x1, x1, 64
        li x5, -1
        mul x3, x3, x5
        add x3, x1, x3
        sb x3, 0(a1)
        addi a1, a1, 1
        addi a2, a2, 1
        sub x5, a2, x4
        bge x5, x2, repeat_B_d
        j loop_B_d
        repeat_B_d:
        mv a2, x4
        j loop_B_d
    end_B_d:
        la a0, new_line
        li a7, 4
        ecall
        la a0, str
        li a7, 4
        ecall
jal x0, retd_blocks

ocurrences:
    la a1, out
    andi x1, x1, 0
    andi x2, x2, 0
    andi x3, x3, 0
    andi x4, x4, 0
    andi x5, x5, 0
    andi x6, x6, 0
    la a0, str
    charge:
        lb x1, 0(a0)
        beq x1, x0, end_C
        mv x3, x2 
        loop:
        beq x3, x0, continue
        addi x3, x3, -1
        la a2, str
        add a2, a2, x3 
        lb x4, 0(a2)
        beq x1, x4, already_is 
        j loop
        continue:
        addi a1, a1 ,1
        li x6, 32
        sb x6, 0(a1)
        #Si tenemos que guardar
        addi a1, a1, 1
        mv x5, x2
        sb x1, 0(a1) 
        addi a1, a1, 1
        li x6, 45
        sb x6, 0(a1)
        addi a1, a1, 1
        mv x31, x1
        call bcd2
        mv x1, x31
        loop_continue:
        addi x5, x5, 1
        la a2, str
        add a2, a2, x5
        lb x4, 0(a2)
        beq x4, x0, end_forward
        beq x1, x4, add_pos
        j loop_continue
        add_pos:
        li x6, 45
        addi a1, a1, 1
        sb x6, 0(a1)
        addi a1, a1, 1
        mv x31, x1
        call bcd
        mv x1, x31
        j loop_continue
        end_forward:
        andi x1, x1, 0
        addi x2, x2, 1
        addi a0, a0, 1
        j charge
        already_is:
        addi x2, x2, 1
        addi a0, a0, 1
        j charge
        
    bcd:
        andi x7, x7, 0 #10
        andi x8, x8, 0 #100
        mv x6, x5 #Number
        addi x6, x6, 1
        loop_bcd:
        li x4, 100
        blt x6, x4, less_100
        addi x8, x8, 1
        addi x6, x6, -100
        j loop_bcd
        less_100:
        li x4, 10
        blt x6, x4, less_10
        addi x7, x7, 1
        addi x6, x6, -10
        j loop_bcd
        less_10:
        beq x8, x0, c_cero
        addi x8, x8, 48
        sb x8, 0(a1)
        addi a1, a1, 1
        addi x7, x7, 48
        sb x7, 0(a1)
        addi a1, a1, 1
        j end_bcd
        c_cero:
        beq x7, x0, end_bcd
        addi x7, x7, 48
        sb x7, 0(a1)
        addi a1, a1, 1
        end_bcd:
        addi x6, x6, 48
        sb x6, 0(a1)
        ret
    bcd2:
        andi x7, x7, 0 
        andi x8, x8, 0
        mv x6, x2 
        addi x6, x6, 1
        loop_bcd_2:
        li x4, 100
        blt x6, x4, less_100_2
        addi x8, x8, 1
        addi x6, x6, -100
        j loop_bcd_2
        less_100_2:
        li x4, 10
        blt x6, x4, less_10_2
        addi x7, x7, 1
        addi x6, x6, -10
        j loop_bcd_2
        less_10_2:
        beq x8, x0, c_cero_2
        addi x8, x8, 48
        sb x8, 0(a1)
        addi a1, a1, 1
        addi x7, x7, 48
        sb x7, 0(a1)
        addi a1, a1, 1
        j end_bcd_2
        c_cero_2:
        beq x7, x0, end_bcd_2
        addi x7, x7, 48
        sb x7, 0(a1)
        addi a1, a1, 1
        end_bcd_2:
        addi x6, x6, 48
        sb x6, 0(a1)
        ret
    end_C: 
        la a1, out
        addi a1, a1, 2
        la a0, str
        loop_fin_C:
        lb x1, 0(a1)
        beq x1, x0, fin2_C
        sb x1, 0(a0)
        sb x0, 0(a1)
        addi a0, a0, 1
        addi a1, a1, 1
        j loop_fin_C
        fin2_C:
        la a0, new_line
        li a7, 4
        ecall
        la a0, str
        li a7, 4
        ecall
jal x0, ret_ocurrences

d_ocurrences:
    la a0, str
    andi x1, x1, 0
    andi x2, x2, 0
    andi x3, x3, 0
    get_length_C_d:
        lb x1, 0(a0) 
        beq x1, x0, fin_C_d 
        addi x2, x2, 1
        addi a0, a0, 1
        j get_length_C_d
        fin_C_d:
        la a0, str
        add a0, a0, x3
        lb x5, 0(a0)
        addi a0, a0, 1
        lb x1, 0(a0)
        j loop_ocur_d
        fin_C_d2:
        la a0, str
        add a0, a0, x3
        lb x5, 0(a0)
        mv x1, x5
        j loop_ocur_d
        start_str:
        addi a0, a0, 1
        lb x1, 0(a0)
        beq x1, x0, out_deco_enc
        loop_ocur_d:
        li x4, 32
        beq x1, x4, space
        li x4, 45
        beq x1, x4, hyphen #Is -?  J-8-10 I-1-2
        
        lb x6, 0(a0) #x6 has the position on where to put the current working char on x5
        addi x6, x6, -48
        #Here we have the number
        addi a0, a0, 1
        lb x7, 0(a0)
        addi a0, a0, -1
        li x4, 45
        beq x7, x4 d_unit #If we found any of the next chars, then the number is a units
        li x4, 32
        beq x7, x4, d_unit #" "
        beq x7, x0, d_unit
        #Else, check fot 10's and 100's
        addi a0, a0, 2
        lb x8, 0(a0)
        addi a0, a0, -2
        li x4, 45
        beq x8, x4 d_ten #Found -
        li x4, 32
        beq x8, x4, d_ten
        beq x8, x0, d_ten
        #Else it´s 100's
        li x4, 100
        addi x8, x8, -48
        mul x6, x6, x4
        add x6, x6, x8
        addi x7, x7, -48
        li x4, 10
        mul x7, x7, x4
        add x6, x6, x7
        addi a0, a0, 1
        addi x3, x3, 2
        j d_unit
        d_ten:
        li x4, 10
        addi x7, x7, -48
        mul x6, x6, x4
        add x6, x6, x7
        addi a0, a0, 1
        addi x3, x3, 1
        d_unit:
        add x6, x6, x2
        la a1, str
        add a1, a1, x6
        sb x5, 0(a1)
        hyphen:
        addi x3, x3, 1
        j start_str
        space:
        addi x3, x3, 1
        addi x3, x3, 1
        j fin_C_d 
        
        out_deco_enc:
        la a1, str
        add a1, a1, x2
        addi a1, a1, 1
        la a0, str #a0 -> IN y a1 -> OUT
        loop_fin_C_d:
        lb x1, 0(a1)
        beq x1, x0, fin2_C_d
        sb x1, 0(a0)
        sb x0, 0(a1)
        addi a0, a0, 1
        addi a1, a1, 1
        j loop_fin_C_d
        fin2_C_d:
        sb x0, 0(a0)
        addi a0, a0, 1
        lb x1, 0(a0)
        bne x1, x0, fin2_C_d
        la a0, new_line
        li a7, 4
        ecall
        la a0, str
        li a7, 4
        ecall
jal x0, retd_ocurrences

dictionary:
    la a0, str
    andi x1, x1, 0 #Clear x1
    andi x2, x2, 0 #Clear x2
    loop_dictionary:
        lb x1, 0(a0)
        beq x1, x0, fin_D
        li x3, 48
        blt x1, x3, not_char_D
        li x3, 58
        blt x1, x3, number_D
        li x3, 65
        blt x1, x3, not_char_D
        li x3, 91
        blt x1, x3, lower_D
        li x3, 97
        blt x1, x3, not_char_D
        li x3, 123
        blt x1, x3, upper_D
        number_D:
        addi x5, x1, -57
        li x4, 48
        sub x5, x4, x5
        sb x5, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_dictionary
        not_char_D:
        sb x1, 0(a0)
        addi a0, a0, 1 
        addi x2, x2, 1 
        j loop_dictionary
        upper_D:
        addi x5, x1, -65
        li x4, 90
        sub x5, x4, x5
        addi x5, x5, 32
        sb x5, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_dictionary
        lower_D:
        addi x5, x1, -97
        li x4, 122
        sub x5, x4, x5
        addi x5, x5, -32
        sb x5, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_dictionary
    fin_D:
        la a0, new_line
        li a7, 4
        ecall
        la a0, str
        li a7, 4
        ecall
jal x0, ret_dictionary

d_dictionary:
    la a0, str
    andi x1, x1, 0 
    andi x2, x2, 0
    loop_dictionary_d:
        lb x1, 0(a0)
        beq x1, x0, fin_D_d
        li x3, 48
        blt x1, x3, not_char_D_d
        li x3, 58
        blt x1, x3, number_D_d
        li x3, 65
        blt x1, x3, not_char_D_d
        li x3, 91
        blt x1, x3, upper_D_d
        li x3, 97
        blt x1, x3, not_char_D_d
        li x3, 123
        blt x1, x3, lower_D_d
        number_D_d:
        addi x5, x1, -57
        li x4, 48
        sub x5, x4, x5
        sb x5, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_dictionary_d
        not_char_D_d:
        sb x1, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_dictionary_d
        upper_D_d:
        addi x5, x1, -65
        li x4, 90
        sub x5, x4, x5
        addi x5, x5, 32
        sb x5, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_dictionary_d
        lower_D_d:
        addi x5, x1, -97
        li x4, 122
        sub x5, x4, x5
        addi x5, x5, -32
        sb x5, 0(a0)
        addi a0, a0, 1
        addi x2, x2, 1
        j loop_dictionary_d
    fin_D_d:
        la a0, new_line
        li a7, 4
        ecall
        la a0, str
        li a7, 4
        ecall
jal x0, retd_dictionary

inversion:
    la a0, str
    andi x1, x1, 0
    andi x2, x2, 0
    get_length:
        lb x1, 0(a0)
        beq x1, x0, fin_E
        addi x2, x2, 1
        addi a0, a0, 1
        j get_length
    fin_E:
        andi x3, x3, 0
        loop_E:
        la a0, str
        add a0, a0, x2
        addi a0, a0, -1 
        lb x4, 0(a0)
        la a0, str
        add a0, a0, x3
        lb x5, 0(a0)
        la a0, str
        add a0, a0, x2
        addi a0, a0, -1
        sb x5, 0(a0)
        la a0, str
        add a0, a0, x3
        sb x4, 0(a0)
        addi x3, x3, 1
        addi x2, x2, -1
        bge x3, x2, end_E
        j loop_E
    end_E: 
        la a0, new_line
        li a7, 4
        ecall
        la a0, str
        li a7, 4
        ecall
jal x0, ret_inversion

d_inversion:
    la a0, str
    andi x1, x1, 0
    andi x2, x2, 0
    get_length_d:
        lb x1, 0(a0) 
        beq x1, x0, fin_E_d
        addi x2, x2, 1
        addi a0, a0, 1
        j get_length_d
    fin_E_d:
        andi x3, x3, 0
        loop_E_d:
        la a0, str
        add a0, a0, x2
        addi a0, a0, -1
        lb x4, 0(a0)
        la a0, str
        add a0, a0, x3
        lb x5, 0(a0)
        la a0, str
        add a0, a0, x2
        addi a0, a0, -1
        sb x5, 0(a0)
        la a0, str
        add a0, a0, x3
        sb x4, 0(a0)
        addi x3, x3, 1
        addi x2, x2, -1
        bge x3, x2, end_E_d
        j loop_E_d
    end_E_d: 
        la a0, new_line
        li a7, 4
        ecall
        la a0, str
        li a7, 4
        ecall
jal x0, retd_inversion