#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32M
RVTEST_CODE_BEGIN

    li   a0, 0x12345678
    csrw mscratch, a0
    csrr a1, mscratch
    la   s0, result
    sw   a1, 0(s0)

RVTEST_PASS
fail:
RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
.align 3
result: .space 4
RVTEST_DATA_END
