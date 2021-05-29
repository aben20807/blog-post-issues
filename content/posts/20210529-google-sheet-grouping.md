+++
title = "Google Sheet Grouping"
date = "2021-05-29T11:16:15+08:00"
url = "/posts/20210529-google-sheet-grouping"
description = ""
image = "https://lh3.googleusercontent.com/pw/ACtC-3eGzeTF-u6a8scFj0NVUs5GCRge149HD7X6oygWYCyLx322QMxejANFBdLzqkTCBtMaX78yDWUHRCzbZBg3NimvKwhXokBfc_FJi4KNL-iPFX1MS6mgLarOQIwLPbKsxItFPkB9PvsDneu1N9XYXzcmVg=w505-h387-no"
credit = ""
thumbnail = ""
comments = true
categories = ["線上工具"]
tags = ["google sheet", "google"]
toc = false
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

Proficient programming language:  
+ Google sheet

<!--more-->

善用工具的心法很簡單：
> 我相信有這個功能

不過還是需要拆解一下：需求 -> 功能分解 -> 合併

# 需求

以這次功能為例，我想要針對所有同學進行分組，但是不需要隨機，只要按照順序分 A, B, C 就好。

# 功能分解、逐漸合併

三個一個循環很容易想到取餘數 (modulo)[^modulo]。接著到 Google sheet function list [^Google sheet function list] 搜尋看看有沒有：

![搜尋結果](https://lh3.googleusercontent.com/pw/ACtC-3eHskvbWonxNnPntuPoVU-BB5frZRuSWBseEPPHvhg16rNbOLr23yhb2Tuz85f7vYaXiwlkgFMsTjsSitPAAevG904AnSEQLgyMMEghKFwomt81AQKUzU-Cv67Q451GlAUpLWxmeoHNrMmOykGNJMUO3A=w1199-h776-no)

[^modulo]: (https://en.wikipedia.org/wiki/Modulo_operation)。
[^Google sheet function list]: (https://support.google.com/docs/table/25273?hl=en)

我們大概可以知道 `MOD(x, y)` 得到的是 `x/y` 的餘數，因此 `x` 是對應到列數，而 `y` 是分組的數量。

再來比較抽象。我們有了餘數功能，要怎麼對應到每一列 (row)? 所以就找到 `ROW()` 可以取得目前的列數，這樣我們就得到 `x` 了。

![每個人的列數](https://lh3.googleusercontent.com/pw/ACtC-3fiUAHHbCsaBpyvclBHNlMa57_1-JlrEAxSMRP3BVX071SZnn_ORcsEhZtnJHOuKy4HK67yw_JdbdKocrBhJwjWvqgLf5GxGDsakCLbiTZJdNWIicGirct-YQ-ddVNbS58h_rayFvi4zN9yi041gG4zaQ=w307-h386-no)

`y` 用 `3` 代入

![2,0,1 重複出現](https://lh3.googleusercontent.com/pw/ACtC-3fEda2LS9FQLpGcan6rweZctvXTwK1q-OsEA-kjdmbCe6u0L40y0W2deC-sJb0sreCOLIrhbHIjJZnaSofjM0YcA6TgpQd7DauHQy5-FalhW0LMzRniLvSulgd21t9MxtSjjYiN1UdP0KBHHbPw-wdfCw=w308-h387-no)

如果分組編號就是 0,1,2 的話就可以在這邊停止，不過如果要重新取代號 (A,B,C) 或是分配不同內容給各個組別時就需要繼續下去。

再來的思考方向，就是用剛剛的 0,1,2 當作索引值 (index)，查看看如何用索引值取得其他格子的內容。我們選擇使用 `INDEX()`，其使用方法就是先選擇一個區塊 `reference` 接著用 `row`, `column` 去選擇。

![選一個功能最不複雜的](https://lh3.googleusercontent.com/pw/ACtC-3fSOGvhxqM_OW94b9zA6qbLl1QGMXiLcMS-4wcQgOTPUiaXnA1PIOUqcfRX39GNuWDQDAycJXlsi1vvnI_uHAMqTd4MRD8le7oTlrBVVII1nJ_oyE07eYf-GL8cyEuqhAZ2t28PFZQ6iwBqmtftOAK_wA=w1174-h900-no)

套用進去會長這樣，`INDEX(\$E\$1:\$E\$3, MOD(ROW(), 3))` (`\$` 是鎖定用，不會因為下拉導致列或欄改變，因為 `E1:E3` 是固定放我們的代號)。
![目前的成果](https://lh3.googleusercontent.com/pw/ACtC-3djn5Tqfhr3O1GH6SALCCahCihSID6m0RbA_4VYXGqNU61yoL5Lk6bRp81gsIVOj8tevLHv0-w-0RihTdeAv6UfDQtqwE4CTepk71mYrFmztiTzwjMSvtxqcXrEo8y2Wu2t4K81R18gRBF1VkY41F3K7Q=w506-h385-no)

會發生上面的錯誤是因為 `INDEX` 使用的列起始是從 `1` 開始，所以我們來加 `1`。

![完成](https://lh3.googleusercontent.com/pw/ACtC-3dsrRA-9kdsJrtANswZ01XvsoSW3UdUn8UyjgTCqihHAq_QH7Dm65y9P0616XASNuCcVu2Np_ZR9Z5ZiobW-by36NZT-U87j3eO_EK1LYqoxrmN_m-vSOUD5OETzm_7CtQ6IoWfkwzDz0arxbha-QTmDQ=w506-h385-no)

如果想要 A 開始的會只要將右邊 E 欄換個順序即可。

![換順序](https://lh3.googleusercontent.com/pw/ACtC-3eGzeTF-u6a8scFj0NVUs5GCRge149HD7X6oygWYCyLx322QMxejANFBdLzqkTCBtMaX78yDWUHRCzbZBg3NimvKwhXokBfc_FJi4KNL-iPFX1MS6mgLarOQIwLPbKsxItFPkB9PvsDneu1N9XYXzcmVg=w505-h387-no)