.data
    dataset1: .word 0x3fcccccd    #1.6
    dataset2: .word 0xbfc00000    #-1.5
    dataset3: .word 0x3fb33333    #1.4
    dataset4: .word 0xbfa66666    #-1.3
    dataset5: .word 0x3f99999a    #1.2
    dataset6: .word 0xbf8ccccd    #-1.1
    array_size: .word 0x00000006
    _EOL: .string "\n"
.text

main:
    addi, sp,sp,-20
    lw, s0,dataset1    
    lw, s1,dataset2    
    lw, s2,dataset3    
    lw, s3,dataset4    
    lw, s4,dataset5    
    lw, s5,dataset6    
    sw, s0,0(sp)
    sw, s1,4(sp)
    sw, s2,8(sp)
    sw, s3,12(sp)
    sw, s4,16(sp)
    sw, s5,20(sp)
    lw, s11,array_size
    jal, ShellSort

ShellSort:
    lw, t0,array_size      
    srli, t0,t0,1          # int interval = array_size / 2;

Whileinterval:
    beq, t0,zero,Print     # while (interval >0)
    add, t1,zero,t0        # i = interval

Foriarraysize:
    beq, t1,s11,Interval_div2    # i<interval
    add, t2,zero,t1              # j = i
    slli, s0,t1,2                # temp = array[i] ,t4 = temp
    add, s1,sp,s0
    lw, t4,0(s1)

ReadData_Temp_done:
    sub, t3,t2,t0                # j = j - interval
    slli, s0,t3,2                # array[j-interval] ,t5 = j-interval
    add, s1,sp,s0
    lw, t5,0(s1)
    jal, BOS                     # Flag = BOS(array[j-interval], temp);

WhilejandFlag:
    beq, s10,zero,arrayjtotemp     
    bltu, t2,t0,arrayjtotemp       # while (j>= interval && Flag == 1)
    slli, s0,t2,2                  # array[j] = array[j-interval]
    add, s1,sp,s0
    sw, t5,0(s1)
    sub,t2,t2,t0
    jal, ReadData_Temp_done

arrayjtotemp:
    slli, s0,t2,2          # array[j] = temp
    add, s1,sp,s0
    sw, t4,0(s1)
    addi, t1,t1,1          # i++
    jal, Foriarraysize

Interval_div2:
    srli, t0,t0,1
    jal, Whileinterval

#--------------------------------------------------

BOS:
    xor, t6,t4,t5
    srli, t6,t6,31
    beq, t6,zero,Same
    blt, t5,t4,Big
    addi, s10,zero,1
    jal, WhilejandFlag

Big:
    add, s10,zero,zero
    jal, WhilejandFlag

Same:
    srli, t6,t4,31
    beq, t6,zero,pos
    bltu, t5,t4,negBig
    add, s10,zero,zero
    jal, WhilejandFlag

negBig:
    addi, s10,zero,1
    jal, WhilejandFlag

pos:
    blt, t5,t4,posBig
    addi, s10,zero,1
    jal, WhilejandFlag

posBig:
    add, s10,zero,zero
    jal, WhilejandFlag

#--------------------------------------------------

Print:
    slli, s0,t6,2
    add, s1,sp,s0
    lw, a0,0(s1)
    li, a7,2
    ecall
    addi, t6,t6,1
    la, a0,_EOL
    li, a7,4
    ecall
    beq, t6,s11,End
    jal, Print

End:   
    addi, sp,sp,20
    li, a7,10
    ecall