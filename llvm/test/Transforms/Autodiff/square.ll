; RUN: opt < %s -lower-autodiff -O3 -S | FileCheck %s

; source code
; double square(double x) {
;     return x * x;
; }
; 
; double dsquare(double x) {
;     return __builtin_autodiff(square, x);
; }

define double @square(double %x) {
entry:
  %mul = fmul fast double %x, %x
  ret double %mul
}

define double @dsquare(double %x) {
entry:
  %0 = tail call double (double (double)*, ...) @llvm.autodiff.p0f_f64f64f(double (double)* nonnull @square, double %x)
  ret double %0
}

declare double @llvm.autodiff.p0f_f64f64f(double (double)*, ...) 

; CHECK: define double @dsquare(double %x)
; CHECK-NEXT: entry:
; CHECK-NEXT:   %factor.i = fmul fast double %x, 2.000000e+00
; CHECK-NEXT:   ret double %factor.i
; CHECK-NEXT: }
