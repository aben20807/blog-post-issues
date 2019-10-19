+++
title = "資料整理"
date = "2019-10-19T11:20:13+08:00"
url = "/posts/20191019-data-statistic"
description = ""
image = "https://drive.google.com/uc?export=view&id=1NnbVE8x3tW3BDpNNNdohXiyM4jyVIgPs"
credit = ""
thumbnail = ""
comments = true
categories = ["軟體工具"]
tags = ["spreadsheet", "awk", "paste"]
toc = false
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id=1NnbVE8x3tW3BDpNNNdohXiyM4jyVIgPs -->

剛好用到一些蠻有用的工具，記錄一下

<!--more-->

資料：一個檔案 13 個數字共有 10,000 個檔案。  
目的：視覺化平均後的 13 欄資料  
主要分作以下步驟：  

1. 合併 10,000 筆資料到一個檔案方便複製
2. 用 Google Spreadsheet 來平均並製作圖表

## 1. 合併

檔案架構大致如下

```bash
├── mae_0000.txt
├── mae_0001.txt
├── mae_0002.txt
├── mae_0003.txt
├── mae_0004.txt
├── mae_0005.txt
├── mae_0006.txt
├── mae_0007.txt
├── mae_0008.txt
├── mae_0009.txt
├── mae_0010.txt
├── mae_0011.txt
├── mae_0012.txt
.
.
.
└── mae_9999.txt
```

所以首先我們需要合併，這裡介紹一個頗好用的指令 `paste`。 `paste` 可以將資料水平合併，例如：(左邊行號，右邊內容)

```bash
$ cat a.txt b.txt c.txt 
───────┬──────────────────────────────────────────
       │ File: a.txt
───────┼──────────────────────────────────────────
   1   │ 1
   2   │ 2
   3   │ 3
   4   │ 4
───────┴──────────────────────────────────────────
───────┬──────────────────────────────────────────
       │ File: b.txt
───────┼──────────────────────────────────────────
   1   │ 5
   2   │ 6
   3   │ 7
   4   │ 8
───────┴──────────────────────────────────────────
───────┬──────────────────────────────────────────
       │ File: c.txt
───────┼──────────────────────────────────────────
   1   │ 9
   2   │ 10
   3   │ 11
   4   │ 12
───────┴──────────────────────────────────────────

```

```bash
$ paste *.txt > all.txt
$ cat all.txt 
───────┬──────────────────────────────────────────
       │ File: all.txt
───────┼──────────────────────────────────────────
   1   │ 1   5   9
   2   │ 2   6   10
   3   │ 3   7   11
   4   │ 4   8   12
───────┴──────────────────────────────────────────
```

所以我們一樣可以用 `paste *.txt > all.txt` 來把 10,000 資料都整理到同一個檔案，

此時如果出現 `Too many open files` 的錯誤，可以使用以下指令來增加同時可開啟的檔案數

```bash
$ ulimit -Hn 10240 # The hard limit
$ ulimit -Sn 10240 # The soft limit
```

成功變成一個檔案後發現它的 column 太多了 Spreadsheet 無法直接貼上，所以接下來要轉置一下。

這裡我們使用 awk 來幫忙，新增一個 `transpose.sh` 的檔案，內容如下：

```bash
#!/usr/bin/env bash
awk '
{
    for (i=1; i<=NF; i++)  {
        a[NR,i] = $i
    }
}
NF>p { p = NF }
END {
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=NR; i++){
            str=str" "a[i,j];
        }
        print str
    }
}' $1
```

變更一下執行權限，就可以執行了

```bash
$ chmod +x transpose.sh 
$ ./transpose.sh all.txt > all_tr.txt
```

這樣資料就會從原本的往右長變成往下長

![google-轉置前](https://drive.google.com/open?id=1dZ7u6raak9lUQiPR5DKxUTRjQJWPTPFZ)
![google-轉置後](https://drive.google.com/open?id=1_vu6Is-UDZqvWJodUJjdVlmbGokwct5O)

## 使用 Google Spreadsheep

這裡可能比較沒啥，就是貼上去，這裡我覺得不要用 vim 開啟，找個方便複製的 (例如：VSCode)

用 Ctrl-v 貼上 Spreadsheet 時可能會花一點時間

不過發現它把所有的 column 合在一起了

![google- ](https://drive.google.com/open?id=1jluF0VN_pDaifwAjVaJVsklIb5j3w7nN)

我們選取第一個 column 然後點上方的 "資料" > "將文字分隔成不同欄"

![google- ](https://drive.google.com/open?id=1daksDj4iW6FCgvoTi9pxrQks7RYxBd4c)

它會自動將第一個 column 分出來，這時後會冒出一個小視窗 (有點不明顯，有時候要滾動一下才會出現)，把下拉式選單點開選擇 "空格" 這樣它就會把所有 column 分開了。

![google- ](https://drive.google.com/open?id=13wfpf9aTKIqahEW-WUjAWkTAH-zwLlAf)
![google- ](https://drive.google.com/open?id=1sUbYYqab7gdhWDDSFX0eJUxujb7_zfPn)
![google- ](https://drive.google.com/open?id=1NnbVE8x3tW3BDpNNNdohXiyM4jyVIgPs)

平均跟圖表部份就按照一般試算表的使用方式，就不記錄了。

## 參考

+ [An efficient way to transpose a file in Bash](https://stackoverflow.com/a/1729980/6734174)
+ [Combining large amount of files](https://unix.stackexchange.com/a/205646)
