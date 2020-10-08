// NOTE: Assertions have been autogenerated by utils/generate-test-checks.py
// RUN: circt-opt %s -llhd-memory-to-block-argument -split-input-file -verify-diagnostics | FileCheck %s

// CHECK-LABEL:   llhd.proc @check_simple() -> () {
// CHECK:           %[[VAL_0:.*]] = llhd.const 5 : i32
// CHECK:           %[[VAL_1:.*]] = llhd.const true : i1
// CHECK:           cond_br %[[VAL_1]], ^bb1, ^bb2
// CHECK:         ^bb1:
// CHECK:           %[[VAL_2:.*]] = llhd.const 6 : i32
// CHECK:           br ^bb3(%[[VAL_2]] : i32)
// CHECK:         ^bb2:
// CHECK:           %[[VAL_3:.*]] = llhd.const 7 : i32
// CHECK:           br ^bb3(%[[VAL_3]] : i32)
// CHECK:         ^bb3(%[[VAL_4:.*]]: i32):
// CHECK:           %[[VAL_5:.*]] = llhd.not %[[VAL_4]] : i32
// CHECK:           llhd.halt
// CHECK:         }
llhd.proc @check_simple() -> () {
  %c5 = llhd.const 5 : i32
  %cond = llhd.const 1 : i1
  %ptr = llhd.var %c5 : i32
  cond_br %cond, ^bb1, ^bb2
^bb1:
  %c6 = llhd.const 6 : i32
  llhd.store %ptr, %c6 : !llhd.ptr<i32>
  br ^bb3
^bb2:
  %c7 = llhd.const 7 : i32
  llhd.store %ptr, %c7 : !llhd.ptr<i32>
  br ^bb3
^bb3:
  %ld = llhd.load %ptr : !llhd.ptr<i32>
  %res = llhd.not %ld : i32
  llhd.halt
}

// CHECK-LABEL:   func @allocate_mem() -> !llhd.ptr<i32> {
// CHECK:           %[[VAL_0:.*]] = llhd.const 0 : i32
// CHECK:           %[[VAL_1:.*]] = llhd.var %[[VAL_0]] : i32
// CHECK:           return %[[VAL_1]] : !llhd.ptr<i32>
// CHECK:         }
func @allocate_mem() -> !llhd.ptr<i32> {
  %c = llhd.const 0 : i32
  %ptr = llhd.var %c : i32
  return %ptr : !llhd.ptr<i32>
}

// CHECK-LABEL:   llhd.proc @pointer_returned_from_call() -> () {
// CHECK:           %[[VAL_0:.*]] = llhd.const true : i1
// CHECK:           %[[VAL_1:.*]] = call @allocate_mem() : () -> !llhd.ptr<i32>
// CHECK:           cond_br %[[VAL_0]], ^bb1, ^bb2
// CHECK:         ^bb1:
// CHECK:           %[[VAL_2:.*]] = llhd.const 6 : i32
// CHECK:           llhd.store %[[VAL_1]], %[[VAL_2]] : !llhd.ptr<i32>
// CHECK:           br ^bb3
// CHECK:         ^bb2:
// CHECK:           %[[VAL_3:.*]] = llhd.const 7 : i32
// CHECK:           llhd.store %[[VAL_1]], %[[VAL_3]] : !llhd.ptr<i32>
// CHECK:           br ^bb3
// CHECK:         ^bb3:
// CHECK:           %[[VAL_4:.*]] = llhd.load %[[VAL_1]] : !llhd.ptr<i32>
// CHECK:           %[[VAL_5:.*]] = llhd.not %[[VAL_4]] : i32
// CHECK:           llhd.halt
// CHECK:         }
llhd.proc @pointer_returned_from_call() -> () {
  %cond = llhd.const 1 : i1
  %ptr = call @allocate_mem() : () -> !llhd.ptr<i32>
  cond_br %cond, ^bb1, ^bb2
^bb1:
  %c6 = llhd.const 6 : i32
  llhd.store %ptr, %c6 : !llhd.ptr<i32>
  br ^bb3
^bb2:
  %c7 = llhd.const 7 : i32
  llhd.store %ptr, %c7 : !llhd.ptr<i32>
  br ^bb3
^bb3:
  %ld = llhd.load %ptr : !llhd.ptr<i32>
  %res = llhd.not %ld : i32
  llhd.halt
}

