# 不定积分
## 不定积分的概念与性质
### 原函数与不定积分概念
**定义 1** 如果在区间 $I$ 上, 可导函数 $F(x)$ 的到函数为 $f(x)$, 即对任一 $x\in I$ 都有:
```math
F'(x)=f(x) \ \ \ 或\ \ \ \mathrm{d}F(x)=f(x)\mathrm{d}x
```
那么函数 $F(x)$ 就称为 $f(x)$ (或 $f(x)\mathrm{d}x$) 在区间 $I$ 上的一个**原函数**

**原函数存在定理** 如果函数 $f(x)$ 在区间 $I$ 上连续, 那么在区间 $I$ 上存在可导函数 $F(x)$, 使对于任一 $x\in I$ 都有 
```math
F'(x)=f(x)
```
简单的说就是: **连续函数一定有原函数**.

还要说明两点:

**第一** 如果 $f(x)$ 在区间 $I$ 上有原函数, 即有一个函数 $F(x)$ , 是对于任一 $x\in I$ 都有 $F'(x)=f(x)$, 那么对任何常数 $C$, 显然也有
```math
[F(x)+C]'=f(x)
```
即对于任何常数 $C$, 函数 $F(x)+C$ 也是 $f(x)$ 的原函数, 这说明, 如果 $f(x)$ 有一个原函数, 那么 $f(x)$ 就有无限多个原函数.

**第二**, 如果在区间 $I$ 上 $F(x)$ 是 $f(x)$ 的一个原函数, 那么 $f(x)$ 的其他原函数与 $F(x)$ 有什么关系?

设 $\Phi(x)$ 是 $f(x)$ 的另一个原函数, 即对任一 $x\in I$ 有
```math
\Phi'(x)=f(x)
```
于是
```math
[\Phi(x)-F(x)]'=\Phi'(x)-F'(x)=f(x)=f(x)=0
```
在一个区间上导数恒为零的函数必为常数, 所以
```math
\Phi(x)-F(x)=C_0\ \ \ (C_0为某个常数)
```

这表明 $\Phi(x)$ 与 $F(x)$ 只差一个常数. 因此, 当 $C$ 为任意的常数时, 表达式
```math
F(x) + C
```
就可以表示 $f(x)$ 的任意一个原函数.

**定义 2** 在区间 $I$ 上, 函数 $f(x)$ 的带有任意常数项的原函数称为 $f(x)$ (或 $f(x)\mathrm{d}x$) 在区间 $I$ 上的**不定积分**, 记作
```math
\int f(x)\mathrm{d}x
```
其中记号 $\int$ 称为**积分符号**, $f(x)$ 称为**被积函数**, $f(x)\mathrm{d}x$ 称为**被积表达式**, $x$称为**积分变量**.

由此定义及前面的说明可知, 如果 $F(x)$ 是 $f(x)$ 在区间 $I$ 上的一个原函数, 那么 $F(x)+C$ 就是 $f(x)$ 的不定积分, 即
```math
\int f(x)\mathrm{d}x=F(x)+C
```
因而不定积分 $\displaystyle\int f(x)\mathrm{d}x$ 可以表示 $f(x)$ 的任意一个原函数.

### 基本积分表
基本积分表
* $\displaystyle\int k\mathrm{d}x=kx+C\ \ (k是常数)$
* $\displaystyle\int x^\mu\mathrm{d}x=\frac{x^{\mu+1}}{\mu+1}\ \ (\mu\neq -1)$
* $\displaystyle\int \frac{\mathrm{d}x}{x}=\ln|x|+C$
* $\displaystyle\int \frac{\mathrm{d}x}{1+x^2}=\arctan x+C$
* $\displaystyle\int \frac{\mathrm{d}x}{\sqrt{1-x^2}}=\arcsin x+C$
* $\displaystyle\int \cos x \mathrm{d}x = \sin x+C$
* $\displaystyle\int \sin x \mathrm{d}x = -\cos x+C$
* $\displaystyle\int \frac{\mathrm{d}x}{\cos^2 x}=\int \sec^2 x \mathrm{d}x=\tan x+C$
* $\displaystyle\int \frac{\mathrm{d}x}{\sin^2 x}=\int \csc^2 x\mathrm{d}x=-\cot x+C$
* $\displaystyle\int \sec x \tan x \mathrm{d}x=\sec x + C$
* $\displaystyle\int \csc x \cot x \mathrm{d}x=-\csc x + C$
* $\displaystyle\int e^x\mathrm{d}x=e^x+C$
* $\displaystyle\int a^x\mathrm{d}x=\frac{a^x}{\ln a}+C$

以上十三种基本积分是求解不定积分的基础, **必须熟记**. 

### 不定积分的性质
**性质 1** 设函数 $f(x)$ 及 $g(x)$ 的原函数存在, 则
```math
\int[f(x)+g(x)]\mathrm{d}x=\int f(x)\mathrm{d}x+\int g(x)\mathrm{d}x
```

