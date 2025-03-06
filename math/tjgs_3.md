# 微分中值定理与导数的应用
## 微分中值定理
### 罗尔定理
**费马引理** 设函数 $f(x)$ 在点 $x_0$ 的某邻域 $U(x_0)$ 内有定义, 并且在 $x_0$ 处可导, 如果对于任意的 $x\in U(x_0)$, 有
```math
f(x)\le f(x_0)\ \ \ (或 f(x) \ge f(x_0))
```
那么 $f'(x_0)=0$

**罗尔定理** 如果函数 $f(x)$ 满足
* 在闭区间 $[a,b]$ 上连续
* 在开区间 $(a,b)$ 内可导
* 在区间端点处的函数值相等, 即 $f(a) = f(b)$

那么在 $(a,b)$ 内至少有一点 $\xi (a\lt\xi\lt b)$, 使得 $f'(\xi)=0$

### 拉格朗日中值定理
**拉格朗日中值定理** 如果函数 $f(x)$ 满足
* 在闭区间 $[a,b]$ 上连续
* 在开区间 $(a,b)$ 内可导

那么在 $(a,b)$ 内至少有一点 $\xi (a\lt\xi\lt b)$, 使等式
```math
f(b)-f(a)=f'(\xi)(b-a)
```
成立.

**定理** 如果函数 $f(x)$ 在区间 $I$ 上连续, $I$ 内可导, 且导数为零, 那么 $f(x)$ 在区间 $I$ 上是一个常数.

### 柯西中值定理
**柯西中值定理** 如果函数 $f(x)$ 及 $F(x)$ 满足
* 在闭区间 $[a,b]$ 上连续
* 在开区间 $(a,b)$ 内可导
* 对于任一 $x\in(a,b), F'(x)\neq 0$
那么在 $(a,b)$ 内至少有一点 $\xi$, 使等式
```math
\frac{f(b)-f(a)}{F(b)-F(a)}=\frac{f'(\xi)}{F'(\xi)}
```
成立.

## 洛必达法则
**定理 1** 设
* 当 $x\to a$ 时, 函数 $f(x)$ 及 $F(x)$ 都趋于零
* 在点 $a$ 的某去心邻域内, $f'(x)$ 及 $F'(x)$ 都存在且 $F'(x)\neq 0$
* $\displaystyle\lim_{x\to a}\frac{f'(x)}{F'(x)}$ 存在 (或为无穷大)