// CHECK-LABEL:   func @store_something(
// CHECK-SAME:                          %[[VAL_0:.*]]: !llhd.ptr<i32>) {
// CHECK:           %[[VAL_1:.*]] = llhd.const 0 : i32
// CHECK:           llhd.store %[[VAL_0]], %[[VAL_1]] : !llhd.ptr<i32>
// CHECK:           return
// CHECK:         }
func @store_something(%ptr : !llhd.ptr<i32>) {
  %c = llhd.const 0 : i32
  llhd.store %ptr, %c : !llhd.ptr<i32>
  return
}

// CHECK-LABEL:   llhd.proc @pointer_passed_to_function() -> () {
// CHECK:           %[[VAL_0:.*]] = llhd.const true : i1
// CHECK:           %[[VAL_1:.*]] = llhd.const 5 : i32
// CHECK:           %[[VAL_2:.*]] = llhd.var %[[VAL_1]] : i32
// CHECK:           cond_br %[[VAL_0]], ^bb1, ^bb2
// CHECK:         ^bb1:
// CHECK:           call @store_something(%[[VAL_2]]) : (!llhd.ptr<i32>) -> ()
// CHECK:           br ^bb3
// CHECK:         ^bb2:
// CHECK:           %[[VAL_3:.*]] = llhd.const 7 : i32
// CHECK:           llhd.store %[[VAL_2]], %[[VAL_3]] : !llhd.ptr<i32>
// CHECK:           br ^bb3
// CHECK:         ^bb3:
// CHECK:           %[[VAL_4:.*]] = llhd.load %[[VAL_2]] : !llhd.ptr<i32>
// CHECK:           %[[VAL_5:.*]] = llhd.not %[[VAL_4]] : i32
// CHECK:           llhd.halt
// CHECK:         }
llhd.proc @pointer_passed_to_function() -> () {
  %cond = llhd.const 1 : i1
  %c5 = llhd.const 5 : i32
  %ptr = llhd.var %c5 : i32
  cond_br %cond, ^bb1, ^bb2
^bb1:
  call @store_something(%ptr) : (!llhd.ptr<i32>) -> ()
  br ^bb3
^bb2:
  %c7 = llhd.const 7 : i32
  llhd.store %ptr, %c7 : !llhd.ptr<i32>
  br ^bb3
^bb3:
  %ld = llhd.load %ptr : !llhd.ptr<i32>
  %res = llhd.not %ld : i32
  llhd.halt
}

// CHECK-LABEL:   llhd.proc @pointer_block_argument() -> () {
// CHECK:           %[[VAL_0:.*]] = llhd.const 5 : i32
// CHECK:           %[[VAL_1:.*]] = llhd.const true : i1
// CHECK:           %[[VAL_2:.*]] = llhd.var %[[VAL_0]] : i32
// CHECK:           cond_br %[[VAL_1]], ^bb1(%[[VAL_2]] : !llhd.ptr<i32>), ^bb2
// CHECK:         ^bb1(%[[VAL_3:.*]]: !llhd.ptr<i32>):
// CHECK:           %[[VAL_4:.*]] = llhd.const 6 : i32
// CHECK:           llhd.store %[[VAL_3]], %[[VAL_4]] : !llhd.ptr<i32>
// CHECK:           br ^bb3
// CHECK:         ^bb2:
// CHECK:           %[[VAL_5:.*]] = llhd.const 7 : i32
// CHECK:           llhd.store %[[VAL_2]], %[[VAL_5]] : !llhd.ptr<i32>
// CHECK:           br ^bb3
// CHECK:         ^bb3:
// CHECK:           %[[VAL_6:.*]] = llhd.load %[[VAL_2]] : !llhd.ptr<i32>
// CHECK:           %[[VAL_7:.*]] = llhd.not %[[VAL_6]] : i32
// CHECK:           llhd.halt
// CHECK:         }
llhd.proc @pointer_block_argument() -> () {
  %c5 = llhd.const 5 : i32
  %cond = llhd.const 1 : i1
  %ptr = llhd.var %c5 : i32
  cond_br %cond, ^bb1(%ptr : !llhd.ptr<i32>), ^bb2
^bb1(%p : !llhd.ptr<i32>):
  %c6 = llhd.const 6 : i32
  llhd.store %p, %c6 : !llhd.ptr<i32>
  br ^bb3
^bb2:
  %c7 = llhd.const 7 : i32
  llhd.store %ptr, %c7 : !llhd.ptr<i32>
  br ^bb3
^bb3:
  %ld = llhd.load %ptr : !llhd.ptr<i32>
  %res = llhd.not %ld : i32
  llhd.halt
}

