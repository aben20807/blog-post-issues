+++
title = "First Met Hugo"
date = "2019-03-21T22:20:12+08:00"
url = "/posts/20190321-first-met-hugo"
description = ""
image = ""
credit = ""
thumbnail = ""
comments = true
categories = ["Blog"]
tags = ["hugo", "小技巧"]
toc = true
draft = true
+++
<!-- https://drive.google.com/uc?export=view&id= -->

正常轉換跑道時都會有一篇推坑文，不過我這篇算比較晚了，也不是為了摸久一點，就感覺好像一直沒啥時間寫文章。  
就請多見諒＠＠  

<!--more-->

# 前言

從 Blogger 轉出來的原因可以去關於的頁面看看，我就不再贅述，此篇主要也不會手把手的教學如何用 Hugo 從頭到尾架設一個網頁，因為網路上有相當多這類的教學，我主要是記錄一些比較特別地方。接著跟我唸三遍：

> 前端坑好深，前端坑好深，前端坑好深

# 安裝

說不教好像也有點無情，不過在 GitHub 架 Hugo 真的太過簡單了，步驟真的算少，所以我就推給其他文章吧(可以先看完整篇再開始)：[在 GitHub 部署 Hugo 靜態網站](https://medium.com/@chs_wei/%E5%9C%A8-github-%E9%83%A8%E7%BD%B2-hugo-%E9%9D%9C%E6%85%8B%E7%B6%B2%E7%AB%99-9c40682dfe40)

# 安裝 - 注意事項

Ubuntu 請用 `snap` 來安裝比較新的版本，用 `apt` 會發現一堆主題不能用因為版本過舊。
```bash
$ sudo snap install hugo
$ hugo version
Hugo Static Site Generator v0.54.0 linux/amd64 BuildDate: 2019-02-01T13:33:06Z
```

# 部落格架構配置

因為 Hugo 會針對主題和文章經過 `hugo` 指令去產生一個完整的網站並預設放在 `public/` 資料夾。所以一般會把寫文章的地方跟網站分成兩個 repo，也就是把 `public/` push 到 `<username>.github.io`，寫文章的就創見另一個 `blog-post` 之類的 repo。這個作法可以使得網站不會被污染，也就是不會有奇怪的檔案，repo 也不會好像各種語言都有。

但是，一般上面這種是會把主題的檔案都複製到你寫文章的 repo 裡這樣就可以自訂一些前端設計。

我覺得這樣還不夠乾淨！因此我的方式是使用三個 repo：

+ blog-post
+ hugOuO
+ aben20807.github.io

沒錯，多一個 repo 追蹤主題，由於 Hugo 會自動的搜尋一些資料夾找尋網站設定，在一開始的資料夾找不到時，會根據 `config.toml` 中設定的主題去 `themes/` 找對應的主題，所以一開始的資料夾就不要有任何前端的檔案，除非像是 google analytics 需要放置規定的檔案，不然所有的前端設計 (架構, css, javascript) 都放在主題的 repo 中。當然這是給那些會修改別人主題的人的建議，如果是直接用現成的那就不需要多一個 repo 了。

以下是一個簡單的檔案結構：
```
blog-post/ <----------------------- repo 1: 存文章
├── config.toml
├── content
│   ├── about
│   ├── _index.md
│   └── posts/ <------------------- 文章會在這裡
├── themes/
│   └── hugOuO/ <------------------ repo 2: 主題
│       ├── archetypes/
│       │   ├── default.md
│       │   └── posts.md
│       ├── layouts/
│       │   ├── 404.html
│       │   ├── _default/
│       │   ├── index.html
│       │   ├── index.json
│       │   ├── index.rss.xml
│       │   ├── partials/
│       │   └── shortcodes/
│       ├── static/
│       │   ├── css/
│       │   ├── img/
│       │   └── js/
│       └── theme.toml
└── public/ <---------------------- repo 3: 發布網站
```

## 缺點

這麼多 repo 就是一個蠻大的缺點，不過若是非常在意的話可以利用 branch 來讓三個 repo 合併。

## 其他

當然也可以利用 GitHub 和其他工具達到持續集成、部署，參考：[利用Travis CI和Hugo將Blog自動部署到Github Pages](https://axdlog.com/zh/2018/using-hugo-and-travis-ci-to-deploy-blog-to-github-pages-automatically/)。不過我是有點點懶惰，所以我就用 [script](https://github.com/aben20807/blog-post/blob/master/deploy.sh) 來部屬。

另外對於文章，我建議可以用日期當作檔名的前綴，以便排序。我的主題就會自動切割日期。

# 有趣的功能

## 1. 搜尋

由於之前 Blogger 算是內建搜尋的，所以這裡算是研究頗久，原本要使用一些已經做成套件的切字工具，但是中文字真的太難搞定了，所以我乾脆直接用 google 提供的搜尋：Google Custom Search。一樣，這裡就不一一教學，請移駕：[將 Google自訂搜尋引擎 (Google Custom Search) 搭配 OpenSearch 加至 Hugo 網站中](https://blog.yowko.com/google-search-in-hugo/)。真的要參考實做的話可以來這個 [commit](https://github.com/aben20807/blog-post/commit/6f6b62898791322876091d4db98d580b8a7accdc#diff-44f0b83d58ef03d7cee156de462be50c) 看看。對了，設定完後要等個幾天才會可以搜尋，我那時候以為我哪裡設定錯誤，結果等個幾天就可以用了。

## 2. TOC (Table Of Content)

Hugo 算有提供 toc 工具，但是用起來沒這麼好看，例如它無法設定深度，不管幾層就都會做成 toc 也就是 h1~6 都有，造成空間浪費。這裡我也是弄超級久，最後我是參考 [AllinOne](https://orianna-zzo.github.io/sci-tech/2018-08/blog%E5%85%BB%E6%88%90%E8%AE%B016-%E8%87%AA%E5%BB%BAhugo%E7%9A%84toc%E6%A8%A1%E6%9D%BF/#/hugo%E7%9A%84table-of-content) 這個主題的實做方式：[toc.html](https://github.com/orianna-zzo/AllinOne/blob/master/layouts/partials/toc.html)。

## 3. Headline Hash

也就是滑鼠移到標題會出現一個 anchor 可以產生直接跳到這個標題的連結，直接參考：[Adding anchor next to headers](https://discourse.gohugo.io/t/adding-anchor-next-to-headers/1726)。

## 4. Smooth Scroll

這個可以讓移動有滾動的動畫而不是直接跳到那邊，我是使用 `jquery.smooth-scroll.min.js` 來達成，請參考這個 [commit](https://github.com/aben20807/blog-post/commit/68fa52f8d25c90d003fec296081427d12c6724cf#diff-0aa74fe7c8cd2a2b79dab67ece16cb02)。

## 5. Scrollspy

讓右邊的 toc 自動標記現在所在的標題位置，我是從 [how to use scrollspy without using bootstrap 的其中一個回答](https://stackoverflow.com/questions/30348314/how-to-use-scrollspy-without-using-bootstrap/49257431#49257431) 改成這個 [commit](https://github.com/aben20807/blog-post/commit/94b0b7344de07858b4ed346bc76b30caafa71220#comments)

## 6. 自動換標題 OuO

這算是一個有趣但是沒啥實用性的功能，我是在 https://diygod.me/ 看到的，當你暫時離開去其他分頁時，它的標題就會變換。建議不要在手機上用這個功能。參考：[CHANGE BROWSER TAB TITLE WHEN TAB NOT ACTIVE](https://blog.youdivi.com/tutorials/change-browser-tab-title-tab-not-active/)，[commit](https://github.com/aben20807/blog-post/commit/4a468cb27289453f1a53ccb05db50343877438d8#diff-0aa74fe7c8cd2a2b79dab67ece16cb02)，如何排擠手機：[What is the best way to detect a mobile device in jQuery?](https://stackoverflow.com/questions/3514784/what-is-the-best-way-to-detect-a-mobile-device-in-jquery/3540295#3540295)

## 7. RSS

## 8. E-mail subscribe (mailchimp)
