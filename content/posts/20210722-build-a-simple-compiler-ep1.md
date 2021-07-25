+++
title = "Build a Simple Compiler Ep1"
date = "2021-07-22T18:17:52+08:00"
url = "/posts/20210722-build-a-simple-compiler-ep1"
description = ""
image = "https://images.unsplash.com/photo-1582899973294-9851630b69ec?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1567&q=80"
credit = "https://unsplash.com/photos/icoCwXaxLL8"
thumbnail = ""
comments = true
categories = ["編譯器"]
tags = ["flex", "compiler", "lex", "regexp"]
toc = true
draft = true
+++
<!-- https://drive.google.com/uc?export=view&id= -->

詞法分析器 (Scanner)

<!--more-->

+ Series: [[ep0]]({{< ref "/posts/20210722-build-a-simple-compiler-ep0" >}}), [[ep1]]({{< ref "/posts/20210722-build-a-simple-compiler-ep1" >}}), [[ep2]]({{< ref "/posts/20210722-build-a-simple-compiler-ep2" >}}), [[ep3]]({{< ref "/posts/20210722-build-a-simple-compiler-ep3" >}})
+ Source code: [aben20807/learn_compiler](https://github.com/aben20807/learn_compiler)

# 詞法分析器 (Scanner)

這裡我們不需要像編譯系統的課本或課程中提到的演算法來用 C 語言寫一個詞法分析器，而是利用 flex (lex) 這個詞法分析器產生器，它讓使用者可以用一些高階的定義詞法分析的模式，接著自動產生對應的詞法分析器。

使用這類工具的原因如下:
+ 減少人工撰寫造成的錯誤
+ 開發快速且方便除錯
+ ~~修課學生不是每一個都對編譯器有興趣，但這是必修課~~

然而實際上真實的複雜語言，如 C++、Rust、Go [^1] [^2] [^3] 大多都是手寫來達到更高的設計彈性。

[^1]: https://en.wikipedia.org/wiki/GNU_Bison#Use
[^2]: https://doc.rust-lang.org/nightly/nightly-rustc/src/rustc_lexer/lib.rs.html
[^3]: https://doc.rust-lang.org/nightly/nightly-rustc/src/rustc_parse/lib.rs.html

# flex (lex) 三大區塊

用兩個 `%%` 來作為區隔:
+ Definition section: 又分作兩個小區塊 (可對照下方完整程式碼): %{ 定義標頭檔、全域變數 %}、正規表達式標籤、condition (`%x`) [^cond]、選項 (`%option`) [^opt]
+ Rules section: 定義判斷為 token 的規則。定義的順序會影響優先度所以要考慮是否會覆蓋其他規則，例如關鍵字應該要優先於變數名，否則像是 `decl`, `print` 會被判定為 ident。這同時也是為何 `.` (匹配所有字元) 會放在最下面
+ C Code section: 定義 main 函式、其他函式

[^cond]: https://www.cs.virginia.edu/~cr4bd/flex-manual/Start-Conditions.html
[^opt]: https://www.cs.virginia.edu/~cr4bd/flex-manual/Scanner-Options.html#Scanner-Options

```
<< Definition section >>

%%

<< Rules section >>

%%

<< C Code section >>
```

# 正規表達式

這裡主要利用正規表達式 (Regular Expression, regex, regexp, RE) 來判斷一個輸入中有那些 token，例如 `apple` 不是任何一個保留關鍵字，所以就是一般的變數名稱。由於本系列所採用的是簡化版的語言，變數只有大小寫字母組成，所以這裡就直接定義 `ident` 個標籤負責對應 `{letter}+` 其中 `letter` 對應 a~z 或是 A~Z 其中一個字元。

# 完整程式碼

+ `mycompiler.l`:
```c {linenos=table,linenostart=1}}
/* Definition section */
%{
    #include <stdio.h>

    #define YY_NO_UNPUT
    #define YY_NO_INPUT
%}

/* Define regular expression label */
letter [a-zA-Z]
digit [0-9]
ident {letter}+
num_lit {digit}+

/* Rules section */
%%

"+"         { printf("%-8s \t %s\n", yytext, "ADD"); }
"-"         { printf("%-8s \t %s\n", yytext, "SUB"); }
"*"         { printf("%-8s \t %s\n", yytext, "MUL"); }
"/"         { printf("%-8s \t %s\n", yytext, "DIV"); }
"("         { printf("%-8s \t %s\n", yytext, "LPAR"); }
")"         { printf("%-8s \t %s\n", yytext, "RPAR"); }
"="         { printf("%-8s \t %s\n", yytext, "ASSIGN"); }
"\n"        { printf("%-8s \t %s\n", "\\n", "NEWLINE"); }
"decl"      { printf("%-8s \t %s\n", yytext, "DECL"); }
"print"     { printf("%-8s \t %s\n", yytext, "PRINT"); }
{ident}     { printf("%-8s \t %s\n", yytext, "IDENT"); }
{num_lit}   { printf("%-8s \t %s\n", yytext, "NUMLIT"); }

<<EOF>>     { yyterminate(); }
.           {;}

%%

/*  C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc, char *argv[])
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    yylex();
    printf("\nFinish scanning.");
    fclose(yyin);
    return 0;
}
```

# 測試範例

+ `input/in01.lc`:
```
decl x = 1 + 4
decl y = 2
decl num = x + y * (3 + 5)
print num
```

+ Result (其他檔案，如 Makefile 請參考 Source code):
```
$ make
$ ls
input/  lex.yy.c  Makefile  mycompiler.l  myscanner*
$ ./myscanner < input/in01.lc
decl             DECL
x                IDENT
=                ASSIGN
1                NUMLIT
+                ADD
4                NUMLIT
\n               NEWLINE
decl             DECL
y                IDENT
=                ASSIGN
2                NUMLIT
\n               NEWLINE
decl             DECL
num              IDENT
=                ASSIGN
x                IDENT
+                ADD
y                IDENT
*                MUL
(                LPAR
3                NUMLIT
+                ADD
5                NUMLIT
)                RPAR
\n               NEWLINE
print            PRINT
num              IDENT
\n               NEWLINE

Finish scanning.
```

# References

+ [Lexical Analysis With Flex, for Flex 2.6.2](https://westes.github.io/flex/manual/)
+ [Lexical Analysis With Flex, for Flex 2.6.3](https://www.cs.virginia.edu/~cr4bd/flex-manual/index.html#Top)
+ [westes/flex](https://github.com/westes/flex)
+ [YY_NO_UNPUT, YY_NO_INPUT](https://stackoverflow.com/questions/39075510/option-noinput-nounput-what-are-they-for)