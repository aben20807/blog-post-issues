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
draft = true
+++
<!-- https://drive.google.com/uc?export=view&id= -->

指令生成 (Codegen)

<!--more-->

+ Series: [[ep0]]({{< ref "/posts/20210722-build-a-simple-compiler-ep0" >}}), [[ep1]]({{< ref "/posts/20210722-build-a-simple-compiler-ep1" >}}), [[ep2]]({{< ref "/posts/20210722-build-a-simple-compiler-ep2" >}}), [[ep3]]({{< ref "/posts/20210722-build-a-simple-compiler-ep3" >}})
+ Source code: [aben20807/learn_compiler](https://github.com/aben20807/learn_compiler)

# 指令生成 (Codegen)

~~由於是簡化版的編譯器~~，我們不產生中間的表達式 (Intermediate representation, IR) [^ir]，也不會有 Abstract syntax tree (AST) [^ast]，而是直接利用上一篇的螢幕輸出改成對應的 Java bytecode 指令 [^bc]。有興趣的可以去參考完整列表 [^list] 看有支援什麼神奇功能。會寫 Java 的也可以參考如何使用反組譯的方式 [^rev] 找出對應的 bytecode 來觀察行為。

# Jasmin

Jasmin [^jasmin] 為一 JVM 的組譯器，其會將可讀指令形式的 bytecode 轉換成 .class 的形式 (可執行的 bytecode)


[^ir]: https://en.wikipedia.org/wiki/Intermediate_representation
[^ast]: https://en.wikipedia.org/wiki/Abstract_syntax_tree
[^bc]: https://en.wikipedia.org/wiki/Java_bytecode
[^list]: [Java bytecode instruction listings](https://en.wikipedia.org/wiki/Java_bytecode_instruction_listings)
[^rev]: https://github.com/aben20807/blog-post/issues/105
[^jasmin]: http://jasmin.sourceforge.net/guide.html

# 測試範例