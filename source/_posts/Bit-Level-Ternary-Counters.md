---
title: Bit Level Counters
date: 2018-11-15 20:51:06
tags:
---
> TODO: Add explainations and reasoning for bitwise operations

+ Related problem: https://leetcode.com/problems/single-number-ii

# Basic Analysis
For every bit, we could count the number of ones to determine that bit of the single number. Clearly, there is no need to employ correlations between bits. So we could simply generalize the counting method to anything that has a binary representation. As several bits (in our case, 2 bits) is enough to capture the useful information, we only needs 2*32 bits (in this case) to store the counters. Consequently, two 32-bit integers has provided enough space for our problem.

There are many ways to represent the 32 counters:

1. We could store 16 counters in one integer and the rest in the other integer. To make it simple, we choose one to count odd bits and the other to count even bits. 
1. We could store lower bits in one number and higher bits in the other number. This method could better take advantage of bitwise operations, as it has bit to bit correspondence between numbers and low/high counters.

## Two bits groups: count even and odd bits
This method needs shift operations to align high bits and low bits. Which is not a worry for method 2.
```c
unsigned odd32=0x55555555;
unsigned ternary_add32(unsigned S, unsigned a){
    int lo = ~(S>>1) & (S^a) & odd32;
    int hi = (S^(S>>1)) & ~(S^a) & odd32;
    return (hi<<1)|lo;
}

unsigned single_number(unsigned *A, int length){
    unsigned odd=0, even=0;
    for (int i=0; i<length; i++){
        odd = ternary_add32(S1, A[i]);
        even = ternary_add32(S2, A[i]>>1);
    }
    return (even<<1)|odd;
}
```

## Bitwise counter: high bits and low bits of counters
```c
int single_number(int A[], int length) {
    int low = 0, high = 0;
    for(int i = 0; i < length; i++){
        low = (low ^ A[i]) & ~high;
        high = (high ^ A[i]) & ~low;
    }
    return low;
}
```

