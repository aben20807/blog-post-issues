+++
title = "寫一個記帳程式有多難？"
date = "2020-08-15T17:17:26+08:00"
url = "/posts/20200815-how-hard-to-build-money-manager-app"
description = ""
image = "https://lh3.googleusercontent.com/pw/ACtC-3e3RXtqDVFdubJjmlkAZCHYZ8ru-FtTDTd8vtkxaetMkS1p7LiDKKNdgLZ0IXXq27vYR2-onK45Gghk3-itmUuTId7LzROOm0tcuY9_xstcEfiDZ7-NichYkmS5t7Rk52bOgpAIBvUxBzj0fkCEvxRR=w1272-h643-no"
credit = ""
thumbnail = ""
comments = true
categories = ["程式設計"]
tags = ["app"]
toc = true
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

靈機一動，想說可以用表單來記帳，一查果然有人做過 OuO

<!--more-->

# 前言

又被 Google play 發了60元禮金，想說看一下工具類的 APP 付費情況，發現前幾名有兩個記帳 APP，原本想說要買來用養成一下記帳，可是我對現有的記帳程式沒有啥好感，之前也用過兩三種，後來也都放棄。結果後來想想還是不要拿來買工具，所以又買了一個 Rusty lake 的遊戲，燒腦的解謎遊戲，多多支持 (無業配XD)

