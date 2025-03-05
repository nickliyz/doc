- [函数与极限](#函数与极限)
  - [映射与函数](#映射与函数)
    - [映射](#映射)
      - [映射的概念](#映射的概念)
    - [函数](#函数)
      - [函数的概念](#函数的概念)
      - [函数的几种特性](#函数的几种特性)
      - [反函数与复合函数](#反函数与复合函数)
      - [函数的运算](#函数的运算)
      - [初等函数](#初等函数)
  - [数列的极限](#数列的极限)
    - [数列极限的定义](#数列极限的定义)
    - [收敛数列的性质](#收敛数列的性质)
  - [函数的极限](#函数的极限)
    - [函数极限的定义](#函数极限的定义)
      - [自变量趋于有限值时函数的极限](#自变量趋于有限值时函数的极限)
      - [自变量趋于无穷大时函数的极限](#自变量趋于无穷大时函数的极限)
    - [函数极限的性质](#函数极限的性质)
  - [无穷小与无穷大](#无穷小与无穷大)
    - [无穷小](#无穷小)
    - [无穷大](#无穷大)


# 函数与极限
## 映射与函数
### 映射
#### 映射的概念
**定义** 设 X,Y 是两给非空集合, 如果存在一个法则 $f$ 使得 X 中每个元素 $x$ ,按法则 $f$, 在 Y 中有唯一确定的元素 $y$ 与之对应, 那么称 $f$ 为从 X 到 Y 的**映射**. 记作
```math
f:X\to Y
```
其中 $y$ 称为元素 $x$ (在映射 $f$ 下)的像, 并记作 $f(x)$, 即:
```math
y=f(x)
```

而元素 $x$ 称为元素 $y$ (在映射 f) 下的一个**原像**, 集合 X 称为映射 f 的定义域, 记作 $D_f$, 即 $D_f=X$; X 中所有元素的像所组成的集合称为映射 f 的值域, 记作 $R_f$ 或 $f(X)$, 即:
```math
R_f=f(X)=|f(x)|mid x\in X|
```

逆映射与复合映射
设 f 是 X 到 Y 的映射, 则由定义, 对于每个 $y\in R_f$, 有唯一的 $x\in X$, 适合 $f(x)=y$, 于是, 我们可以定义一个从 $R_f$ 到 X 的新映射 g 即:
```math
g:R_f \to X
```
对于每个 $y\in R_f$, 规定 $g(y)=x$, 这 x 满足 $f(x)=y$. 这个映射 g 称为 f 的**逆映射**, 记作 $f^{-1}$, 其定义域 $D_{f^{-1}}=R_f$, 值域 $R_{f^{-1}}=X$.

### 函数
#### 函数的概念
**定义** 设数集 $\mathbf{D}\subset \mathbb{R}$, 则称映射 $f:\mathbf{D}\to\mathbb{R}$ 为定义在 $\mathbf{D}$ 上的**函数**, 通常简记为:
```math
y=f(x), x\in \mathbf{D}
```
其中 x 称为**自变量**, y 称为**因变量**, D 称为**定义域**, 记作 $D_f$, 即 $D_f=D$.

#### 函数的几种特性
1) **函数的有界性** 设函数 $f(x)$ 的定义域为 D, 数集 $X\in\mathbf{D}$ 如果存在数 $K_1$ 使得
```math
f(x) \le K_1
```
对于任意 $x\in X$ 都成立, 那么函数 $f(x)$ 在 X 上有**上界**, 而 $K_1$ 称为函数的一个上界. 如果存在数 $K_2$ 使得:
```math
f(x)\ge K_2
```
对于任意 $x\in X$ 都成立, 那么函数 $f(x)$ 在 X 上有**下界**, 而 $K_2$ 称为函数的一个下界.

2) **函数的单调性** 设函数 $f(x)$ 的定义域为 $D$, 区间 $I\subset D$. 如果对于区间 $I$ 上任意两点 $x_1$ 及 $x_2$ 当 $x_1 \lt x_2$ 是恒有:
```math
f(x_1) \lt f(x_2)
```
那么称函数 f(x) 在区间 I 上是**单调增加**的. 如果对于区间 $I$ 上任意两点 $x_1$ 及 $x_2$ 当 $x_1 \lt x_2$ 是恒有:
```math
f(x_1) \gt f(x_2)
```
那么称函数 f(x) 在区间 I 上是**单调减少**的. 单调增加和单调减少函数统称为单调函数.

3) **函数的奇偶性** 设函数 f(x) 的定义域 D 关于原点对称. 如果对于任一 $x\in D$:
```math
f(-x)=f(x)
```
恒成立, 那么称 f(x) 为偶函数. 如果对于任一 $x\in D$:
```math
f(-x)=-f(x)
```
恒成立, 那么称 f(x) 为奇函数. 

4) **函数的周期性** 设函数 f(x) 的定义域为 D. 如果存在一个正数 l , 使得对于任意 $x\in D$ 有 $(x\pm)\in D$ 且
```math
f(x+l)=f(x)
```
恒成立, 那么称 f(x) 为周期函数, l 称为 f(x) 的周期, 通常我们说说周期函数的周期是最小正周期.

#### 反函数与复合函数
设函数 $f:D\to f(D)$ 是单射, 则它存在逆映射 $f^{-1}:f(D) \to D$, 称映射 $f^{-1}$ 为函数 $f$ 的反函数. 对于每个 $y \in f(D)$ 有唯一的 $x\in D$ 使得 $f(x)=y$, 于是有:
```math
f^{-1}(y)=x
```

#### 函数的运算
设函数 $f(x),g(x)$ 的定义域以此为 $D_f,D_g,D=D_f\cap\neq\emptyset$, 则我们可以定义这两个函数的下列运算:
* 和(差) $f\pm g:\ \ \ \ \ \ (f\pm g)(x)=f(x)\pm g(x),x \in D$
* 积 $f\cdot g:\ \ \ \ \ \ (f\cdot g)(x)=f(x)\cdot g(x), x\in D$
* 商 $\displaystyle\frac{f}{g}:\ \ \ \ \ \ \displaystyle\left(\frac{f}{g}\right)(x)=\frac{f(x)}{g(x)}, x\in D \backslash \{x\mid g(x)=0,x\in D\}$

#### 初等函数
幂函数: $y=x^\mu (\mu \in \mathbb{R} 是常数)$  
指数函数: $y=a^x (a \gt 0 且 a \neq 1)$  
对数函数: $y=\log_{a}x(a\gt 0 且 a\neq 1, 特别当 a=\mathrm{e} 时, 记为 y=\ln x)$  
三角函数: 如 $y=\sin x,y=\cos x,y=\tan x$ 等  
反三角函数: 如 $y=\arcsin x, y=\arccos x,y=\arctan x$ 等

以上这五类函数统称为基本初等函数.

由常数和基本初等函数经过有限次的四则元算和有限次的函数复合步骤所构成并可用一个式子表示的函数称为**初等函数**. 例如:
```math
y=\sqrt{1-x^2}, y=\sin^2x,y=\sqrt{\cot \frac{x}{2}}
```
等都是初等函数.

应用上常遇到以 $\mathrm{e}$ 为底的指数函数 $y=\mathrm{e}^x$ 和 $y=\mathrm{e}^{-x}$ 所产生的双曲函数以及它们的反函数:反双曲函数, 它们的定义如下:
* 双曲正弦: $\displaystyle\mathrm{sh} x = \frac{e^x-e^{-x}}{2}$
* 双曲余弦: $\displaystyle\mathrm{ch} x = \frac{e^x+e^{-x}}{2}$
* 双曲正切: $\displaystyle\mathrm{th} x = \frac{\mathrm{sh} x}{\mathrm{ch} x} = \frac{e^x-e^{-x}}{e^x+e^{-x}}$

根据双曲函数的定义, 可证如下四个公式:
* $\mathrm{sh} (x + y) = \mathrm{sh} x \mathrm{ch} y + \mathrm{ch} x \mathrm{sh} y$
* $\mathrm{sh} (x - y) = \mathrm{sh} x \mathrm{ch} y - \mathrm{ch} x \mathrm{sh} y$
* $\mathrm{ch} (x + y) = \mathrm{ch} x \mathrm{ch} y + \mathrm{sh} x \mathrm{sh} y$
* $\mathrm{ch} (x - y) = \mathrm{ch} x \mathrm{ch} y - \mathrm{sh} x \mathrm{sh} y$

双曲函数 $y=\mathrm{sh} x, y=\mathrm{ch} x(x\ge0),y=\mathrm{th} x$ 的反函数依次记为:
* 反双曲正弦: $y=\mathrm{arsh} x$
* 反双曲余弦: $y=\mathrm{arch} x$
* 反双曲正切: $y=\mathrm{arth} x$

先讨论双曲正弦 $y=\mathrm{sh} x$ 的反函数. 由 $x=\mathrm{sh} y$ 有
```math
x=\frac{e^y-e^{-y}}{2}
```

令 $u=e^y$, 则由上式有
```math
u^2-2xu-1=0
```
这是关于 u 的一个二次方程, 它的根为:
```math
u=x\pm\sqrt{x^2+1}
```
因 $u=e^y \gt 0$, 故上式根号前应取正号, 于是:
```math
u=x+\sqrt{x^2+1}
```
由于 $y=\ln u$, 故得反双曲正弦:
```math
y=\mathrm{arsh}x=\ln(x+\sqrt{x^2+1})
```
函数 $y=\mathrm{arsh}x$ 的定义域为: $(-\infty, \infty)$ , 它是奇函数, 在区间 $(-\infty, \infty)$ 内为单调增加.

类似的, 反双曲余弦函数:
```math
y=\mathrm{arch}x=\ln(x+\sqrt{x^2+1})
```

反双曲正切:
```math
y=\mathrm{arth}x=\frac{1}{2}\ln \frac{1+x}{1-x}
```

## 数列的极限
### 数列极限的定义
如果按照某一法则, 对于每个 $n\in \mathbb{N}_+$, 对应着一个确定的实数 $x_n$, 这些实数 $x_n$ 按照下标从小到大排列得到的一个序列
```math
x_1,x_2,x_3,\cdots,x_n,\cdots
```
就叫做数列, 简记为数列 $|x_n|$

数列中的每一个数叫做列的项, 第 n 项 $x_n$ 叫做数列的**一般项**(或**通项**).

数列 $\{x_n\}$ 恶可以看作自变量为正整数 n 的函数:
```math
x_n=f(n),n\in \mathbb{N}_+
```
当自变量 n 依次取 $1,2,3,\cdots$ 一切正整数时, 对应的函数值就排列成数列 $\{x_n\}$

**定义** 设 $\{x_n\}$ 为一数列, 如果存在常数 $a$, 对于任意给定的正数 $\epsilon$ (无论多么小), 总存在正整数 $N$ 使得当 $n\gt N$ 时, 不等式
```math
|x_n-a|\le \epsilon
```
都成立, 那么就称常数 $a$ 是数列 $\{x_n\}$ 的**极限**, 或者称数列 $\{x_n\}$ 收敛于 $a$, 记为
```math
\lim_{n\to \infty}x_n=a
```
或
```math
x_n\to a(n \to \infty)
```

为了表达方便, 引入记号 " $\forall$ " 表示 "对于任意给定的" 或 "对于每一个(`\forall`)", 记号 " $\exists$ " 表示 "存在"(`\exists`). 于是, "对于任意给定的 $\epsilon \gt 0$"写成: " $\forall\epsilon\gt 0$ ", " 存在正整数 $N$ " 写成 " $\exists正整数N$ ", 数列极限 $\displaystyle\lim_{n\to\infty}x_n=a$ 的定义可表达为:
```math
\lim_{n\to\infty}x_n=a \Leftrightarrow \forall\epsilon\gt 0, \exists 正整数 N, 当 n \gt N 时, 有 |x_n-a|\le\epsilon
```

### 收敛数列的性质
**定理 1(极限的唯一性)** 如果数列 $\{x_n}$ 收敛, 那么它的极限唯一.

**定理 2(收敛数列的有界性)** 如果数列 $\{x_n\}$ 收敛, 那么数列 $\{x_n\}$ 一定有界. 

**定理 3(收敛数列的保号性)** 如果 $\displaystyle\lim_{n\to\infty}=a, 且 a \gt 0(或 a \lt 0)$, 那么存在正整数 $N$, 当 $n \gt N$ 时, 都有 $x_n\gt 0 (或 x_n \lt 0)$

**推论** 如果数列 $\{x_n\}$ 从某项起有 $x_n \ge 0$(或 $x_n \le 0$), 且 $\displaystyle\lim_{x\to\infty}x_n=a$, 那么 $a\gt 0$(或 $a\le 0$)

**定理 4(收敛数列与其子数列间的关系)** 如果数列 $\{x_n\}$ 收敛于 $a$, 那么它的任一子序列也收敛, 且极限也是 $a$

## 函数的极限
### 函数极限的定义
#### 自变量趋于有限值时函数的极限
**定义 1** 设函数 $f(x)$ 在点 $x_0$ 的某一去心邻域内有定义. 如果存在常数 $A$, 对于任意给定的正数 $\epsilon$ (不论它有多么小), 总存在正整数 $\delta$, 使得当 $x$ 满足不等式 $0\lt|x-x_0|\lt\delta$ 时, 对应的函数值 $f(x)$ 都满足不等式
```math
|f(x)-A|\lt\epsilon
```
那么常数 $A$ 就叫做函数 $f(x)$ 当 $x\to x_0$ 时的极限, 记作:
```math
\lim_{x\to x_0}f(x)=A\ \ 或\ \ f(x) \to A(当 x\to x_0)
```

#### 自变量趋于无穷大时函数的极限
**定义 2** 设函数 $f(x)$ 当 $|x|$ 大于某一正数时有定义. 如果存在常数 $A$, 对于任意给定的正数 $\epsilon$ (无论它有多么小), 总存在着正数 $X$, 使得当 $x$ 满足不等式 $|x|\gt X$ 时, 对应的函数值 $f(x)$ 都满足不等式:
```math
|f(x)-A|\lt \epsilon
```
那么常数 $A$ 就叫做函数 $f(x)$ 当 $x\to\infty$ 时的极限, 记作:
```math
\lim_{x\to\infty}f(x)=A\ \ 或\ \ f(x)\to A(当 x\to\infty)
```
定义2 可简单地表达为:
```math
\lim_{x\to\infty}f(x)=A\Leftrightarrow \forall\epsilon\lt 0,\exists X \gt 0, 当 |x|\gt X 时, 有 |f(x)-A|\lt\epsilon
```

### 函数极限的性质
**定理 1(函数极限的唯一性)** 如果 $\lim_{x\to x_0}f(x)$ 存在, 那么极限唯一.

**定理 2(函数极限的局部有界性)** 如果 $\lim_{x\to x_0}f(x)=A$, 那么存在常数 $M\gt 0$ 和 $\delta\gt 0$, 使得当 $0\lt |x-x_0|\lt \delta$ 时, 有 $f|x|\le M$.

**定理 3(函数极限的局部保号性)** 如果 $\displaystyle\lim_{x\to x_0}f(x)=A$, 其 $A\gt 0$(或 $A\lt 0$) 那么存在常数 $\delta \gt 0$, 使得当 $0\lt|x-x_0|\lt\delta$ 时, 有 $f(x)\gt 0$(或 $f(x)\lt 0$).

**定理 4(函数极限与数列极限的关系)** 如果极限 $\displaystyle\lim_{x\to x_0}f(x)$ 存在, $\{ x_n \}$ 为函数 $f(x)$ 的定义域内任一收敛于 $x_0$ 的数列, 且满足 $x_n \neq x_0 (n \in \mathbb{N}_+)$ , 那么相应的函数值数列 $\{f(x_n)\}$ 必收敛, 且 $\displaystyle \lim_{x \to \infty}f(x_n)=\lim_{x \to x_0}f(x)$

## 无穷小与无穷大
### 无穷小
**定义 1** 如果函数 $f(x)$ 当 $x\to x_0$ (或 $x\to\infty$) 时的极限为0, 那么称函数 $f(x)$ 为 $x\to x_0$ (或 $x\to\infty$) 时的无穷小.

**定理 1** 在自变量的同一变化过程 $x\to x_0$ (或 $x\to\infty$) 中, 函数 $f(x)$ 具有极限 $A$ 的充分必要条件是: $f(x)=A+a$, 其中 $a$ 是无穷小.

### 无穷大
**定义 2** 设函数 $f(x)$ 在 $x_0$ 的某一去心邻域内有定义(或 $|x|$ 大于某一正数时有定义). 如果对于任意给定的正数 $M$ (无论它多么大), 总存在正数 $\delta$ (或正数 $X$), 只要 $x$ 适合不等式 $0\lt|x-x_0|\lt \delta$ ,对应的函数值 $f(x)$ 总满足不等式
```math
|f(x)|\gt M
```
那么称函数 $f(x)$ 是当 $x\to x_0$ (或 $x\to\infty$) 时的无穷大.

**定理 2** 在自变量的同一变化过程中, 如果 $f(x)$ 为无穷大, 那么 $\displaystyle\frac{1}{f(x)}$ 为去穷小; 反之, 如果 $f(x)$ 为无穷小, 且 $f(x)\neq 0$, 那么 $\displaystyle\frac{1}{f(x)}$ 为无穷大.

