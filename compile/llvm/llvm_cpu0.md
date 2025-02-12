# LLVM

git:
```
cd ~/
git clone https://github.com/P2Tree/LLVM_for_cpu0.git
```

patch:
```
diff --git a/llvm/include/llvm/Demangle/MicrosoftDemangleNodes.h b/llvm/include/llvm/Demangle/MicrosoftDemangleNodes.h
index 9e3478e9..865ad76b 100755
--- a/llvm/include/llvm/Demangle/MicrosoftDemangleNodes.h
+++ b/llvm/include/llvm/Demangle/MicrosoftDemangleNodes.h
@@ -1,6 +1,8 @@
 #ifndef LLVM_SUPPORT_MICROSOFTDEMANGLENODES_H
 #define LLVM_SUPPORT_MICROSOFTDEMANGLENODES_H
 
+#include <stdint.h>
+#include <string>
 #include "llvm/Demangle/Compiler.h"
 #include "llvm/Demangle/StringView.h"
 #include <array>
diff --git a/llvm/lib/Target/Cpu0/Cpu0InstrInfo.td b/llvm/lib/Target/Cpu0/Cpu0InstrInfo.td
index dfe10915..8695755b 100644
--- a/llvm/lib/Target/Cpu0/Cpu0InstrInfo.td
+++ b/llvm/lib/Target/Cpu0/Cpu0InstrInfo.td
@@ -329,13 +329,13 @@ class StoreM<bits<8> op, string instrAsm, PatFrag opNode, RegisterClass regClass
 // 32-bit load
 multiclass LoadM32<bits<8> op, string instrAsm,
                    PatFrag opNode, bit pseudo=0> {
-  def #NAME# : LoadM<op, instrAsm, opNode, GPROut, mem, pseudo>;
+  def NAME : LoadM<op, instrAsm, opNode, GPROut, mem, pseudo>;
 }
 
 // 32-bit store
 multiclass StoreM32<bits<8> op, string instrAsm,
                     PatFrag opNode, bit pseudo=0> {
-  def #NAME# : StoreM<op, instrAsm, opNode, CPURegs, mem, pseudo>;
+  def NAME : StoreM<op, instrAsm, opNode, CPURegs, mem, pseudo>;
 }
 
 // Conditional Branch
diff --git a/llvm/lib/Target/Cpu0/Cpu0Other.td b/llvm/lib/Target/Cpu0/Cpu0Other.td
index 4200370f..b88af821 100644
--- a/llvm/lib/Target/Cpu0/Cpu0Other.td
+++ b/llvm/lib/Target/Cpu0/Cpu0Other.td
@@ -20,5 +20,5 @@ include "llvm/Target/Target.td"
 //===----------------------------------------------------------------------===//
 
 include "Cpu0RegisterInfo.td"
-include "Cpu0RegisterINfoGPROutForOther.td" // except AsmParser
+include "Cpu0RegisterInfoGPROutForOther.td" // except AsmParser
 include "Cpu0.td"
```

```
cd ~/github/LLVM_for_cpu0

cmake -G Ninja \
    -DLLVM_TARGETS_TO_BUILD=Cpu0 \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_C_COMPILER=clang \
    -DLLVM_PARALLEL_LINK_JOBS=1 \
    -DLLVM_PARALLEL_COMPILE_JOBS=24 \
    ../llvm

ninja
```
