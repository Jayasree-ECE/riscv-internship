#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

    la   t0, darray         # t0 = base address of double array
    li   t1, 5              # t1 = array length
    li   t2, 1              # t2 = index (start from 1)

    fld  ft0, 0(t0)         # ft0 = darray[0] (current max)

dmax_loop:
    bge  t2, t1, dend       # if index >= length, done
    slli t3, t2, 3          # t3 = index * 8 (byte offset for double)
    add  t4, t0, t3         # t4 = &darray[index]
    fld  ft1, 0(t4)         # ft1 = darray[index]
    fmax.d ft0, ft0, ft1    # ft0 = max(ft0, ft1)
    addi t2, t2, 1          # index++
    j    dmax_loop

dend:
    la   t0, dresult
    fsd  ft0, 0(t0)         # store max in signature region

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 3
darray:  .double 1.5, -2.5, 3.0, 7.2, 4.0
dresult: .space 8
RVTEST_DATA_END
