+++
title = 'Makefile for Testing'
date = "2019-02-16T10:00:48+08:00"
url = "/posts/20190216-makefile-for-testing"
description = ""
image = ""
credit = ""
thumbnail = ""
comments = true
categories = ["程式語言"]
tags = ["makefile"]
draft = false
toc = true
+++

Makefile 可以執行終端機的指令，所以也可以搭配重新導向 (redirection) 用來做簡單測試

例如：
```make
test:
    ./a.out < input.txt > output.txt
```

這樣只需要用 `$ make test` 就可以測試輸入 input.txt，並把結果存到 output.txt

<!--more-->

# 舊方法

不過若是有很多種輸入測資的話會有點麻煩，當然還是可以寫成這樣
```make
test1:
    ./a.out < input1.txt > output1.txt

test2:
    ./a.out < input2.txt > output2.txt

test3:
    ./a.out < input3.txt > output3.txt
```

或是
```make
test:
    ./a.out < input1.txt > output1.txt
    ./a.out < input2.txt > output2.txt
    ./a.out < input3.txt > output3.txt
```

這樣寫的缺點就是每次測資增加的時候舊需要修改 Makefile

# Makefile 內建函式
不過其實有更好的寫法，利用 makefile 內建的函式
```make
INPUT_DIR = input/linux/
INPUTS = $(wildcard $(INPUT_DIR)*.txt)
OUTPUT_DIR = output/linux/
OUTPUTS = $(addprefix $(OUTPUT_DIR),$(notdir $(INPUTS)))
```

+ `wildcard`: 獲取輸入檔案列表
+ `notdir`: 獲得檔案名稱 (去掉前面路徑)
+ `addprefix`: 加上前綴 (修改輸出路徑)

這樣的優點就是只要 input/linux/ 中有多的 .txt 檔就會自動加入測試，不需要修改 Makefile

# 完整範例

## 檔案們

### `t.c`:

```c
#include <stdio.h>

int main() {
    int a, b;
    scanf("%d%d", &a, &b);
    printf("%d\n", a + b);
    return 0;
}
```

### `Makefile`:

```make
CC = gcc
EXEC = a.out

INPUT_DIR = input/linux/
INPUTS = $(wildcard $(INPUT_DIR)*.txt)
OUTPUT_DIR = output/linux/
OUTPUTS = $(addprefix $(OUTPUT_DIR),$(notdir $(INPUTS)))
.PHONY: all, test, mk_parent_dir

all: $(EXEC)

mk_parent_dir:
    @mkdir -p $(OUTPUT_DIR)

test: mk_parent_dir $(OUTPUTS)

$(OUTPUT_DIR)%.txt: $(INPUT_DIR)%.txt $(EXEC)
    ./a.out < $< > $@
    @cat $< $@ # cat the content of file

$(EXEC): t.c
    $(CC) t.c

clean:
    rm -rf $(OUTPUT_DIR) a.out
```

### 檔案架構

```
$ tree .
.
├── input
│   └── linux
│       ├── test1.txt
│       ├── test2.txt
│       └── test3.txt
├── Makefile
├── output
└── t.c
```

## 使用

### 指令同為 `$ make test`

```bash
$ make test
gcc t.c
./a.out < input/linux/test2.txt > output/linux/test2.txt
1 6
7
./a.out < input/linux/test3.txt > output/linux/test3.txt
78 99
177
./a.out < input/linux/test1.txt > output/linux/test1.txt
3 4
7
```

### 結果檔案架構

```
$ tree .
.
├── a.out
├── input
│   └── linux
│       ├── test1.txt
│       ├── test2.txt
│       └── test3.txt
├── Makefile
├── output
│   └── linux
│       ├── test1.txt
│       ├── test2.txt
│       └── test3.txt
└── t.c
```

# 後記

上面的簡單例子中可能看不出 `$(INPUTS)` 跟 `$(OUTPUTS)` 的用途，不過在相依多的話可以直接代表全部的檔案，但若是需要做名稱配對的話還是需要 `%` 出馬，就像 `$(OUTPUT_DIR)%.txt: $(INPUT_DIR)%.txt` 來表示輸入輸出的檔名要一致。
