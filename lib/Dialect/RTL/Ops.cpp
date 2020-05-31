//===- Ops.cpp - Implement the RTL operations -----------------------------===//
//
//===----------------------------------------------------------------------===//

#include "cirt/Dialect/RTL/Ops.h"
#include "cirt/Dialect/RTL/Visitors.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/IR/StandardTypes.h"

using namespace cirt;
using namespace rtl;

/// Return true if the specified operation is a combinatorial logic op.
bool rtl::isCombinatorial(Operation *op) {
  struct IsCombClassifier
      : public CombinatorialVisitor<IsCombClassifier, bool> {
    bool visitInvalidComb(Operation *op) { return false; }
    bool visitUnhandledComb(Operation *op) { return true; }
  };

  return IsCombClassifier().dispatchCombinatorialVisitor(op);
}

//===----------------------------------------------------------------------===//
// ConstantOp
//===----------------------------------------------------------------------===//

static LogicalResult verifyConstantOp(ConstantOp constant) {
  // If the result type has a bitwidth, then the attribute must match its width.
  auto intType = constant.getType().cast<IntegerType>();
  if (constant.value().getBitWidth() != intType.getWidth()) {
    constant.emitError(
        "firrtl.constant attribute bitwidth doesn't match return type");
    return failure();
  }

  return success();
}

OpFoldResult ConstantOp::fold(ArrayRef<Attribute> operands) {
  assert(operands.empty() && "constant has no operands");
  return valueAttr();
}

/// Build a ConstantOp from an APInt and a FIRRTL type, handling the attribute
/// formation for the 'value' attribute.
void ConstantOp::build(OpBuilder &builder, OperationState &result,
                       const APInt &value) {

  auto type = IntegerType::get(value.getBitWidth(), IntegerType::Signless,
                               builder.getContext());
  auto attr = builder.getIntegerAttr(type, value);
  return build(builder, result, type, attr);
}

void ConstantOp::getAsmResultNames(
    function_ref<void(Value, StringRef)> setNameFn) {
  auto intTy = getType().cast<IntegerType>();
  auto intCst = getValue();

  // Sugar i1 constants with 'true' and 'false'.
  if (intTy.getWidth() == 1)
    return setNameFn(getResult(), intCst.isNullValue() ? "false" : "true");

  // Otherwise, build a complex name with the value and type.
  SmallVector<char, 32> specialNameBuffer;
  llvm::raw_svector_ostream specialName(specialNameBuffer);
  specialName << 'c' << intCst << '_' << intTy;
  setNameFn(getResult(), specialName.str());
}

//===----------------------------------------------------------------------===//
// Unary Operations
//===----------------------------------------------------------------------===//

static LogicalResult verifyExtOp(Operation *op) {
  // The source must be smaller than the dest type.  Both are already known to
  // be signless integers.
  auto srcType = op->getOperand(0).getType().cast<IntegerType>();
  auto dstType = op->getResult(0).getType().cast<IntegerType>();
  if (srcType.getWidth() >= dstType.getWidth()) {
    op->emitError("extension must increase bitwidth of operand");
    return failure();
  }

  return success();
}

static LogicalResult verifyTruncOp(Operation *op) {
  // The source must be bigger than the dest type. Both are already known to
  // be signless integers.
  auto srcType = op->getOperand(0).getType().cast<IntegerType>();
  auto dstType = op->getResult(0).getType().cast<IntegerType>();
  if (srcType.getWidth() <= dstType.getWidth()) {
    op->emitError("rtl.trunc must reduce bitwidth of operand");
    return failure();
  }

  return success();
}

//===----------------------------------------------------------------------===//
// TableGen generated logic.
//===----------------------------------------------------------------------===//

// Provide the autogenerated implementation guts for the Op classes.
#define GET_OP_CLASSES
#include "cirt/Dialect/RTL/RTL.cpp.inc"