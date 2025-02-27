# 线性方程组的解
## 解线性方程组的矩阵消元法
左端都是未知量 $x_1,x_2,x_3,x_4,x_5$ 的一次齐次式, 右端是常数, 这样的方程组成为**线性方程组**. 每个未知量前面的数称为系数.

含 n 个未知量的线性方程组成为 **n 元线性方程组**, 它的一般形式是:
$$
\left\{\begin{align*}
    a_{11}x_1+a_{12}+\cdots+a_{1n}x_n&=b_1 \\
    a_{21}x_1+a_{22}+\cdots+a_{2n}x_n&=b_1 \\
    \cdots \\
    a_{n1}x_1+a_{n2}+\cdots+a_{nn}x_n&=b_1 \\
\end{align*}\right.
$$
其中 $a_{11},a_{12},\cdots,a_{nn}$ 是系数, $b_{1},b_{2},\cdots,b_{n}$ 是常数项, 常数项一般写在等号右边.

**定义 1** 由 $s\cdot m$ 个数排成 $s$ 行, $m$ 列的一张表称为一个 $s\times m$矩阵, 其中每一个数称为这个矩阵的**一个元素**, 第 $i$ 行与第 $j$ 列交叉位置的元素称为矩阵的 **$(i,j)$ 元**. 元素全为0的矩阵称为**零矩阵**, 简记作: $0$, $s$ 行 $m$ 列的零矩阵可以记作 $0_{s\times m}$

矩阵的三种初等行变换:
1. 把一行的倍数加到另一行上
2. 互换两行的位置
3. 用一个非零数乘某一行

阶梯形矩阵的特点:
1. 元素全为0的行(称为**零行**)在下方(如果有零行的话)
2. 元素不全为0的行(称为**非零行**), 从左边起第一个不为0的元素(称为**主元**), 它们的列指标随着行指标的递增而严格增大.

简化阶梯形矩阵的特点:
1. 它是阶梯形矩阵
2. 每个非零行的主元都是1
3. 每个主元所在的列的其余元素都是0

**定理 1** 任意一个矩阵都可以经过一系列初等行变换化成阶梯形矩阵.

**推论 1** 任意一个矩阵都可以经过一系列初等行变换化成简化行阶梯形矩阵.

## 线性方程组的解的情况及其判别准则
**定理 1** 系数为有理数(或实数, 或复数)的 n 元线性方程组的解的情况有三种可能:
* **无解**: 把 n 元线性方程组的增广矩阵经过初等行变换化成阶梯形矩阵, 如果相应的阶梯形方程组出现 $0=d$ (其中 $d$ 是非零数) 这种方程, 那么原方程无解
* **有唯一解**: 如果阶梯形矩阵的非零行数目 r 等于未知量数目 n, 那么原方程组有唯一解
* **有无穷多个解**: 如果 $r<n$ 那么原方程组有无穷多个解

如果一个线性方程组有解, 那么称它是**相容**的, 否则,称它是**不相容**的.

常数项全为0的线性方程组称为**齐次线性方程组**. $(0,0,\cdots,0)$ 是齐次线性方程组的一个解, 称为**零解**. 其余的解称为**非零解**. 如果一个齐次线性方程组有非零解, 那么它有无穷多个解. 

**推论 1** n 元齐次线性方程组有非零解的充分必要条件是: 它的系数矩阵经过初等行变换化成的阶梯形矩阵中, 非零行的数目 $r<n$.

**推论 2** n 元齐次线性方程组如果方程的数目 s 小于未知量的数目 n, 那么它一定有非零解.

## 数域
**定义 1** 复数集的一个子集 $K$ 如果满足:
1. $0,1 \in K$
2. $a,b \in K \Rightarrow a\plusmn,ab\in K, \\ a,b \in K, 且 b\neq 0 \Rightarrow \frac{a}{b} \in K$

那么, 称 $K$ 是一个数域.

常见的数域:
* 有理数集: $\mathbb{Q}$
* 实数集: $\mathbb{R}$
* 复数集: $\mathbb{C}$

但整数集 $\mathbb{Z}$ 不是数域, 因为 $\mathbb{Z}$ 对于除法不封闭.

**命题 1** 任意数域都包含有理数域

# 行列式
二阶行列式:
$$
\begin{vmatrix}
    a_{11} && a_{12} \\
    a_{21} && a_{22}
\end{vmatrix}=a_{11}a_{22}-a_{12}a_{21}
$$

**命题 1** 两个方程的二元一次方程组有唯一解的充分必要条件是: 它的系数矩阵 $A$ 的行列式(简称为**系数行列式**) $\begin{vmatrix} A \end{vmatrix}\neq 0$, 此时它的唯一解是:
$$
\begin{bmatrix}
    \frac{
        \begin{vmatrix}
            b_1 && a_{12} \\
            b_2 && a_{22}
        \end{vmatrix}
    }{
        \begin{vmatrix}
            a_{11} && a_{12} \\
            a_{21} && a_{22}
        \end{vmatrix}
    }, \frac{
        \begin{vmatrix}
            a_{11} && b_1 \\
            a_{21} && b_2
        \end{vmatrix}
    }{
        \begin{vmatrix}
            a_{11} && a_{12} \\
            a_{21} && a_{22}
        \end{vmatrix}
    }
\end{bmatrix}
$$

## n 元排列
n 个不同的自然数的一个全排列称为一个 **n 元排列**

在 n 元排列 $a_1a_2,\cdots,a_n$ 中, 任取一对数 $a_ia_j$ (其中 $i<j$), 如果 $a_i < a_j$ , 那么称这一对数构成一个**顺序**; 如果 $a_i > a_j$ , 那么称这一对数构成一个**逆序**. 一个 n 元排列中逆序的总数成为**逆序数**, 记作 $\tau(a_1a_2\cdots a_n)$

逆序数为奇数的排列成为**奇排列**, 逆序数为偶数的排列成为**偶排列**.

**定理 1** 对换改变 n 元排列的奇偶性.

**定理 2** 任一 n 元排列与排列 $123\cdots n$ 可以经过一系列对换互变, 并且所对换的次数与这个 n 元排列有相同的奇偶性.

## n 阶行列式的定义
2阶行列式:
$$
\begin{vmatrix}
    a_{11} && a_{12} \\
    a_{21} && a_{22}
\end{vmatrix}=a_{11}a_{22}-a_{12}a_{21}
$$
结合逆序数可写成:
$$
\begin{vmatrix}
    a_{11} && a_{12} \\
    a_{21} && a_{22}
\end{vmatrix}=\sum_{j_1j_2}(-1)^{\tau(j_1j_2)}a_{1j_1}a_{2j_2}
$$

**定义 1** n 阶行列式:
$$
\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    a_{21} && a_{22} && \cdots && a_{2n} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}=\sum_{j_1j_2\cdots j_n}(-1)^{\tau(j_1j_2\cdots j_n)}a_{1j_1}a_{2j_2}\cdots a_{nj_n}
$$
其中 $j_1j_2\cdots j_n$ 是 n 元排列, $\displaystyle\sum_{j_1j_2\cdots j_n}$ 表示对所有 n 元排列求和. 上式称为 n 阶行列式的**完全展开式**.

