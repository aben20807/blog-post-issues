+++
title = "Github Flow (2)"
date = "2019-04-21T19:13:02+08:00"
url = "/posts/20190421-github-flow-2"
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

針對昨天的再多釐清一些。順便補充一些東西。

<!--more-->
# 關於流程

昨天的流程主要是有需要 fork 的，通常是針對那些你無法對原始專案直接操作的狀況。

如果對同一個專案使用 GitHub flow 也是可以的，也就是說在同一個專案中開啟 branch 在對自己開啟 PR，或許這就是我一開始有點困惑的原因，結果是都適用。

# PR 被 merge 後呢

## 更新 merge commit

接下來要做的就是更新一下自己的 master (origin 跟 local)。
```bash
$ git fetch upstream
$ git checkout master
$ git merge upstream/master
$ git push origin master
```

## 刪除 branch

GitHub 上在被 merge 的 PR 的界面會出現可以刪除 branch 的按鈕。
![google- ](https://drive.google.com/open?id=1MM_kFgO6PWBnPRPp9Ry3BgX4Lf6j2U3i)

刪除完成後會出現提示，貌似還可以復原呢。這個步驟後你帳號遠端上的那個 branch 就不見了。
![google- ](https://drive.google.com/open?id=1Q39-VcdZ36CqtvOh0NCu1Ix35JxwuzaQ)

再來是更新到本地端。
```bash
# 列出本地端的分支 (加上遠端記錄)
$ git branch -a
```
![google- ](https://drive.google.com/open?id=1QifWjcp6goVP329L8aBoeV98yVze_XAc)

刪除遠端記錄
```bash
# 模擬遠端可刪除分支
$ git remote prune origin --dry-run

# 執行刪除
$ git remote prune origin
```
![google- ](https://drive.google.com/open?id=1w1LtPh3fYn6s2EO21yof6Xh8T60Gw-Zc)
![google- ](https://drive.google.com/open?id=1MdDsIHfyFUX9hAmorRbWYmg8tv0HYtO0)

刪除本地分支後就大功告成
```bash
$ git branch -d new_feature
```

# 參考
+ [Clean up your local branches after merge and delete in GitHub](http://www.fizerkhan.com/blog/posts/Clean-up-your-local-branches-after-merge-and-delete-in-GitHub.html)
