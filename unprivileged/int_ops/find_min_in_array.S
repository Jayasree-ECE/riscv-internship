#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    la   t0, array        # t0 = base address of array
    li   t1, 5            # t1 = array length (number of elements)
    lw   t2, 0(t0)        # t2 = min (initialize with array[0])
    li   t3, 1            # t3 = loop counter (start from index 1)

loop:
    beq  t3, t1, end      # if i == length, exit loop
    slli t4, t3, 2        # t4 = i * 4 (byte offset)
    add  t5, t0, t4       # t5 = &array[i]
    lw   t6, 0(t5)        # t6 = array[i]
    blt  t6, t2, update   # if array[i] < min, update min
    addi t3, t3, 1        # i++
    j    loop

update:
    mv   t2, t6           # min = array[i]
    addi t3, t3, 1        # i++
    j    loop

end:
    la   t0, result
    sw   t2, 0(t0)        # store min in result

    # Optionally, check if min is as expected (here, 2)
    li   t4, 2
    bne  t2, t4, fail

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
array:  .word 5, 7, 2, 9, 8
result: .space 4
RVTEST_DATA_END
