#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32UF
RVTEST_CODE_BEGIN

    # Load floating-point values from memory
    la   t0, fval1
    flw  ft0, 0(t0)         # ft0 = fval1 (e.g., 3.5)

    la   t0, fval2
    flw  ft1, 0(t0)         # ft1 = fval2 (e.g., 2.0)

    # Floating-point addition: ft2 = ft0 + ft1
    fadd.s ft2, ft0, ft1

    # Floating-point subtraction: ft3 = ft0 - ft1
    fsub.s ft3, ft0, ft1

    # Floating-point multiplication: ft4 = ft0 * ft1
    fmul.s ft4, ft0, ft1

    # Floating-point division: ft5 = ft0 / ft1
    fdiv.s ft5, ft0, ft1

    # Store results to memory (signature region)
    la   t0, fresult
    fsw  ft2, 0(t0)         # store addition result
    fsw  ft3, 4(t0)         # store subtraction result
    fsw  ft4, 8(t0)         # store multiplication result
    fsw  ft5, 12(t0)        # store division result

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
fval1:   .float 3.5
fval2:   .float 2.0
fresult: .space 16          # space for 4 floats (4 bytes each)
RVTEST_DATA_END
