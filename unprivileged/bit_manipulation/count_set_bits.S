#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    la   t0, input      # t0 = &input
    lw   t1, 0(t0)      # t1 = input value (32 bits)
    sll  t1, t1, 32     # Zero-extend: shift left 32
    srl  t1, t1, 32     # then right 32 (RV64: upper bits now zero)
    li   t2, 0          # t2 = count

count_loop:
    beqz t1, done
    andi t3, t1, 1
    add  t2, t2, t3
    srli t1, t1, 1
    j    count_loop

done:
    la   t4, result     # t4 = &result
    sw   t2, 0(t4)      # store count in result
    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
input:  .word 0b10110101001011101101101001010101
result: .word 0
RVTEST_DATA_END
