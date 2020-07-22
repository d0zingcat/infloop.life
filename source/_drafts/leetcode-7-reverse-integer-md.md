---
title: leetcode-7-reverse-integer.md
tags: ["leetcode", "solution"]
date: 2019-11-26 20:56:46
---

	7. Reverse Integer
	Given a 32-bit signed integer, reverse digits of an integer.
	Example 1:
	
	Input: 123
	Output: 321
	Example 2:
	
	Input: -123
	Output: -321
	Example 3:
	
	Input: 120
	Output: 21
	
	Note:
	Assume we are dealing with an environment which could only store integers within the 32-bit signed integer range: [−231,  231 − 1]. For the purpose of this problem, assume that your function returns 0 when the reversed integer overflows.

<!--more-->

题意很简单，就是数字反转，例如123-\>321。解法也比较简单，就是每次取除10的模数（然后除10取整），原数乘10累加。例如123就是1+10*((0+3)*10+2)=321。需要注意有两个点，一个是可能数字是120000，那么就不能简单地通过字符串反转来做（算数方法做是没问题的）；另一个就是有边界，边界是4字节的有符号整型数字的范围，也就是 $$[-2^{-31}, 2^{31}-1]$$。

我的做法比较粗暴，判断还有一位的时候用边界去减了除10，和当前数比较大小即可（其实这么做有问题，如果test case长度不是2的31次方位，比如100位的数字，那也会最后一步才会判断是否溢出，对于python这种科学计算型语言不会有问题，因为底层已经处理了大数运算。对于C、Java等传统语言，这么写就会有问题。当然，也可以上来就手动判一下数字长度，如果大于10就直接返回0，不过我没写。），也没想到居然这么写过了，代码如：

```python
class Solution:
    def reverse(self, x: int) -> int:
        n = 0
        flag = 1
        if x < 0:
            flag = -1
            x = -x
        while x > 0:
            if x < 10:
                if flag == 1 and n > ((1<<31)-1-x)/10 or flag == -1 and n > ((1<<31)-1)/10:
                    return 0
            n = n * 10 + x % 10
            x = x // 10
        return flag * n
```



然后就是参考题解了。发现有两个地方可以改进代码。一个其实不用一开始就把负数转换为正数，因为带符号数累加之后符号还是在的；还有一个是判断条件可以做修改为判断为当前数是不是大于MAXINT/10，因为如果大于的话那么下一次x10就必然溢出；如果等于那么判断尾数是不是大于等于8（正数时）、小于等于-9（负数时）。










# Refer

[7. Reverse Integer](https://leetcode.com/problems/reverse-integer/)

[7. Reverse Integer](https://leetcode.com/articles/reverse-integer/)

# Appendix