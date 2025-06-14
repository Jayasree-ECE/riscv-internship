#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32UF
RVTEST_CODE_BEGIN

    la   t0, farray         # t0 = base address of array
    li   t1, 5              # t1 = array length
    fmv.s.x ft0, zero       # ft0 = 0.0 (sum)
    li   t2, 0              # t2 = index

mean_loop:
    bge  t2, t1, mean_end
    slli t3, t2, 2
    add  t4, t0, t3
    flw  ft1, 0(t4)
    fadd.s ft0, ft0, ft1
    addi t2, t2, 1
    j    mean_loop

mean_end:
    # Divide sum by array length
    li   t1, 5
    fcvt.s.w ft2, t1        # Convert int length to float in ft2
    fdiv.s ft0, ft0, ft2    # ft0 = sum / length

    la   t0, fresult
    fsw  ft0, 0(t0)

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
farray:  .float 1.5, -2.5, 3.0, 7.2, 4.0
fresult: .space 4
RVTEST_DATA_END
