.data
    dataset1: .word 0x3fcccccd    #1.6
    dataset2: .word 0xbfc00000    #-1.5
    dataset3: .word 0x3fb33333    #1.4
    dataset4: .word 0xbfa66666    #-1.3
    dataset5: .word 0x3f99999a    #1.2
    dataset6: .word 0xbf8ccccd    #-1.1
.text
main:
    addi, sp,sp,-20
    lw, s0,dataset1    #1.6
    lw, s1,dataset2    #-1.5
    lw, s2,dataset3    #1.4
    lw, s3,dataset4    #-1.3
    lw, s4,dataset5    #1.2
    lw, s5,dataset6    #-1.1
    sw, s0,0(sp)
    sw, s1,4(sp)
    sw, s2,8(sp)
    sw, s3,12(sp)
    sw, s4,16(sp)
    sw, s5,20(sp)
    li, a1,0x00000001
    li, a2,0x00000002
    li, a3,0x00000003
    li, a4,0x00000004
    li, a5,0x00000005
    li, a6,0x00000006
    li, s11,0x00000006
    jal, ShellSort
End:
    lw, s0,0(sp)    
    lw, s1,4(sp)    
    lw, s2,8(sp)    
    lw, s3,12(sp)    
    lw, s4,16(sp)    
    lw, s5,20(sp)    
    addi, sp,sp,20
    li, a7,10
    ecall
ShellSort:
    add, t0,zero,a6      #
    srli, t0,t0,1        # interval
Whileinterval:
    beq, t0,zero,End
    add, t1,zero,t0            # i = interval
Foriarraysize:
    beq, t1,s11,Interval_div2    # i<interval
    add, t2,zero,t1              # j = i
    
    # temp = array[i]
    beq, t1,zero,ReadData0_Temp
    beq, t1,a1,ReadData1_Temp
    beq, t1,a2,ReadData2_Temp
    beq, t1,a3,ReadData3_Temp
    beq, t1,a4,ReadData4_Temp
    beq, t1,a5,ReadData5_Temp
ReadData_Temp_done:
    sub, t3,t2,t0                # j = j - interval
    # array[j-interval]
    beq, t3,zero,ReadData0_jinterval
    beq, t3,a1,ReadData1_jinterval
    beq, t3,a2,ReadData2_jinterval
    beq, t3,a3,ReadData3_jinterval
    beq, t3,a4,ReadData4_jinterval
    beq, t3,a5,ReadData5_jinterval
WhilejandFlag:
    beq, s10,zero,arrayjtotemp    # flag
    bltu, t2,t0,arrayjtotemp     # j>= interval
    beq, t2,zero,LoadData0_jtointerval    # array[j] = array[j-interval]
    beq, t2,a1,LoadData1_jtointerval    # array[j] = array[j-interval]
    beq, t2,a2,LoadData2_jtointerval    # array[j] = array[j-interval]
    beq, t2,a3,LoadData3_jtointerval    # array[j] = array[j-interval]
    beq, t2,a4,LoadData4_jtointerval    # array[j] = array[j-interval]
    beq, t2,a5,LoadData5_jtointerval    # array[j] = array[j-interval]
arrayjtotemp:
    # array[j] = temp
    beq, t2,zero,LoadData0_jtotemp    # array[j] = temp
    beq, t2,a1,LoadData1_jtotemp    # array[j] = temp
    beq, t2,a2,LoadData2_jtotemp    # array[j] = temp
    beq, t2,a3,LoadData3_jtotemp    # array[j] = temp
    beq, t2,a4,LoadData4_jtotemp    # array[j] = temp
    beq, t2,a5,LoadData5_jtotemp    # array[j] = temp
Interval_div2:
    srli, t0,t0,1
    jal, Whileinterval
#--------------------------------------------------
BOS:
    # code
    jal, WhilejandFlag
fp32_to_bf16:
    # code
    # jal, BOS
    xor, t6,t4,t5
    srli, t6,t6,31
    beq, t6,zero,Same
    blt, t5,t4,Big
    add, s10,zero,a1
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
    add, s10,zero,a1
    jal, WhilejandFlag
pos:
    blt, t5,t4,posBig
    add, s10,zero,a1
    jal, WhilejandFlag
posBig:
    add, s10,zero,zero
    jal, WhilejandFlag
#--------------------------------------------------
ReadData0_Temp:
    lw, t4,0(sp)
    jal, ReadData_Temp_done
ReadData1_Temp:
    lw, t4,4(sp)
    jal, ReadData_Temp_done
ReadData2_Temp:
    lw, t4,8(sp)
    jal, ReadData_Temp_done
ReadData3_Temp:
    lw, t4,12(sp)
    jal, ReadData_Temp_done
ReadData4_Temp:
    lw, t4,16(sp)
    jal, ReadData_Temp_done
ReadData5_Temp:
    lw, t4,20(sp)
    jal, ReadData_Temp_done
ReadData0_jinterval:
    lw, t5,0(sp)
    jal, fp32_to_bf16
ReadData1_jinterval:
    lw, t5,4(sp)
    jal, fp32_to_bf16
ReadData2_jinterval:
    lw, t5,8(sp)
    jal, fp32_to_bf16
ReadData3_jinterval:
    lw, t5,12(sp)
    jal, fp32_to_bf16
ReadData4_jinterval:
    lw, t5,16(sp)
    jal, fp32_to_bf16
ReadData5_jinterval:
    lw, t5,20(sp)
    jal, fp32_to_bf16
LoadData0_jtotemp:
    sw, t4,0(sp)
    addi, t1,t1,1          # i++
    jal, Foriarraysize
LoadData1_jtotemp:
    sw, t4,4(sp)
    addi, t1,t1,1          # i++
    jal, Foriarraysize
LoadData2_jtotemp:
    sw, t4,8(sp)
    addi, t1,t1,1          # i++
    jal, Foriarraysize
LoadData3_jtotemp:
    sw, t4,12(sp)
    addi, t1,t1,1          # i++
    jal, Foriarraysize
LoadData4_jtotemp:
    sw, t4,16(sp)
    addi, t1,t1,1          # i++
    jal, Foriarraysize
LoadData5_jtotemp:
    sw, t4,20(sp)
    addi, t1,t1,1          # i++
    jal, Foriarraysize
LoadData0_jtointerval:
    sw, t5,0(sp)
    sub, t2,t2,t0      # j = j-interval
    jal, ReadData_Temp_done  # Flag
LoadData1_jtointerval:
    sw, t5,4(sp)
    sub, t2,t2,t0
    jal, ReadData_Temp_done
LoadData2_jtointerval:
    sw, t5,8(sp)
    sub, t2,t2,t0
    jal, ReadData_Temp_done
LoadData3_jtointerval:
    sw, t5,12(sp)
    sub, t2,t2,t0
    jal, ReadData_Temp_done
LoadData4_jtointerval:
    sw, t5,16(sp)
    sub, t2,t2,t0
    jal, ReadData_Temp_done
LoadData5_jtointerval:
    sw, t5,20(sp)
    sub, t2,t2,t0
    jal, ReadData_Temp_done