// CHECK-LABEL:   llhd.proc @two_block_arguments() -> () {
// CHECK:           %[[VAL_0:.*]] = llhd.const 5 : i32
// CHECK:           %[[VAL_1:.*]] = llhd.const true : i1
// CHECK:           cond_br %[[VAL_1]], ^bb1, ^bb2
// CHECK:         ^bb1:
// CHECK:           %[[VAL_2:.*]] = llhd.const 6 : i32
// CHECK:           br ^bb3(%[[VAL_2]], %[[VAL_0]] : i32, i32)
// CHECK:         ^bb2:
// CHECK:           %[[VAL_3:.*]] = llhd.const 7 : i32
// CHECK:           br ^bb3(%[[VAL_3]], %[[VAL_3]] : i32, i32)
// CHECK:         ^bb3(%[[VAL_4:.*]]: i32, %[[VAL_5:.*]]: i32):
// CHECK:           %[[VAL_6:.*]] = llhd.not %[[VAL_4]] : i32
// CHECK:           %[[VAL_7:.*]] = llhd.not %[[VAL_5]] : i32
// CHECK:           llhd.halt
// CHECK:         }
llhd.proc @two_block_arguments() -> () {
  %c5 = llhd.const 5 : i32
  %cond = llhd.const 1 : i1
  %ptr = llhd.var %c5 : i32
  %ptr2 = llhd.var %c5 : i32
  cond_br %cond, ^bb1, ^bb2
^bb1:
  %c6 = llhd.const 6 : i32
  llhd.store %ptr, %c6 : !llhd.ptr<i32>
  br ^bb3
^bb2:
  %c7 = llhd.const 7 : i32
  llhd.store %ptr, %c7 : !llhd.ptr<i32>
  llhd.store %ptr2, %c7 : !llhd.ptr<i32>
  br ^bb3
^bb3:
  %ld = llhd.load %ptr : !llhd.ptr<i32>
  %ld2 = llhd.load %ptr2 : !llhd.ptr<i32>
  %res = llhd.not %ld : i32
  %res2 = llhd.not %ld2 : i32
  llhd.halt
}

// CHECK-LABEL:   llhd.proc @multiple_store_one_block() -> () {
// CHECK:           %[[VAL_0:.*]] = llhd.const 5 : i32
// CHECK:           %[[VAL_1:.*]] = llhd.const true : i1
// CHECK:           cond_br %[[VAL_1]], ^bb1, ^bb2(%[[VAL_0]] : i32)
// CHECK:         ^bb1:
// CHECK:           %[[VAL_2:.*]] = llhd.const 7 : i32
// CHECK:           %[[VAL_3:.*]] = llhd.not %[[VAL_2]] : i32
// CHECK:           %[[VAL_4:.*]] = llhd.const 8 : i32
// CHECK:           br ^bb2(%[[VAL_4]] : i32)
// CHECK:         ^bb2(%[[VAL_5:.*]]: i32):
// CHECK:           %[[VAL_6:.*]] = llhd.not %[[VAL_5]] : i32
// CHECK:           llhd.halt
// CHECK:         }
llhd.proc @multiple_store_one_block() -> () {
  %c5 = llhd.const 5 : i32
  %cond = llhd.const 1 : i1
  %ptr = llhd.var %c5 : i32
  cond_br %cond, ^bb1, ^bb2
^bb1:
  %c7 = llhd.const 7 : i32
  llhd.store %ptr, %c7 : !llhd.ptr<i32>
  %ld_tmp = llhd.load %ptr : !llhd.ptr<i32>
  %tmp = llhd.not %ld_tmp : i32
  %c8 = llhd.const 8 : i32
  llhd.store %ptr, %c8 : !llhd.ptr<i32>
  br ^bb2
^bb2:
  %ld = llhd.load %ptr : !llhd.ptr<i32>
  %res = llhd.not %ld : i32
  llhd.halt
}

