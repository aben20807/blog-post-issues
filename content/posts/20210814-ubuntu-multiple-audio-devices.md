+++
title = "Ubuntu Multiple Audio Devices"
date = "2021-08-14T15:08:12+08:00"
url = "/posts/20210814-ubuntu-multiple-audio-devices"
description = "Show how to output the sound to multiple audio devices at the same time in ubuntu"
image = "https://images.unsplash.com/photo-1535406208535-1429839cfd13?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1655&q=80"
credit = "https://unsplash.com/photos/sdtnZ4LgbWk"
thumbnail = ""
comments = true
categories = ["軟體工具"]
tags = ["ubuntu", "paprefs", "pulseaudio", "audio"]
toc = false
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

聲音同時輸出多個裝置 (藍芽、喇叭、螢幕)

<!--more-->

# 前言

假日用電腦看電影，找不到 win10 可以設定同時多個音訊輸出 (網路提供的都不能用)。所以就看看 Ubuntu 可不可以，結果只需要安裝 paprefs 這個套件就好，也太簡單了吧 :+1:

# 使用 paprefs

```bash
$ sudo apt install paprefs # 安裝
$ paprefs # 開啟設定視窗
```

選擇 Simultaneous Output 頁面，並勾選如下圖

![virtual output device](https://lh3.googleusercontent.com/pw/AM-JKLV-ZBr1zarhENeHCexK-1txjCCnWoW16_nWJrJxFUCq3g4aSuAbNjyNa4BvtgbsqvITH4FkCYHadg9nm0ctVw6xdijpSHL363TYp3GC5_QU4pQ0N9DRa_XLsDsLp2REkckaXh1IApGrL0fFKSO8kBKZyg=w757-h339-no)

```bash
$ pulseaudio -k # 重新整理音訊卡
```

接著就會出現一個新的輸出卡如下圖，選擇這個就會在所有裝置輸出聲音了，個別聲音的音量在個別去設定，或是關閉螢幕聲音即可。

![音效輸出卡](https://lh3.googleusercontent.com/pw/AM-JKLVmz3mgDsg5iz7CVmmL2qDpR_QwR4u6u2nRCP-X4GVkBesON9AFMESBPVEapnZ4n3hGTjyKWOSrvy6IVlgzfCoAxi2r3cZsqLnR9rEerj5OzLZfV1xnYSdSP0cE9CHGxbbJNQx3tdujqm498DmMDlp9zg=w1291-h713-no)

# 回復

取消勾選後執行 `pulseaudio -k` 即可。

# 結語

> 大哥沒有輸 QuQ

# References

+ [Play sound through two or more outputs/devices](https://askubuntu.com/a/78179)