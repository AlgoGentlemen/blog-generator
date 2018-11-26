---
title: EM算法与Word Alignment
date: 2018-11-16 00:15:49
tags: 
    - ML
    - NLP
mathjax: true
---

# EM算法

## 概述

已有一个对随机变量的观测（Observation）$X$，我们想求出模型参数$\theta$。我们假设X的分布不仅受$\theta$影响，而且还受一个隐变量$Z$影响（$Z$也由$\theta$决定）。

所以似然函数（likelihood）可以写为
\begin{align*}
L(\theta) &= \log P(X\mid \theta) = \log \sum_Z P(X,Z\mid \theta) \\
          &= \log (\sum_Z P(X\mid Z,\theta)P(Z\mid \theta))
\end{align*}

## 算法输入

+ 观测量 $X$
+ 隐变量 $Z$
+ 联合分布 $p(X,Z\mid \theta)$
+ 条件分布 $p(Z\mid X, \theta)$

## 算法输出

参数$\theta = \arg\max_\theta L(\theta)$
<!--more-->

## Procedure

Note: $\theta_i$ is the value of i-th iteration's parameter $\theta$.

1. Select an initial $\theta_0$
2. (i+1)-th **E** step: compute $$ \begin{align} Q(\theta,\theta_i) &= E_Z[\ln p(X,Z\mid \theta)|X,\theta_i] \\ &= \sum_Z \ln p(X,Z\mid \theta) p(Z\mid X,\theta_i) \end{align}$$
3. (i+1)-th **M** step: compute $\theta_{i+1} = \underset{\theta}{\text{argmax}} Q(\theta, \theta_i)$
4. repeat 2 and 3 until convergence

# Intuition behind EM

$$
\begin{align}
\ln p(X\mid \theta) &= \sum_Z q(Z) \cdot \ln \dfrac{p(X,Z\mid \theta)}{p(Z\mid X,\theta)} \\
&= \sum_Z q(Z) \cdot \ln p(X,Z\mid \theta) - \sum_Z q(Z) \cdot \ln p(Z\mid X,\theta) \\
&= \sum_Z q(Z) \cdot \ln \dfrac{p(X,Z\mid \theta)}{q(Z)} - \sum_Z q(Z) \cdot \ln \dfrac{p(Z\mid X,\theta)}{q(Z)} \\
&= \mathcal{L}(q,\theta) + KL(q \| p)
\end{align}
$$

$KL(q\|p)\ge 0$ always holds. We fix KL-divergence and maximize $\mathcal{L}$.

Let $KL(q\|p) = 0$ so we have $q(Z)=p(Z\mid X,\theta)$.

If we subsitute $q(Z)=p(Z\mid X,\theta)$ into $\mathcal{L}$, $\mathcal{L}(q,\theta) = Q(\theta, \theta^{old}) + constant$.