**性质 2** 设函数 $f(x)$ 的原函数存在, $k$ 为非零常数, 则
```math
\int kf(x)\mathrm{d}x=k\int f(x)\mathrm{d}x
```

## 换元积分法
### 第一类积分法
设 $f(u)$ 具有原函数 $F(u)$, 即
```math
F'(u)=f(u),\ \int f(u)\mathrm{d}u=F(u)+C
```
如果 $u$ 是中间变量: $u=\varphi(x)$, 且设 $\varphi(x)$ 可微, 那么根据复合函数微分法, 有
```math
\mathrm{d}F[\varphi(x)]=f[\varphi(x)]\varphi'(x)\mathrm{d}x
```
从而根据不定积分的定义得
```math
\int f[\varphi(x)]\varphi'(x)\mathrm{d}x=F[\varphi(x)] +C=\left[\int f(u)\mathrm{d}u\right]_{u=\varphi(x)}
```
于是有下述定理

**定理 1** 设 $f(u)$ 具有原函数, $u=\varphi(x)$ 可导, 则有换元公式
```math
\int f[\varphi(x)]\varphi'(x)\mathrm{d}x=\left[\int f(u)\mathrm{d}u\right]_{u=\varphi(x)}
```

### 第二类换元法
**定理 2** 设 $x=\psi(t)$ 是单调的可导函数, 并且 $\psi'(t)\neq 0$. 有设 $f[\psi(t)]\psi'(t)$ 具有原函数, 则有换元公式
```math
\int f(x)\mathrm{d}x=\left[\int f[\psi(t)]\psi'(t)\mathrm{d}t\right]_{t=\psi^{-1}(x)}
```
其中 $\psi^{-1}(x)$ 是 $x=\psi(t)$ 的反函数.

双曲积分公式
* $\int \sh x \mathrm{d}x=\ch x + C$
* $\int \ch x \mathrm{d}x=\sh x + C$

额外的几个积分公式
* $\displaystyle\int \tan x \mathrm{d}x=-\ln|\cos x|+C$
* $\displaystyle\int \cot x \mathrm{d}x=\ln|\sin x|+C$
* $\displaystyle\int \sec x \mathrm{d}x=\ln|\sec x + \tan x|+C$
* $\displaystyle\int \csc x \mathrm{d}x=\ln|\csc x-\cot x|+C$
* $\displaystyle\int \frac{\mathrm{d}x}{a^2+x^2}=\frac{1}{a}\arctan \frac{x}{a}+C$
* $\displaystyle\int \frac{\mathrm{d}x}{x^2+a^2}=\frac{1}{a}\ln\left|\frac{x-a}{x+a}\right|+C$
* $\displaystyle\int \frac{\mathrm{d}x}{\sqrt{a^2-x^2}}=\arcsin\frac{x}{a}=C$
* $\displaystyle\int \frac{\mathrm{d}x}{\sqrt{x^2+a^2}}=\ln(x+\sqrt{x^2+a^2})+C$
* $\displaystyle\int \frac{\mathrm{d}x}{\sqrt{x^2-a^2}}=\ln|x+\sqrt{x^2-a^2}|+C$

## 分布积分法
设函数 $u=u(x)$ 及 $v=v(x)$ 具有连续导数, 则两个函数乘积的导数公式为
```math
(uv)'=u'v+uv'
```
移项, 得
```math
uv'=(uv)'-u'v
```
对这个等式两边求不定积分, 得
```math
\int uv'\mathrm{d}x=uv-\int u'v\mathrm{d}x
```
上述公式称为**分部积分公式**. 简便起见, 可以写成:
```math
\int u\mathrm{d}v=uv-\int v\mathrm{d}u
```

## 有理函数的积分
### 有理函数的积分
两个多项式的商 $\displaystyle\frac{P(x)}{Q(x)}$ 称为**有理函数**. 又称 **有理分式**. 当分子多项式 $P(x)$ 的次数小于分母多项式 $Q(x)$ 的次数时, 称这有理函数为 **真分式**, 否则称为**假分式**.

利用多项式的除法, 总可以将一个假分式化成一个多项式和与一个真分式之和的形式.

对于真分式 $\displaystyle\frac{P(x)}{Q(x)}$, 如果分母可分解为两个多项式的乘积:
```math
Q(x)=Q_1(x)Q_2(x)
```
且 $Q_1(x)$ 与 $Q_2(x)$ 没有共因式, 那么它可拆成两个真分式之和
```math
\frac{P(x)}{Q(x)}=\frac{P_1(x)}{Q_1(x)}+\frac{P_2(x)}{Q_2(x)}
```
上述步骤成为把真分式化成部分分式之和.

### 可化为有理函数的积分
略

## 积分表的使用
往往把常用的积分公式汇集成表, 这种表叫做**积分表**