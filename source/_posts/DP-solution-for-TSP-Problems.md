---
title: DP solution for TSP Problems
date: 2018-11-16 21:00:16
tags:
---

> From [Wikipedia](https://en.wikipedia.org/wiki/Travelling_salesman_problem): The travelling salesman problem (TSP) asks the following question: "Given a list of cities and the distances between each pair of cities, what is the shortest possible route that visits each city and returns to the origin city?" It is an NP-hard problem in combinatorial optimization, important in operations research and theoretical computer science. 

Let's consider a variant of TSP problem such that we fix the first city and the last city of this travel and there in total $n+2$ cities. 

The naive brute force method to solve TSP problem has $O((n+1)!)$ time complexity and $O(n)$ extra space. In this post, we introduce an DP algorithm that works in $O(n^2 2^n)$ time complexity and $O(n 2^n)$ space complexity. There are also other methods like branch and bound method that we would not cover in this post.

# DP Space and recurrence
One reason the naive algorithm is inefficient is because it has saved a lot unnecessary ordering information of visited cities. As a improvement, our DP state space only care where is the current city and what cities have been visited. Consequently, the total state space is $n 2^n$. (If we take into consideration that the last city has to be choosed, this could be reduced to $n 2^{n-1}$, but it is inconvenient for our later implementation).

Our next step is to write the recurrence of DP. Clearly, we should get our current state by by coming from a previous city. Let's say we are at city $c_m$ and our current visited cities are $C=\{c_1, c_2,\ldots, c_{k-1}, c_k\}$, which is denoted by the tuple $(c_m, C)$. We could go from any previous state $(c_n\in C\setminus\{c_m\}, C\setminus\{c_m\})$ with an extra cost $d(c_m, c_n)$.


# Implementation
## Representation of Set of Cities
We use an 32-bit integer to represent the set of cities (less than 32). Existence of the $i$-th city corresponds to $i$-th bit of the integer. 

## Data Denpendency and DP update
It is obvious that one state only has dependency on other state with a smaller set of cities, which correspondes to a smaller integer in our representation. So we enumerate all set of travelled cities by ascending order of their integer i.e. $0,1,2,\ldots 2^n$.

## Code
```python3
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
