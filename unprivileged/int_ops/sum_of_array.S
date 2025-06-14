#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    la   t0, array        # t0 = base address of array
    li   t1, 5            # t1 = array length (number of elements)
    li   t2, 0            # t2 = sum (accumulator)
    li   t3, 0            # t3 = loop counter (i)

loop:
    beq  t3, t1, end      # if i == length, exit loop
    lw   t4, 0(t0)        # load array[i] into t4
    add  t2, t2, t4       # sum += array[i]
    addi t0, t0, 4        # advance pointer to next element
    addi t3, t3, 1        # i++
    j    loop

end:
    la   t0, result
    sw   t2, 0(t0)        # store sum in result

    # Optionally, check if sum is as expected (here, 15)
    li   t4, 15
    bne  t2, t4, fail

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
array:  .word 1, 2, 3, 4, 5
result: .space 4
RVTEST_DATA_END
