+++
title = "Build a Simple Compiler Ep0"
date = "2021-07-22T17:17:52+08:00"
url = "/posts/20210722-build-a-simple-compiler-ep0"
description = ""
image = "https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80"
credit = "https://unsplash.com/photos/vrbZVyX2k4I"
thumbnail = ""
comments = true
categories = ["編譯器"]
tags = ["flex", "bison", "compiler", "lex", "yacc"]
toc = true
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

說明及事前準備

<!--more-->

+ Series: [[ep0]]({{< ref "/posts/20210722-build-a-simple-compiler-ep0" >}}), [[ep1]]({{< ref "/posts/20210722-build-a-simple-compiler-ep1" >}}), [[ep2]]({{< ref "/posts/20210722-build-a-simple-compiler-ep2" >}}), [[ep3]]({{< ref "/posts/20210722-build-a-simple-compiler-ep3" >}})
+ Source code: [aben20807/learn_compiler](https://github.com/aben20807/learn_compiler)

# 前言

雖然好像很多相關資料了，但我覺得還是欠缺完整性，所以就寫了這個系列來補全。儘管還是有少數人無論如何都選擇直接抄襲同學這條路，但還是希望透過本系列能夠清楚完整的帶領完全沒概念的人走一遍，藉此降低這些行為。

雖然我算是蠻常使用本系列所介紹的這套工具了，不過可能還是會有錯誤的地方，還請各位不吝指教。

# 本篇所建構的編譯器

本系列內容為使用 flex/bison (lex/yacc) 建構一個簡易的編譯器，並使其產生的 jasmin 指令可在 JVM 執行。完整執行流程如下。我們會利用 flex 產生 scanner，利用 bison 產生 parser。

![流程，橘色區塊為本系列需要寫程式的部分](https://lh3.googleusercontent.com/pw/AM-JKLVfavnVca_5BLSfCjR9c4-qX2B3aClIeT0xi-dKP7OA3I6YQ6wpE7Xpesp1-TiV7scUERknJm54uRRowNcFRd1vm7irZP_97aKpwDJMTSH8d5B0bcyF6whs077_llSwlHZyCey4jSwH4XqjpQ8O2vJ5pQ=w551-h281-no)

# 環境設定

## 作業系統

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

# Q&A (僅代表本人意見)

{{< summary "建議心理素質強健者再行觀看" >}}
+ **Q** 為何編譯系統~~目前~~為必修?
+ **A** 這需要回顧一下整個資訊工程的範疇，一般這個科系會有一些硬體課程以及多數的軟體課程 (包含數學、理論)，編譯系統是連接兩大領域的科學，因此在這堂課會用到幾乎所有在大學的所學 (例如，程式設計、資料結構、演算法、作業系統、計算理論)，雖然沒有到使用硬體指令 (否則會太難，想學可以參考 Jserv 的課)，不過可以說是整個大學的總整理。
+ **Q** 為何編譯系統這麼難?
+ **A** 其實課程部分一點也不難，每年超過100分的大概都有 20 個已經超過修課人數的一成，要不及格只可能是上課都沒在聽、考試沒複習、作業有問題都沒有問幾乎每次都沒交。如果是編譯器領域的話的確是難，但相對的會的人就少。
+ **Q** 為何作業沒有部份給分?
+ **A** 試想你之後出社會，老闆要你開發產品而你只能寫出屍體，連執行都不行，這樣你覺得老闆要給你多少薪水。你總不能跟他說我寫了哪些功能只是不能跑，所以應該要部份給薪吧。
{{< /summary >}}