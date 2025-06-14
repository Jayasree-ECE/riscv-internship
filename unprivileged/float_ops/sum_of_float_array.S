#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32UF
RVTEST_CODE_BEGIN

    la   t0, farray         # t0 = base address of array
    li   t1, 5              # t1 = array length
    flw  ft0, 0(t0)         # ft0 = farray[0] (initialize sum)
    li   t2, 1              # t2 = index (start from 1)

sum_loop:
    bge  t2, t1, end        # if index >= length, done
    slli t3, t2, 2          # t3 = index * 4 (byte offset)
    add  t4, t0, t3         # t4 = &farray[index]
    flw  ft1, 0(t4)         # ft1 = farray[index]
    fadd.s ft0, ft0, ft1    # sum += farray[index]
    addi t2, t2, 1          # index++
    j    sum_loop

end:
    la   t0, fresult
    fsw  ft0, 0(t0)         # store sum in signature region

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
farray:  .float 1.5, 2.5, 3.0, 4.0, 5.0
fresult: .space 4
RVTEST_DATA_END