则
```math
\lim_{x\to a}\frac{f(x)}{F(x)}=\lim_{x\to a}\frac{f'(x)}{F'(x)}
```
这种在一定条件下通过分子分母分别求导再求极限来确定未定式的值的方法称为**洛必达(L'Hospital)法则**

**定理 2** 设
* 当 $x\to\infty$ 时函数 $f(x)$ 及 $F(x)$ 都趋于零
* 当 $|x|\gt N$ 时, $f'(x)$ 与 $F'(x)$ 都存在, 且 $F'(x)\neq 0$
* $\displaystyle\lim_{x\to\infty}\frac{f'(x)}{F'(x)}$ 存在(或为无穷大)

则
```math
\lim_{x\to\infty}\frac{f(x)}{F(x)}=\lim_{x\to\infty}\frac{f'(x)}{F'(x)}
```

## 泰勒公式
**泰勒(Taylor)中值定理 1** 如果函数 $f(x)$ 在 $x_0$ 处具有 $n$ 阶导数, 那么存在 $x_0$ 的一个邻域, 对于该邻域内的任一 $x$ 有
```math
f(x)=f(x_0)+f'(x_0)(x-x_0)+\frac{f''(x_0)}{2!}(x-x_0)^2+\cdots+\frac{f^{(n)}(x_0)}{n!}(x-x_0)^n + R_n(x)
```
其中
```math
R_n(x)=o((x-x_0)^n)
```

**泰勒(Taylor)中值定理 2** 如果函数 $f(x)$ 在 $x_0$ 的某个去心邻域 $U(x_0)$ 内具有 $(n_1)$ 阶导数, 那么对于任一 $x\in U(x_0)$, 有
```math
f(x)=f(x_0)+f'(x_0)(x-x_0)+\frac{f''(x_0)}{2!}(x-x_0)^2+\cdots+\frac{f^{(n)}(x_0)}{n!}(x-x_0)^n + R_n(x)
```
其中
```math
R_n(x)=\frac{f^{(n+1)}(\xi)}{(n+1)!}(x-x_0)^{n+1}
```
这里 $\xi$ 是 $x_0$ 与 $x$ 之间的某个值.

## 函数的的单调性与曲线的凹凸性
### 函数单调性的判定法
**定理 1** 设函数 $y=f(x)$ 在 $[a,b]$ 上连续, 在 $(a,b)$ 内可导.
* 如果在 $(a,b)$ 内 $f'(x)\ge 0$, 且等号仅在有限多个点处成立, 那么函数 $y=f(x)$ 在 $[a,b]$ 上单调增加.
* 如果在 $(a,b)$ 内 $f'(x)\le 0$, 且等号仅在有限多个点处成立, 那么函数 $y=f(x)$ 在 $[a,b]$ 上单调减少.

### 曲线的凹凸与拐点
**定义** 设 $f(x)$ 在区间 $I$ 上连续, 如果对 $I$ 上任意两点 $x_1,x_2$ 恒有
```math
f\left(\frac{x_1+x_2}{2}\right) \lt \frac{f(x_1)+f(x_2)}{2}
```
那么称 $f(x)$ 在 $I$ 上的**图形是(向上)凹的(或凹弧)；如果恒有
```math
f\left(\frac{x_1+x_2}{2}\right) \gt \frac{f(x_1)+f(x_2)}{2}
```
那么称 $f(x)$ 在 $I$ 上的**图形是(向上)凸的(或凸弧)；

**定理 2** 设 $f(x)$ 在 $[a,b]$ 上连续, 在 $(a,b)$ 内具有一阶和二阶导数, 那么
* 若在 $(a,b)$ 内 $f''(x)\gt 0$, 则 $f(x)$ 在 $[a,b]$ 上的图形是凹的.
* 若在 $(a,b)$ 内 $f''(x)\lt 0$, 则 $f(x)$ 在 $[a,b]$ 上的图形是凸的.

## 函数的极值与最大值最小值
### 函数极值及其求法
**定义** 设函数 $f(x)$ 在点 $x_0$ 的某邻域 $U(x_0)$ 内有定义, 如果对于去心邻域 $\mathring{U}(x_0)$ 内的任一 $x$, 有
```math
f(x)\lt f(x_0)\ \ \ (或 f(x) \gt f(x_0))
```
那么称  $f(x_0)$ 是函数 $f(x)$ 的一个**极大值**(或**极小值**).

**定理 1(必要条件)** 设函数 $f(x)$ 在点 $x_0$ 处可导, 且在 $x_0$ 处取得极值, 则 $f'(x_0)=0$.

**定理 2(第一充分条件)** 设函数 $f(x)$ 在点 $x_0$ 处连续, 且在 $x_0$ 的某去心邻域 $\mathring{U}(x_0)$ 内可导.
* 若 $x\in(x_0-\delta, x_0))$ 时, $f'(x)\gt 0$, 而 $x\in (x_0,x_0+\delta)$ 时, $f'(x)\lt 0$, 则 $f(x)$ 在 $x_0$ 处取得极大值.
* 若 $x\in(x_0-\delta, x_0))$ 时, $f'(x)\lt 0$, 而 $x\in (x_0,x_0+\delta)$ 时, $f'(x)\gt 0$, 则 $f(x)$ 在 $x_0$ 处取得极小值.
* 若 $x\in(x_0-\delta, x_0))$ 时, $f'(x)$ 的符号保持不变, 则 $f(x)$ 在 $x_0$ 处没有极值.

**定理 3(第二充分条件)** 设函数 $f(x)$ 在点 $x_0$ 处有二阶导数且 $f'(x_0)=0, f''(x_0)\neq 0$ 则
* 当 $f''(x_0)\lt 0$ 时, 函数 $f(x)$ 在 $x_0$ 处取得极大值
* 当 $f''(x_0)\gt 0$ 时, 函数 $f(x)$ 在 $x_0$ 处取得极小值

