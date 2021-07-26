+++
title = "Build a Simple Compiler Ep2"
date = "2021-07-22T19:17:52+08:00"
url = "/posts/20210722-build-a-simple-compiler-ep2"
description = ""
image = "https://images.unsplash.com/photo-1445294211564-3ca59d999abd?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1567&q=80"
credit = "https://unsplash.com/photos/zThTy8rPPsY"
thumbnail = ""
comments = true
categories = ["編譯器"]
tags = ["flex", "bison", "compiler", "lex", "yacc", "jvm"]
toc = true
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

語法剖析器 (Parser)

<!--more-->

+ Series: [[ep0]]({{< ref "/posts/20210722-build-a-simple-compiler-ep0" >}}), [[ep1]]({{< ref "/posts/20210722-build-a-simple-compiler-ep1" >}}), [[ep2]]({{< ref "/posts/20210722-build-a-simple-compiler-ep2" >}}), [[ep3]]({{< ref "/posts/20210722-build-a-simple-compiler-ep3" >}})
+ Source code: [aben20807/learn_compiler](https://github.com/aben20807/learn_compiler)

{{< alert info >}}
從文章長度跟作業繳交期限就可以知道 parser 的難度遠大於 scanner，所以請提早動手開始，~~雖然不斷宣導下還是一定有人會不信邪前一個禮拜才開始~~。
{{< /alert >}}
# 語法剖析器 (Parser)

與詞法分析器 (Scanner) 相同，這裡我們仰賴語法剖析器產生器來建構符合我們定義文法的語法剖析器。

由於我們再來會使用到的 JVM 功能是屬於 stack-based 的 virtual machine [^jvm]，所以在語法剖析時就要預先考慮產生對應的指令順序。

[^jvm]: https://en.wikipedia.org/wiki/Stack_machine#Virtual_stack_machines

## bison (yacc) 三大區塊

這裡其實與上一篇幾乎相同 (用 `%%` 切了三個區塊出來)，只是中間區塊從 Rules section 換成 Grammar section，用來定義文法。

寫法如下，其實跟課本學到的文法表示差不多只是換個符號表示。

```c
Parent
    : Child1 Child2 Child3
    | Child4
;
```

## Action

Action [^act] 可以在 parse 過程中插入某些定義的動作，如下方程式範例中大括號部分。可以看到並不限於在最後方加上，也可以在 child 間加上 action。所以在建構不同層的 symbol table 時可以利用這個特性。

[^act]: https://thiagoh.github.io/bison/#Actions

```c
Parent
    : Child1 {
        printf("after reducing Child1; before reducing Parent");
    } Child2 Child3 {
        printf("reduce Parent!");
    }
    | Child4 {
        printf("reduce Parent from Child4");
    }
;
```

## 利用 Semantic value 將下方資訊向上傳遞

為了向上傳遞資訊，bison (yacc) 提供了這項功能，讓下方的 action 可以用 `$$` 來作為回傳值，而上方的 action 可以用 `$1`, `$2` 來存取對應來自下方的回傳值。要使用這項功能需要注意需要在 Definition section 宣告相關的型別 (包含 `%union`, `%token`, `%type`) [^sem][^fea]。另外，數字所表示的位子需要把 action 也計算進去，如下方範例第一個 rule `$1` 來自 `Child1`; `$2` 來自 `Child1` 的 action, `$3` 來自 `Child2`, `$4` 來自 `Child3`。換 rule 則再從 1 開始，如 `$1` 來自 `Child4`。

[^sem]: https://thiagoh.github.io/bison/#Action-Types
[^fea]: https://thiagoh.github.io/bison/#Action-Features

```c
Parent
    : Child1 {
        printf("after reducing Child1; before reducing Parent");
    } Child2 Child3 {
        $$ = 123 + $1 + $3 + $4;
        printf("reduce Parent!");
    }
    | Child4 {
        $$ = 4 + $1;
        printf("reduce Parent from Child4");
    }
;
```

# Symbol table

由於硬體 (或是虛擬機器) 是看不懂你程式所寫的 `x`, `y` 變數，所以編譯器需要給這些變數一個位址 (address) 或是參考 (reference) 來代表不同的變數 (因為 JVM 常用參考來說明，所以這裡以後者來表示這個專有名詞)，因此 symbol table 最大用意就在生成 "變數" 與 "參考" 的一對一對應表，當有 scope 的概念時必須考慮變數是否在外層已經被定義並且從中獲取對應的參考，再來就是作業會遇到的內容就不多加贅述，不過可以提示: 是要利用 linked list 來實作 (沒意外大二資料結構就教過)。

# Stack-based

## 運算範例

利用 Stack-based 的運算可以大幅減少硬體的相依性，也因為 JVM 採用這個運算模式，所以我們產生的指令需要符合可執行的順序。下圖簡單示範一個加法的運作流程，左方為對應的虛擬指令，①: 第 1,2 行會把 x 變數存放的值放入 stack；②: y 也放入後遇到第 5 行的加法運算，因此將 stack 中兩個值 pop 出來進行加法運算；③: 最後將運算結果放回。

![Stack 版本的運算](https://lh3.googleusercontent.com/pw/AM-JKLVeUXwOtg_rkDa19Jd4yQ7AT2_7Ijf_6iQhaDiplgQf4-ZrvVvvl50lP0o2d3aime409KsaCtxmeyr4VN5_jZNaiFm0fBwazef5yNccep0_4hCuYok2BtO8qH9eMgOF_za2GpGjZONQGY-C6f40kMuFhQ=w611-h332-no)

__進階版本__ `decl num = x + y * (3 + 5)` 應該要產生如下的指令順序，則在 JVM 執行流程會是: 第一個遇到的運算是 `ADD`，所以 `3`、`5` 做完後放回 `8`，再來是 `MUL`，就是剛剛放回的 `8` 與 `y`，依此類推，最後才將結果存到 `num` 中

```
IDENT x, ref: 0
LOAD
IDENT y, ref: 1
LOAD
NUMLIT 3
NUMLIT 5
ADD
MUL
ADD
IDENT num, ref: 2
STORE
```

## 轉成 stack-based 順序

這裡就不包含詳細的從頭教學，這裡示範怎麼透過 action 來將原先的順序轉換成 stack-baced 順序。根據輸入的字串 `x * 2`，parser 會以同樣的順序跑過，符合可以 reduce 時才會向上合併，例如，`MulExpr` (從 `IDENT` ① 來), `MulOp`, `Operand` (從 `NUMLIT` ② 來) 都走過就會 reduce 成 `MulExpr` 接著執行它的 action ③。為了在 ③ 才印出運算子，這裡我們需要在 ③ 時知道下方上來的運算子是哪一個，因此利用上面提到的 [Semantic value](#利用-semantic-value-將下方資訊向上傳遞) 來傳遞 (注意 `%union` 中有 `op` 這個欄位，中間使用到 `\$<op>\$` 代表指定的回傳型別) 讓 ③ 的 `\$2` 獲得運算子資訊。所以就會達到先印出 `x` 的參考及數字 `2` 後再印出運算子類型。

![action 被執行的步驟](https://lh3.googleusercontent.com/pw/AM-JKLW6ZMC2XfsnZg8jHI64e3dKCSezHqXX3QGtvRlmC9ZN2z8isdz0fU7BpkalJRei9VrdiOMPcYX1J_cacpu3iiXN3EZaQPNdEoc72iKKLKHpykzNxfMX7wjvUHBtGh18vRx389qK2SxuOU-028GIcUStCw=w1371-h821-no)

# 程式碼除錯

有時候想要確認 shift、reduce 的中間過程可以加入下方兩行程式，不過就需要自行簡化輸入的程式不然會資訊量過多難以觀察。

```c
#define YYDEBUG 1
int yydebug = 1;
```

## 測試範例

```
decl x = 2
```

{{< summary "輸出內容太多請點擊查看" >}}
```
$ ./mycompiler < input/in02.cl
> Create symbol table
Starting parse
Entering state 0
Reading a token: Next token is token DECL ()
Shifting token DECL ()
Entering state 1
Reading a token: Next token is token IDENT ()
Shifting token IDENT ()
Entering state 8
Reading a token: Next token is token '=' ()
Shifting token '=' ()
Entering state 18
Reading a token: Next token is token NUMLIT ()
Shifting token NUMLIT ()
Entering state 9
Reducing stack by rule 17 (line 166):
   $1 = token NUMLIT ()
NUMLIT 2
-> $$ = nterm Operand ()
Stack now 0 1 8 18
Entering state 15
Reducing stack by rule 14 (line 153):
   $1 = nterm Operand ()
-> $$ = nterm MulExpr ()
Stack now 0 1 8 18
Entering state 14
Reading a token: Next token is token NEWLINE ()
Reducing stack by rule 10 (line 136):
   $1 = nterm MulExpr ()
-> $$ = nterm AddExpr ()
Stack now 0 1 8 18
Entering state 13
Next token is token NEWLINE ()
Reducing stack by rule 8 (line 128):
   $1 = nterm AddExpr ()
-> $$ = nterm Expression ()
Stack now 0 1 8 18
Entering state 27
Next token is token NEWLINE ()
Shifting token NEWLINE ()
Entering state 31
Reducing stack by rule 6 (line 109):
   $1 = token DECL ()
   $2 = token IDENT ()
   $3 = token '=' ()
   $4 = nterm Expression ()
   $5 = token NEWLINE ()
> Insert {x} into symbol table; assign it as ref {0}
IDENT x, ref: 0
STORE
-> $$ = nterm DeclStmt ()
Stack now 0
Entering state 6
Reducing stack by rule 4 (line 104):
   $1 = nterm DeclStmt ()
-> $$ = nterm Statement ()
Stack now 0
Entering state 5
Reading a token: Now at end of input.
Reducing stack by rule 3 (line 100):
-> $$ = nterm StatementList ()
Stack now 0 5
Entering state 17
Reducing stack by rule 2 (line 99):
   $1 = nterm Statement ()
   $2 = nterm StatementList ()
-> $$ = nterm StatementList ()
Stack now 0
Entering state 4
Reducing stack by rule 1 (line 95):
   $1 = nterm StatementList ()
-> $$ = nterm Program ()
Stack now 0
Entering state 3
Now at end of input.
Shifting token $end ()
Entering state 16
Stack now 0 3 16
Cleanup: popping token $end ()
Cleanup: popping nterm Program ()
> Dump symbol table
Total lines: 2
```
{{< /summary >}}
# 完整程式碼

{{< alert danger >}}
下方程式碼的 symbol table 為求簡單所以使用一維陣列實作，僅適用於本範例，容易造成記憶體錯誤且無法套用至多層級的 scope，所以請勿學習。
{{< /alert >}}

+ `mycompiler.y`:

```c
/*	Definition section */
%{
    // Extern variables that communicate with lex
    #include "common.h" 
    // #define YYDEBUG 1
    // int yydebug = 1;

    extern int yylineno;
    extern int yylex();
    extern FILE *yyin;

    void yyerror (char const *s)
    {
        printf("error:%d: %s\n", yylineno, s);
    }


    /* Symbol table function */
    static void create_symbol(/* ... */);
    static int insert_symbol(const char* id_name);
    static int lookup_symbol(const char* id_name);
    static void dump_symbol();

    /* Global variables */
    int example_symbol_cnt = 0;
    #define MAX_SYMBOL_NUM 10
    char *example_symbol[MAX_SYMBOL_NUM] = {};

    const char* get_op_name(op_t op) {
        switch (op) {
            case OP_ADD:
                return "ADD";
            case OP_SUB:
                return "SUB";
            case OP_MUL:
                return "MUL";
            case OP_DIV:
                return "DIV";
            default:
                return "unknown";
        }
    }
%}

%error-verbose

/* Use variable or self-defined structure to represent
 * nonterminal and token type
 */
%union {
    int val;
    char *id_name;
    op_t op;
}

/* Token without return */
%token DECL PRINT NEWLINE

/* Token with return, which need to sepcify type */
%token <val> NUMLIT
%token <id_name> IDENT

/* Nonterminal with return, which need to sepcify type */
%type <op> AddOp MulOp

/* Yacc will start at this nonterminal */
%start Program

/* Grammar section */
%%

Program
    : StatementList
;

StatementList
    : Statement StatementList
    |
;

Statement
    : DeclStmt
    | PrintStmt
;

DeclStmt
    : DECL IDENT '=' Expression NEWLINE {
        int ref = insert_symbol($<id_name>2);
        printf("IDENT %s, ref: %d\n", $<id_name>2, ref);
        printf("STORE\n");
        free($<id_name>2);
    }
;

PrintStmt
    : PRINT Expression NEWLINE {
        printf("PRINT\n");
    }
;

Expression
    : AddExpr
;

AddExpr
    : AddExpr AddOp MulExpr {
        printf("%s\n", get_op_name($<op>2));
    }
    | MulExpr
;

AddOp
    : '+'  {
        $<op>$ = OP_ADD;
    }
    | '-' {
        $<op>$ = OP_SUB;
    }
;

MulExpr
    : MulExpr MulOp Operand {
        printf("%s\n", get_op_name($<op>2));
    }
    | Operand
;

MulOp
    : '*' {
        $<op>$ = OP_MUL;
    }
    | '/' {
        $<op>$ = OP_DIV;
    }
;

Operand
    : NUMLIT {
        printf("NUMLIT %d\n", $<val>1);
    }
    | IDENT {
        int ref = lookup_symbol($<id_name>1);
        printf("IDENT %s, ref: %d\n", $<id_name>1, ref);
        printf("LOAD\n");
        free($<id_name>1);
    }
    | '(' Expression ')'
;


%%

/* C code section */
int main(int argc, char *argv[])
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }

    create_symbol();
    yyparse();
    dump_symbol();

    fclose(yyin);    
    printf("Total lines: %d\n", yylineno);
    return 0;
}

static void create_symbol()
{
    printf("> Create symbol table\n");
    // do nothing...
}

static int insert_symbol(const char* id_name)
{
    printf("> Insert {%s} into symbol table; assign it as ref {%d}\n", 
        id_name, example_symbol_cnt);
    example_symbol[example_symbol_cnt] = strdup(id_name);
    example_symbol_cnt++;
    return example_symbol_cnt - 1;
}

static int lookup_symbol(const char* id_name)
{
    printf("> Lookup in symbol table\n");
    for (int i = 0; i < example_symbol_cnt; i++) {
        if (strcmp(id_name, example_symbol[i]) == 0) {
            return i;
        }
    }
    printf("{%s} not found in symbol table\n", id_name);
    return -1;
}
static void dump_symbol()
{
    printf("> Dump symbol table\n");
    for (int i = 0; i < example_symbol_cnt; i++) {
        free(example_symbol[i]);
    }
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
$ ./myparser < input/in01.lc
> Create symbol table
NUMLIT 1
NUMLIT 4
ADD
> Insert {x} into symbol table; assign it as ref {0}
IDENT x, ref: 0
STORE
NUMLIT 2
> Insert {y} into symbol table; assign it as ref {1}
IDENT y, ref: 1
STORE
> Lookup in symbol table
IDENT x, ref: 0
LOAD
> Lookup in symbol table
IDENT y, ref: 1
LOAD
NUMLIT 3
NUMLIT 5
ADD
MUL
ADD
> Insert {num} into symbol table; assign it as ref {2}
IDENT num, ref: 2
STORE
> Lookup in symbol table
IDENT num, ref: 2
LOAD
PRINT
> Dump symbol table
Total lines: 5
```

# References

+ [Bison 3.0.4 Manual](https://thiagoh.github.io/bison/)