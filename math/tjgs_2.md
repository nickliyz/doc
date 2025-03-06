# 导数与微分
## 导数概念
### 引例
#### 直线运动加速度
时间 $t$, 位置 $s$, 有
```math
s = f(t)
```
平均速度:
```math
\frac{s-s_0}{t-t_0} = \frac{f(t) - f(t_0)}{t - t_0}
```
在 $t_0$ 时刻的速度:
```math
v = \lim_{t\to t_0}\frac{f(t) - f(t_0)}{t - t_0}
```

#### 切线问题
```math
k = \lim_{x\to x_0}\frac{f(x) - f(x_0)}{x-x_0}
```
$k$ 是切线的斜率.

### 导数的定义
#### 函数在一点处的导数与导函数
**定义** 设函数 $y=f(x)$ 在点 $x_0$ 的某个去心邻域内有定义, 当自变量 $x$ 在 $x_0$ 处取得增量 $\Delta x$ (点 $x_0+\Delta x$ 仍在该邻域内) 时, 相应地, 因变量取得增量 $\Delta y=f(x_0+\Delta x) - f(x_0)$; 如果 $\Delta y$ 与 $\Delta x$ 之比当 $\Delta \to 0$ 时的极限存在, 那么称函数 $y = f(x)$ 在 $x_0$ 处可导, 并称这个极限为函数 $y = f(x)$ 在点 $x_0$ 处的导数, 记为 $f'(x_0)$,即
```math
f'(x_0)=\lim_{\Delta x \to 0}\frac{\Delta y}{\Delta x} = \lim_{\Delta x \to 0}\frac{f(_0+\Delta x)-f(x_0)}{\Delta x}
```
也可记作 $\displaystyle y'\mid_{x=x_0}, \frac{\mathrm{d}y}{\mathrm{d}x}\mid_{x=x_0}$ 或 $\frac{\mathrm{d}f(x)}{\mathrm{d}x}\mid_{x=x_0}$

#### 求导数函数举例
略

#### 单侧导数
根据函数 $f(x)$ 在点 $x_0$ 处的导数 $f'(x_0)$ 的定义, 导数
```math
f'(x_0) = \lim_{h\to0}\frac{f(x_0+h)-f(x_0)}{h}
```
是一个极限, 而极限存在的充分必要条件是左/右极限都存在且相等, 因此 $f'(x_0)$ 存在即 $f(x)$ 在点 $x_0$ 处可导的充分必要条件是左/右极限
```math
\lim_{h\to0^-}\frac{f(x_0+h)-f(x_0)}{h}\ \ \ 及\ \ \ \lim_{h\to0^+}\frac{f(x_0+h)-f(x_0)}{h}
```
都存在且相等. 这两个极限分别称为函数 $f(x)$ 在点 $x_0$ 处的**左导数** 和**右导数**, 记作 
```math
\displaystyle f_-'(x_0) = \lim_{h\to0^-}\frac{f(x_0+h)-f(x_0)}{h}
```
```math
\displaystyle f_+'(x_0) = \lim_{h\to0^+}\frac{f(x_0+h)-f(x_0)}{h}
```

左导数和右导数统称为单侧导数.

如果 $f(x)$ 在开区间 $(a,b)$ 内可导, 且 $f_+'(a)$ 及 $f_-'(b)$ 都存在, 那么说 $f(x)$ 在**闭区间** $[a,b]$ 上可导.

### 导数的几何意义
函数 $y=f(x)$ 在点 $x_0$ 处的导数 $f'(x_0)$ 在几何上表示曲线 $y = f(x)$ 在点 $M(x_0, f(x_0)$ 处的切线的斜率, 即:
```math
f'(x_0) = \tan \alpha
```
其中 $\alpha$ 是切线的倾角. 

切线方程为:
```math
y - y_0 = f'(x_0)(x-x_0)
```
法线方程为:
```math
y-y_0 = -\frac{1}{f'(x_0)}(x-x_0)
```

### 函数可导性与连续性的关系
设函数 $y=f(x)$ 在点 $x$ 处可导, 即
```math
\lim_{x\to 0}\frac{\Delta y}{\Delta x} = f'(x)
```
存在. 由具有极限的函数与无穷小的关系知道:
```math
\frac{\Delta y}{\Delta x} = f'(x) + \alpha
```
其中 $\alpha$ 为当 $\Delta x \to 0$ 似的无穷小. 上式两边同乘 $\Delta x$ 得
```math
\Delta y = f'(x)\Delta x + \alpha \Delta x
```
由此可见, 当 $\Delta x \to 0$ 时, $\Delta y \to 0$. 这就是说, 函数 $y=f(x)$ 在点 $x$ 处是连续的. 所以, 如果 $y=f(x)$ 在点 $x$ 处可导, 那么函数在该点必定连续.

