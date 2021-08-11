+++
title = "Use VSCode to Write LaTeX Paper"
date = "2021-08-11T13:50:05+08:00"
url = "/posts/20210811-use-vscode-to-write-latex-paper"
description = ""
image = "https://images.unsplash.com/photo-1532153975070-2e9ab71f1b14?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80"
credit = "https://unsplash.com/photos/5cFwQ-WMcJU"
thumbnail = ""
comments = true
categories = ["軟體工具"]
tags = ["latex", "vscode", "miktex"]
toc = true
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

<!--more-->

# 前言

為了測完整的安裝流程，我用 virtualbox 裝了一個乾淨的 windows 10。記錄到可以編譯 latex 的最簡化流程就好，所以本篇的終端機使用的是 powershell 而不是 WSL。在 Ubuntu 理論上也可以套用這個方法，不過安裝的套件就不同，例如: MikTex 就要換成 Tex Live [^tlive]。

本篇範例使用 ACM 釋出的模板[^acm]，因此 IEEE 或是學校畢業論文的模板可能會有所不同。

因為圖太多了，所以使用 "示意圖" 按鈕來隱藏圖片，想參考時打開即可。

[^acm]: [ACM Primary Article Templates AND Publication Workflow](https://www.acm.org/publications/taps/word-template-workflow#h-2.-the-workflow-and-templates)

[^tlive]: [How to install LaTex on Ubuntu 18.04 Bionic Beaver Linux](https://linuxconfig.org/how-to-install-latex-on-ubuntu-18-04-bionic-beaver-linux)

## LaTeX Cheat sheet

+ [Getting to Grips with LaTeX](https://www.andy-roberts.net/writing/latex/formatting)
+ [List of LaTeX mathematical symbols](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols)
+ [Latex Tables Generator](https://www.tablesgenerator.com/latex_tables#)

# 安裝套件

安裝順序應該沒關係，本篇測試順序是 VSCode → MikTex → Perl。

## Perl

這裡直接安裝推薦的版本: [Strawberry Perl](https://strawberryperl.com/)，選 64-bit 版本。

{{< summary "示意圖" >}}
![Strawberry Perl](https://lh3.googleusercontent.com/pw/AM-JKLXs_PdqsqpM2mkMvhICdIe37zPtDQsvKfVtuWNfwjcUk2SnzbBnOkSrtPApkKZjIJonrr2POWGVmwTJLCj-BbRQA5z_ZakRrts1mL_9yUm4woKKtn6sO9ivljF58cjZaaZEaOmZ8-lhTREJW6uBRxV4BQ=w1600-h1200-no)
{{< /summary >}}

## MikTex

這個是 Latex 編譯器包，安裝網址: https://miktex.org/download。

安裝完後會跳出提醒來安裝所有更新。

{{< summary "示意圖" >}}
![安裝所有更新](https://lh3.googleusercontent.com/pw/AM-JKLUyFhHoqLOl0ud9GfH2YxuUAQGRPdyNVWIaO4NB9AhaxmKnLUdBhxyiW7750RNHiqIlYTj1IUAzfDFqPOy_XDyvvF3Lb4XW8hv5JOo2tm4L-UI6Q0tvlyaUe_G_SIobWkL8FLf_VFUHu70ZCP1kQE8aBQ=w1600-h1200-no)
{{< /summary >}}

打開 powershell 輸入 `latexmk.exe` 確認安裝正確。可能會先跳出一個視窗要安裝新套件，點選 install 即可。

{{< summary "示意圖" >}}
![powershell](https://lh3.googleusercontent.com/pw/AM-JKLV2gfq28ff0fnfv74PB_m6DHG-hl9a4wgEfxOdrQ2idrQoNu52LWlBXMjtmngSETOVxsKiHrFO4YI0npZ5UMw_FRvyMkzYdd3AIIa3oBGazrXP1hJqwL2PYAGh4tOV9SS-iUhMq5zZZu-N8ofNGYn0W6w=w1600-h1200-no)
{{< /summary >}}

## VSCode

建議安裝時打開 "以 Code 開啟" 的功能。

{{< summary "示意圖" >}}
![以 Code 開啟](https://lh3.googleusercontent.com/pw/AM-JKLXlBw7vOU2XUjDrJR7KfMSu416nevszajoo2n9NAHIKO58wgb7xrkPdbewM3lvoXGzCZTZXAx7cGxIdlEDYWqXAv4TcdkvhjOCFKXt-aA8jpgvXWcovW56py_GJD2jvhNkNCV4KcZEAJxBOeRPdmdwmqg=w1600-h1200-no)
{{< /summary >}}

### 外掛

理論上必要的只有 latex-workshop，其他的選用。

+ james-yu.latex-workshop
+ mhutchie.git-graph
+ coenraads.bracket-pair-colorizer
+ valentjn.vscode-ltex: 英文文法檢查，需要安裝 Java
+ vscode-icons-team.vscode-icons

{{< summary "示意圖" >}}
![vscode 外掛](https://lh3.googleusercontent.com/pw/AM-JKLUhazz8sW9uiCIu6fkCbTaBQXRJu2-a2Il_r6qWN_EjoWCqvqxHrP-DY_e7JQ8GITghx60BCYwzQ5eamEfv2ni1zbVps5rT2CV_y9CkRgEAuPwJCrZFv4j9g0VC7PO3IiAmeCo-gQyuNX04jEhRX76kIg=w1600-h1200-no)
{{< /summary >}}

### 針對 latex 文字顯示設定

使用 `Ctrl-Shift-P`，輸入 setting，打開 json 檔。可加入如下設定，這樣只會針對 latex 設定，而不會影響程式編輯。

```json
{
    "[latex]": {
        "editor.fontSize": 18,
        "editor.fontFamily": "'Georgia'",
        "editor.lineNumbers": "on",
        "editor.wordWrap": "bounded",
        "editor.letterSpacing": 0.1,
        "editor.lineHeight": 38,
        "editor.formatOnSave": false,
    },
}
```

{{< summary "示意圖" >}}
![setting.json](https://lh3.googleusercontent.com/pw/AM-JKLVyoAzzgE5xs4JLPpuXtcx8_CPKlIfKZmtu-an-S94W5TUdBtUJ_A904RSGZEK0G4JZMC9gD4C9GOO4tiZnXs-lU3qfuwiAcE303UhtyN7cunSkswmlUwiPsSLkrvnt1DribaWwWPFAFX_U-kP-I1sy8Q=w1600-h1200-no)
![latex setting](https://lh3.googleusercontent.com/pw/AM-JKLV1YqPWPVOaUPtlh4ZeC4j4SrbcJKeRRDDVnk9MT4627oJVYfFIxPVpmICFv8-EQg1lyCv76dN0cIA8HtSdbmyp6rgTQ6ESejTwpxXoiJSnY9oUqo0mwo43U-dS6U_quVyzinCgdVcj7yY7suNaXAL5HA=w1600-h1200-no)
{{< /summary >}}

# 範例

這裡直接使用 git 來拉範例 (使用 ACM 模板)，因此會需要用到 git，可直接安裝 [git for windows](https://gitforwindows.org/)，或直接上 github 下載也可以。

{{< summary "示意圖" >}}
![git for windows](https://lh3.googleusercontent.com/pw/AM-JKLVzP-_HMuTJhu1eGgAI1OJVBik9t1idYqKj9GdBjiBIuRgPaVohradkWO3RzPDmIpTVodYZ6_S2T9OJ64XYorCieaPqS3DCEmfw6LZkEPBEEbLyD3KRIWd_qeQmLjVYkMVCcbTqZakB5v29B8qR3ZMaCQ=w1600-h1200-no)
{{< /summary >}}

直接在 powershell 執行下面指令 (前方 `>` 不需要複製)，就會看到 vscode 打開範例資料夾。

```powershell
> git clone https://github.com/aben20807/paper-template.git
> code .\paper-template\
```

點開 paper.tex 檔案後，左方會出現 TEX 的圖示，點開後執行編譯的 recipe (最長那個)。這時候會跳出安裝套件的視窗。

{{< summary "示意圖" >}}
![編譯](https://lh3.googleusercontent.com/pw/AM-JKLWp9ZNMNj-yePUCWIj1AvQquVNlK6QYqXWTje1vL6U7JN8fC4OuqhFdhyIIgDlD4ydMI-x_Gvu2hqWEE49NDhQgIbmJoLqsM8VAkiz5Q5eaBCBCMSU-z1EX6KiJfcX-WomSZokxHHJNZhgnZrSUAE9kSg=w1600-h1200-no)
{{< /summary >}}

如果不想要一個一個點的話可以從開始選單中找 "MiKTex Console"，在 setting 中把自動安裝套件改成 Always。

{{< summary "示意圖" >}}
![MiKTex Console](https://lh3.googleusercontent.com/pw/AM-JKLXm4NBSLxHqiFM2ISIUKqJ-p8IFzCb9wQRMBwxU1VCrCUqRTNFpc8zwqWGonri1KFM0uQY7WNGgBMVwolb4dYcpMWBbFiSrjtOmaAKbM0ImvtpnmcpOoW8515RVAH9nRgZVWySfY0eBe_pzi16mM6mh0w=w1600-h1200-no)
{{< /summary >}}

最後就成功把範例編譯完成

![完成](https://lh3.googleusercontent.com/pw/AM-JKLVawO6vCeLTqrKvREekjNGd0G-Ogq9g4OBBtJlNmtsNcA_C75WBFS5qPZgrVK97JjQO05GU9HPMIrLMQpINWsLKDDczZayHama0igM0yuOJqkbp7GXE9Lz3IihhuCRfivOfhvtI6jpUfcXWmkcz60BJLg=w1600-h1200-no)

# 錯誤排除

+ 有時候 pdf viewer 在編譯後不會自動更新，這時候要先關閉那個分頁，再重新打開即可。
+ 編譯失敗時會出現打開錯誤訊息的視窗，或是可以直接開啟 LaTeX Compiler 的 Output，如上圖 (完成) 下方視窗所示。