# 基础
## 区间表示
|表示|区间|
|-|-|
|$(a, b)$|$\{x:a < x < b\}$|
|$[a, b]$|$\{x: a \le x \le b\}$|
|$(a, b]$|$\{x: a < x \le b\}$|
|$[a, b)$|$\{x: a \le x < b\}$|
|$(a, \infty)$|$\{x :x > a\}$|
|$[a, \infty)$|$\{x: x \ge a\}$
|$(-\infty, b)$|$\{x:x < b\}$|
|$(-\infty, b]$|$\{x:x \le b\}$|
|$(-\infty, \infty)$|$\R$|

## 三角形恒等式
```math
\tan{x} = \frac{\sin{x}}{\cos{x}}
```
```math
\cos^2{x} + \sin^2{x} = 1`
``
```math
1 + \tan^2{x} = \sec^2{x}
```
```math
\cot^2{x} + 1 = \csc^2{x}
```
```math
\sin(x) = \cos(\frac{\pi}{2} - x)
```
```math
\tan(x) = \cot(\frac{\pi}{2} - x)
```
```math
\sec(x) = \csc(\frac{\pi}{2} - x)
```
```math
\sin(A + B) = \sin(A)\cos(B) + \cos(A)\sin(B)
```
```math
\cos(A + B) = \cos(A)\cos(B) - \sin(A)\sin(B)
```
```math
\sin(A - B) = \sin(A)\cos(B) - \cos(A)\sin(B)
```
```math
\cos(A - B) = \cos(A)\cos(B) + \sin(A)\sin(B)
```
```math
\sin(2x) = 2\sin(x)\cos(x)
```
```math
\cos(2x) = 2\cos^2(x) - 1 = 1 - 2\sin^2(x)
```


# 微积分
## 数列的极限
定义: 数列 $\{x_n\}$, $\exists$ 常数 $a$, $\forall \epsilon > 0$ (不管多小), $\exists$ 正整数 $N$, 使得当 $n > N$ 时, 有 $\lvert x_n - a \rvert < \epsilon$

记为: $\lim_{n \to \infty}x_n = a$

## 极限的定义

定义: 设 $f(x)$ 在 $x_0$ 的某去心邻域内有定义, $\exists$ 常数 `A`( $f(x)$ 的极限), $\forall \epsilon > 0$, $\exists \delta > 0$ 满足 $0 < \lvert x-x_0\rvert < \delta$.

也就是: $\lvert f(x) - A\rvert < \epsilon$, 也就是 $\lim_{x \to x_0}f(x) = A$

也就是 $f(x) \to A, (x \to x_0)$

## 导数
1) 函数在一点的导数
$y = f(x)$ 在 $x_0$ 的某个去心邻域内有定义, $x$ 在 $x_0$ 去增量 $\Delta x$ (改变量), $\Delta y = f(x_0 + \Delta x) - f(x_0)$, 则: $f(x_0) = \lim_{\Delta x \to 0}\frac{\Delta y}{\Delta x} = \lim_{\Delta x \to 0}\frac{f(x_0 + \Delta x) - f(x_0)}{\Delta x}$ 存在.

记为: $y'\mid_{x = x_0}$ , 或: $\frac{\mathrm{d}y}{\mathrm{d}x}\mid_{x = x_0}$ , 或 $\frac{\mathrm{d}f(x)}{\mathrm{d}x}\mid_{x = x_0}$

三种记法:
```math
\lim_{\Delta x \to 0}\frac{f(x_0 + \Delta x) - f(x_0)}{\Delta x}
```
```math
\lim_{\Delta x \to x_0}\frac{f(x) - f(x_0)}{x - x_0}
```
```math
\lim_{h \to 0}\frac{f(x_0 + h) - f(x_0)}{h}
```

基本函数求导
```math
(x^n)' = nx^{n-1} \xLeftrightarrow{} \frac{\mathrm{d}}{\mathrm{d}x}(x^n) = nx^{n-1}
```
```math
(nx)' = n \xLeftrightarrow{} \frac{\mathrm{d}}{\mathrm{d}x}(nx) = n
```
```math
(x)' = 1 \xLeftrightarrow{} \frac{\mathrm{d}}{\mathrm{d}x}(x) = 1
```
```math
(C)' = 0 \xLeftrightarrow{} \frac{\mathrm{d}}{\mathrm{d}x}(C) = 0
```
```math
(\sin(x))' = \cos(x)
```
```math
(a^x)' = a^x\ln{a-1}
```
```math
(\log{a^x})' = \frac{1}{x\ln{a}}
```
```math
(\ln{x})' = \frac{1}{x}
```

