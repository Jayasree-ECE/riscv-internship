#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    la   t0, var1          # Load address of var1 into t0
    lw   t1, 0(t0)         # Load var1 (32-bit) into t1

    la   t0, var2          # Load address of var2 into t0
    lw   t2, 0(t0)         # Load var2 (32-bit) into t2

    add  t3, t1, t2        # t3 = var1 + var2

    la   t0, result        # Load address of result into t0
    sw   t3, 0(t0)         # Store sum into result (32-bit)

    # Check if result == expected (30)
    li   t4, 30
    bne  t3, t4, fail

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2                 # 4-byte alignment for RV32
var1:   .word 10
var2:   .word 20
result: .space 4           # reserve 4 bytes for result
RVTEST_DATA_END
