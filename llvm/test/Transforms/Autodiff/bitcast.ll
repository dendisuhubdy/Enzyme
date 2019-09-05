; RUN: opt < %s -load=%llvmshlibdir/LLVMEnzyme%shlibext -enzyme -mem2reg -simplifycfg -adce -constprop -deadargelim -instsimplify -inline -S | FileCheck %s

define double @tester(double %x) {
entry:
  %y = bitcast double %x to i64
  %z = bitcast i64 %y to double
  ret double %z
}

define double @test_derivative(double %x) {
entry:
  %0 = tail call double (double (double)*, ...) @llvm.autodiff.p0f_f64f64f(double (double)* nonnull @tester, double %x)
  ret double %0
}

declare double @llvm.autodiff.p0f_f64f64f(double (double)*, ...)

; CHECK: define double @test_derivative(double %x)
; CHECK-NEXT: entry:
; CHECK-NEXT:   ret double 1.000000e+00
; CHECK-NEXT: }
