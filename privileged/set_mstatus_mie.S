#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32M
RVTEST_CODE_BEGIN

    csrr a0, mstatus        # Read original mstatus
    ori  a1, a0, 0x8        # Set MIE bit (bit 3)
    csrw mstatus, a1        # Write back with MIE set
    csrr a2, mstatus        # Read back to verify
    la   s0, result
    sw   a0, 0(s0)          # Store original mstatus
    sw   a2, 4(s0)          # Store new mstatus

RVTEST_PASS
fail:
RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
.align 3
result: .space 8
RVTEST_DATA_END
