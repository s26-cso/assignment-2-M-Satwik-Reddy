.global main

.section .rodata
fmt: .string "%d "
fmt_nl: .string "\n"

.text

main:
    addi sp, sp, -80
    sd x1, 72(sp)
    sd s0, 64(sp)
    sd s1, 56(sp)
    sd s2, 48(sp)
    sd s3, 40(sp)
    sd s4, 32(sp)
    sd s5, 24(sp)
    sd s6, 16(sp)
    sd s7, 8(sp)

    #a0 = number of words including ./a.out
    #a1 = pointer to each word in first line

    addi t0, x0, 2
    blt a0, t0, end                   #if only 1 number in array (./a.out + 1 element so 2) go to end

    addi s0, a0, -1                         #s0 = n = number of words - 1(./a.out)
    addi s1, a1, 0                          #s1 = pointer to array of strings

    slli a0, s0, 2                          #a0 = n * 4
    call malloc
    addi s2, a0, 0                          #s2 = arr

    slli a0, s0, 2
    call malloc
    addi s3, a0, 0                          #s3 = result

    slli a0, s0, 2
    call malloc
    addi s4, a0, 0                          #s4 = stack

    addi s5, x0 ,0                          #s5 = i = 0

loop:
    bge s5, s0, done                        #if(i >= n) go to done

    addi t0, s5, 1                          #t0 = i + 1
    slli t0, t0, 3                          #(i + 1) * 8
    add t0, s1, t0                          #arr + (i+1)*8
    ld a0, 0(t0)                            #a0 = arr[i + 1]
    call atoi                               #convert string to int

    slli t1, s5, 2                          # t1 = i * 4
    add t2, s2, t1                          # arr + i*4
    sw a0, 0(t2)                            #arr[i] = atoi(arr[i + 1])

    addi t3, x0, -1
    add t4, s3, t1                          #result + i*4
    sw t3, 0(t4)                            #result[i] = -1

    addi s5, s5, 1                          #i++
    beq x0, x0, loop                        #jump to loop

done:
    addi s6, x0, 0                          #s6 = top
    addi s5, s0, -1                         #s5 = i = n - 1

loop1:
    blt s5, x0, done1                       #if(i < 0) go to done1

    slli t0, s5, 2                          #t0 = i * 4
    add t1, s2, t0                          #arr + i*4
    lw s7, 0(t1)                            #s7 = arr[i]

while_loop:
    beq s6, x0, loop_end                    #if stack_pointer == 0 break
    addi t2, s6, -1                         #stack_pointer - 1
    slli t2, t2, 2                          #(stack_pointer - 1) * 4
    add t3, s4, t2                          #stack + (stack_pointer - 1) * 4
    lw t4, 0(t3)                            #t4 = top = stack[stack_pointer - 1]

    slli t5, t4, 2                          #top * 4
    add t6, s2, t5                          #arr + top*4
    lw t6, 0(t6)                            #t6 = arr[top]

    bgt t6, s7, loop_end                    #if(arr[top] > arr[i]) break
    addi s6, s6, -1                         #stack_pointer--
    beq x0, x0, while_loop

loop_end:
    beq s6, x0, push                       #if stack is empty, skip

    addi t2, s6, -1
    slli t2, t2, 2
    add t3, s4, t2
    lw t4, 0(t3)                            #t4 = top

    slli t0, s5, 2
    add t5, s3, t0
    sw t4, 0(t5)

push:
    slli t2, s6, 2                          #stack_pointer * 4
    add t3, s4, t2                          #stack + stack_pointer*4
    sw s5, 0(t3)                            #stack[stack_pointer] = i
    addi s6, s6, 1                          #stack_pointer++
    addi s5, s5, -1                         # i--
    beq x0, x0, loop1

done1:
    addi s5, x0, 0                          #i = 0
print:
    bge s5, s0, print_done                  #if (i >= n) done printing

    slli t0, s5, 2
    add t1, s3, t0                          #result + i*4
    lw a1, 0(t1)                            #a1 = result[i]
    la a0, fmt                              #a0 = "%d "
    call printf
    addi s5, s5, 1                          #i++
    beq x0, x0, print

print_done:
    la a0, fmt_nl
    call printf

end:
    addi a0, x0, 0
    ld s7, 8(sp)
    ld s6, 16(sp)
    ld s5, 24(sp)
    ld s4, 32(sp)
    ld s3, 40(sp)
    ld s2, 48(sp)
    ld s1, 56(sp)
    ld s0, 64(sp)
    ld x1, 72(sp)
    addi sp, sp, 80
    ret