另一方面, 一个函数在某点连续却不一定在该点可导.

## 函数的求导法则
### 函数的和/差/积/商的求导法则
**定理 1** 如果函数 $u=u(x)$ 及 $v=v(x)$ 都在点 $x$ 具有导数, 那么他们的和/差/积/商(除分母为零的点外)都在点 $x$ 具有导数, 且:
* $[u(x)\pm v(x)]' = u'(x)\pm v'(x)$
* $[u(x)v(x)]' = u'(x)v(x) + u(x)v'(x)$
* $\displaystyle\left[\frac{u(x)}{v(x)}\right]' = \frac{u'(x)v(x)-u(x)v'(x)}{v^2(x)} (v(x) \neq 0)$

定理 1 的扩展:
* $(u+v-w)' = u'+v'-w'$
* $(uvw)' = (uv)'w + (uv)w' = (u'v + uv')w + uvw'$ 即 $(uvw)'=u'vw+uv'w+uvw'$

### 反函数求导法则
**定理 2** 如果函数 $x=f(y)$ 在区间 $I_y$ 內单调, 可导, 且 $f'(y) \neq 0$, 那么它的反函数 $y=f^{-1}(x)$ 在区间 $I_x=\{x\mid x=f(y),y\in I_y\}$ 内也可导, 且
```math
[f^{-1}(x)]' = \frac{1}{f'(y)}\ \ \ 或\ \ \ \frac{\mathrm{d}y}{\mathrm{d}x} = \frac{1}{\frac{\mathrm{d}x}{\mathrm{d}y}}
```

### 复合函数求导法则
**定理 3** 如果 $u=g(x)$ 在点 $x$ 可导, 而 $y=f(u)$ 在点 $u=g(x)$ 可导, 那么复合函数 $y=f[g(x)]$ 在点 $x$ 可导, 且其导数为:
```math
\frac{\mathrm{d}y}{\mathrm{d}x} = f'(u)\cdot g'(x) \ \ \ 或\ \ \ \frac{\mathrm{d}y}{\mathrm{d}x} = \frac{\mathrm{d}y}{\mathrm{d}u} \cdot \frac{\mathrm{d}u}{\mathrm{d}x}
```

### 基本求导法则与求导公式
#### 常数和基本初等函数的导数公式
* $(C)' = 0$
* $(x^\mu)' = \mu x^{\mu - 1}$
* $(\sin x)' = \cos x$
* $(\cos x)' = -\sin x$
* $(\tan x)' = \sec^2 x$
* $(\cot x)' = -\csc^2 x$
* $(\sec x)' = \sec x \tan x$
* $(\csc x)' = -\csc x \cot x$
* $(a^x)' = a^x\ln a\ (a\gt 0, a\neq 1)$
* $(e^x)' = e^x$
* $(\log_ax)' = \frac{1}{x\ln a}\ (a\gt 0,a\neq 1)$
* $(\ln x)' = \frac{1}{x}$
* $(\arcsin x)' = \frac{1}{\sqrt{1-x^2}}$
* $(\arccos x)' = -\frac{1}{\sqrt{1-x^2}}$
* $(\arctan x)' = \frac{1}{1+x^2}$
* $(\mathrm{arccot}x)' = -\frac{1}{1+x^2}$

#### 函数的和/差/积/商的求导法则
设 $u=u(x), v=v(x)$ 都可导, 则
* $(u\pm v)' = u' \pm v'$
* $(Cu)' = Cu' (C是常数)$
* $(uv)' = u'v + uv'$
* $\displaystyle(\frac{u}{v}) = \frac{u'v-uv'}{v^2}\ (v\neq 0)$

#### 反函数求导法则
设函数 $x=f(y)$ 在区间 $I_y$ 內单调, 可导, 且 $f'(y) \neq 0$, 那么它的反函数 $y=f^{-1}(x)$ 在区间 $I_x=\{x\mid x=f(y),y\in I_y\}$ 内也可导, 且
```math
[f^{-1}(x)]' = \frac{1}{f'(y)}\ \ \ 或\ \ \ \frac{\mathrm{d}y}{\mathrm{d}x} = \frac{1}{\frac{\mathrm{d}x}{\mathrm{d}y}}
```

