+++
title = 'Features'
date = "2019-02-06T09:37:31+08:00"
url = "/posts/features"
description = ""
image = ""
credit = ""
thumbnail = ""
comments = true
categories = ["Blog"]
tags = ["小技巧"]
draft = false
toc = true
skip = true
+++

記錄一下一些特性和使用方式
<!--more-->

# 標題 (heading)
```
# h1
## h2
### h3
#### h4 支援 emoji :smile:
##### h5 支援中文~
###### h6 
####### h7 最多只有到 6 級
```

# h1
## h2
### h3
#### h4 支援 emoji :smile:
##### h5 支援中文~
###### h6
####### h7 最多只有到 6 級

右邊會有浮動 TOC (table of contents)，可點擊！  
只會顯示 h1 ~ h3 過長會變成 ...
### test中文 1-12sdofjsojdfojasodjfosjofdsoifjaosjdofj

# Code section [ref](https://gohugo.io/content-management/syntax-highlighting/#highlighting-in-code-fences)

<pre>
```c {linenos=table,hl_lines=[2,"4-6"],linenostart=199}
#include <stdio.h>
int main()
{
    int a = 0;
    return a;
}
```
</pre>

```c {linenos=table,hl_lines=[2,"4-6"],linenostart=199}
#include <stdio.h>
int main()
{
    int a = 0;
    return a;
}
```

# 強調字型

可參考：https://www.markdownguide.org/basic-syntax/#emphasis

```
__粗體__  
**粗體**  
_斜體_  
*斜體*  
__*粗斜體*__
```

__粗體__  
**粗體**  
_斜體_  
*斜體*  
__*粗斜體*__

# 橫線

```
---
```

---

# 項目 (Bullet)
```
+ a
  + 1
  + 2
+ b
  1. OuO
  2. QuQ
```

+ a
  + 1
  + 2
+ b
  1. OuO
  2. QuQ

# 引用

```
> The more I learn, the more I realize how much I don't know.  
> --- Albert Einstein
```

> The more I learn, the more I realize how much I don't know.  
> --- Albert Einstein

# 插入圖片

目前並不打算直接上傳到 github，所以找了一些方式  
一般圖片
```markdown
![alt](https://drive.google.com/uc?export=view&id=1LipAb-4seXENzvyjSYbgtCqEQUfzGziC)
```
![alt](https://drive.google.com/uc?export=view&id=1LipAb-4seXENzvyjSYbgtCqEQUfzGziC)

這裡大部份會使用 google 雲端當作圖床  
不過從取得連結那裡會拿到：https://drive.google.com/open?id=1LipAb-4seXENzvyjSYbgtCqEQUfzGziC  
要改成上面的連結才行，所以我動了一些手腳，下面還會顯示標題說明，點擊即可在新分頁開啟可放大的圖片瀏覽器
```markdown
![google-title here](https://drive.google.com/open?id=1LipAb-4seXENzvyjSYbgtCqEQUfzGziC)
```
![google-title here](https://drive.google.com/open?id=1LipAb-4seXENzvyjSYbgtCqEQUfzGziC)

# YouTube
<pre>
{{&lt; youtube &quot;<span>https://www.youtube.com/watch?v=jC3jnC1dsAg</span>&quot; &gt;}}
</pre>
{{< youtube "https://www.youtube.com/watch?v=jC3jnC1dsAg" >}}

<pre>
{{&lt; youtube &quot;<span>https://www.youtube.com/watch?v=jC3jnC1dsAg?t=500</span>&quot; &gt;}}
</pre>
{{< youtube "https://www.youtube.com/watch?v=jC3jnC1dsAg?t=500" >}}


# Section [ref](https://codepen.io/DobsonDev/pen/GgRJwv)
<pre>
{{&lt; alert info >}}
**Beware !** is a text
{{&lt; /alert >}}

{{&lt; alert success >}}
**Beware !** is a text
{{&lt; /alert >}}

{{&lt; alert warning >}}
**Beware !** is a text
{{&lt; /alert >}}

{{&lt; alert danger >}}
**Beware !** is a text
{{&lt; /alert >}}
</pre>

{{< alert info >}}
**Beware !** is a text
{{< /alert >}}

{{< alert success >}}
**Beware !** is a text
{{< /alert >}}

{{< alert warning >}}
**Beware !** is a text
{{< /alert >}}

{{< alert danger >}}
**Beware !** is a text
{{< /alert >}}