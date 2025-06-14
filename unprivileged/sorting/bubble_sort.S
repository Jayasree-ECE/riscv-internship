#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    la   t0, array      # t0 = base address of array
    li   t1, 5          # t1 = array length

    addi t2, t1, -1     # t2 = n-1 (outer loop limit)
outer_loop:
    blez t2, sort_end   # if t2 <= 0, done

    li   t3, 0          # t3 = inner loop index (j = 0)
inner_loop:
    bge  t3, t2, next_outer

    slli t4, t3, 2      # t4 = j * 4 (byte offset)
    add  t5, t0, t4     # t5 = &array[j]
    lw   t6, 0(t5)      # t6 = array[j]
    addi a0, t5, 4      # a0 = &array[j+1]
    lw   a1, 0(a0)      # a1 = array[j+1]
    blt  t6, a1, no_swap

    # Swap array[j] and array[j+1]
    sw   a1, 0(t5)
    sw   t6, 0(a0)

no_swap:
    addi t3, t3, 1      # j++
    j    inner_loop

next_outer:
    addi t2, t2, -1     # n--
    j    outer_loop

sort_end:
    # Copy sorted array to result region for easy inspection
    la   t0, array      # t0 = &array[0]
    la   t1, result     # t1 = &result[0]
    li   t2, 5          # t2 = array length
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
array:  .word 6,7,9,3,8

result: .space 20     # 5 words (sorted output will be here)
RVTEST_DATA_END
