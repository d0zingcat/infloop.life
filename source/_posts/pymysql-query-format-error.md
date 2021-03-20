---
title: Pymysql查询中包含有%导致的查询错误
tags: []
date: 2021-03-20 21:48:10
---

好久没写技术文章了，说起来真是非常的惭愧。讲道理工作繁忙不应该成为一个理由，但是工作对生活和自己日常的学习造成挤压之后，确实会影响自己分享和折腾的心情。另外自己最近可能还是有一些其他的比较占用时间的事情，比如我最近比较迷经济（但其实也没有多么沉迷，甚至于也没有好好去系统地看资料），所以也会导致我不大想写博客。不管怎么说，从这一篇开始吧。
<!--more-->

## 问题

在airflow上面有一个告警任务，其实就是一个sql：
```sql
select acc.* from dap.ad_accounts acc where account_id in (select main.account_id
 from reports.report_third_facebook_day main  where main.begintime = 1616025600 group by main.account_id)
 and (acc.game_id is null or acc.region_id is null)
 and acc.account_name not like '%-sgame-%'
```
代码片是： 
```python
from db import engine
sql = "blahblah"
res = engine.execute(sql).fetchall()
if len(res) > 0:
    logger.info(f'res: {dict(res)}')
    raise Exception(f'')
```

而使用的db的engine其实就是sqlalchemy的engine，但是实际执行的时候会报错：

```
[2021-03-19 02:39:10,693] {pod_launcher.py:136} INFO -     res = engine.execute(sql).fetchall()
[2021-03-19 02:39:10,694] {pod_launcher.py:136} INFO -   File "/usr/local/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 2075, in execute
[2021-03-19 02:39:10,694] {pod_launcher.py:136} INFO -     return connection.execute(statement, *multiparams, **params)
[2021-03-19 02:39:10,694] {pod_launcher.py:136} INFO -   File "/usr/local/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 942, in execute
[2021-03-19 02:39:10,694] {pod_launcher.py:136} INFO -     return self._execute_text(object, multiparams, params)
[2021-03-19 02:39:10,694] {pod_launcher.py:136} INFO -   File "/usr/local/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 1104, in _execute_text
[2021-03-19 02:39:10,694] {pod_launcher.py:136} INFO -     statement, parameters
[2021-03-19 02:39:10,694] {pod_launcher.py:136} INFO -   File "/usr/local/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 1200, in _execute_context
[2021-03-19 02:39:10,694] {pod_launcher.py:136} INFO -     context)
[2021-03-19 02:39:10,694] {pod_launcher.py:136} INFO -   File "/usr/local/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 1416, in _handle_dbapi_exception
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -     util.reraise(*exc_info)
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -   File "/usr/local/lib/python3.7/site-packages/sqlalchemy/util/compat.py", line 249, in reraise
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -     raise value
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -   File "/usr/local/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 1193, in _execute_context
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -     context)
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -   File "/usr/local/lib/python3.7/site-packages/sqlalchemy/engine/default.py", line 509, in do_execute
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -     cursor.execute(statement, parameters)
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -   File "/usr/local/lib/python3.7/site-packages/pymysql/cursors.py", line 146, in execute
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -     query = self.mogrify(query, args)
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -   File "/usr/local/lib/python3.7/site-packages/pymysql/cursors.py", line 125, in mogrify
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO -     query = query % self._escape_args(args, conn)
[2021-03-19 02:39:10,695] {pod_launcher.py:136} INFO - TypeError: not enough arguments for format string
```
看起来是说没有足够的参数去做format，但是我很疑惑的是我并没有做任何format，那么这个format string是哪边来的呢？

		
## 排查

1. 因为这个功能的实现就是用sqlalchemy执行一句raw sql，如果查询结果大于1个表示有异常数据就进行告警，所以其实很快可以定位问题原因。我翻找了pymysql和sqlalchemy的源码，总算深刻的明白了这个问题的根源。因为一方面这个sql最后的like语句是我临时加了之后出现的问题，一方面错误堆栈已经提示了是query的问题，所以基本可以断定是`and acc.account_name not like '%-sgame-%'`这句话导致的问题。
2. 看起来pymysql使用了`query = query % self._escape_args(args, conn)`这样的写法，这样会导致query会当作python的string进行format，但是其实pymysql里面的设定是如果没有参数的话就需要args传None，但是很多框架里面比如django、sqlalchemy的args传进去是一个空的dict（可能是出于拓展性的考虑，因为他们用的是一个可变参数，底层就是一个默认dict），然后就会走到上面这句话的逻辑里面，然后如果query里面有`%`这个符号，就会导致问题。
3. 看起来是裸sql、且是无占位符的裸sql导致的问题，但是触发这个问题的是%。但是我的第一反应是，如果是%导致的，但是怎么可能？因为我的%后面跟的是`-`而不是`%s`（真是基础不牢地动山摇），找了半天的资料之后明白了过来，其实python的`%`作为string的format功能的话，是符合比如C中的`printf`的格式化规范的，比如%s就是chars、%f就是浮点数、%d就是整数，而前面是有填充标识的，比如%3d就表示是占用了3位的整数，%20s就是占用了20位的字符串，且都是右对齐的（因为比如空白长度是从左边开始填充的），那么如果想要左对齐呢？很简单，`%-20s`就行，空格会从右手边开始填充。所以基本是`%-s`，一样会被认为是格式化标志，不仅如此，准确来讲是，裸sql中只要有%就意味着转义和格式化。
4. 那么还有一个问题，为何错误提示是`缺少格式化的参数`而不是别的错误提示呢？其实一开始我的理解是如果写法是 `params = {1:1}; s= 'xxxx %-s123-'; s = s % params;`应该起到的作用是根据占位符去找dict里面的参数（奥天真如我，dict是无序的，且占位符是%s而不是参数名，如何能找到这样的参数呢），如果没找到就自动留空这样，但是当我实现之后我发现s会是这样子：`xxxx {1:1}123-`，奥我的老天。
5. 如果我手动填满两个参数呢？ `params = {1:1}, 1; s = "'%-sdsf-%'"; s = s % params;` 这样子的话执行起来就会提示`ValueError: unsupported format character ''' (0x27) at index 9`。为啥呢？因为`%'`并不是一个合法的格式化符号。

## 解决方案

1. 使用 %% 来替代%（使用%转义%）
2. 使用sqlalchemy的text函数，在raw sql外层套一层text就好（但是这种处理方式比较粗暴在一定的场景下可能会有意想不到的结果）
3. 使用sqlalchemy的占位符进行参数的处理，比如 `t = text("SELECT * FROM user where id=:user_id"); result = connection.execute(t, user_id=1)`。
4. 如果是pymysql原生的使用的话，其实可以使用 %s 这个参数的占位符。


# Refer
[Column Elements and Expressions](https://docs.sqlalchemy.org/en/13/core/sqlelement.html#column-elements-and-expressions)

[% (String Formatting Operator)](https://python-reference.readthedocs.io/en/latest/docs/str/formatting.html)

# Appendix