#### 复合函数求导法则
设 $y=f(u)$, 而 $u=g(x)$ 且 $f(u)$ 及 $g(x)$ 都可导, 则复合函数 $y=f[g(x)]$ 的导数为:
```math
\frac{\mathrm{d}y}{\mathrm{d}x} = \frac{\mathrm{d}y}{\mathrm{d}u} \cdot \frac{\mathrm{d}u}{\mathrm{d}x}\ \ \ 或\ \ \ \frac{\mathrm{d}y}{\mathrm{d}x} = f'(u)\cdot g'(x)
```

## 高阶导数
一般地, 函数 $y=f(x)$ 的导数 $y'=f'(x)$ 仍然是 $x$ 的函数. 我们把 $y'=f'(x)$ 的导数叫做函数 $y=f(x)$ 的**二阶导数**, 记作 $y''$ 或 $\displaystyle\frac{\mathrm{d}^2y}{\mathrm{d}x}$, 即:
```math
y'' = (y')'\ \ \ 或\ \ \ \frac{\mathrm{d}^2y}{\mathrm{d}x^2} = \frac{\mathrm{d}}{\mathrm{d}x}(\frac{\mathrm{d}y}{\mathrm{d}x})
```

相应地, 把 $y=f(x)$ 的导数 $y'=f'(x)$ 叫做函数的**一阶导数**.

类似的, 二阶导数的导数, 叫做**三阶导数**, 一般地, $(n-1)$ 阶导数的导数叫做 $n$ 阶导数, 分别记作
```math
y''',y^{(2)},\cdots,y^{(n)}
```
或
```math
\frac{\mathrm{d}^3y}{\mathrm{d}x^3},\frac{\mathrm{d}^4y}{\mathrm{d}x^4},\cdots,\frac{\mathrm{d}^ny}{\mathrm{d}x^n}
```
函数 $y=f(x)$ 有 $n$ 阶导数, 也常说成函数 $y=f(x)$ 为 **$n$ 阶可导**.

函数 $y=f(x)$ 在点 $x$ 处具有 $n$ 阶导数, 那么 $y=f(x)$ 在点 $x$ 的某一去心邻域内必定具有一切低于 $n$ 阶的导数. 二阶及二阶以上的导数统称为**高阶导数**

## 隐函数及有参数方程所确定的函数的导数  相关变化率
### 隐函数的导数
把一个隐函数化成显函数, 叫做隐函数的显化.
**例 1** 求由方程 $e^y+xy-e=0$ 所确定的隐函数的导数 $\displaystyle\frac{\mathrm{d}y}{\mathrm{d}x}$

**解** 我们把方程两边分别对 $x$ 求导数, 注意 $y=y(x)$. 方程两边对 $x$ 求导得:
```math
\frac{\mathrm{d}}{\mathrm{d}x}(e^y+xy-e)=e^y\frac{\mathrm{d}y}{\mathrm{d}x}+y+x\frac{\mathrm{d}y}{\mathrm{d}x}
```
方程右边对 $x$ 求导得:
```math
(0)'=0
```
由于等式两边对 $x$ 的导数相等, 所以:
```math
e^y\frac{\mathrm{d}y}{\mathrm{d}x}+y+x\frac{\mathrm{d}y}{\mathrm{d}x} = 0
```
从而
```math
\frac{\mathrm{d}y}{\mathrm{d}x}=-\frac{y}{x+e^y}\ \ \ (x+e^y\neq 0)
```

### 由参数方程所确定的函数的导数
一般地, 若参数方程
```math
\begin{cases}
x=\varphi(t) \\
y=\psi(t)
\end{cases}
```
确定 $y$ 与 $x$ 间的函数关系, 则称此函数关系所表达的函数为由上述参数方程所确定的函数.

