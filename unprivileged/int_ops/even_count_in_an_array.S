#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    la   t0, array          # t0 = base address of array
    li   t1, 7              # t1 = array length
    li   t2, 0              # t2 = index (i)
    li   t3, 0              # t3 = even count

count_loop:
    beq  t2, t1, end        # if i == length, done
    slli a0, t2, 2          # a0 = i * 4 (offset)
    add  a1, t0, a0         # a1 = &array[i]
    lw   a2, 0(a1)          # a2 = array[i]
    andi a3, a2, 1          # a3 = array[i] & 1 (checks LSB)
    beq  a3, zero, is_even  # if (array[i] & 1) == 0, it's even
    addi t2, t2, 1          # i++
    j    count_loop

is_even:
    addi t3, t3, 1          # even count++
    addi t2, t2, 1          # i++
    j    count_loop

end:
    la   t0, result
    sw   t3, 0(t0)          # store even count in signature region

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
array:  .word 6, 7, 2, 9, 4, 8, 11
result: .space 4
RVTEST_DATA_END
