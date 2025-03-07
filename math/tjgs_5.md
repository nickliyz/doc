# 定积分
## 定积分的概念与性质
### 定积分问题举例
#### 曲边梯形的面积
设 $y=f(x)$ 在区间 $[a,b]$ 上非负/连续. 由直线 $x=a,x=b,y=0$ 及曲线 $y=f(x)$ 所围成的图形称为**曲边梯形**, 其中曲线弧称为**曲边**.

在区间 $[a,b]$ 中任意插入若干个分点
```math
a=x_0 \lt x_1 \lt x_2 \lt \cdots \lt x_{n-1} \lt x_n = b
```
把 $[a,b]$ 分成 $n$ 个小区间
```math
[x_0,x_1],[x_1,x_2],\cdots,[x_{n-1},x_n]
```
它们的长度依次为:
```math
\Delta x_1 = x_1-x_0, \Delta x_2=x_2-x_1,\cdots,\Delta x_n=x_n-x_{n-1}
```
记 $\lambda=max\{\Delta x_1,\Delta x_2,\cdots,\Delta x_n\}$, 所求曲边梯形面积 $A$ 的近似值, 即:
```math
A\approx f(\xi_1)\Delta x_1+f(\xi_2)\Delta x_2+\cdots+f(\xi_n)\Delta x_n=\sum_{i=1}^n f(\xi_i)\Delta x_i
```
得曲边梯形的面积
```math
A=\lim_{\lambda\to 0}\sum_{i=1}^n f(\xi_i)\Delta x_i
```

#### 变速直线运动的路程
在时间间隔 $[T_1,T_2]$ 内任意插入若干个分点
```math
T_1=t_0\lt t_1 \lt t_2 \lt \cdots \lt t_{n-1} \lt t_n=T_2
```
把 $[T_1,T_2]$ 分成 $n$ 个小时间段
```math
[t_0,t_1],[t_1,t_2],\cdots,[t_{n-1},t_n]
```
每个小时段时间的长度一次为:
```math
\Delta t_1 = t_1-t_0, \Delta t_2=t_2-t_1,\cdots,\Delta t_n=t_n-t_{n-1}
```
相应地, 在各段时间内物体经过的路程依次为
```math
\Delta s_1,\Delta s_2,\cdots,\Delta s_n
```
部分路程 $\Delta s_i$ 的近似值:
```math
\Delta s_i\approx v(\tau_i)\Delta t_i\ \ (i=1,2,\cdots,n)
```
变速直线运动路程 $s$ 的近似值为:
```math
s\approx v(\tau_1)\Delta t_1 + v(\tau_2)\Delta t_2+\cdots+v(\tau_n)\Delta t_n=\sum_{i=1}^n\Delta t_i
```
记 $\lambda=max\{\Delta t_1,\Delta t_,\cdots,\Delta t_n\}$, 当 $\lambda\to 0$ 时, 取上述和式的极限, 即得:
```math
s=\lim_{\lambda\to 0}\sum_{i=1}^nv(\tau_i)\Delta t_i
```

### 积分的定义
对于面积和路程, 归结为:
```math
面积A=\lim_{\lambda\to 0}\sum_{i=1}^n f(\xi_i)\Delta x_i \\
路程s=\lim_{\lambda\to 0}\sum_{i=1}^nv(\tau_i)\Delta t_i
```

**定义** 设函数 $f(x)$ 在 $[a,b]$ 上有界, 在 $[a,b]$ 中任意插入若干个分点
```math
a=x_0\lt x_1 \lt x_2 \lt \cdots \lt x_{n-1} \lt x_n = b
```
把 $[a,b]$ 分成 $n$ 个小区间
```math
[x_0,x_1],[x_1,x_2],\cdots,[x_{n-1},x_n]
```
各个小区间的长度依次为:
```math
\Delta x_1 = x_1-x_0, \Delta x_2=x_2-x_1,\cdots,\Delta x_n=x_n-x_{n-1}
```
在每个小区间 $[x_{i-1}, x_i]$ 上任取一点 $\xi(x_{i-1}\le\xi_i\le x_i)$, 作函数值 $f(\xi_i)$ 与小区间长度 $\Delta x_i$ 的乘积 $f(\xi_i)\Delta x_i(i=1,2,\cdots,n)$, 并作出和
```math
S=\sum_{i=1}^n f(\xi_i)\Delta x_i
```
记 $\lambda=\mathrm{max}\{\Delta x_1,\Delta x_2,\cdots,\Delta x_n\}$, 如果当 $\lambda\to 0$ 时, 这和的极限总存在, 且与闭区间 $[a,b]$ 的分法及点 $\xi_i$ 的取法无关, 那么称这个极限 $I$ 为函数 $f(x)$ 在区间 $[a,b]$ 上的**定积分**(简称**积分**), 记作 $\displaystyle\int_a^b f(x)\mathrm{d}x$, 即:
```math
\int_a^b f(x)\mathrm{d}x=I=\lim_{\lambda\to 0}\sum_{i=1}^n f(\xi_i)\Delta x_i
```
其中 $f(x)$ 叫做**被积函数**, $f(x)\mathrm{d}x$ 叫做**被积表达式**, $x$ 叫**积分变量**, $a$ 叫做**积分下线**, $b$ 叫做**积分上限**, $[a,b]$ 叫做**积分区间**.