### 最大值最小值问题
方法:
* 求出 $f(x)$ 在 $(a,b)$ 内的驻点及不可导点
* 计算 $f(x)$ 在上述驻点/不可导点处的函数值及 $f(a), f(b)$
* 比较上述各值的大小, 其中最大的便是 $f(x)$ 在 $[a,b]$ 上的最大值, 最小的便是  $f(x)$ 在 $[a,b]$ 上的最小值.

## 函数图形的描绘.
步骤:
* 确定函数 $y=f(x)$ 的定义域及函数所具有的某些特性(如奇偶性/周期性等), 并求处函数的一阶导数 $f'(x)$ 和二阶导数 $f''(x)$
* 求出一阶导数 $f'(x)$ 和二阶导数 $f''(x)$ 在函数定义域内的全部零点, 并求出函数 $f(x)$ 的间断点及 $f'(x)$ 和 $f''(x)$ 不存在的点, 用这些点把函数的定义域划分成几个部分区间.
* 确定这些部分区间内 $f'(x)$ 和 $f''(x)$ 符号, 并由此确定函数图形的升降/凹凸和拐点.
* 确定函数图形的水平, 铅直渐近线及其他变化趋势.
* 算出 $f'(x)$ 和 $f''(x)$ 的零点以及不存在的点对应的函数值, 定出图形上相应的点. 为了把图形描绘的准确些, 有时还需要补充一些点, 然后结合第三/四步中得到的结果, 联结这些点画出函数 $y=f(x)$ 的图形.

## 曲率
### 弧微分
设函数 $f(x)$ 在区间 $(a,b)$ 内具有连续导数, 在曲线 $y=f(x)$ 上取固定点 $M_0(x_0,y_0)$ 作为弧长的基点, 并规定依 $x$ 增大方向作为曲线的正向. 对曲线上任一点 $M(x,y)$, 规定有向弧段 $\overset{\frown}{M_0M}$ 的值 $s$ (简称弧 $s$)如下: $s$ 的绝对值等于这段弧的长度, 当有向弧段 $\overset{\frown}{M_0M}$ 的方向与曲线正向一致时 $s\gt 0$, 相反时 $s\lt 0$. 显然, 弧 $s$ 与 $x$ 存在函数关系 $s=s(x)$, 而且 $s(x)$ 是 $x$ 的单调增加函数. 下面求 $x(x)$ 的导数及微分.

设 $x,x+\Delta x$ 为 $(a,b)$ 内两个邻近的点, 它们在曲线 $y=f(x)$ 上对应的点为 $M,M'$, 并设对应于 $x$ 的增量为 $\Delta x$, 弧 $s$ 的增量为 $\Delta s$, 那么
```math
\Delta s = \overset{\frown}{M_0M'}-\overset{\frown}{M_0M}=\overset{\frown}{M_M'}
```
于是
```math
\begin{align}
\left(\frac{\Delta s}{\Delta x}\right)^2 &= \left(\frac{\overset{\frown}{MM'}}{\Delta x}\right)^2 = \left(\frac{\overset{\frown}{MM'}}{|MM'|}\right)^2\cdot\frac{|MM'|^2}{(\Delta x)^2} \\
&= \left(\frac{\overset{\frown}{MM'}}{|MM'|}\right)^2\cdot\frac{(\Delta x)^2+(\Delta y)^2}{(\Delta x)^2} \\
&= \left(\frac{\overset{\frown}{MM'}}{|MM'|}\right)\left[1+\left(\frac{\Delta y}{\Delta x}\right)^2\right] \\
\frac{\Delta s}{\Delta x} &= \pm\sqrt{\left(\frac{\overset{\frown}{MM'}}{|MM'|}\right)^2\cdot\left[1+\left(\frac{\Delta y}{\Delta x}\right)^2\right]}
\end{align}
```
令 $\Delta x \to 0$ 取极限, 由于 $\Delta x \to 0$ 时, $M' \to M$, 这时弧的长度与弦的长度之比的极限等于 1, 即
```math
\lim_{M'\to M}\frac{\overset{\frown}{MM'}}{|MM'|}=1
```
又
```math
\lim_{\Delta x \to 0}\frac{\Delta y}{\Delta x} = y'
```
因此得:
```math
\frac{\mathrm{d}s}{\mathrm{d}x}=\pm\sqrt{1+y'^2}
```
由于 $s=s(x)$ 是单调增加函数, 从而根号前应取正号, 于是有
```math
\mathrm{d}s = \sqrt{1+y'^2}\mathrm{d}x
```
这就是弧微分公式.

