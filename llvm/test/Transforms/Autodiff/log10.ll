; RUN: opt < %s -load=%llvmshlibdir/LLVMEnzyme%shlibext -enzyme -O3 -S | FileCheck %s

; Function Attrs: nounwind readnone uwtable
define double @tester(double %x) {
entry:
  %0 = tail call fast double @llvm.log10.f64(double %x)
  ret double %0
}

define double @test_derivative(double %x) {
entry:
  %0 = tail call double (double (double)*, ...) @llvm.autodiff.p0f_f64f64f(double (double)* nonnull @tester, double %x)
  ret double %0
}

; Function Attrs: nounwind readnone speculatable
declare double @llvm.log10.f64(double)

; Function Attrs: nounwind
declare double @llvm.autodiff.p0f_f64f64f(double (double)*, ...)

; CHECK: define double @test_derivative(double %x)
; CHECK-NEXT: entry:
; equivalent to 1/log(10) / x
; CHECK-NEXT:   %0 = fdiv fast double 0x3FDBCB7B1526E50D, %x
; CHECK-NEXT:   ret double %0
; CHECK-NEXT: }
