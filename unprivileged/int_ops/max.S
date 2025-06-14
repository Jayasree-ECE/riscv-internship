#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    # Load values from memory
    la   t0, num1
    lw   t1, 0(t0)      # t1 = num1

    la   t0, num2
    lw   t2, 0(t0)      # t2 = num2

    # Compare t1 and t2
    blt  t1, t2, else_case  # if t1 < t2, branch to else_case

    # If t1 >= t2
    la   t0, result
    sw   t1, 0(t0)      # result = t1 (num1 is max)
    j    done

else_case:
    la   t0, result
    sw   t2, 0(t0)      # result = t2 (num2 is max)

done:
    # Optionally, check if result is as expected (change expected value as needed)
    li   t3, 50         # Suppose max should be 50
    la   t0, result
    lw   t4, 0(t0)
    bne  t4, t3, fail

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
num1:   .word 50
num2:   .word 20
result: .space 4
RVTEST_DATA_END