三角函数导数
```math
\frac{\mathrm{d}}{\mathrm{d}x}\sin(x) = \cos{x}
```
```math
\frac{\mathrm{d}}{\mathrm{d}x}\cos(x) = -\sin(x)
```
```math
\frac{\mathrm{d}}{\mathrm{d}x}\tan(x) = \sec^2(x)
```
```math
\frac{\mathrm{d}}{\mathrm{d}x}\sec(x) = \sec(x)\tan(x)
```
```math
\frac{\mathrm{d}}{\mathrm{d}x}\csc(x) = -\csc(x)\cot(x)
```
```math
\frac{\mathrm{d}}{\mathrm{d}x}\cot(x) = -\csc^2(x)
```
```math
\frac{\mathrm{d}^2}{\mathrm{d}x^2}(\sin(x)) = -\sin(x)
```
```math
\frac{\mathrm{d}}{\mathrm{d}x}(\sin(ax)) = a\cos(ax)
```

指数函数
```math
b^0 = 1
```
```math
b^1 = b
```
```math
b^xb^y = b^{x + y}
```
```math
\frac{b^x}{b^y} = b^{x - y}
```
```math
(b^x)^y = b^{xy}
```
对数函数
```math
\log_b(1) = 0
```
```math
\log_b(b) = 1
```
```math
\log_b(xy) = log_b(x) + log_b(y)
```
```math
\log_b(x/y) = log_b(x) - log_b(y)
```
```math
\log_b(x^y) = y\log_b(x)
```
换底法则($b>1$和$c>1$及任意的数$x>0$):
```math
\log_b(x) = \frac{\log_c(x)}{\log_c(b)}
```
对数函数求导
```math
\frac{\mathrm{d}}{\mathrm{d}x}\ln(x) = \frac{1}{x}
```
```math
\frac{\mathrm{d}}{\mathrm{d}x}\log_b(x) = \frac{1}{x\ln(b)}
```
```math
\frac{\mathrm{d}}{\mathrm{d}x}(b^x) = b^x\ln(b)
```
```math
\frac{\mathrm{d}}{\mathrm{d}x}\mathrm{e}^x = \mathrm{e}^x
```

求导公式
```math
(u+v)' = u' + v'
```
```math
(u-v)' = u' - v'
```

乘积法则(版本一):
```math
h(x) = f(x)g(x) \to h'(x) = f'(x)g(x) = f(x)g'(x)
```
乘积法则(版本二):
```math
(uv)' = u'v + v'u \xLeftrightarrow{} \frac{\mathrm{d}y}{\mathrm{d}x} = v\frac{\mathrm{d}u}{\mathrm{d}x} + u\frac{\mathrm{d}v}{\mathrm{d}x}
```
乘积法则(三乘法)
```math
(uvw)' = u'vw + uv'w + uvw' \xLeftrightarrow{} \frac{\mathrm{d}x}{\mathrm{d}x} = \frac{\mathrm{d}u}{\mathrm{d}x}uw + u\frac{\mathrm{d}v}{\mathrm{d}x}w + uv\frac{\mathrm{d}w}{\mathrm{d}x}
```

商法则(版本一):
```math
h(x) = \frac{f(x)}{g(x)} \to h'(x) = \frac{f'(x)g(x) - f(x)g'(x)}{(g(x))^2}
```
商法则(版本二):
```math
(\frac{u}{v})' = \frac{v'u - u'v}{v^2} \xLeftrightarrow{} \frac{\mathrm{d}y}{\mathrm{d}x} = \frac{v\frac{\mathrm{d}u}{\mathrm{d}x} - u\frac{\mathrm{d}v}{\mathrm{d}x}}{v^2}
```

扩展:
乘法法则的几何理解:
```math
\Delta(uv) = v\Delta u + u\Delta v
```
```math
(u + v + w)' = u' + v' + w'
```
```math
(xe^x\sin{x})' = e^x\sin{x} + xe^x\sin{x}+xe^x\cos{x}
```

链式求导法则(版本一):
```math
h(x) = f(g(x)) \to h'(x) = f'(g(x))g'(x)
```
链式求导法则(版本二):
如果 $y$ 是 $u$ 的函数, 并且 $u$ 是 $x$ 的函数, 那么
```math
\frac{\mathrm{d}y}{\mathrm{d}x} = \frac{\mathrm{d}y}{\mathrm{d}u}\frac{\mathrm{d}u}{\mathrm{d}x}
```

## 其它
二项式的 $n$ 次方展开:
```math
(a + b)^n = \mathbf{C}_n^0a^b = \mathbf{C}_n^1a^{n-1}b+\mathbf
{C}_n^2a^{n-2}b^2+\ldots+\mathbf{C}_n^nb^n
```
切线方程: 
```math
y - y_0 = m(x - x_0)
```
其中 $m$ 是斜率.

速度: 
```math
速度 = v = \frac{\mathrm{d}x}{\mathrm{d}t}
```

加速度: 
```math
加速度 = \frac{\mathrm{d}v}{\mathrm{d}t} = \frac{\mathrm{d}^2{x}}{\mathrm{d}t^2}
```

对于任意的 $x$, 有 $-1 \le \sin{x} \le 1$ 和 $-1 \le \cos{x} \le 1$