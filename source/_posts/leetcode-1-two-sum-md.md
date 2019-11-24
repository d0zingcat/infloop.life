---
title: leetcode-1-two-sum
tags: ["leetcode", "solution"]
date: 2019-11-24 21:06:37
---

> 嗯，虽然以前就就在Leetcode上面刷过题，但是都没有坚持下去。这次准备重操旧业，希望能起码做到一天一道题吧。

首先是A+B问题，按理说是所有题目的开始。但是很遗憾的是我还是提交了三次才AC，感觉自己弱爆了。废话不多说，进入正题。

<!--more-->

```
1. Two Sum

Given an array of integers, return indices of the two numbers such that they add up to a specific target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

Example:

Given nums = [2, 7, 11, 15], target = 9,

Because nums[0] + nums[1] = 2 + 7 = 9,
return [0, 1].
```

题意很简单，就是给一个list，然后给定一个target，需要从list中找到两个数的和是target，然后输出这两个数的下标。需要注意的是每个元素只能用一次，另外输出的list中元素的顺序不影响结果。

我很快就完成了，但是第一版代码是错的，代码如：

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        m = dict()
        for i in range(len(nums)):
            if i not in m:
                m[nums[i]] = i
            if nums[i] in m and target-nums[i] in m:
                return [m[nums[i]], m[target - nums[i]]]
        return []
```

致命的问题在于如果test case是[3,2,1] 6，那么输出是 [0,0]，也就是说第一个元素用了两次，嗯，这么简单的边界都翻车。

然后很快又改好了，加了判断条件，代码如：

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        m = dict()
        for i in range(len(nums)):
            if nums[i] not in m:
                m[nums[i]] = i
            if nums[i] in m and target-nums[i] in m and m[nums[i]] != m[target - nums[i]]:
                return [m[nums[i]], m[target - nums[i]]]
        return []
```

然后又WA了。。。嗯，仔细分析了一下，发现test case是[3,3] 6的时候，输出是空。嗯，分支条件写错了。不应该判断两个数字都在字典里面，因为如果有两个相同的元素的话只有一个会加入到字典中。为了解决这个问题，嗯，直接换个写法就好，如：

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        m = dict()
        for i in range(len(nums)):
            if nums[i] not in m:
                m[nums[i]] = i
            if target-nums[i] in m and i != m[target - nums[i]]:
                return [i, m[target - nums[i]]]
```

嗯，总算AC了。我感觉每天一题的目标估计是要GG了。

稍微看了下题解和别人的代码，我发现这么写更加优雅：

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        m = dict()
        for i, n in enumerate(nums):
            if target-n in m:
                return [m[target - n], i]
            if n not in m:
                m[n] = i
```

# Refer

[1. Two Sum](https://leetcode.com/problems/two-sum/)

[1. Two Sum](https://leetcode.com/articles/two-sum/)
# Appendix
