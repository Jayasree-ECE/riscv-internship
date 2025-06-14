#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    la   t0, array      # t0 = base address of array
    li   t1, 10         # t1 = array length

    li   t2, 1          # t2 = i = 1
outer_loop:
    bge  t2, t1, sort_end

    slli t3, t2, 2      # t3 = i * 4
    add  t4, t0, t3     # t4 = &array[i]
    lw   t5, 0(t4)      # t5 = key = array[i]
    addi t6, t2, -1     # t6 = j = i - 1

inner_loop:
    bltz t6, insert_key # if j < 0, insert key

    slli a0, t6, 2      # a0 = j * 4
    add  a1, t0, a0     # a1 = &array[j]
    lw   a2, 0(a1)      # a2 = array[j]
    ble  a2, t5, insert_key

    addi a3, a1, 4      # a3 = &array[j+1]
    sw   a2, 0(a3)      # array[j+1] = array[j]
    addi t6, t6, -1     # j--
    j    inner_loop

insert_key:
    addi a0, t6, 1      # a0 = j+1
    slli a1, a0, 2      # a1 = (j+1)*4
    add  a2, t0, a1     # a2 = &array[j+1]
    sw   t5, 0(a2)      # array[j+1] = key

    addi t2, t2, 1      # i++
    j    outer_loop

sort_end:
    # Copy sorted array to result region for easy inspection
    la   t0, array      # t0 = &array[0]
    la   t1, result     # t1 = &result[0]
    li   t2, 10         # t2 = array length
    li   t3, 0          # t3 = index

copy_loop:
    bge  t3, t2, copy_done
    slli t4, t3, 2
    add  t5, t0, t4
    add  t6, t1, t4
    lw   a0, 0(t5)
    sw   a0, 0(t6)
    addi t3, t3, 1
    j    copy_loop

copy_done:
    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
array:  .word 8, 3, 7, 1, 9, 2, 6, 4, 5, 0
result: .space 40     # 10 words (sorted output will be here)
RVTEST_DATA_END
