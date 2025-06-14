#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    la   t0, array          # t0 = base address of array (start)
    li   t1, 5              # t1 = array length
    srli t5, t1, 1          # t5 = length / 2 (loop limit)
    slli t2, t1, 2          # t2 = length * 4 (bytes)
    add  t3, t0, t2         # t3 = &array[length] (one past last)
    addi t3, t3, -4         # t3 = &array[length-1] (actual last element)
    li   t4, 0              # t4 = i (start index)

loop:
    bge  t4, t5, end        # if i >= length/2, done

    slli a0, t4, 2          # a0 = i * 4 (offset)
    add  a1, t0, a0         # a1 = &array[i]
    lw   a2, 0(a1)          # a2 = array[i]
    lw   a3, 0(t3)          # a3 = array[length-1-i]
    sw   a3, 0(a1)          # array[i] = array[length-1-i]
    sw   a2, 0(t3)          # array[length-1-i] = array[i]

    addi t4, t4, 1          # i++
    addi t3, t3, -4         # move end pointer backward
    j loop

end:
    # Copy reversed array to signature region for checking
    la   t0, array
    la   t1, result
    li   t2, 5
copy_loop:
    beqz t2, done
    lw   a0, 0(t0)
    sw   a0, 0(t1)
    addi t0, t0, 4
    addi t1, t1, 4
    addi t2, t2, -1
    j copy_loop

done:
    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
array:  .word 1, 2, 3, 4, 5
result: .space 20         # space for 5 reversed elements
RVTEST_DATA_END