// CHECK-LABEL:   llhd.proc @loop(
// CHECK-SAME:                    %[[VAL_0:.*]] : !llhd.sig<i2>) -> () {
// CHECK:           br ^bb1
// CHECK:         ^bb1:
// CHECK:           %[[VAL_1:.*]] = llhd.const 0 : i32
// CHECK:           br ^bb2(%[[VAL_1]] : i32)
// CHECK:         ^bb2(%[[VAL_2:.*]]: i32):
// CHECK:           %[[VAL_3:.*]] = llhd.const 2 : i32
// CHECK:           %[[VAL_4:.*]] = cmpi "ult", %[[VAL_2]], %[[VAL_3]] : i32
// CHECK:           cond_br %[[VAL_4]], ^bb4, ^bb3
// CHECK:         ^bb3:
// CHECK:           llhd.wait (%[[VAL_0]] : !llhd.sig<i2>), ^bb1
// CHECK:         ^bb4:
// CHECK:           %[[VAL_5:.*]] = llhd.const 0 : i2
// CHECK:           %[[VAL_6:.*]] = llhd.const 1 : i32
// CHECK:           %[[VAL_7:.*]] = addi %[[VAL_2]], %[[VAL_6]] : i32
// CHECK:           br ^bb2(%[[VAL_7]] : i32)
// CHECK:         }
llhd.proc @loop(%in_i : !llhd.sig<i2>) -> () {
  br ^body
^body:
  %0 = llhd.const 0 : i32
  %i = llhd.var %0 : i32
  br ^loop_body
^loop_body:
  %i_ld = llhd.load %i : !llhd.ptr<i32>
  %1 = llhd.const 2 : i32
  %2 = cmpi "ult", %i_ld, %1 : i32
  cond_br %2, ^loop_continue, ^check
^check:
  llhd.wait (%in_i : !llhd.sig<i2>), ^body
^loop_continue:
  %3 = llhd.const 0 : i2
  %5 = llhd.const 1 : i32
  %i_ld4 = llhd.load %i : !llhd.ptr<i32>
  %14 = addi %i_ld4, %5 : i32
  llhd.store %i, %14 : !llhd.ptr<i32>
  br ^loop_body
}

