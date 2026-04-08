.text
.global make_node
.global insert
.global get
.global getAtMost

make_node:
    addi sp, sp, -16
    sd x1, 8(sp)
    sd s0, 0(sp)

    addi s0, a0, 0          #s0 = val

    addi a0, x0, 24         #struct size
    call malloc             #a0 = address to malloc

    sw s0, 0(a0)            #node->val = val
    sd x0, 8(a0)            #node->left = NULL
    sd x0, 16(a0)           #node->right = NULL

    ld s0, 0(sp)
    ld x1, 8(sp)
    addi sp, sp,16

    jalr x0, 0(x1)

#insert

insert:
    addi sp, sp, -32
    sd x1, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    beq a0,  x0, empty_tree     #if root == NULL go to emty_tree
    addi s0, a0, 0              #s0 = root
    addi s1, a1, 0              #s1 = val

    lw t0, 0(s0)                #t0 = root->val
    bge s1, t0, right           #if val >= root->val go  right
                                #if didnt go to right, then will come here
    ld a0, 8(s0)                #a0 = root->left
    addi a1, s1, 0              #a1 = val
    call insert                 #insert(root->left, val)
    sd a0, 8(s0)                #root->left = node returned
    beq x0, x0, end             #go to end

right:
    ld a0, 16(s0)               #a0 = root->right
    addi a1, s1, 0              #a1 = val
    call insert                 #insert(root->right, val)
    sd a0, 16(s0)               #root->right = node returned
    beq x0, x0, end             #go to end

empty_tree:
    addi a0, a1, 0
    call make_node              #a0 = new node pointer
    beq x0, x0, end1

end:
    addi a0, s0, 0              #return value = current root
end1:
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld x1, 24(sp)
    addi sp, sp, 32
    jalr x0, 0(x1)

#get

get:
    addi sp, sp, -16
    sd x1, 8(sp)

search:
    beq a0, x0, found       #if root == NULL go to found
    lw t0, 0(a0)            #t0 = root->val
    beq a1, t0, found       #if(root->val == val) go to found
    blt a1, t0, get_left    #if(val < root->val) go to get_left

    ld a0, 16(a0)           #root = root->right
    beq x0, x0, search      #go to search

get_left:
    ld a0, 8(a0)            #root = root->left
    beq x0, x0, search      #go to search

found:
    ld x1, 8(sp)
    addi sp, sp, 16
    jalr x0, 0(x1)

#getAtMost

getAtMost:
    addi sp, sp, -16
    sd x1, 8(sp)

    addi t0, a0, 0          #t0 = val
    addi t1, a1, 0          #t1 = root
    addi a0, x0, -1         #a0 = -1

predecessor:
    beq t1, x0, finish          #if(root == NULL) go to finish
    lw t2, 0(t1)                #t2 = root->val
    beq t2, t0, equal           #if(root->val == val) go to equal
    bgt t2, t0, left            #if(root->val > val) go left
                                #going to right
    addi a0, t2, 0              #best = root->val
    ld t1, 16(t1)               #root = root->right
    beq x0,  x0, predecessor    #go to predecessor

left:
    ld t1, 8(t1)                #root = root->left
    beq x0, x0, predecessor     #go to predecessor

equal:
    addi a0, t2, 0              #best = root->val

finish:
    ld x1, 8(sp)
    addi sp, sp, 16
    jalr x0, 0(x1)
