#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

    la   t0, array          # t0 = base address of array
    li   t1, 5              # t1 = array length
    li   t2, 0              # t2 = index (i)
    li   t3, 4              # t3 = value to search for
    li   t4, -1             # t4 = result (default: not found)

search_loop:
    beq  t2, t1, not_found  # if i == length, not found
    slli a0, t2, 2          # a0 = i * 4 (offset)
    add  a1, t0, a0         # a1 = &array[i]
    lw   a2, 0(a1)          # a2 = array[i]
    beq  a2, t3, found      # if array[i] == value, found
    addi t2, t2, 1          # i++
    j    search_loop

found:
    mv   t4, t2             # t4 = index where found

not_found:
    la   t0, result
    sw   t4, 0(t0)          # store result (index or -1)

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
  .align 2
array:  .word 5, 7, 2, 4, 8
result: .space 4
RVTEST_DATA_END