根据复合函数的求导法则与反函数的求导法则有:
```math
\frac{\mathrm{d}y}{\mathrm{d}x}=\frac{\mathrm{d}y}{\mathrm{d}t}\cdot\frac{\mathrm{d}t}{\mathrm{d}x}=\frac{\mathrm{d}y}{\mathrm{d}t}\cdot\frac{1}{\frac{\mathrm{d}x}{\mathrm{d}t}}=\frac{\varphi'(t)}{\psi'(t)}
```
即
```math
\frac{\mathrm{d}y}{\mathrm{d}x}=\frac{\varphi'(t)}{\psi'(t)}
```
上式也可以写成:
```math
\frac{\mathrm{d}y}{\mathrm{d}x}=\frac{\frac{\mathrm{d}y}{\mathrm{d}t}}{\frac{\mathrm{d}x}{\mathrm{d}t}}
```
如果 $x=\varphi(t), y=\psi(t)$ 还是二阶可导的, 那么又可得到函数的二阶求导公式:
```math
\begin{align}
\frac{\mathrm{d}^2y}{\mathrm{d}x^2}&=\frac{\mathrm{d}}{\mathrm{d}x}\left(\frac{\mathrm{d}y}{\mathrm{d}x}\right)=\frac{\mathrm{d}}{\mathrm{d}x}\left(\frac{\varphi'(t)}{\psi'(t)}\right)\cdot\frac{\mathrm{d}t}{\mathrm{d}x} \\
&=\frac{\varphi''(t)\psi'(t)-\varphi'(t)\psi''(t)}{\psi'^2(t)}\cdot\frac{1}{\psi'(t)}
\end{align}
```
即
```math
\frac{\mathrm{d}^2y}{\mathrm{d}x^2}=\frac{\varphi''(t)\psi'(t)-\varphi'(t)\psi''(t)}{\psi'^3(t)}
```

### 相关变化率
设 $x=x(t)$ 及 $y=y(t)$ 都是可导函数, 而变量 $x$ 与 $y$ 间存在某种关系, 从而变化率 $\displaystyle\frac{\mathrm{d}x}{\mathrm{d}t}$ 与 $\displaystyle\frac{\mathrm{d}y}{\mathrm{d}t}$ 间也存在一定关系. 这两个相互以来的变化率称为**相关变化率**. 

## 函数的微分
### 微分的定义
**定义** 设函数 $y=f(x)$ 在某区间内有定义, $x_0$ 及 $x_0+\Delta x$ 在这区间内, 如果函数的增量
```math
\Delta y = f(x_0 + \Delta x) - f(x_0)
```
可表示为:
```math
\Delta y = A\Delta x + o(\Delta x)
```
其中 $A$ 是不依赖于 $\Delta x$ 的常数, 那么城函数 $y=f(x)$ 在点 $x_0$ 是**可微**的. 而 $A\Delta x$ 叫做函数 $y=f(x)$ 在点 $x_0$ 相应于自变量 $\Delta x$ 的**微分**, 记作 $\mathrm{d}y$, 即
```math
\mathrm{d}y=A\Delta x
```

### 微分的几何意义
在直角坐标系中, 函数 $y=f(x)$ 的图形是一条曲线. 对于某一固定的 $x_0$ 值, 曲线上有一个确定点 $M(x_0,y_0)$, 当自变量 $x$ 有微小增量 $\Delta x$ 时, 就得到曲线上另一个点 $N(x_0+\Delta x, y_0+\Delta y)$, 可知:
```math
MQ=\Delta x
QN=\Delta y
```
过点 $M$ 做曲线的切线 $MT$ , 它的倾角为 $\alpha$, 则
```math
QP=MQ\cdot\tan\alpha=\Delta x\cdot f'(x_0)
```
即
```math
\mathrm{d}y=QP
```

### 基本初等函数的微分公式与微分运算法则
函数的微分公式:
```math
\mathrm{d}y=f'(x)\mathrm{d}x
```

