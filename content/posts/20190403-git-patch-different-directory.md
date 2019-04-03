+++
title = "不同路徑之 Git Patch"
date = "2019-04-03T16:50:28+08:00"
url = "/posts/20190403-git-patch-different-directory"
description = ""
image = "https://drive.google.com/uc?export=view&id=1oerWXAO9-X5k8wb1ixdAmnaqgCFFAizP"
credit = ""
thumbnail = ""
comments = true
categories = ["軟體工具"]
tags = ["git"]
toc = false
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

最近也算常用 git，不過有些特殊的功能都沒用過，這次也不算是學學看，而是真的要用到了，總之就是還個技術債順便記錄。不過會用到這個情境的應該算是少數。

<!--more-->

# tl;dr

```bash
$ git format-patch --relative <SHA> ./ -o /tmp/patches
$ git am /tmp/patches/*.patch
```

# 前言

git 有一個好用的工具可以針對 repo 上面的 commit 產生補丁檔 (patch)。詳細用法可以去查看官方說明文件 [git format-patch](https://git-scm.com/docs/git-format-patch)。

這裡主要記錄一個使用情境：要把專案A 下的子專案a 的修改記錄做成 patch 給專案B 使用，注意，專案a 與專案B 是同一個專案。

會有這樣需求主要是因為 B 是開源專案，然後我們拿來修改後變成 A 的子專案。當然最好的方式是用 fork，然後利用 submodule 管理，不過因為只有一個 repo 可以使用，所以就採用這個作法。

限制：內部檔案名稱要相同

# 範例檔案架構

接下來利用簡單的範例來模擬。

`repo A`:
```bash
A
├── a
│   └── file_1.txt
└── sth_in_A.txt

* a257187 - (HEAD -> master) Add sth in A
* a1f4b9e - init
```

`repo B`:
```bash
B
└── file_1.txt

* 63998ea - (HEAD -> master) init
```

接著進行一些修改 (記得用 git 去追蹤修改記錄)

我們測試一些不同的行為，可以從下方 commit message 看出，同時修改(`eb948ee`)也可以喔

大概像是這樣
```bash
A
├── a
│   ├── file_1.txt
│   └── file_2.txt
└── sth_in_A.txt

* 0f5c75e - (HEAD -> master) Add file_2 in a
* eb948ee - Modify file_1 and sth_in_A.txt
* 26bde10 - Modify sth_in_A.txt
* b551578 - Modify file_1
* a257187 - Add sth in A
* a1f4b9e - init
```

# 產生 patch

開始產生 patch 囉，首先 `cd` 到子資料夾，接著打入下方指令，`a1f4b9e` 是起始 commit，如果這個子專案是從中間才開始追蹤的話也可以從中間的 commit 開始。可以看到它只會針對 a 中有修改的部份才產生 patch 檔。`-o` 是指定輸出的路徑，完全可以依照自己喜好修改。

```bash
$ cd A/a/
$ git format-patch --relative a1f4b9e ./ -o /tmp/patches
/tmp/patches/0001-Modify-file_1.patch
/tmp/patches/0002-Modify-file_1-and-sth_in_A.txt.patch
/tmp/patches/0003-Add-file_2-in-a.patch
```

# 套用 patch

套用 patch 到專案B

```bach
$ cd B/
$ git am /tmp/patches/*.patch
Applying: Modify file_1
Applying: Modify file_1 and sth_in_A.txt
Applying: Add file_2 in a
```

最後可以看到它把所有的 commit 都一一重現

```bash
B
├── file_1.txt
└── file_2.txt

* e28e672 - (HEAD -> master) Add file_2 in a
* 24d4693 - Modify file_1 and sth_in_A.txt
* 96d0b8c - Modify file_1
* 63998ea - init
```
