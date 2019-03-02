+++
title = '把 app 加到 ubuntu 的 dash 目錄'
date = "2019-03-02T10:40:02+08:00"
url = "/posts/20190302-add-app-to-ubuntu-dash-home"
description = ""
image = "https://drive.google.com/uc?export=view&id=14kN9vjDOKr9W5d6e-1rgDEkNh6XtWRSa"
credit = ""
thumbnail = ""
comments = true
categories = ["作業系統"]
tags = ["小技巧", "ubuntu"]
toc = false
draft = false
+++

所謂的 dash 就有點像是在 windows 10 點擊「開始」出現的很多 app 的畫面。而在 ubuntu 中有些程式的安裝方式是從網路上下載壓縮檔後解壓縮，一般要啟動的話就需要先去打開那個資料夾再點擊，有點麻煩，所以就找了一個最簡單的方式將要用的程式加到 dash 中。

<!--more-->

測試系統：Ubuntu 18.04

首先安裝 `gnome-desktop-item-edit` 這個工具

```bash
$ sudo apt install --no-install-recommends gnome-panel
```

接著新增一個應用程式

```bash
$ sudo gnome-desktop-item-edit /usr/share/applications/ --create-new
```

出現一個小框框，填入名稱以及程式所在

![google- ](https://drive.google.com/open?id=1YFjaDpgQhBUacfdD38UnId97hAoPG1QL)

點 OK 後就會出現了，不需要重新登入或關機

![google- ](https://drive.google.com/open?id=1dRR1G6VrP2oid0S9QBvTvXVMeFHzGF8r)

圖標示預設的，若需要要修改就編輯一下檔案，注意檔名是剛剛取的名稱加上 .desktop 的副檔名

```bash
$ sudo vim /usr/share/applications/VisualVM.desktop
```

加上 icon 路徑

![google- ](https://drive.google.com/open?id=1rAWhlWkLTVIJ8JhS_o-o-gZW1grBVbQU)

儲存後就可以看到結果了

![google- ](https://drive.google.com/open?id=1P1k41x1OtC9bbsphoYVyNTBoA14xDTKf)
