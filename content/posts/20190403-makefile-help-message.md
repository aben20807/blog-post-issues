+++
title = "Makefile Help Message"
date = "2019-04-02T09:06:15+08:00"
url = "/posts/20190402-makefile-help-message"
description = ""
image = "https://drive.google.com/uc?export=view&id=1jMqjSm6HUMHY3QBm0x51leBBmvBW5EEu"
credit = ""
thumbnail = ""
comments = true
categories = ["程式語言"]
tags = ["makefile", "小技巧"]
toc = false
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

最近蠻常用 Makefile 的，想說寫一個 help 選項，這樣就不用要使用時都要打開 Makefile 看怎麼用，意外查到可以使用小技巧來印出 help。達到註解及文件的效果。

<!--more-->

原本可能在寫完所有 rule 後要再加一個 `help` 來寫準備印出來給使用者的內容。如下：

```makefile
action1: ## Do action 1.
	@printf "Doing action 1..."

action2: ## Do action 2.
	@printf "Doing action 2..."

help: ## Show help message.
	@printf "Usage:\n"
	@printf "  make <target>\n\n"
	@printf "Targets:\n"
	@printf "  action1\tDo action 1.\n"
	@printf "  action2\tDo action 2.\n"
	@printf "  help\t\tShow help message.\n"
```

![google-結果](https://drive.google.com/open?id=1IwQiOPfxIXVfPhZ76N7UX497HuZ-lA3m)

這種方式在數量一多下會很麻煩，尤其是要不斷確認上面是否有被更動。所以找到許多人針對每個 target 的註解去產生 help 資訊。這裡使用 perl 跟 awk 幫忙。

下方印出的結果同上就不貼圖片了。

```makefile
action1: ## Do action 1.
	@printf "Doing action 1..."

action2: ## Do action 2.
	@printf "Doing action 2..."

help: ## Show help message.
	@printf "Usage:\n"
	@printf "  make <target>\n\n"
	@printf "Targets:\n"
	@perl -nle'print $& if m{^[a-zA-Z0-9_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "  %-18s %s\n", $$1, $$2}'
```

稍微解釋一下 perl 那一行

首先就是先使用 regexp 去 match 符合的表達式，`^[a-zA-Z0-9_-]+:.*?## .*$$` 表示由一個單字(可能含數字)開頭 `:` 後方是相依的部份，最後是用 `##` 註解的描述。

接著利用 pipe (`|`) 給 awk，它可以針對欄 (column) 去操作文字，`BEGIN` 區塊表示初始化宣告，也就是輸入的字串是用 `##` 當作分割符號，最後利用 `printf()` 去把第一欄及第二欄印出來。

最後最後，加上點顏色頗不錯 OuO

```makefile
# color
BLUE = \033[34m
NC = \033[0m

action1: ## Do action 1.
	@printf "Doing action 1..."

action2: ## Do action 2.
	@printf "Doing action 2..."

help: ## Show help message.
	@printf "Usage:\n"
	@printf "  make $(BLUE)<target>$(NC)\n\n"
	@printf "Targets:\n"
	@perl -nle'print $& if m{^[a-zA-Z0-9_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "$(BLUE)  %-18s$(NC) %s\n", $$1, $$2}'
```

![google-有顏色版本](https://drive.google.com/open?id=1RTn1OcTBserVT9XOFhDRSFA2f3Lx1R-G)

### 參考資料
+ [Makefile help target](https://nedbatchelder.com/blog/201804/makefile_help_target.html)