![Rusty Lake Paradise](https://lh3.googleusercontent.com/pw/ACtC-3fMBGVal6Y6qmf0-CSh-AfKoWtWNqvCUI-60lPR7C9ZAgDbE0CNwlqPyAdjm-Q1uLbExDxLR14b6K2AtJJZLBcHftF0fZ3gblRscO7kjQBQ0DP74gCnNbiFOOOdxHri-Zqcay_gKsUCyi_Y7hkR49XQ=w646-h1041-no)

# 使用表單記帳

靈機一動，想說可以用表單來記帳，一查果然有人做過[^1]

[^1]: [【Google表單記帳術】史上最完整雲端記帳本打造教學！1小時內開始用表單記帳，免費又方便！](https://leadingmrk.com/google-sheet-form-account-book/)

不過我也只是採用了簡單部份，後面那個對帳有點複雜啊。所以我就建了兩個表單：消費記錄、轉帳記錄。

+ 消費記錄：記錄平常花費
+ 轉帳記錄：領錢、悠遊卡或是點點卡儲值

用表單記帳好處：
+ 雲端化，即時更新
+ 自動時間戳記
+ 超客制化，問題選項及流程都自行設計
+ 統計圖表功能完整

可能缺點：
+ 一定要有網路才能記帳
+ 複雜統計功能要花時間設計
+ 某些表單沒有的可能就無法提供，例如，顯示表格，另外我發現手機無法上傳圖片 QuQ

## 表單設計

表單有一個很有用的功能，就是區段，可以針對回答跳轉到不同的問題

![根據回答跳轉區段](https://lh3.googleusercontent.com/pw/ACtC-3dtUNadoaEi6qkB0o9GKiDL1uZLqi7ZtRLBbOshWrIMFbIkF5MYjICopOKcSXLBjJldZudGT87f5hrf02RASGct7YaMXLHAphLohzBmlMlNjxhetEQ54pa7bwIqhv150zbY_sxdVIuaM3zGVSDU6XmB=w859-h579-no)

所以大概就是這樣設計，如此便可以快速方便記錄細節。其實這就是一個狀態機，Compiler DFA 回憶起來~ 針對自己的情況加選項或是問題，超級客制化。

![我沒畫完整版的喔](https://lh3.googleusercontent.com/pw/ACtC-3e_fQr9GGaMQHlG1-JLvQpCmzcuImufjPFuqtFlugwb9QRj9VCHhpGle_-A-zICRSk6ZQ9PqXyftjUV1piJdzm5mz2syYiKMI6LbS5gocIyS4fSv-Z_GdTWehkdEVe13kp35NYO7MdXNYTFKzvdeJya=w892-h422-no)

## 預先填入表單

某些選項可能超常用，比方說消費記錄大部份都是現金，可以將它用作選項預設值，可以參考 [^2]

![新版在右上角](https://lh3.googleusercontent.com/pw/ACtC-3c51lQNqFVCSqjAn2XVkDt0xZSs9PSqt2S623mTXkh-oTcmLdcNJd5Qh59cDiUALwe4EnGx1oO94vTn9O8AasjwZOfFwG8IkdblaSR4643XjYfozFOT5h1bJpxScbVyPMBXMlYAH0tlZd6irq7jWtyc=w692-h403-no)

[^2]: [Google 表單如何設定欄位預設值（可從網址列變更預設值）](https://blog.miniasp.com/post/2014/07/17/Create-Google-Forms-with-Pre-filled-Responses)

## 如何使用表單

一開始想法很簡單，就是建立記錄用的表單，然後將連結用書籤的型式存在手機桌面，這樣就可以直接點來記帳。

![ ](https://lh3.googleusercontent.com/pw/ACtC-3dBfRoc4yz-m2ciB1uy1WiY5NUFUdHZZ7Us8HWtZPVZviemG2keYD56E0Ujo-00380KveIxeQcQ2l5AqRjHYrVejcxQESoC6lR43QtZGwsSKjyX-m_0rdqzzg8hE0Y9NEUjzPRe7L4t3R4J5TTtrmwQ=w1272-h836-no)
![出現在桌面](https://lh3.googleusercontent.com/pw/ACtC-3frXOytq3We7pyNsglA69vKcVR3mFoV0nQbihbk8mqR5ebdj-gxlvXPhxQ7oNByjdtlwTQ9Szj1TTxC4mWJ0ty7SLGr5LpJIJKMmpWzBGlyHuK-26TGR8A2rgkBn4nUv_ODDaC1FUCxQDjO51t8dUrE=w1272-h903-no)

# APP

用書籤有一個很大的缺點，就是一定要放在桌面，多表單的話很麻煩。再來就是每次點開就需要開啟瀏覽器，而我的瀏覽器頁面常駐超過 99 個分頁 (`:D`) 所以載入要花費一定的記憶體及時間。

![ ](https://lh3.googleusercontent.com/pw/ACtC-3fljY1Lx9qYXtjq8dfqx-dSbDyjz9IMmU5DAMkDUivBFwupJQSODbQxBZD3NEQqxt0v8dZhQKk1COJQDHHgtNnIawzdwr5WEJZjZvyh2Tgq31R2aY3cLObAA2ELveNItMXgpRmasztoSxK93Le0--3X=w1272-h1239-no)

於是我就想說找看看有沒有將表單變成 APP 的方法，不過看來沒有簡單的方法，[AppSheet](https://play.google.com/store/apps/details?id=x1Trackmaster.x1Trackmaster&hl=zh_TW) 好像可以不過似乎之後要收費。接著我就打算自己用一個簡單的 APP。

Android Studio 過於肥大是不得已才會採用。查了一下發現 App Inventer 2 (AI2) 也有支援 WebView 的元件所以我的想法應該可行，基本概念就是用 WebView 來載入我們的表單，用按鈕控制開啟哪個表單這樣。

## 版面設計

兩個畫面，左邊主畫面作為一開始進入的畫面；右邊用來開啟網頁也就是表單，放一個 WebViewer 然後大小用最大。

![ ](https://lh3.googleusercontent.com/pw/ACtC-3dV5Gn101vL3GfVWY6yecntkVd0UP_vDgzZGqd0tjoA8k9V87nX7zlF2EbEFGxqcDrn8icutYcE4SV7-tv9eCHWX3qc8Mez--FxVkzNpoQmtH-IbD-Vu0iVv4sIKCEPKIw8KLvQYWBwdJnK8PfNJZoG=w1272-h554-no)

## 開始寫 code，咦，是拉 code

先展示一下完整的模樣

![Screen1](https://lh3.googleusercontent.com/pw/ACtC-3e3RXtqDVFdubJjmlkAZCHYZ8ru-FtTDTd8vtkxaetMkS1p7LiDKKNdgLZ0IXXq27vYR2-onK45Gghk3-itmUuTId7LzROOm0tcuY9_xstcEfiDZ7-NichYkmS5t7Rk52bOgpAIBvUxBzj0fkCEvxRR=w1272-h643-no)

![Screen2](https://lh3.googleusercontent.com/pw/ACtC-3e2vKJQmuKlTVEAJ88cMpwZBqYB05bvn23YiBIITp8wQ4EKct_hx56i0QFq6Fhhx1novqwDOLs0kyxpPMnU0UkKL9-PeN5MnMBSLV9HCkuzJT3g47X_jkz-a_E2_BzZqZvWJrEKl-TR1NbEGyd-QOYg=w1272-h640-no)

1. 首先是畫面進入及離開，因為在 AI2 中對 TextBox 作修改是無法儲存的，關閉 App 重開後會恢復，所以這裡採用建議的方式：用 TinyDB 當作儲存空間。那紫色的兩個 procedure 將在稍候提到。主要就是用來讓設定可以被儲存。

![ ](https://lh3.googleusercontent.com/pw/ACtC-3dZJnlJPYoM8IWlwit56aajeQJuqncIQu5uY5sh1pZIxoxaCayShM1Ay7BmT2j6S5MxmrNmMAf7BGEfBvJaglWr6GqP_vE4eu3d8eVXRie1sVBmiwzBVQJ3knwwkcTK-V7lrddQ4lIuC7PrbM9Og8vz=w285-h219-no)

2. 點擊按鈕後傳送對應的連結給 Screen 2 當作瀏覽連結，這裡我有點懶所以命名就大致上不更改@@，值得注意的是，這裡看到傳入 TextBox 的值，可是剛剛畫面上沒看到 TextBox 啊，其實是我隱藏起來了，將 visiable 設定為 false，按下設定才會顯示。

![ ](https://lh3.googleusercontent.com/pw/ACtC-3cNajTDVEms6BWCGBHIX63Fd96YTILkirW2p1q-3ZP_hStceuVfYwJaYOU5hTqFINqrGtgCQfCPL0ggoefHZNOnq5bQMG4QdZdPCoPtc-3NVfHMrlOabF64OWSOJLnnsoRCA3XgfSDlXf3VXROB5GxR=w592-h299-no)

3. Screen 2 接收剛剛傳的連結後當作首頁畫面，Screen 2 也就只有這個方塊。

![Screen2](https://lh3.googleusercontent.com/pw/ACtC-3e6D9aJTo3gFXSJfGY-iZRUp-u_KXDHUEJFF8QUDn5Jldo8X0lMhkwOa8x4xL3KqFa4kSqFbCDj7PzP-P_-UNhxP5EtyR0DqAEk67CtIQOMSGOa6OMOCo9euneoXM1NScigiOmUBofdCfifTklbz5uT=w521-h200-no)

4. 這裡就是我在 2. 中提到的，按設定的按鈕會顯示設定

![Setting section](https://lh3.googleusercontent.com/pw/ACtC-3f_jBNSwSu_p9eWDv0JXn71OjRa06_utd5xEswjfv0jJzZ37yEsERkJhZWAF8dZjET5kNbGcIPxv69s5IJ3yi-zi0bhSXjBuRZeXrjV8LpzEZ-j0R-kDJC6gMraE-fKY-1B9SvYuK-ACQN2biQz7gCe=w465-h160-no)

5. 在 4. 中設定的部份會需要儲存到 TinyDB 中。

![Set button](https://lh3.googleusercontent.com/pw/ACtC-3ctSw-g3InpKnt1QyfG7yu4i5nKUx_671d5lJf6lmI4rxnGNUPmnw0iZNa7TZHgvS3nbeRoQc3muMyjZhg6K1iyHWZ2jpAjMt7jyZ2hwX5my6GPAUpH3TW48aaNVq1gcDnAfyDWo0fcgZnbwWdLTG1s=w449-h290-no)

6. 最後，把 TextBox 存取 TinyDB 的動作寫成 procedure，這樣比較清楚。

![](https://lh3.googleusercontent.com/pw/ACtC-3fuQeIoXDp-C0TvgNpIznR4JRc9DS0LNSmCg0kfnQbSz3r_FlL3sxPNhAg4PG_OWO0tixY_v9-p9tlfMDECuiPBbu3HDHNDPLFsoXp_3S2Zduhvrc4Q24jfEasuM55IkriY7mdfDjI5nVVFbK_6ywRR=w668-h1038-no)

7. 額外功能。開啟相機掃描 QRcode 並複製到剪貼簿，這裡需要安裝一個外掛套件 [Clipboard Extension](https://puravidaapps.com/clipboard.php)，另外記得取消勾選BarcodeScanner1 的 UseExternalScanner 直接使用內建的即可。會多這個功能主要是可以用在電子發票上，在記帳前可以先掃描，之後直接複製到備註那邊即可。

![ ](https://lh3.googleusercontent.com/pw/ACtC-3c-baXvN_ippYf4tCbROQDqkwHjfknfbXDqdElVdxzrL59g3gnELs3BUf2Ep_xsxMGlpB9Hv7SCx8oWR5wzQ8ERxKR8UTf7qtScZWZwMu9pbp4PmYYVQavRyFq_JKcg6vFP5bARTyCiu73obddk6AJC=w401-h272-no)

# 成品

感覺我也不算是做一個記帳 App，反而像是將書籤或是網址合併變成一個 App，所我雖然取這個名子不過我還是找一個沒有跟錢相關的 icon。我也增加設定頁面可以設定的東西，包括按鈕的文字也可以換，所以也就不限於記帳了。

Icons made by [Smashicons](https://smashicons.com/) from [www.flaticon.com](https://www.flaticon.com/)

![ ](https://lh3.googleusercontent.com/pw/ACtC-3dCHkhaKSt4Pe-t7pRfxzxIkU9A_MWEyLR0svdl1wfinZR2ZWCTHdPAPFcmO0ZvBb8zNxEeMLkDC8hIWSV3dGmKY_CWAYZmojmgoma500tOE_9fMUyDH3nY0faL-9rCjL-91-TE52bD_NTjXlzn55CU=w660-h1319-no)

![主頁面](https://lh3.googleusercontent.com/pw/ACtC-3er9oo-dAdEogzgXc41sHDxnVwKEkUQc0l36X0jxzWBpb92QlXhWG6E7__NLzf9SarSWnkUIMytNOhLRCXg5ur5F9_DcTGqRs6pYsgzE7htPymKKSPlUigLhhJbOe5KgmmHm2vRSf3gAodtYE0m83Dh=w660-h1319-no)

![設定頁面](https://lh3.googleusercontent.com/pw/ACtC-3ev0_9UxWRs2TNPcc947ntp3ncr_Tkl8E_mYhJWHBTOlMeWi9GEbFH0H_j7iXEQyYsnGhu2-hxX2t12ktLjV0-tB5RKV9M292ZcbKR9-KMBRa-nCNzV5QxBkpHGM4-bc5B3pHNr0EPA1DOuaOB2pzog=w660-h1319-no)

![消費記錄，連額頭網址列都消失了，舒服 OuO](https://lh3.googleusercontent.com/pw/ACtC-3cg3mhLJEIYy3tIRsOxqJr3PiOjmWaEc6ho6npj1Q69AgaCnIbU073VmOqbA2DULN1r9mfN7CI57ZOW_9ZrDKhtEkyU65zBAy9lu7i7gaNUr8e1f2Vo3QodWIKZDBjKHeCMgC1GNwcuh_yJxr-sR7k6=w660-h1319-no)

![轉帳記錄](https://lh3.googleusercontent.com/pw/ACtC-3fEqBTRnMchjOpS4SqzjifLk05CXdQuQQ-9I0Ve_quNnRtTz07Cv6rdSh2s5R4H5B08zy1eEEJsJoyEVkaep0PZ4upa1D5eyteMM1A1-aXwAlLYymFscg2z73dx4UDiAq4kn3EOkbHVwVNi7SHK5VXZ=w660-h1319-no)

![報表，就是畫幾張圖用手機開的感覺](https://lh3.googleusercontent.com/pw/ACtC-3dMfTlxaQfdxv0wXs3JRymXiUE9ZYfW6e-fUDP2N7ABITWv_f0aULXvR8NrLMLjPRDDH9HqAKd5OvDxGjP7auQG6-lwY60N5a2h1L-m9loZD2VU3-yFNFALtn4Jq0q648kG2oHz3xZB2U5lhew98PKa=w660-h1319-no)