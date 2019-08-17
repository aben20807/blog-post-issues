+++
title = "Valgrind 的 Memcheck"
date = "2019-08-17T11:17:09+08:00"
url = "/posts/20190817-valgrind-memcheck"
description = ""
image = "https://drive.google.com/uc?export=view&id=10pF-pr6yd5wJxlMfyaUHOrz-5v6iB1Ud"
credit = ""
thumbnail = ""
comments = true
categories = ["軟體工具"]
tags = ["valgrind", "profiling"]
toc = true
draft = true
+++
<!-- https://drive.google.com/uc?export=view&id=1_AbE-ZZwgjrCTgCi9ypGCVyYqWvxDO6f -->

簡單玩玩 @@

<!--more-->

# 前言

之前大學時期 (講得好像很久之前 OuO) 的某幾個作業我有拿來測試自己的程式碼是否有 memory leak 的情況，會發生這種情況主要原因是沒有對每一個 alloc 做 free。

# 環境

+ T490s
+ Ubuntu 18.04

# Valgrind 的 Memcheck

要一篇講完 Valgrind 基本上有點難，而且東西頗雜，我也是邊摸邊記錄，因為 Valgrind 有很多工具可以用，本篇主要講解預設的工具 __memcheck__，當然也只是部份的部份而已 QuQ。顧名思義是用來檢測記憶體使用情況，主要用在 C 及 C++。它是以插入額外程式碼 ([Instrumentation](https://en.wikipedia.org/wiki/Profiling_(computer_programming)#Instrumentation)) 的方式來記錄記憶體的使用，根據 wiki，memcheck 幾乎對所有指令的周圍都插入額外的檢測程式碼用來追蹤記憶體區塊的有效性 (validity)。原因是因為一開始未被分配的區塊都會是無效 (invalid) 或是未定義 (undefined)，當這些區快被初始化後，memcheck 仍繼續追蹤 V bits ([Valid-value bits](http://valgrind.org/docs/manual/mc-manual.html#mc-manual.value)) 及 A bits ([Valid-address bits](http://valgrind.org/docs/manual/mc-manual.html#mc-manual.vaddress))。此外，還實做了記憶體分配器 ([memory allocator](https://en.wikipedia.org/wiki/C_dynamic_memory_allocation))，也就是定義了 `malloc` 與 `free` 之類的函式來記錄呼叫次數。

總結來說，主要用來做以下項目檢測：

+ 使用位初始化的記憶體空間
+ 讀或寫一塊已經 `free` 過得區塊
+ 讀或寫超過一塊 `malloc` 取得合法的大小
+ 記憶體洩漏 ([Memory leaks](https://en.wikipedia.org/wiki/Memory_leak))

不過插入外程式碼是有代價的，就是效能會變低許多。

## 安裝

```bash
$ sudo apt install valgrind
```

## 使用

### 測試記憶體洩漏 (Memory leak detection)

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int *a = (int *) malloc(1024 * sizeof(int));
    printf("%p\n", a);
    // free(a);
    return 0;
}
```

### 編譯

`-g` 代表加入除錯資訊，可以讓 valgrind 指出在程式的那一行。
```bash
$ gcc -o test test.c -g
```

### 利用 valgrind 抓 memory leak

```bash
$ valgrind --leak-check=full --show-leak-kinds=all ./test
```
```txt
==18006== Memcheck, a memory error detector
==18006== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==18006== Using Valgrind-3.13.0 and LibVEX; rerun with -h for copyright info
==18006== Command: ./test
==18006== 
0x522d040
==18006== 
==18006== HEAP SUMMARY:
==18006==     in use at exit: 4,096 bytes in 1 blocks
==18006==   total heap usage: 2 allocs, 1 frees, 5,120 bytes allocated
==18006== 
==18006== 4,096 bytes in 1 blocks are definitely lost in loss record 1 of 1
==18006==    at 0x4C2FB0F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==18006==    by 0x10869B: main (test.c:5)
==18006== 
==18006== LEAK SUMMARY:
==18006==    definitely lost: 4,096 bytes in 1 blocks
==18006==    indirectly lost: 0 bytes in 0 blocks
==18006==      possibly lost: 0 bytes in 0 blocks
==18006==    still reachable: 0 bytes in 0 blocks
==18006==         suppressed: 0 bytes in 0 blocks
==18006== 
==18006== For counts of detected and suppressed errors, rerun with: -v
==18006== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 0 from 0)
```

## 分析

程式中我們 malloc 的一塊 1024 個整數大小 (4 bytes) 的記憶體空間，程式結束前沒有呼叫 free 因此產生的 memory leak 的現象。可以看到 valgrind 指出我們在程式第 5 行 `int *a = (int *) malloc(1024 * sizeof(int));` 分配了 4096 bytes 的記憶體。

此外這裡有一個有趣的現象，就是總共分配的大小是 5120 bytes，這是因為 `printf` 的關係，這個函式會固定使用 1024 bytes 的記憶體空間。所以 5120 = 4096 + 1024。

# 有顏色版本：colour-valgrind

## 安裝

```bash
$ pip3 install colour-valgrind # 需要 python
```

## 如果喜歡的話可以直接加在 `~/.bashrc`
```bash
alias valgrind='colour-valgrind'
```

## 使用

基本上就直接跟 valgrind 一樣

```bash
$ colour-valgrind --leak-check=full --show-leak-kinds=all ./test
```
![google-結果](https://drive.google.com/open?id=10pF-pr6yd5wJxlMfyaUHOrz-5v6iB1Ud)

# 參考資料
+ [Valgrind User Manual - 4. Memcheck: a memory error detector](http://valgrind.org/docs/manual/mc-manual.html)
+ https://en.wikipedia.org/wiki/Valgrind
