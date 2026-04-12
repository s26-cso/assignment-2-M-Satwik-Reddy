.global main

.section .rodata
filename: .string "input.txt"
mode: .string "r"
yes_str: .string "Yes\n"
no_str: .string "No\n"

.text

main:
    addi sp, sp, -48
    sd x1, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)
    sd s4, 0(sp)

    la a0, filename
    la a1, mode
    call fopen
    addi s0, a0, 0                #s0 = file pointer

    beq s0, x0, print_no          #if s0 = NULL print no_str

    addi a0, s0, 0
    addi a1, x0, 0
    addi a2, x0, 2              #2 represent SEEK_END
    call fseek                  #fseek(fp, 0, SEEK_END)

    #ftell(fp)
    addi a0,  s0, 0
    call ftell
    addi s2,a0, 0               #s2 = file length

    ble s2, x0, empty           #empty string

    addi a1, s2, -1             
    addi a0, s0, 0
    addi a2, x0, 0              #SEEK_SET = 0
    call fseek

    addi a0, s0, 0
    call fgetc
    addi t0, x0, 10             # 10 = ASCII for '\n'
    bne a0, t0, not_newline    # if not a newline then skip

    addi s2, s2, -1

not_newline:
    addi s2, s2, -1             #s2 = len - 1 (right_index)
    addi s1, x0, 0              #s1 = 0 (left_index)

loop:
    bge s1, s2, print_yes       #if (left_index >= right_index) print_yes 

    #left_index
    addi a0, s0, 0
    addi a1, s1, 0
    addi a2, x0, 0              #SEEK_SET = 0
    call fseek

    addi a0, s0, 0
    call fgetc
    addi s3, a0, 0              #s3 = left char

    #right_index
    addi a0, s0, 0
    addi a1, s2, 0
    addi a2, x0, 0              #SEEK_SET = 0
    call fseek

    addi a0, s0, 0
    call fgetc
    addi s4, a0, 0              #s4 = right char

    bne s3, s4, no1             #if(left_char != right_char) print no and fclose

    addi s1, s1, 1              #left++
    addi s2, s2, -1             #right--
    beq x0, x0, loop            #jump to loop

empty:
    beq x0, x0, print_yes       # jump to print_yes

no1:
    addi a0, s0, 0
    call fclose
print_no:
    la a0, no_str
    call printf
    beq x0, x0, end

print_yes:
    addi a0, s0, 0
    call fclose
    la a0, yes_str
    call printf

end:
    addi a0, x0, 0
    ld x1, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    ld s4, 0(sp)
    addi sp, sp, 48
    jalr x0, 0(x1)