### 曲率及其计算公式
设曲线 $C$ 是光滑的, 在曲线 $C$ 上选定一点 $M_0$ 作为度量弧 $s$ 的基点. 设曲线上点 $M$ 对应于弧 $s$, 在点 $M$ 处切线的倾角为 $\alpha$ (这里假定曲线 $C$ 所在的平面上已设立了 $xOy$ 坐标系), 曲线上另外一点 $M'$ 对应于弧 $s+\Delta s$, 在点 $M'$ 出切线的倾角为 $\alpha + \Delta\alpha$, 则弧段 $\overset{\frown}{MM'}$ 的长度为 $|\Delta s|$, 当动点从 $M$ 移动到 $M'$ 时切线转过的角度为 $|\Delta\alpha|$.

我们用比值 $\displaystyle\frac{|\Delta\alpha|}{|\Delta s|}$, 即单位弧段上切线转过的角度大小来表达弧段 $\overset{\frown}{MM'}$ 弯曲程度, 把这比值叫做弧段 $\overset{\frown}{MM'}$ 的**平均曲率**, 并记作 $\overline{K}$, 即
```math
\overline{K}=\left|\frac{\Delta\alpha}{\Delta s}\right|
```
类似于从平均速度引进瞬时速度的方法, 当 $\Delta s \to 0$ 时(即 $M'\to M$ 时), 上述平均曲率的极限叫做曲线 $C$ 在点 $M$ 处的**曲率**, 记作 $K$, 即
```math
K=\lim_{\Delta s \to 0}\left|\frac{\Delta\alpha}{\Delta s}\right|
```
在 $\displaystyle\lim_{\Delta s \to 0}\frac{\Delta\alpha}{\Delta s}=\frac{\mathrm{d}\alpha}{\mathrm{d}s}$ 存在的条件下, $K$ 也可以表示为:
```math
K=\left|\frac{\mathrm{d}\alpha}{\mathrm{d}s}\right|
```
对于直线来说, 切线与直线本身重合, 当点沿直线移动时, 切线的倾角 $\alpha$ 不变, $\displaystyle\Delta \alpha = 0, \frac{\Delta \alpha}{\Delta s} = 0$, 从而 $\displaystyle K=\left|\frac{\mathrm{d}\alpha}{\mathrm{d}s}\right|=0$. 这就是说, 直线上任意点 $M$ 处的曲率都等于零. 这与我们直觉认识到的"直线不弯曲"一致.

设曲线的直角坐标方程是 $y=f(x)$, 其 $f(x)$ 具有二阶导数(这时 $f'(x)$ 连续, 从而曲线是光滑的). 因为 $\tan\alpha=y'$, 所以
```math
\sec^2\alpha\frac{\mathrm{d}\alpha}{\mathrm{d}x}=y'' \\
\frac{\mathrm{d}\alpha}{\mathrm{d}x}=\frac{y''}{1+\tan^2\alpha}=\frac{y''}{1+y'^2}
```
于是
```math
\mathrm{d}\alpha=\frac{y''}{1+y'^2}\mathrm{d}x
```
由
```math
\mathrm{d}s=\sqrt{1+y'^2}\mathrm{d}x
```
从而根据曲率 $K$ 的表达式有:
```math
K=\frac{|y''|}{(1+y'^2)^{3/2}}
```
设曲线方程:
```math
\begin{cases}
x=\varphi(x) \\
y=\psi(x)
\end{cases}
```
给出, 则可利用由参数方程所确定的函数的求导法, 求出 $y'$, 及 $y''$, 带入上式得
```math
K=\frac{|\varphi(t)\psi''(t)-\varphi''(t)\psi'(t)|}{[\varphi'^2(t)+\psi'^2(t)]^{3/2}}
```

### 曲率圆与曲率半径

设曲线 $y=f(x)$ 在点 $M(x,y)$ 处的曲率为 $K(K\neq 0)$. 在点 $M$ 处的曲线的法线上, 在凹的一侧取一点 $D$, 使 $\displaystyle|DM|=\frac{1}{K}=\rho$. 以 $D$ 为圆心, $\rho$ 为半径作圆, 这个圆叫做曲线在点 $M$ 处的**曲率圆**, 曲率圆的圆心 $D$ 叫做曲线在点 $M$ 处的**曲率中心**, 曲率圆的半径 $\rho$ 叫做曲线在点 $M$ 处的**曲率半径**.

曲线在点 $M$ 处的曲率 $K(K\neq 0$ 与曲线在点 $M$ 处的曲率半径 $\rho$ 有如下关系:
```math
\rho=\frac{1}{K}, K=\frac{1}{\rho}
```
这就是说: 曲线上一点处的曲率圆半径与曲线在该点处的曲率互为倒数.

### 曲率中心的计算公式, 渐屈线与渐伸线
设已知曲线的方程是 $y=f(x)$, 且其二阶导数 $y''$ 在点 $x$ 不为零, 则曲线在对应点 $M(x,y)$ 的曲率中心 $D(\alpha, \beta)$ 的坐标为:
```math
\begin{cases}
\alpha &= x-\frac{y'(1+y'^2)}{y''}\\
\beta &= y+\frac{1+y'^2}{y''}
\end{cases}
```
这是因为, 曲线 $y=f(x)$ 在 $M(x,y)$ 的曲率圆方程为:
```math
(\xi-\alpha)^2+(\eta-\beta)^2=\rho^2
```
其中 $\xi,\eta$ 是曲率圆上的动点坐标, 且
```math
\rho^2=\frac{1}{K^2}=\frac{(1+y'^2)^3}{y''^2}
```
因为点 $M$ 在曲率圆上, 所以
```math
(x-\alpha)^2+(y-\beta)^2=\rho^2
```
又因为曲线在点 $M$ 的切线与曲率圆的半径 $DM$ 互相垂直, 所以
```math
y'=-\frac{x-\alpha}{y-\beta}
```
消去 $x-\alpha$ 解出
```math
(y-\beta)^2=\frac{\rho^2}{1+y'^2}=\frac{(1+y'^2)}{y''^2}
```
由于当 $y''\gt 0$ 时曲线为凹弧, $y=\beta \lt 0$; 当 $y''\lt 0$ 时曲线为凸弧, $y=\beta \gt 0$. 总之 $y''$ 与 $y-\beta$ 异号. 因此取上式两边的平方根得:
```math
y-\beta=\frac{1+y'^2}{y''}
```
又
```math
x-\alpha=-y'(y-\beta)=\frac{y'(1+y'^2)}{y''}
```
从而上述坐标公式.

当点 $(x,f(x))$ 沿曲线 $C$ 移动是, 相应的曲率中心 $D$ 的轨迹曲线 $G$ 成为曲线 $C$ 的**渐屈线**, 而曲线 $C$ 成为曲线 $G$ 的**渐伸线**. 所以曲线 $y=f(x)$ 的渐屈线的参数方程为:
```math
\begin{cases}
\alpha=x-\frac{y'(1+y'^2)}{y''} \\
\beta=y+\frac{1+y'^2}{y''}
\end{cases}
```
其中 $y=f(x), y'=f'(x),y''=f''(x)$, $x$ 为参数, 直角坐标系 $\alpha O \beta$ 与 $xOy$ 坐标系重合.

## 方程的近似解
### 二分法
设 $f(x)$ 在区间 $[a,b]$ 上连续, $f(a)\cdot f(b)\lt 0$, 且方程 $f(x)=0$ 在 $(a,b)$ 内仅有一个实根 $\xi$, 于是 $[a,b]$ 即是这个根的一个隔离区间.

取 $[a,b]$ 的中点 $\displaystyle\xi_1=\frac{a+b}{2}$ , 计算 $f(\xi_1)$

如果 $f(\xi_1)=0$, 那么 $\xi=\xi_1$

如果 $f(\xi_1)$ 与 $f(a)$ 同号, 那么取 $a_1=\xi_1, b_1=b$, 由 $f(a_1)\cdot f(b_1)\lt 0$, 即知 $a_1 \lt \xi_1 \lt b_1$, 且 $\displaystyle b_1=a_1=\frac{1}{2}(b-a)$

如果 $f(\xi_1)$ 与 $f(b)$ 同号, 那么取 $a_1=a, b_1=\xi_1$, 也有 $a_1 \lt \xi_1 \lt b_1$, 及 $\displaystyle b_1=a_1=\frac{1}{2}(b-a)$

总之, 当 $\xi \neq \xi_1$ 时, 可求得 $a_1 \lt \xi_1 \lt b_1$, 且 $\displaystyle b_1=a_1=\frac{1}{2}(b-a)$

以 $[a_1,b_1]$ 作为新的隔离区间, 重复上述做法, 当 $\xi\neq\xi_2=\frac{1}{2}(a_1+b_1)$ 时, 可求得 $\displaystyle a_1\lt\xi\lt b_2$, 且 $\displaystyle b_2-a_2=\frac{1}{2^2}(b-a)$

如此重复 $n$ 次, 可求得 $a_b\lt\xi\lt b_n$, 且 $\displaystyle b_n-a_n=\frac{1}{2^n}(b-a)$. 由此可知, 如果以 $a_n$ 或 $b_n$ 作为 $\xi$ 的近似值, 那么其误差小于 $\displaystyle\frac{1}{2^n}(b-a)$

### 切线法
设 $f(x)$ 在区间 $[a,b]$ 上有二阶导数, $f(a)\cdot f(b)\lt 0$ 且 $f'(x)$ 及 $f''(x)$ 在 $[a,b]$ 上保持定号. 在上述条件下, 方程 $f(x)=0$ 在 $(a,b)$ 内有唯一的实根 $\xi$, $[a,b]$ 为根的一个隔离区间. 此时 $y=f(x)$ 在 $[a,b]$ 上的图形 $\overset{\frown}{AB}$ 只有四种不同情形.

以 $f(a)\lt 0, f(b) \gt 0, f'(x)\gt 0, f''(x) \gt 0$ 情形为例进行讨论. 此时因为 $f(b)$ 与 $f''(x)$ 同号, 所以令 $x_0=b$ 在端点 $(x_0,f(x_0))$ 处做切线, 切线的方程为:
```math
y-f(x_0)=f'(x_0)(x-x_0)
```
令 $y=0$, 从上式中解出 $x$, 就得到切线与 $x$ 轴的交点的横坐标为:
```math
x_1=x_0-\frac{f(x_0)}{f'(x_0)}
```
它比 $x_0$ 更接近方程的根 $\xi$

再在点 $(x_1, f(x_1))$ 处做切线, 可得近似值 $x_2$, 如此继续, 一般地, 在点 $(x_n,f(x_n))$ 处做切线, 得根的近似值:
```math
x_{n+1}=x_n-\frac{f(x_n)}{f'(x_n)}
```

如果 $f(a)$ 与 $f''(x)$ 同号, 那么切线在端点 $(a,f(a))$ 处, 可记 $x_0=a$, 扔按公式计算切线与 $x$ 轴交点的横坐标.

### 割线法
利用切线法计需要计算函数的导数, 当 $f(x)$ 比较复杂时, 计算 $f'(x)$ 可能有困难. 这时可以考虑用 
```math
\frac{f(x_n)-f(x_{n-1})}{x_n-x_{n-1}}
```
来近似替代切线法中的 $f'(x_n)$, 这时的迭代公式成为
```math
x_{n+1}=x_n-\frac{x_n-x_{n-1}}{f(x_n)-f(x_{n-1})}\cdot f(x_n)
```
其中 $x_0, x_1$ 为初始值. 这个方法叫做**割线法**或**截弦法**