// CHECK-LABEL:   llhd.proc @more_complicated() -> () {
// CHECK:           %[[VAL_0:.*]] = llhd.const true : i1
// CHECK:           %[[VAL_1:.*]] = llhd.const 3 : i8
// CHECK:           %[[VAL_2:.*]] = llhd.not %[[VAL_1]] : i8
// CHECK:           br ^bb1(%[[VAL_1]] : i8)
// CHECK:         ^bb1(%[[VAL_3:.*]]: i8):
// CHECK:           %[[VAL_4:.*]] = llhd.not %[[VAL_3]] : i8
// CHECK:           br ^bb2(%[[VAL_3]] : i8)
// CHECK:         ^bb2(%[[VAL_5:.*]]: i8):
// CHECK:           %[[VAL_6:.*]] = llhd.not %[[VAL_5]] : i8
// CHECK:           cond_br %[[VAL_0]], ^bb3, ^bb4
// CHECK:         ^bb3:
// CHECK:           %[[VAL_7:.*]] = llhd.not %[[VAL_5]] : i8
// CHECK:           %[[VAL_8:.*]] = llhd.const 4 : i8
// CHECK:           br ^bb2(%[[VAL_8]] : i8)
// CHECK:         ^bb4:
// CHECK:           %[[VAL_9:.*]] = llhd.not %[[VAL_5]] : i8
// CHECK:           cond_br %[[VAL_0]], ^bb1(%[[VAL_5]] : i8), ^bb5
// CHECK:         ^bb5:
// CHECK:           %[[VAL_10:.*]] = llhd.not %[[VAL_5]] : i8
// CHECK:           cond_br %[[VAL_0]], ^bb6, ^bb7
// CHECK:         ^bb6:
// CHECK:           %[[VAL_11:.*]] = llhd.not %[[VAL_5]] : i8
// CHECK:           cond_br %[[VAL_0]], ^bb8, ^bb9(%[[VAL_5]] : i8)
// CHECK:         ^bb7:
// CHECK:           %[[VAL_12:.*]] = llhd.not %[[VAL_5]] : i8
// CHECK:           %[[VAL_13:.*]] = llhd.const 5 : i8
// CHECK:           br ^bb9(%[[VAL_13]] : i8)
// CHECK:         ^bb8:
// CHECK:           %[[VAL_14:.*]] = llhd.not %[[VAL_5]] : i8
// CHECK:           br ^bb10
// CHECK:         ^bb9(%[[VAL_15:.*]]: i8):
// CHECK:           %[[VAL_16:.*]] = llhd.not %[[VAL_15]] : i8
// CHECK:           br ^bb11(%[[VAL_15]] : i8)
// CHECK:         ^bb10:
// CHECK:           %[[VAL_17:.*]] = llhd.not %[[VAL_5]] : i8
// CHECK:           cond_br %[[VAL_0]], ^bb8, ^bb11(%[[VAL_5]] : i8)
// CHECK:         ^bb11(%[[VAL_18:.*]]: i8):
// CHECK:           %[[VAL_19:.*]] = llhd.not %[[VAL_18]] : i8
// CHECK:           llhd.halt
// CHECK:         }
llhd.proc @more_complicated() -> () {
  %cond = llhd.const 1 : i1
  %init = llhd.const 3 : i8
  %ptr = llhd.var %init : i8
  %ld = llhd.load %ptr : !llhd.ptr<i8>
  %res = llhd.not %ld : i8
  br ^bb1
^bb1:
  %ld1 = llhd.load %ptr : !llhd.ptr<i8>
  %res1 = llhd.not %ld1 : i8
  br ^bb2
^bb2:
  %ld2 = llhd.load %ptr : !llhd.ptr<i8>
  %res2 = llhd.not %ld2 : i8
  cond_br %cond, ^bb3, ^bb4
^bb3:
  %ld3 = llhd.load %ptr : !llhd.ptr<i8>
  %res3 = llhd.not %ld3 : i8
  %c4 = llhd.const 4 : i8
  llhd.store %ptr, %c4 : !llhd.ptr<i8>
  br ^bb2
^bb4:
  %ld4 = llhd.load %ptr : !llhd.ptr<i8>
  %res4 = llhd.not %ld4 : i8
  cond_br %cond, ^bb1, ^bb41
^bb41:
  %ld5 = llhd.load %ptr : !llhd.ptr<i8>
  %res5 = llhd.not %ld5 : i8
  cond_br %cond, ^bb5, ^bb6
^bb5:
  %ld6 = llhd.load %ptr : !llhd.ptr<i8>
  %res6 = llhd.not %ld6 : i8
  cond_br %cond, ^bb7, ^bb8
^bb6:
  %ld7 = llhd.load %ptr : !llhd.ptr<i8>
  %res7 = llhd.not %ld7 : i8
  %c5 = llhd.const 5 : i8
  llhd.store %ptr, %c5 : !llhd.ptr<i8>
  br ^bb8
^bb7:
  %ld8 = llhd.load %ptr : !llhd.ptr<i8>
  %res8 = llhd.not %ld8 : i8
  br ^bb9
^bb8:
  %ld9 = llhd.load %ptr : !llhd.ptr<i8>
  %res9 = llhd.not %ld9 : i8
  br ^bb10
^bb9:
  %ld10 = llhd.load %ptr : !llhd.ptr<i8>
  %res10 = llhd.not %ld10 : i8
  cond_br %cond, ^bb7, ^bb10
^bb10:
  %ld11 = llhd.load %ptr : !llhd.ptr<i8>
  %res11 = llhd.not %ld11 : i8
  llhd.halt
}