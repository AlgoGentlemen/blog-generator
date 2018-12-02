---
title: 试谈一下Onepass算法
mathjax: true
date: 2018-12-01 14:58:22
tags: Onepass, dynamic programming
---

### 所谓Onepass算法

对于这个名字大家可能很奇怪，什么是onepass算法？其实这是一类算法问题的简称，这种算法的根本目的是在O(N)的时间内解决问题，即，**solve the problem in one pass**. 

本人对于Onepass的理解还不够深刻，所以今天仅仅是试着借助一些例子去试着谈一谈这一类有趣的算法问题。



### Onepass的核心

Onepass的核心是dp，dp的核心在于caching，在算法的进程中不断地更新储存的信息，我们叫“状态”，去结合下一时刻所遇到的信息以及更新后的状态去得到下一时刻状态——最终得到终态。而Onepass又是dp的特例，我们一般仅用O(N)或者O(1)的space去解决问题。同时，一些复杂dp的过程中可能会去追溯之前某些特定时刻的状态，但是对于onepass来说，一般只追溯之前一个时刻的状态，是一个非常轻便又巧妙的算法。

空口无凭，我们先借一个小例子去认识一下onepass算法。



<!--more-->



### 引子

#### LC84

> Given *n* non-negative integers representing the histogram's bar height where the width of each bar is 1, find the area of largest rectangle in the histogram.

![LC84](./_images/Onepass/LC84.png)

这一道题代表一系列的题目，算法的核心在于构建一个stack，在每一个时刻都保持stack是一个我们想要的状态。对于这一题来说，我们想要这个stack里保持递增，这样遇到下一个比`stack[-1]`要小的值，我们可以依次pop出`stack`内比它大的值，来对pop出的单元格进行计算。

在这一题中，我们对于每一个pop出来的值，它会与自己**右边**的值组成一个长方形，此时的**右边**是指隐形的右边，是指可能已经被pop出去的所有单元格，而它是目前为止这一时刻所有pop出去单元格的最小值，所以由它的值来决定公共矩形区域的高。

需要注意的是，stack里面每一个值都可能是有隐形的左右单元格，所以当我们想要找到这一时刻的矩形宽度，我们需要找到目前的index以及pop出去之后`stack[-1]`的差值-1。一个小技巧是可以在首尾各pad一个0，这样使得所有的单元格都能在一个循环内得到处理。

总结：

stack中存储的是过去所有的可用信息（递增单元格），与当前的单元格高度信息结合，如果当前单元格高于stack[-1]，那么可能还会有面积更大的矩形，放入stack中。如果当前单元格低于stack[-1]，那么在这一时刻进行计算，计算目前为止的最大矩形，同时更新stack。

```python
def largestRectangleArea(self, heights):
    heights = [0] + heights + [0]
    stack = []
    _max = area = 0

    for i, height in enumerate(heights):
        while stack and heights[stack[-1]] > height:
            temp = stack.pop()
            area = (i - stack[-1] - 1) * heights[temp]
            _max = max(_max, area)
    	stack.append(i)

    return _max
```



#### LC862

> Return the **length** of the shortest, non-empty, contiguous subarray of `A` with sum at least `K`.
>
> If there is no non-empty subarray with sum at least `K`, return `-1`.

该题其实需要一个用`presum`做预处理的过程，把subarray的和问题转化成两点之间的差值问题。如果题意改为`subarray with sum equals to K`，那么其实就是一个`two sum`的问题。但是题意是要求是一个大于`K`的范围，那么显然是一个dp的问题。

本题该怎么样用Onepass来做呢，首先我们要考虑的是，我们需要存储的状态是什么？显然，是到目前为止`有意义`的起始点，那么一旦`当前值`减去`起始点`的值大于`K`，那么就是一个符合要求的`subarray`，我们只需要找到每个这样的subarray然后计算长度即可。

那么什么样的起始点是有意义的呢？很容易可以想到，假设当前起始点的值是`x`，如果遇到下一个值`大于x`，不影响之后subarray的结果。但是如果遇到一个值`小于x`，假设为`x-1`那么我们可以理解为，`x-1`比`x`距离符合要求更近，这时候x就不再是一个潜在的可能结果，因为即便之后出现了`x+k`这样的值，由于`x-1`距离`x+k`比`x`距离`x+k`更近，所以x永远不可能是一个最小值。因此我们需要更新起始点，使得我们存储的值是递增的。

什么样的数据结构符合要求呢，显然是deque，不断pop右边使得该deque递增，遇到合格的值就popleft找到合格的subarray长度。

```python
def shortestSubarray(self, A, K):
    N = len(A)
    P = [0]
    for x in A:
        P.append(P[-1] + x)
        ans = N + 1
        state = collections.deque() 
        for i, num in enumerate(P):
            while state and num <= P[state[-1]]:
                state.pop()
            while state and num - P[state[0]] >= K:
                ans = min(ans, i - state.popleft())

            state.append(i)

    return ans if ans < N + 1 else -1
```















