---
title: DP solution for TSP Problems
date: 2018-11-16 21:00:16
tags:
mathjax: true
---

> From [Wikipedia](https://en.wikipedia.org/wiki/Travelling_salesman_problem): The travelling salesman problem (TSP) asks the following question: "Given a list of cities and the distances between each pair of cities, what is the shortest possible route that visits each city and returns to the origin city?" It is an NP-hard problem in combinatorial optimization, important in operations research and theoretical computer science. 

Let's consider a variant of TSP problem such that we fix the first city and the last city of this travel and there are $n+2$ cities in total.

The naive brute force method to solve TSP problem has $O((n+1)!)$ time complexity. In this post, we introduce a DP algorithm that works in $O(n^2 2^n)$ time complexity and $O(n 2^n)$ space complexity. There are also other methods like branch and bound method that we would not cover in this post.

# DP Space and Recurrence
One reason the naive algorithm is inefficient is that it has saved a lot of *unnecessary ordering information* of visited cities and there are actually overlapping between subproblems. Consider two incomplete paths `A B C` and `B A C`, they are actually equavalent because they have visited the same set of cities and have the same current city.

Our DP space intend to capture all intermediate states where some cities are visited but others are not. To eliminate the redundant information or ordering, our DP state space only care the __current city__ and __set of visited cities__. The current city has $n$ choices, and every city except current one could be visited or not. Consequently, the total state space by rule of product is
$$n 2^(n-1)$$
To make our later implementation easier, we ignoring that the current city must be visited and use a larger DP space of size $n 2^n$. These extra space however does not affect our result.

Our next step is to write the recurrence of DP. Clearly, we should go to our current state from a previous city. Let's say we are at city $c_m$ and we have visited cities $C=\{c_1, c_2,\ldots, c_{k-1}, c_k\}$. This state is denoted by the tuple $(c_m, C)$. To arrive at current city, we could go from any previous state
$$(c_n, C\setminus\{c_m\}),\quad c_n\in C\setminus\{c_m\}$$
with an extra cost $d(c_m, c_n)$.


# Implementation
## Representation of Set of Cities
We use a 32-bit integer to represent the set of cities (less than 32). Existence of the $i$-th city corresponds to $i$-th bit of the integer. 

## Data Dependency and DP updates
It is obvious that one state only has dependency on other state with a smaller set of cities, which corresponds to a smaller integer in our representation. So we enumerate all set of travelled cities by ascending order of their integer i.e. $0,1,2,\ldots 2^n-1$.

## Code
```py
inf = float('inf')
def highbit_range(n):
    for h in range(n):
        for i in range(1<<h, 1<<(h+1)):
            yield h, i

def last_two_bits(h, cur):
    l = [k for k in range(h) if (1<<k)&cur]
    if not l: return []
    l.append(h)
    return ((i, j) for i in l for j in l if i!=j)

def simple_tsp(s, e, M):
    n = len(M)
    dp = [[inf]*(2**n) for i in range(n)]
    for i in range(n):
        dp[i][1<<i] = s[i]
    for h, cur in highbit_range(n):
        for last, last2 in last_two_bits(h, cur):
            prev = cur^(1<<last)
            dp[last][cur] = min(dp[last2][prev]+M[last2][last], dp[last][cur])
    complete = (1<<n)-1
    return min(dp[last][complete]+e[last] for last in range(n))
```
