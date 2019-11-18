+++
title = "Programming Sense (2)"
date = "2019-11-18T11:36:33+08:00"
url = "/posts/20191118-programming-sense-2"
description = ""
image = "https://images.unsplash.com/photo-1539392253103-78d190be0116?ixlib=rb-1.2.1&auto=format&fit=crop&w=2689&q=80"
credit = "https://unsplash.com/photos/LSC9t3kWOdE"
thumbnail = ""
comments = true
categories = ["程式設計"]
tags = ["programming sense", "小技巧", "coding style", "c", "可讀性"]
toc = true
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

結果因為太多項了導致右邊的目錄超出邊界，所以還是要拆成兩篇。QuQ

<!--more-->

[{{ 上一篇傳送門：Programming Sense (1) }}]({{< ref "/posts/20191116-programming-sense" >}})


# 抽像化 ([Abstraction](https://en.wikipedia.org/wiki/Abstraction_(computer_science)))

盡量的抽象化自己的程式，最簡單的方式就是把相關的程式碼包成一塊，而不是散在主函式中，包起來的動作通常稱作封裝 ([Encapsulation](https://en.wikipedia.org/wiki/Encapsulation_(computer_programming)))，也有實作成 ADT ([Abstract data type](https://en.wikipedia.org/wiki/Abstract_data_type)) 一說。

主要目的就是讓程式碼可重複使用，並讓簡化主函式的流程。抽象化過程要想著如何讓別人 (包括未來的自己) 使用自己的程式碼。可以透過將函式切成一個函式只做一件事讓可重複利用率提高。

例如實作一個 Queue 時，可以將存放的結構 (陣列)、操作指標 (front, rear) 放在同一個 `struct` 中，甚至將 enqueue 和 dequeue 做成函式指標 (function pointer) 一起放入 `struct` 中。注意，以下程式碼尚未測試過...

```c
// 結構定義
struct Queue {
  char que[26];
  int front;
  int rear;
  void (*enque)(struct Queue *, const char a);
  void (*deque)(struct Queue *);
};

// 初始化
struct Queue *init_queue() {
  struct Queue *ret = calloc(sizeof(struct Queue), 1);
  ret->front = -1;
  ret->rear = -1;
  ret->enque = enque; // 須另外定義 enque 函式
  ret->deque = deque; // 須另外定義 deque 函式
  return ret;
}

// 使用
int main() {
  struct Queue *q = init_queue();
  q->enque(q, 'A');
  q->deque(q);
  return 0;
}
```

# 寫程式的過程

## 思考

不先思考就直接寫程式的話是很危險的，通常最後很容易落得需要打掉重練的情況，預先思考可以避免掉一些盲點。

![google- ](https://drive.google.com/open?id=1uYiTbRQ-bmFDkJE-MC_z-HyemZzzz6kA)

### 待解決的問題

首先得理解題目或問題的要求，如果有提供範例輸入輸出的話請一定要按照給定的格式，不能多也不能少。不過這在現實中比較少見，很多情況是要去設計防呆的。

直覺的解法一定有，但是通常會有大量的迴圈拖慢程式執行，儘管現在的硬體好到讓我們感覺不出差異，但是還是需要正視這個問題，因為當需求一擴大，效能瓶頸就會是一個大問題。

以下題目來自 108-1 成大資工 資料結構作業三 (這裡放上題目，不過我不打算解它，雖然這樣會比較完整，可是我真的沒空 QuQ)

<iframe src="https://drive.google.com/file/d/1N7S4ynPmXpMYVZVgJdL0_h0K_IYXCwUl/preview" width="100%" height="340px"></iframe>

### 是否能簡化

以範例問題來說，題目會給定 N 個團體，每個群體的人數不定。最直觀的方法是使用二維陣列存放這 N 個團體各自的成員，要檢查 A 是否屬於某個群體時使用雙層迴圈去搜尋這個二維陣列，都找不到則代表不屬於任何團體。

然而這樣每次搜尋都要耗費不少資源，甚至需要不少程式碼。更好的作法可以對題目的細節做解讀，題目提到成員只會有 A~Z 所以我們可以直接產生一個長度為 26 的整數陣列 `people_group_ids` (更好的方式是使用 dict 不過 C 沒有內建) 來存放這 26 的人的團體編號，為了方便初始化，可以讓 0 代表沒有團體接著往上累加，讀取到範例輸入讀取到 3 A B C 時，在陣列的 0 1 2 位置上填入 1，等到要查詢 A 的團體編號時就可以使用 `people_group_ids[0]` 來查詢了，原本 $O(nm)$ 的複雜度直接降為 $O(1)$，程式碼上也較為清楚。另外關於 A 對應 0 要怎麼寫，這就需要對字元有一些了解，可以觀察一下 [ASCII 表格](https://en.wikipedia.org/wiki/ASCII)，`person = 'B';` 的話我們只需要使用 `person - 'A'`; 就可以得到 `1` 了，把這個操作放到函式中增加可讀性的話更棒如下。

```c
int get_group_id(
    const int * const people_group_ids,
    const char person) {
  return people_group_ids[person - 'A'];
}

void set_group_id(
    int * const people_group_ids,
    const char person,
    const int group_id) {
  people_group_ids[person - 'A'] = group_id;
}
```

插隊的話只需要從 queue 的頭找 `group_id` 相同的人即可。

### 事前設計

這裡表達的不是一定要畫出 UML 或是先做好完整架構圖，而是有一點架構就可以，有簡易的流程圖當然更棒，但是我自己通常會在腦中進行，遇到比較大型的才會拿一張紙畫一下流程，這裡推薦 [draw.io](https://www.draw.io/) 這個完美的應用程式，可以應付各種圖。

## 小步前進，持續驗證

> 寫大程式要像西敏寺那樣的大教堂一樣，先從一個功能完整的小教堂開始，然後把小部分拆掉蓋個更大更豪華的；如果一次就想蓋個超大的教堂，最後可能弄成一團廢墟，連禮拜的功能都沒有。  
> --- Yoda 生活筆記 (Lee You Tang) [1]

等萬事俱備只欠打扣時我們就可以開始寫程式囉，最有效率的流程就是小步前進逐步驗證，不要一次就把程式打完，這樣執行發現跟結果不一樣時，問題就會非常難找，是輸入錯誤還是中間的邏輯錯誤或是輸出錯誤，若沒有逐步驗證的話，哪個階段出問題真的很難定位。

我的做法會先將輸入部分完成，並且印出結果確認是否跟想像中的結果一模一樣，這裡必須要注意是否有奇怪的換行，或是輸出的順序不對等等問題，因為 C 的輸入會有許多隱藏的陷阱，也許是把空格也當成一個成員之類的。操作的指令也是把讀到的直接印出來確認。驗證完畢才繼續往下一步走。 細心檢查每一個魔鬼細節才能達到最終目的。

強烈建議每一次的驗證完後搭配 git commit 把階段性成果記錄下來。

enque 跟 deque 一樣分開驗證，這時候我們需要加上一些輔助的程式碼幫助我們印出 queue 的內容，來保證每次的操作都是正確的。例如：`print_queue()`。

# 除錯 (Debug)

## 編譯訊息

編譯器產生的訊息相當重要，而且不是只有 Error 重要，Warning 也是一大關鍵，所以千萬不要忽略這些警告，反而要將這些警告視為錯誤，這裡推薦在編譯的時候加上 `-Wall -Werror` 這樣那些警告就會導致編譯錯誤了。

## 設計測資

題目給的測資一定很少，但是實際會遇到的情況相當多，所以一定要多設計幾組測試資料，可以利用上一篇提到的重新導向 (Redirection) 的方式才不用每次都要重新手打，照理說可以再加上 Makefile 來幫忙，可以參考我的另外一篇 [4]。

## 註解大法

用註解部份程式碼來找出錯誤是最簡單的方式，但這我通常是用來幫別人抓錯的時候會用，因為我不確定其是否使用逐步驗證的方式，因此只有結果錯誤，但是中間的過程無法直接看出是哪邊有問題，利用註解的方式隔離未驗證的程式碼來逐步比對。

## `printf` 好夥伴

`printf()` 是一個相當神奇且好用的函式，其底層非常複雜歡迎有興趣的人可以參考 [2]。我的習慣是在實作不同資料結構時都會做一個對應的函式來印出其內容以方便驗證。

```c
void print_queue(struct Queue const * const q) {
  for (int i = 0; i < 26; i++) {
    printf("%c ", q->que[i]);
  }
  printf("\n");
}
```

## GDB

GDB ([The GNU Project Debugger](https://www.gnu.org/software/gdb/)) 是 segmentation fault 發生時的好夥伴，它可以幫助你找出程式是在哪裡發生錯誤，這樣就可以去找出對應的解決方法。關於原生的 GDB 有點樸素這點我之前有寫過一篇介紹 [GDB dashboard](https://github.com/cyrus-and/gdb-dashboard) 可以參考 [3]。

# 後記

突然發現自己好像也不是這麼悠閒，不過還是把這些趕出來了，可能會有錯 (範例打錯或錯字) 再請大家幫忙抓漏 了，感恩 QuQ。很多部份也都沒有附上範例，這可能之後有需要的話可以補上。歡迎討論也歡迎在我有空的時候找我幫忙 review 程式碼，這對我來說也是一種成長的來源吧。身邊如果有人願意幫你 review 的話請盡量把握，也在此感謝曾經幫我看過程式碼的貴人們。

# 參考

+ [1]: [把一顆樹寫出來是會有多難](https://yodalee.blogspot.com/2019/11/rust-visitor.html)
+ [2]: [Tearing apart printf()](https://www.maizure.org/projects/printf/index.html?fbclid=IwAR2fPTM7CxfIWD7pC_crmp-UFDPG2RZ7BH-62e-TCjPmxhzwLyT_D7oEYak)
+ [3]: [107.06.18 好看的 gdb, gdb-dashboard](https://aben20807.blogspot.com/2018/06/1070618-gdb-gdb-dashboard.html)
+ [4]: [Makefile for Testing](https://aben20807.github.io/posts/20190216-makefile-for-testing/)
