#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    li a0, 3
    li a1, 2
    add a2, a0, a1     # a2 = 3 + 2 = 5
    li  t0, 5         # t0 = expected result



    bne a2, t0, fail   # if a2 != 5, fail

      la s0, result
      sw t0, 0(s0)
    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 3
  result: .space 4
RVTEST_DATA_END