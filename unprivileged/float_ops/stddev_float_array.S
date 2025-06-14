#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32UF
RVTEST_CODE_BEGIN

    la   t0, farray         # t0 = base address of array
    li   t1, 5              # t1 = array length

    # Step 1: Compute mean
    fmv.s.x ft0, zero
    li   t2, 0
mean_loop:
    bge  t2, t1, mean_end
    slli t3, t2, 2
    add  t4, t0, t3
    flw  ft1, 0(t4)
    fadd.s ft0, ft0, ft1
    addi t2, t2, 1
    j    mean_loop
mean_end:
    li   t2, 5
    fcvt.s.w ft2, t2
    fdiv.s ft0, ft0, ft2    # ft0 = mean

    # Step 2: Compute sum of (x - mean)^2
    fmv.s.x ft3, zero
    li   t2, 0
var_loop:
    bge  t2, t1, var_end
    slli t3, t2, 2
    add  t4, t0, t3
    flw  ft1, 0(t4)
    fsub.s ft5, ft1, ft0
    fmul.s ft5, ft5, ft5
    fadd.s ft3, ft3, ft5
    addi t2, t2, 1
    j    var_loop
var_end:
    li   t2, 5
    fcvt.s.w ft2, t2
    fdiv.s ft3, ft3, ft2    # variance
    fsqrt.s ft3, ft3        # standard deviation

    la   t0, fresult
    fsw  ft3, 0(t0)

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
