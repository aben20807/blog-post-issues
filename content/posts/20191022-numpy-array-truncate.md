+++
title = "Numpy Array Truncate"
date = "2019-10-22T20:27:13+08:00"
url = "/posts/20191022-numpy-array-truncate"
description = ""
image = ""
credit = ""
thumbnail = ""
comments = true
categories = ["程式語言"]
tags = ["python", "numpy"]
toc = false
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->
踩個雷 OuO
<!--more-->

numpy 的 `trunc` [1] 好像沒有針對小數點以下幾位做設定，一次只能全砍變成整數，可是又不能用 `around` [2] 解決。

網路上有找到解法 [3]：很直覺，就是先乘大，truncate 後再除

```python
def trunc(values, decs=0):
    return np.trunc(values*10**decs)/(10**decs)
```

不過這有個問題，可以從以下程式觀察：

```python
import numpy as np

def trunc(a, decimals=0):
    return np.trunc(a*10**decimals)/(10**decimals)

arr = np.float32(np.array([1.123456789, 2.234567890, 3.45678901]))
print(arr)
print(arr.dtype)

arr_tr6 = trunc(arr, 6)
print(arr_tr6)
print(arr_tr6.dtype)

arr_tr20 = trunc(arr, 20)
print(arr_tr20)
print(arr_tr20.dtype)
```

輸出如下：
```txt
[1.1234568 2.2345679 3.456789 ]
float32
[1.123456 2.234567 3.456789]
float64
[1.1234568357467651 2.234567880630493 3.456789016723633]
object
```

不對啊，型別怎麼不一樣了 OAO

所以如果不想要型別被改動的話可能要在最後轉成原來的型別

```python
import numpy as np

def trunc(a, decimals=0):
    return (np.trunc(a*10**decimals)/(10**decimals)).astype(a.dtype)

arr = np.float32(np.array([1.123456789, 2.234567890, 3.45678901]))
print(arr)
print(arr.dtype)

arr_tr6 = trunc(arr, 6)
print(arr_tr6)
print(arr_tr6.dtype)

arr_tr20 = trunc(arr, 20)
print(arr_tr20)
print(arr_tr20.dtype)
```

輸出：(但是就有型別限制的最大儲存長度了)
```txt
[1.1234568 2.2345679 3.456789 ]
float32
[1.123456 2.234567 3.456789]
float32
[1.1234568 2.2345679 3.456789 ]
float32
```

完美 OuO

## References

+ [1] [numpy.trunc](https://docs.scipy.org/doc/numpy/reference/generated/numpy.trunc.html)
+ [2] [numpy.around](https://docs.scipy.org/doc/numpy/reference/generated/numpy.around.html)
+ [3] [Truncating decimal digits numpy array of floats](https://stackoverflow.com/a/46020635/6734174)
