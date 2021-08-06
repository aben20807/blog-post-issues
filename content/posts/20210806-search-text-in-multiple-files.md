+++
title = "使用 FileLocator 在資料夾中搜尋文件內容"
date = "2021-08-06T15:20:27+08:00"
url = "/posts/20210806-search-text-in-multiple-files"
description = ""
image = "https://lh3.googleusercontent.com/pw/AM-JKLVrBASd3V8HLIHeqrvn951PzqHkaT2Nxy2HUbNrmY_6L4IKCw3IeDoz5KLsYeTDwP0o7-RPpS6zvPRAkFafKuVD5cztcOOvXGgwpG9QzYSDIzo0LkbNgU0bwjd4rnGQ-eXIY0jtaRfx_P70FpC97Po3Wg=w1245-h870-no"
credit = ""
thumbnail = ""
comments = true
categories = ["軟體工具"]
tags = ["ppt", "pdf", "search"]
toc = false
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

知識實在不容易累積

<!--more-->

這其實是我個人覺得，不知道其他人感覺?

為何不容易累積?

最主要原因就是沒有一個好的管理系統來整理這些知識，而時間一久自然就逐漸忘記，自已最近就很常遇到明明就看過且解決過，但是臨時遇到相同問題時無法找到當時解決的方法，只好再重新來一遍，來來回回已經耗費許多時間。

因此我現在遇到問題時，在解決過程我就盡量把所有步驟都寫起來，但是不是很完整的整理，就僅是將使用到的參考網址、指令流程複製下來放到文件或報告投影片 (利用隱藏投影片)，這樣做法一來快速方便，二來與報告放在一起可以做最大化的連結效果。

然而，時間一久就會發現要在這些報告中搜尋內容不太容易，因為這些檔案大多不是純文字檔，例如: word、ppt，最暴力的方法就一個一個檔案開起來然後用 Ctrl-F 輸入關鍵字搜尋，真的不太方便。如果是純文字檔 (txt, md) 可以用 `ag` (silversearcher-ag [^ag]) 或是直接用 vscode 開啟資料夾來搜尋。

[^ag]: https://github.com/ggreer/the_silver_searcher

也是因為這樣我某些時段就會想把這些報告改成用 markdown，但是做投影片又離不開 ppt、google slide，所以後來才找到這個可以直接搜尋資料夾內所有檔案的方法。我所使用的是 FileLocator Lite [^li](雖然有 pro 的試用期，但是我選 Lite，不過不確定是否被迫強制試用，希望不要 QuQ)。

[^li]: https://www.mythicsoft.com/filelocatorlite/download/

這裡示範一下在資料夾中找出有提及 "memcheck" 的文件，可以限制文件的種類，但注意要用分號 `;` 隔開，目標資料夾也同理。比較可惜是搜尋字串不能用正規表達式。

![搜尋範例](https://lh3.googleusercontent.com/pw/AM-JKLVrBASd3V8HLIHeqrvn951PzqHkaT2Nxy2HUbNrmY_6L4IKCw3IeDoz5KLsYeTDwP0o7-RPpS6zvPRAkFafKuVD5cztcOOvXGgwpG9QzYSDIzo0LkbNgU0bwjd4rnGQ-eXIY0jtaRfx_P70FpC97Po3Wg=w1245-h870-no)

找出檔案後，我還是點開然後用 Ctrl-F 搜尋，不過比原先的 "遍歷搜尋法" 快多了。