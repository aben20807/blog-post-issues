+++
title = "Emacs 安裝 rainbow-delimiters 插件"
date = "2019-03-07T20:23:24+08:00"
url = "/posts/20190307-emacs-install-rainbow-delimiters"
description = ""
image = "https://drive.google.com/uc?export=view&id=1Z2vwPs46qPbQTEnrqXEiniGTavMqA0hB"
credit = ""
thumbnail = ""
comments = true
categories = ["編輯器"]
tags = ["emacs"]
toc = true
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

恩....身為一個 vimer，我還是想試試看 emacs，所以就選了系上的一堂教 lisp 的課。  
本篇記錄一下安裝插件的過程  
(雖然我這篇還是用 vim 打的....

<!--more-->

這個插件的名稱是 `rainbow-delimiters`，顧名思義就是讓對應的括號有相同的顏色，這在一堆括號的語言 lisp 中可以對初學者較為友善。

# emacs 安裝

emacs 的安裝方式就還是提一下，不然我應該記不起來@@
```bash
$ sudo add-apt-repository ppa:ubuntu-elisp/ppa
$ sudo apt-get update
$ sudo apt-get install emacs-snapshot emacs-snapshot-el
```

# 超基本按鍵

我是超新手，所以只暫時記錄最重要的@@

+ `ctrl-x ctrl-s`：儲存
+ `ctrl-x ctrl-c`：離開

# 新增設定檔

首先需要新增一個設定檔，就像 vim 中的 `.vimrc` 一樣，而為了方便管理我使用 `~/.emacs.d/init.el`，我們就直接用 emacs 編輯吧～  

Note. `-nw` 可以用非 GUI 的方式開啟 emacs

```bash
$ mkdir ~/.emacs.d/
$ emacs -nw ~/.emacs.d/init.el
```

# 支援 [MELPA](https://melpa.org/#/) 插件庫

打開之後貼上

```lisp
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired                                         
  (add-to-list 'package-archives (cons"melpa"(concat proto"://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons"melpa-stable"(concat proto"://stable.melpa.org/packages/")) t)                            
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib                                                                           
    (add-to-list 'package-archives'("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
```

# 新增 `rainbow-delimiters` 插件

退出 (上面有記錄怎麼儲存跟離開) 後重新開啟 emacs

```bash
$ emacs -nw
```

按下 `alt-x` 後輸入 `package-list-packages` 接著按下 `Enter`
![google- ](https://drive.google.com/open?id=1tcS1Yxs-I0J1Nf63528PVypU7LmrhDhG)

會發現出現一個各種插件的頁面。

搜尋方式請按 `ctrl-s` 後輸入 `rainbow-delimiters` 接著 `Enter`  即可找到
![google- ](https://drive.google.com/open?id=1lQa5BBsjLRQxUheS41WTRi1maN1AtA90)

在那一行按下 `i` 會發現最前方多了一個 `I`

Note. 要取消請按 `u`
![google- ](https://drive.google.com/open?id=1DuzQMOTEc4MO4HByxDhKCpVu30fr3FvV)

選完後按下 `x` 就可以安裝了

結果最後還需要加東西到 `~/emacs.d/init.el`

```lisp
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
```

改完之後會發現有很淺的變色了

# 自訂顏色

結果就如封面所示。

```lisp
(custom-set-variables
 '(package-selected-packages '(rainbow-delimiters)))
(custom-set-faces
 '(rainbow-delimiters-depth-1-face ((t (:foreground "dark orange"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "deep pink"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "chartreuse"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "orchid"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "spring green"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "sienna1"))))
)
```

# 參考資料

+ [Emacs 入坑引導 - 打造自己的 Ruby IDE - Part 1](https://5xruby.tw/posts/emacs-part1/)
+ [RainbowDelimiters](https://www.emacswiki.org/emacs/RainbowDelimiters)
+ [Better Emacs Rainbow Delimiters Color Scheme](https://ericscrivner.me/2015/06/better-emacs-rainbow-delimiters-color-scheme/)