#### 基本初等函数的微分公式
|导数公式|微分公式|
|-|-|
|$(x^\mu)'=\mu x^{\mu-1}$|$\mathrm{d}(x^u)=\mu x^{\mu-1}\mathrm{d}x$|
|$(\sin x)' = \cos x$|$\mathrm{d}(\sin x)=\cos x\mathrm{d}x$|
|$(\cos x)' = -\sin x$|$\mathrm{d}(\cos x)=-\sin x\mathrm{d}x$|
|$(\tan x)' = \sec^2 x$|$\mathrm{d}()=\sec^2x\mathrm{d}x$|
|$(\cot x)' = -\csc^2 x$|$\mathrm{d}()=-\csc^2\mathrm{d}x$|
|$(\sec x)' = \sec x \tan x$|$\mathrm{d}(\sec x)=\sec x\tan x\mathrm{d}x$|
|$(\csc x)' = -\csc x \cot x$|$\mathrm{d}(\csc x)=-\csc x\cot x\mathrm{d}x$|
|$(a^x)' = a^x\ln a\ (a\gt 0, a\neq 1)$|$\mathrm{d}(a^x)=a^x\ln a\mathrm{d}x\ \ (a\gt 0 且 a \neq 1)$|
|$(e^x)' = e^x$|$\mathrm{d}(e^x)=e^x\mathrm{d}x$|
|$(\log_ax)' = \frac{1}{x\ln a}\ (a\gt 0,a\neq 1)$|$\mathrm{d}(\log_a x)=\frac{1}{x\ln a}\mathrm{d}x\ \ (a\gt 0 且 a \neq 1)$|
|$(\ln x)' = \frac{1}{x}$|$\mathrm{d}(\ln x)=\frac{1}{x}\mathrm{d}x$|
|$(\arcsin x)' = \frac{1}{\sqrt{1-x^2}}$|$\mathrm{d}(\arcsin x)=\frac{1}{\sqrt{1-x^2}}\mathrm{d}x$|
|$(\arccos x)' = -\frac{1}{\sqrt{1-x^2}}$|$\mathrm{d}(\arccos x)=-\frac{1}{\sqrt{1-x^2}}\mathrm{d}x$|
|$(\arctan x)' = \frac{1}{1+x^2}$|$\mathrm{d}(\arctan x)=\frac{1}{1+x^2}\mathrm{d}x$|
|$(\mathrm{arccot}x)' = -\frac{1}{1+x^2}$|$\mathrm{d}(\mathrm{arccot}x)=-\frac{1}{1+x^2}\mathrm{d}x$|

#### 函数和/差/积商的微分法则
|函数和/差/积商的求导法则|函数和/差/积商的微分法则|
|-|-|
|$(u\pm v)' = u' \pm v'$|$\mathrm{d}(u\pm v)=\mathrm{d}u\pm \mathrm{d}v$|
|$(Cu)' = Cu' (C是常数)$|$\mathrm{d}(Cu)=C\mathrm{d}u$|
|$(uv)' = u'v + uv'$|$\mathrm{d}(uv)=v\mathrm{d}u+u\mathrm{d}v$|
|$\displaystyle(\frac{u}{v}) = \frac{u'v-uv'}{v^2}\ (v\neq 0)$|$\mathrm{d}\left(\frac{u}{v}\right)=\frac{v\mathrm{d}u-u\mathrm{d}v}{v^2}\ \ (v\neq 0)$|

#### 复合函数的微分法则
设 $y=f(u)$ 及 $u=g(x)$ 都可导, 则复合函数 $x=f[g(x)]$ 的微分为:
```math
dy=y', dx=f'(u)g'(x)\mathrm{d}x
```
由于 $g'(x)\mathrm{d}x=\mathrm{d}u$, 所以, 复合函数 $x=f[g(x)]$ 的微分公式可写成
```math
\mathrm{d}y=f'(u)\mathrm{d}u\ \ \ 或\ \ \ \mathrm{d}y=y'_u\mathrm{d}u
```
由此可见, 无论 $u$ 是自变量还是中间变量, 微分形式 $\mathrm{d}y=f'(u)\mathrm{d}u$ 保持不变. 这一性质称为**微分形式不变性**. 这性质表示, 当变换自变量时, 微分形式 $\mathrm{d}y=f'(u)\mathrm{d}u$ 并不改变.

### 微分在近似计算中的应用
#### 函数的近似计算
如果 $y=f(x)$ 在点 $x_0$ 处的导数 $f'(x_0)\neq0$, 且 $|\Delta x|$ 很小时, 我们有
```math
\Delta y \approx \mathrm{d}x=f'(x_0)\Delta x
```
这个式子也可以写为
```math
\Delta y=f(x_0+\Delta x)-f(x_0)\approx f'(x_0)\Delta x
```
或
```math
f(x_0+\Delta x)\approx f(x_0)+f'(x_0)(x-x_0)
```
如果 $f(x_0)$ 与 $f'(x_0)$ 都容易计算, 那么可以近似计算 $\Delta y$

#### 误差估计
根据带有误差的数据计算所得的结果也会有误差, 我们把它叫做**间接测量误差**

如果某个量的精确值为 $A$, 它的近似值为 $a$, 那么 $|A-a|$ 叫做 $a$ 的绝对差, 而绝对误差. 而绝对误差与 $|a|$ 的比值 $\displaystyle\frac{|A-a|}{a}$ 叫做 $a$ 的相对误差.

如果
```math
|A-a|\le \delta_A
```
那么 $\delta_A$ 叫做测量 $A$ 的**绝对误差限**, 而 $\displaystyle\frac{\delta_A}{|a|}$ 叫做测量 $A$ 的**相对误差限**.