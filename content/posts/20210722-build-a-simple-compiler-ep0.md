+++
title = "Build a Simple Compiler Ep0"
date = "2021-07-22T17:17:52+08:00"
url = "/posts/20210722-build-a-simple-compiler-with-flex-bison-ep0"
description = ""
image = "https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80"
credit = "https://unsplash.com/photos/vrbZVyX2k4I"
thumbnail = ""
comments = true
categories = ["編譯器"]
tags = ["flex", "bison", "compiler", "lex", "yacc"]
toc = true
draft = true
+++
<!-- https://drive.google.com/uc?export=view&id= -->

<!--more-->

+ Series: [[ep0]]({{< ref "/posts/20210722-build-a-simple-compiler-ep0" >}}), [[ep1]]({{< ref "/posts/20210722-build-a-simple-compiler-ep1" >}}), [[ep2]]({{< ref "/posts/20210722-build-a-simple-compiler-ep2" >}}), [[ep3]]({{< ref "/posts/20210722-build-a-simple-compiler-ep3" >}})

# 前言

雖然好像很多相關資料了，但我覺得還是欠缺完整性，所以就寫了這個系列來補全。儘管還是有少數人無論如何都選擇直接抄襲同學這條路，但還是希望透過本系列能夠清楚完整的帶領完全沒概念的人走一遍，藉此降低這些行為。

本系列內容為使用 flex/bison (lex/yacc) 建構一個簡易的編譯器，並使其產生的 jasmin 指令可在 JVM 執行。

## 注意事項

## 環境

+ OS: Ubuntu 18.04 (我使用 WSL2)

## 軟體安裝

+ gcc: 7.5.0 (`gcc -v`)
+ gnu make: 4.1 (`make -v`)
+ flex: 2.6.4 (`flex --version`)
+ bison: 3.0.4 (`bison --version`)
+ java: openjdk 11.0.10 (`java --version`)
+ 安裝指令: `$ sudo apt install gcc make flex bison default-jre`

# 定義本次教學的語言

主要特性: 包含賦值、基本四則運算、輸出。

## 型別 type

+ 整數 (num_lit), e.g., `1`, `2`
+ 變數 (ident), e.g., `x`, `y`, `num`

## 運算子 operator

+ `+`: 加
+ `-`: 減
+ `*`: 乘
+ `/`: 除
+ `=`: 宣告時賦值

## 其他符號

+ `(` `)`: 運算有最高優先度
+ `\n` (newline): 換行作為結尾 

## 關鍵字 keyword

+ `decl`
+ `print`

## 簡化的文法 grammar

+ 未標示運算子優先順序，但是符合先乘除後加減，括號優先度最高。

```
Program -> Statement Program
        | null

Statement -> DeclStmt
          | PrintStmt

DeclStmt -> "decl" ident "=" Expression newline

PrintStmt -> "print" Expression newline

Expression -> Expression BinaryOp Expression
           | Operand
           
Operand -> num_lit
        | ident
        | "(" Expression ")"

BinaryOp -> "+" | "-" | "*" | "/"
```

## 範例輸入

```
decl x = 1 + 4
decl y = 2
decl num = x + y * (3 + 5)
print num
```

# Q&A

+ 為何作業沒有部份給分