令
$$
\mathbf{A}=\begin{bmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    a_{21} && a_{22} && \cdots && a_{2n} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{bmatrix}
$$
则上面的 n 阶行列式也称为 n 级矩阵 $\mathbf{A}$ 的行列式, 简记作 $|\mathbf{A}|$ 或者 $\det \mathbf{A}$

主对角线下方的元素全为0的 n 阶行列式称为**上三角行列式**, 即
$$
\begin{vmatrix}
    a_{11} && a_{12} && a_{13} && \cdots && a_{1,n-2} && a_{1,n-1} && a_{1n} \\
    0 && a_{22} && a_{23} && \cdots && a_{2,n-2} && a_{2,n-1} && a_{2n} \\
    0 && 0 && a_{33} && \cdots && a_{3,n-1} && a_{3,n-1} && a_{3n} \\
    \vdots && \vdots && \vdots && && \vdots && \vdots && \vdots \\
    0 && 0 && 0 && \cdots && 0 && a_{n-1,n-1} && a_{n-1,n} \\
    0 && 0 && 0 && \cdots && 0 && 0 && a_{nn}
\end{vmatrix}
$$
上三角行列式的值为:
$$
(-1)^{\tau(12\codts n)}a_{11}a_{22}\cdots a_{n-1,n-2}a_{nn}=a_{11}a_{22}\cdots a_{n-1,n-1}a_{nn}
$$

**命题 1** n 阶上三角行列式的值等于它主对角线上 n 个元素的乘积.

## 行列式的性质
**性质 1** 行列互换, 行列式的值不变. 即:
$$
\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    a_{21} && a_{22} && \cdots && a_{2n} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}=\begin{vmatrix}
    a_{11} && a_{21} && \cdots && a_{n1} \\
    a_{12} && a_{22} && \cdots && a_{n2} \\
    \vdots && \vdots && && \vdots \\
    a_{1n} && a_{2n} && \cdots && a_{nn}
