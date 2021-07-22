+++
title = "How to Build a Simple Compiler With Flex Bison"
date = "2021-07-22T17:17:52+08:00"
url = "/posts/20210722-how-to-build-a-simple-compiler-with-flex-bison"
description = ""
image = ""
credit = ""
thumbnail = ""
comments = true
categories = ["編譯器"]
tags = ["flex", "bison", "compiler", "lex", "yacc"]
toc = true
draft = true
+++
<!-- https://drive.google.com/uc?export=view&id= -->

<!--more-->

# 前言

## 環境

## 軟體安裝

# 定義本次教學的語言

主要特性: 沒有變數，純粹數字與字串操作。

## 型別 type

+ 數字 (number_lit), e.g., `1`, `2`, `3.14`
+ 字串 (string_lit), e.g., `{OuO}`, `{Hello World}`

## 運算子 operator

+ `+`: 加、字串合併
+ `-`: 減
+ `*`: 乘

## 其他符號

+ `{` `}`: 當作字串
+ `(` `)`: 運算有最高優先度

## 關鍵字 keyword

+ `begin`
+ `end_and_print`

## 文法 grammar

```
Program -> Statement Program
        | null

Statement -> "begin" Expression "end_and_print"

Expression -> Expression BinaryOp Expression
           | Operand
           
Operand -> number_lit
        | string_lit
        | "(" Expression ")"

BinaryOp -> "+" | "-" | "*"
```

# 實作詞法分析器 (Scanner)

## 測試範例

# 實作語法剖析器 (Parser)

## 測試範例

# 實作程式碼產生 (Codegen)

# 完整執行範例