#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32UF
RVTEST_CODE_BEGIN

    la   t0, farray          # t0 = base address of input array
    la   t1, fresult         # t1 = base address of result array
    li   t2, 5               # t2 = array length
    li   t3, 0               # t3 = index
    fmv.s.x ft1, zero        # ft1 = 0.0 (running sum)

cumsum_loop:
    bge  t3, t2, cumsum_end
    slli t4, t3, 2
    add  t5, t0, t4
    add  t6, t1, t4
    flw  ft0, 0(t5)
    fadd.s ft1, ft1, ft0
    fsw  ft1, 0(t6)
    addi t3, t3, 1
    j    cumsum_loop

cumsum_end:
    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
farray:  .float 1.5, -2.5, 3.0, 7.2, 4.0
fresult: .space 20
RVTEST_DATA_END
