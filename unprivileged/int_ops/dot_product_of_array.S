#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32UF
RVTEST_CODE_BEGIN

    la   t0, farray1        # t0 = base address of first array
    la   t1, farray2        # t1 = base address of second array
    li   t2, 5              # t2 = array length
    li   t3, 0              # t3 = index
    fmv.s.x ft0, zero       # ft0 = 0.0 (dot product sum)

dot_loop:
    bge  t3, t2, dot_end
    slli t4, t3, 2
    add  t5, t0, t4
    add  t6, t1, t4
    flw  ft1, 0(t5)
    flw  ft2, 0(t6)
    fmul.s ft3, ft1, ft2
    fadd.s ft0, ft0, ft3
    addi t3, t3, 1
    j    dot_loop

dot_end:
    la   t0, fresult
    fsw  ft0, 0(t0)

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
farray1: .float 1.5, -2.5, 3.0, 7.2, 4.0
farray2: .float 2.0, 0.5, -1.0, 1.0, 2.0
fresult: .space 4
RVTEST_DATA_END