\end{vmatrix}
$$
证明:
$$
右边=\sum_{i_1i_2\cdots i_n}(-1)^{\tau(i_1i_2\cdots i_n)}a_{1i_j}a_{2i_2}\cdots a_{ni_n}
$$
$$
左边=\sum_{i_1i_2\cdots i_n}(-1)^{\tau(i_1i_2\cdots i_n)}a_{1i_j}a_{2i_2}\cdots a_{ni_n}
$$

**性质 2** 行列式一行的公因子可以提出去. 即
$$
\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    ka_{i1} && ka_{i2} && \cdots && ka_{in} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}=k\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    a_{i1} && a_{i2} && \cdots && a_{in} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}
$$
证明:
$$
\begin{align*}
左边 &= \sum_{j_1j_2\cdots j_n}(-1)^{\tau(j_1j_2\cdots j_n)}a_{1j_1}a_{2j_2}\cdots(ka_{ij_i})\cdots a_{nj_n} \\
&= k\sum_{j_1j_2\cdots j_n}(-1)^{\tau(j_1j_2\cdots j_n)}a_{1j_1}a_{2j_2}\cdots a_{nj_n} \\
&= 右边
\end{align*}
$$

**性质 3** 行列式中若有某一行是两组数的和, 则此行列式等于两个行列式的和, 这两个行列式的这一行分别是第一组数和第二组数, 而其余各行与原来行列式的各行相同. 即
$$
\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    b_1+c_1 && b_2+c_2 && \cdots && b_n+c_n \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}=\\\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    b_1 && b_2 && \cdots && b_n \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}+\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    c_1 && c_2 && \cdots && c_n \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}
$$
证明:
$$
\begin{align*}
左边 &= \sum_{j_1j_2\cdots j_n}(-1)^{\tau(j_1j_2\cdots j_n)}a_{1j_1}a_{2j_2}\cdots(b_{j_i}+c_{j_i})\cdots a_{nj_n} \\
&= \sum_{j_1j_2\cdots j_n}(-1)^{\tau(j_1j_2\cdots j_n)}a_{1j_1}a_{2j_2}\cdots b_{j_i}\cdots a_{nj_n} + \sum_{j_1j_2\cdots j_n}(-1)^{\tau(j_1j_2\cdots j_n)}a_{1j_1}a_{2j_2}\cdots c_{j_i}\cdots a_{nj_n}\\
&= 右边
\end{align*}
$$

**性质 4** 两行互换, 行列式反号. 即
$$
\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    a_{i1} && a_{i2} && \cdots && a_{in} \\
    \vdots && \vdots && && \vdots \\
    a_{k1} && a_{k2} && \cdots && a_{kn} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}=-\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    a_{k1} && a_{k2} && \cdots && a_{kn} \\
    \vdots && \vdots && && \vdots \\
    a_{i1} && a_{i2} && \cdots && a_{in} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}
$$

