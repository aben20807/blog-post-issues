+++
title = "Build a Simple Compiler Ep3"
date = "2021-07-22T20:17:52+08:00"
url = "/posts/20210722-build-a-simple-compiler-ep3"
description = ""
image = "https://images.unsplash.com/photo-1534631615537-d8f2af94b6ae?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80"
credit = "https://unsplash.com/photos/sZ9JQScjFfA"
thumbnail = ""
comments = true
categories = ["編譯器"]
tags = ["flex", "bison", "compiler", "lex", "yacc", "jvm", "bytecode"]
toc = true
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

指令生成 (Codegen)

<!--more-->

+ Series: [[ep0]]({{< ref "/posts/20210722-build-a-simple-compiler-ep0" >}}), [[ep1]]({{< ref "/posts/20210722-build-a-simple-compiler-ep1" >}}), [[ep2]]({{< ref "/posts/20210722-build-a-simple-compiler-ep2" >}}), [[ep3]]({{< ref "/posts/20210722-build-a-simple-compiler-ep3" >}})
+ Source code: [aben20807/learn_compiler](https://github.com/aben20807/learn_compiler)

# 指令生成 (Codegen)

~~由於是簡化版的編譯器~~，我們不產生中間的表達式 (Intermediate representation, IR) [^ir]，也不會有 Abstract syntax tree (AST) [^ast]，而是直接利用上一篇的螢幕輸出改成對應的 Java bytecode 指令 [^bc]。有興趣的可以去參考完整列表 [^list] 看有支援什麼神奇功能。會寫 Java 的也可以參考如何使用反組譯的方式 [^rev] 找出對應的 bytecode 來觀察行為。

# Jasmin

Jasmin [^jasmin] 為一 JVM 的組譯器，其會將可讀指令形式的 bytecode 轉換成 .class 的形式 (可執行的 bytecode)。

## `.j` 檔格式

+ 開頭及結尾如下，只需要在一開始開檔時就寫入開頭，等到全部指令產生完畢，離開前再寫入結尾即可。

```asm
.source bytecode.j
.class public Main
.super java/lang/Object
.method public static main([Ljava/lang/String;)V
.limit stack 10
.limit locals 10
    
    ; generated instructions
	
    return
.end method

```

# 完整程式碼

仔細看的話就會發現跟 ep2 的程式碼幾乎差不多，只有加了寫檔把對應操作的指令寫入 bytecode.j。

{{< alert danger >}}
下方程式碼的 symbol table 為求簡單所以使用一維陣列實作，僅適用於本範例，容易造成記憶體錯誤且無法套用至多層級的 scope，所以請勿學習。
{{< /alert >}}

+ `mycompiler.y`:

```c
/*	Definition section */
%{
    //Extern variables that communicate with lex
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

    #define codegen(...) \
        do { \
            for (int i = 0; i < indent_cnt; i++) { \
                fprintf(fout, "\t"); \
            } \
            fprintf(fout, __VA_ARGS__); \
        } while (0)


    /* Symbol table function */
    static void create_symbol(/* ... */);
    static int insert_symbol(const char* id_name);
    static int lookup_symbol(const char* id_name);
    static void dump_symbol();
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
    const char* get_op_instruction(op_t op) {
        switch (op) {
            case OP_ADD:
                return "iadd";
            case OP_SUB:
                return "isub";
            case OP_MUL:
                return "imul";
            case OP_DIV:
                return "idiv";
            default:
                return "unknown";
        }
    }

    /* Global variables */
    int example_symbol_cnt = 0;
    #define MAX_SYMBOL_NUM 10
    char *example_symbol[MAX_SYMBOL_NUM] = {};
    int indent_cnt = 0; // control the number of ident in bytecode
    FILE* fout = NULL;
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
        codegen("istore %d\n", ref);
    }
;

PrintStmt
    : PRINT Expression NEWLINE {
        printf("PRINT\n");
        codegen("getstatic java/lang/System/out Ljava/io/PrintStream;\n");
        codegen("swap\n");
        codegen("invokevirtual java/io/PrintStream/print(I)V\n");
    }
;

Expression
    : AddExpr
;

AddExpr
    : AddExpr AddOp MulExpr {
        printf("%s\n", get_op_name($<op>2));
        codegen("%s\n", get_op_instruction($<op>2));
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
        codegen("%s\n", get_op_instruction($<op>2));
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
        codegen("ldc %d\n", $<val>1);
    }
    | IDENT {
        int ref = lookup_symbol($<id_name>1);
        printf("IDENT %s, ref: %d\n", $<id_name>1, ref);
        printf("LOAD\n");
        free($<id_name>1);
        codegen("iload %d\n", ref);
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

    /* Codegen output init */
    char *bytecode_filename = "bytecode.j";
    fout = fopen(bytecode_filename, "w");
    codegen(".source bytecode.j\n");
    codegen(".class public Main\n");
    codegen(".super java/lang/Object\n");
    codegen(".method public static main([Ljava/lang/String;)V\n");
    codegen(".limit stack 10\n");
    codegen(".limit locals 10\n");
    indent_cnt++;

    create_symbol();
    yyparse();
    dump_symbol();

    /* Codegen end */
    codegen("return\n");
    indent_cnt--;
    codegen(".end method\n");
    fclose(fout);
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


[^ir]: https://en.wikipedia.org/wiki/Intermediate_representation
[^ast]: https://en.wikipedia.org/wiki/Abstract_syntax_tree
[^bc]: https://en.wikipedia.org/wiki/Java_bytecode
[^list]: [Java bytecode instruction listings](https://en.wikipedia.org/wiki/Java_bytecode_instruction_listings)
[^rev]: https://github.com/aben20807/blog-post/issues/105
[^jasmin]: http://jasmin.sourceforge.net/guide.html

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
$ ./mycompiler < input/in01.lc
$ java -jar jasmin.jar -g bytecode.j
Generated: Main.class
$ java Main
21
```