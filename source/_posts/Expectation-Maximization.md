---
title: Expectation Maximization
date: 2018-11-16 00:15:49
tags: AI
mathjax: true
---

# Objective

Maximize the likelihood $$p(X\mid \theta) = \sum_Z p(X,Z\mid \theta)$$

# EM Algorithm

**Input**
Observation **X**
Latent variable **Z**
Joint distribution $p(X,Z\mid \theta)$
Conditional distribution $p(Z\mid X, \theta)$

**Output**
Parameter $\theta$

**Procedure**
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