证明:
$$
\begin{align*}
右边 &= -\sum_{j_1\cdots j_i\cdots j_k\cdots j_n}(-1)^{\tau(j_1\cdots j_i\cdots j_k\cdots j_n)}a_{1j_1}\cdots a_{kj_i}\cdots a_{ij_k}\cdots a_{nj_n} \\
&=-\sum_{j_1\cdots j_k\cdots j_i\cdots j_n}(-1)(-1)^{\tau(j_1\cdots j_k\cdots j_i\cdots j_n)}a_{1j_1}\cdots a_{ij_k}\cdots a_{kj_i}\cdots a_{nj_n} \\
&= \sum_{j_1\cdots j_k\cdots j_i\cdots j_n}(-1)^{\tau(j_1\cdots j_k\cdots j_i\cdots j_n)}a_{1j_1}\cdots a_{ij_k}\cdots a_{kj_i}\cdots a_{nj_n} \\
&= 左边
\end{align*}
$$

**性质 5** 两行相同, 行列式的值为0. 即
$$
\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    a_{i1} && a_{i2} && \cdots && a_{in} \\
    \vdots && \vdots && && \vdots \\
    a_{i1} && a_{i2} && \cdots && a_{in} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}=0
$$

**性质 6** 两行成比例, 行列式的值为0. 即
$$
\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    a_{i1} && a_{i2} && \cdots && a_{in} \\
    \vdots && \vdots && && \vdots \\
    la_{i1} && la_{i2} && \cdots && la_{in} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}=0
$$

**性质 7** 把一行的倍数加到陵一行上, 行列式的值不变. 即
$$
\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    a_{i1} && a_{i2} && \cdots && a_{in} \\
    \vdots && \vdots && && \vdots \\
    a_{k1}+la_{i1} && a_{k2}+la_{i2} && \cdots && a_{kn}+la_{in} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}=\begin{vmatrix}
    a_{11} && a_{12} && \cdots && a_{1n} \\
    \vdots && \vdots && && \vdots \\
    a_{i1} && a_{i2} && \cdots && a_{in} \\
    \vdots && \vdots && && \vdots \\
    a_{k1} && a_{k2} && \cdots && a_{kn} \\
    \vdots && \vdots && && \vdots \\
    a_{n1} && a_{n2} && \cdots && a_{nn}
\end{vmatrix}
$$

## 行列式按一行(列)展开
三阶行列式展开为二阶行列式:
$$
\begin{align*}
|\mathbf{A}| &= \begin{vmatrix}
    a_{11} && a_{12} && a_{13} \\
    a_{21} && a_{22} && a_{23} \\
    a_{31} && a_{32} && a_{33}
\end{vmatrix} \\
&= (a_{11}a_{22}a_{33}-a_{11}a_{23}a_{32})+(a_{12}a_{23}a_{33}-a_{12}a_{21}a_{33})+(a_{13}a_{21}a_{32}-a_{13}a_{22}a_{31}) \\
&= a_{11}\begin{vmatrix}
    a_{22} && a_{23} \\
    a_{32} && a_{33}
\end{vmatrix}-a_{12}\begin{vmatrix}
    a_{21} && a_{23} \\
    a_{31} && a_{33}
\end{vmatrix}+a_{13}\begin{vmatrix}
    a_{21} && a_{22} \\
    a_{31} && a_{32}
\end{vmatrix}
\end{align*}
$$

**定义 1** n 阶行列式 $|\mathbf{A}|$ 中, 划去第 i 行和第 j 列, 剩下的元素按照原来的次序组成的行列式成为矩阵 $\mathbf{A}$ 的 $(i,j)$ 元的**余子式**, 记作 $\mathbf{M}_{ij}$. 令
$$
\mathbf{A}_{ij}=(-1)^{i+j}\mathbf{M}_{ij}
$$
则, 三阶行列式的展开可写成:
$$
|\mathbf{A}|=a_{11}\mathbf{A}_{11}+a_{12}\mathbf{A}_{12}+a_{13}\mathbf{A}_{13}
$$

