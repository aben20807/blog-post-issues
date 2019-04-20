+++
title = "Github Flow"
date = "2019-04-20T21:04:32+08:00"
url = "/posts/20190420-github-flow"
description = ""
image = "https://drive.google.com/uc?export=view&id=1oerWXAO9-X5k8wb1ixdAmnaqgCFFAizP"
credit = ""
thumbnail = ""
comments = true
categories = ["軟體工具"]
tags = ["git"]
toc = true
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

最近算是真的在用多人合作的 git 了，以前大多只有自己在 add, commit, push。不過到多人的合作下就講求流程，這裡以 GitHub flow 為主要的流程做討論以及順便記錄一些會用到的指令。

<!--more-->

# 前言

其實是看了 [Understanding the GitHub flow](https://guides.github.com/introduction/flow/) 之後還不是相當懂，跟同學(大神)討論了一下算是有釐清一些我的懷疑吧。

p.s. 這裡有翻譯版：[讓我們來了解 GitHub Flow 吧！](https://medium.com/@trylovetom/讓我們來了解-github-flow-吧-4144caf1f1bf)

<注意> 因為目前專案還不算大型，所以目前遇到的狀況算是比較簡易的。
<注意> 由於我也是初心者，如果我有誤解的話請跟我說，感激不盡。

# GitHub flow

這個流程，主要是去掉 Git flow 有兩條主線的麻煩。不過誰比較好，還是得看用途，更有 GitLab flow 是合併兩個來用的＠＠

> GitHub flow 只專注在 master 身上，從 master 上開啟 feature branch，在該 branch 上開發(會有一些 commit)，最後在透過 PR(pull request) 合併到 master。

上面這句看似簡單，其實相當複雜，我盡量詳盡解釋。

更清楚的解釋應該為：

> 從主要專案(upstream) fork 一份到自己的帳號(origin)，修改 origin，從 origin/master 新增分支，開發完後將分支 push 到 origin/新分支 上後直接用新分支對 upstream/master 開啟 PR。

# Fork and PR

首先，PR 可以達到討論及 code review 的效果，為了達到 PR 我們必須把主專案 fork 一份到自己的帳號。而 PR 的方式主要就是透過 GitHub 網頁提供的界面進行操作。

不過，我試了一下，發現同一個 repo 還是可以透過 branch 發 PR 的，這我就有點不確定為何一定要 fork，或許 fork 是不一定，不過更改自己的 repo 會比較心安一點，尤其若是常使用....
![google- ](https://drive.google.com/open?id=1poKsFmBeJ650xMa6OtgxMUGNE8NYo8fy)

# Branch

Branch 在 git 中花費相當少，因為它就只是一個標籤，所以應該盡量使用它。GitHub flow 中保證 master 上的每一個版本都是可佈署的，因此在此流程中不建議直接在 master 上加 commit 而是在 master 上開一個 branch 出來。

<注意> 一定要從 master 開 branch
但是又有一個特例：就是當別人還沒 merge 我的 PR 可是我接下來的開發又需要有這個 PR 的內容的時候。網路上我找到有人問這個問題 [傳送門](https://softwareengineering.stackexchange.com/questions/310427/in-github-flow-is-it-ok-to-base-feature-branch-on-another-feature-branch)，好像就只能在 branch 分出另一個 branch 來先暫時用。

# 流程

## 初始化

1. Fork 主要專案到自己的 GitHub 帳號
2. Clone 自己 GitHub 中的專案 (fork 過來的)
```bash
$ git clone <自己專案的 url>
```

3. 設定 upstream 來源
```bash
$ git remote add upstream <主要專案的 url>
```

## 開發中

1. 前往 master 分支 (一開始就在 master 可以不用)
```bash
$ git checkout master
```

2. 新增並前往 feature 分支
```bash
$ git checkout -b new_feature
```

3. 開始開發功能
```bash
$ git add XXX
$ git commit
```

4. push 到自己帳號的專案 (3. 4. 可以混用，push 完後一樣可以 commit 再 push)
```bash
$ git push origin new_feature
```

5. 準備發起 PR，先把專案更新到最新，也就是把 upstream 的東西更新到自己本地端
```bash
$ git checkout master
$ git fetch upstream
$ git merge upstream/master
```

6. 回到 feature 分支把 master 中從 upstream 來的新 commit 更新回 feature branch
```bash
$ git checkout new_feature
$ git rebase master
$ git push origin new_feature
``` 

7. 發 PR
開啟 GitHub 界面，按下 Create pull request 的綠色按鈕，注意方向，輸入標題、解說文字、新增 reviewer 後按下 Create。這樣就大公告成了。

# 參考資料
+ [這次專案用到的Git流程](https://medium.com/@yengttt/開發用到的git流程-c9082b914974)：本篇主要流程來自這裡，更詳盡請點擊參考。
+ [如何使用 GitHub Flow 來參與開源專案](https://poychang.github.io/guide-to-use-github-flow/)
