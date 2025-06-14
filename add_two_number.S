#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # Test add: 12 + 8 = 20
  TEST_RR_OP(1, add, 20, 12, 8)

  TEST_PASSFAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