**定理 1** n 阶行列式 $|\mathbf{A}|$ 等于它的第 i 行元素与自己的代数余子式的乘积之和. 即
$$
\begin{align*}
    |\mathbf{A}| &= a_{i1}\mathbf{A}_{i1}+a_{i2}\mathbf{A}_{i2}+\cdots+a_{in}\mathbf{A}_{in} \\
    &= \sum_{j=1}^n a_{ij}\mathbf{A}_{ij}
\end{align*}
$$

**定理 2** n 阶行列式 $|\mathbf{A}|$ 等于它的第 j 列元素与自己的代数余子式的乘积之和. 即
$$
|\mathbf{A}|=|\mathbf{A'}|=a_{1j}\mathbf{A}_{1j}+a_{2j}\mathbf{A}_{2j}+\cdots+a_{nj}\mathbf{A}_{nj}
$$

**定理 3** n 阶行列式 $|\mathbf{A}|$ 第 i 行元素与第 k 行($k\neq i$)相应的元素的代数余子式的乘积之和为0, 即:
$$
a_{i1}\mathbf{A}_{k1}+a_{i2}\mathbf{A}_{k2}+\cdots+a_{in}\mathbf{A}_{kn}\ ,\  当\ k\neq i
$$

**定理 4** n 阶行列式 $|\mathbf{A}|$ 的第 j 列元素与第 l 列($l\neq j$) 的相应元素的代数余子式的乘积之和为0, 即:
$$
a_{1j}\mathbf{A}_{1l}+a_{2j}\mathbf{A}_{2l}+\cdots+a_{nj}\mathbf{A}_{nl}\ ,\  当\ l\neq j
$$

n 阶范德蒙行列式($n>2)的值为:
$$
\begin{vmatrix}
    1 && 1 && 1 && \cdots && 1 \\
    a_1 && a_2 && a_3 && \cdots && a_n \\
    a_1^2 && a_2^2 && a_3^2 && \cdots && a_n^2 \\
    \vdots && \vdots && \vdots && && \vdots \\
    a_1^{n-2} && a_2^{n-2} && a_3^{n-2} && \cdots && a_n^{n-2} \\
    a_1^{n-1} && a_2^{n-1} && a_3^{n-1} && \cdots && a_n^{n-1}
\end{vmatrix}=\prod_{1\le j<\le i\le n}(a_i-a_j)
$$

## 克莱姆(Cramer)法则
对于数域 K 上 n 个方程的 n 元线性方程组, 如何判断有没有解, 有多少解? 方程组:
$$
\left\{\begin{align*}
    a_{11}x_1+a_{12}+\cdots+a_{1n}x_n&=b_1 \\
    a_{21}x_1+a_{22}+\cdots+a_{2n}x_n&=b_1 \\
    \cdots \\
    a_{n1}x_1+a_{n2}+\cdots+a_{nn}x_n&=b_1 \\
\end{align*}\right.
$$
令
$$
\mathbf{J}=\begin{bmatrix}
    c_{11} && c_{12} && \cdots && c_{1n} \\
    0 && c_{22} && \cdots && c_{2n} \\
    \vdots && \vdots && && \vdots \\
    0 && 0 && \cdots && c_{nn}
\end{bmatrix}
$$

其中 $c_{11}c_{22},\cdots c_{nn}$ 全不为 0. 从而
$$
|\mathbf{J}|=c_{11}c_{22}\cdots c_{nn}\neq 0
$$
上述表明: 原线性方程组无解或有无穷多个解时, $|\mathbf{J}|=0$, 有唯一解时 $|\mathbf{J}|\neq 0$. 由此得出:
* 原线性方程组有唯一解当且仅当: $|\mathbf{J}|\neq 0$
* $|\mathbf{J}|=l|\mathbf{A}|$  
其中 l 是某个非零数. 因此 $|\mathbf{J}|\neq 0$ 当且仅当 $|\mathbf{A}| \neq 0$. 

**定理 1** 数域 K 上 n 个方程的 n 元线性方程组有唯一解的充分必要条件是它的系数行列式(即系数矩阵 $\mathbf{A}$ 的行列式 $|\mathbf{A}|$) 不等于 0. 如果 $\displaystyle\mathbf{A} \xrightarrow{初等行变换} \mathbf{J}$ 那么 $|\mathbf{J}|=l|\mathbf{A}|$, 其中 l 是某个非零数.

**推论 1** 数域 K 上 n 个方程的 n 元线性方程组只有零解的充分必要条件是它的系数行列式不等于 0. 从而它有非零解的充分必要条件是它的系数行列式等于 0.

两个方程的二元一次方程组有唯一解时, 它的解为: $\displaystyle\left(\frac{|\mathbf{B}_1|}{|\mathbf{A}|}, \frac{|\mathbf{B}_2|}{\mathbf{A}}\right)$, 其中 $B_1,B_2$分别是把系数矩阵 A 的第 1, 2 列换成常数项得到的矩阵. 由此启发: n 个方程的 n 元线性方程组的系数矩阵 A 的第 j 列换成常数项, 得到的矩阵记作 $\mathbf{B}_j, j=1,2,\cdots,n$, 即
$$
\mathbf{B}_j=\begin{bmatrix}
    a_{11} && \cdots && a_{1,j-1} && b_1 && a_{1,j+1} && \cdots && a_{1n} \\
    a_{21} && \cdots && a_{2,j-1} && b_1 && a_{2,j+1} && \cdots && a_{2n} \\
    \vdots && && \vdots && \vdots && \vdots && && \vdots \\
    a_{n1} && \cdots && a_{n,j-1} && b_n && a_{n,j+1} && \cdots && a_{nn} \\
\end{bmatrix}
$$

**定理 2** n 个方程的 n 元线性方程组的系数行列式 $|\mathbf{A}|\neq 0$ 时, 它的唯一解是:
$$
\left(\frac{|\mathbf{B}_1|}{|\mathbf{A}|}, \frac{|\mathbf{B}_2|}{\mathbf{A}},\cdots,\frac{|\mathbf{B}_n|}{\mathbf{A}}\right)
$$

**定理 1** 和 **定理 2** 合起来称为**克莱姆(Cramer)法则**

## 行列式按 k 行(列) 展开
**定义 1** n 阶行列式 $|\mathbf{A}|$ 中任意取定 k 行, k 列 ($1 \le k \lt n), 位于这些行列的交叉处的 $k^2$ 个元素按照原来的排法组成的 k 阶行列式, 称 $|\mathbf{A}|$ 的一个 **k 阶子式**. 取定 $|\mathbf{A}|$ 的第 $i_1,i_2,\cdots,i_k$ 行 ($i_1<i_2<\cdots<i_k$), 第 $j_1,j_2,\cdots,j_k$ 列 ($j_1<j_2<\cdots<j_k$), 所得到的 k 阶子式记作:
$$
\mathbf{A}\begin{pmatrix}
    i_1,i_2,\cdots,i_k \\
    j_1,j_2,\cdots,j_k
\end{pmatrix}
$$
划去这个 k 阶子式所在的行和列, 剩下的元素按照原来的排法组成的 $(n-k)$ 阶行列式称为上述子式的余子式, 它前面乘以
$$
(-1)^{(i_1+i_2+\cdots+i_k)+(j_1+j_2+\cdots+j_k)}
$$
则称为上述子式的代数余子式.

**定理 1(Laplace定理)** 在 n 阶行列式 $|\mathbf{A}|$ 中, 取定第 $i_1,i_2,\cdots,i_k$ 行 ($i_1<i_2<\cdots<i_k$), 则这 k 行元素所形成的所有 k 阶子式与他们自己的代数余子式的乘积之和等于 $|\mathbf{A}|$, 即:
$$
|\mathbf{A}|=\sum_{1\le j_1<j_2<\cdots<j_k\le n}\mathbf{A}\begin{pmatrix}
    i_1,i_2,\cdots,i_k \\
    j_1,j_2,\cdots,j_k
\end{pmatrix}(-1)^{(i_1+i_2+\cdots+i_k)+(j_1+j_2+\cdots+j_k)}\begin{pmatrix}
    i_1',i_2',\cdots,i_k' \\
    j_1',j_2',\cdots,j_k'
\end{pmatrix}
$$