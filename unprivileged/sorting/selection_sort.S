#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    la   t0, array      # t0 = base address of array
    li   t1, 10         # t1 = array length

    li   t2, 0          # t2 = i = 0
outer_loop:
    bge  t2, t1, sort_end

    mv   t3, t2         # t3 = min_idx = i
    mv   t4, t2         # t4 = j = i

inner_loop:
    addi t4, t4, 1
    bge  t4, t1, swap_min

    slli t5, t4, 2
    add  t6, t0, t5     # t6 = &array[j]
    lw   a0, 0(t6)      # a0 = array[j]

    slli a1, t3, 2
    add  a2, t0, a1     # a2 = &array[min_idx]
    lw   a3, 0(a2)      # a3 = array[min_idx]

    blt  a0, a3, update_min
    j    inner_loop

update_min:
    mv   t3, t4
    j    inner_loop

swap_min:
    bne  t2, t3, do_swap
    addi t2, t2, 1
    j    outer_loop

do_swap:
    slli t5, t2, 2
    add  t6, t0, t5
    lw   a0, 0(t6)

    slli a1, t3, 2
    add  a2, t0, a1
    lw   a3, 0(a2)

    sw   a3, 0(t6)
    sw   a0, 0(a2)

    addi t2, t2, 1
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
array:  .word 15, 3, 7, 1, 9, 2, 6, 4, 5, 0
result: .space 40     # 10 words (sorted output will be here)
RVTEST_DATA_END
