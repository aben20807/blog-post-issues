+++
title = "C++ Get Pretty Type Name"
date = "2020-07-10T13:36:58+08:00"
url = "/posts/20200710-cpp-get-pretty-type-name"
description = ""
image = "https://lh3.googleusercontent.com/pw/ACtC-3cFVFsP6QcLV2K8_d7pOf3SfR4bWEjy5oM8KqVHXHST8h7ysiSwCAJd4-oZOfWB_v54ekhXZ5OSM36lAtLS0EhN-YoDXIkuRVkDPU6sH41P5jrtNhPYsvgnIeg55ZGXouiUQe-vblaoFGLo40Y315J0=w1708-h1112-no"
credit = ""
thumbnail = ""
comments = true
categories = ["程式語言"]
tags = ["c++", "可讀性"]
toc = false
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

最近狂看 C++ 的東西，明明這麼複雜，可是真香 OuO

<!--more-->

# tl;dr

```cpp
#include <typeinfo>
#include <cxxabi.h>

template<typename T>
const std::string get_type_name(const T variable) {
    const char* const name = typeid(variable).name();
    int status = -4;
    char* const demangled_name = abi::__cxa_demangle(name, NULL, NULL, &status);
    std::string ret{name};
    if (status == 0) {
        ret = std::string(demangled_name);
        free(demangled_name);
    }
    return ret;
}
```

# typeid operator

在 `typeinfo` 中有提供 `typeid()` 可以取得 type 或是 expression (variable) 的名字 [^1] 
[^1]: [typeid operator](https://en.cppreference.com/w/cpp/language/typeid)

## Example

```cpp
#include <iostream>
#include <typeinfo>

int main () {
    int a;
    std::cout << typeid(int).name() << '\n';
    std::cout << typeid(a).name() << '\n';
}
```

[[run]](https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(fontScale:14,j:1,lang:c%2B%2B,selection:(endColumn:2,endLineNumber:8,positionColumn:1,positionLineNumber:1,selectionStartColumn:2,selectionStartLineNumber:8,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctypeinfo%3E%0A%0Aint+main+()+%7B%0A++++int+a%3B%0A++++std::cout+%3C%3C+typeid(int).name()+%3C%3C+!'%5Cn!'%3B%0A++++std::cout+%3C%3C+typeid(a).name()+%3C%3C+!'%5Cn!'%3B%0A%7D'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((g:!((h:compiler,i:(compiler:g83,filters:(b:'0',binary:'1',commentOnly:'0',demangle:'0',directives:'0',execute:'0',intel:'0',libraryCode:'1',trim:'1'),fontScale:14,j:1,lang:c%2B%2B,libs:!(),options:'-Ofast',selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:1),l:'5',n:'0',o:'x86-64+gcc+8.3+(Editor+%231,+Compiler+%231)+C%2B%2B',t:'0')),k:50,l:'4',m:78.34710743801652,n:'0',o:'',s:0,t:'0'),(g:!((h:output,i:(compiler:1,editor:1,fontScale:14,wrap:'1'),l:'5',n:'0',o:'%231+with+x86-64+gcc+8.3',t:'0')),header:(),l:'4',m:21.65289256198347,n:'0',o:'',s:0,t:'0')),k:50,l:'3',n:'0',o:'',t:'0')),l:'2',n:'0',o:'',t:'0')),version:4)

不過像是 int 只能顯示 i，其他複雜的顯示也不直觀，主要是因為 C++ 會對於型別做修飾 (Name mangling [^2])，這也是為何 C++ 能夠支援 function overloading，因為編譯過程中型別都會轉成獨一無二的表達方式所以不會造成衝突。

[^2]: [Name mangling](https://en.wikipedia.org/wiki/Name_mangling)

# Demangle

在 `<cxxabi.h>` 中有提供方法可以讓經過 mangle 的型別轉回可讀性較高的字串。以下範例與上述提到的方法進行比較。

```cpp
#include <iostream>
#include <string>
#include <typeinfo>
#include <cxxabi.h>


template<typename T>
const std::string get_type_name(const T variable) {
    const char* const name = typeid(variable).name();
    int status = -4;
    char* const demangled_name = abi::__cxa_demangle(name, NULL, NULL, &status);
    std::string ret{name};
    if (status == 0) {
        ret = std::string(demangled_name);
        free(demangled_name);
    }
    return ret;
}

namespace OuO::QuQ {
    struct Foo { };

    template <unsigned int size>
    struct Bar { };
}
using Foo = OuO::QuQ::Foo;


int main () {
    int a;
    std::cout << typeid(a).name() << '\n';
    std::cout << get_type_name(a) << '\n';

    Foo b;
    std::cout << typeid(b).name() << '\n';
    std::cout << get_type_name(b) << '\n';

    OuO::QuQ::Bar<99> c;
    std::cout << typeid(c).name() << '\n';
    std::cout << get_type_name(c) << '\n';

    return 0;
}
```

[[run]](https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAM1QDsCBlZAQwBtMQBGAFlICsupVs1qhkAUgBMAISnTSAZ0ztkBPHUqZa6AMKpWAVwC2tQVvQAZPLUwA5YwCNMxEAGYA7KQAOqBYXW0eoYmgj5%2BanRWNvZGTi4eisqYqgEMBMzEBEHGppyJKhG0aRkEUXaOzm6eCumZ2SF5NSVlMXFVAJSKqAbEyBwA5FKu1siGWADU4q466jXEmMxGU9jiAAwAgkMjY5iT03PWwMtrm5LDtKMGE1M6BACeXpjWNMcbWxc7ezrIAB4/zA48AA6BCvTZvDYETBGLzCKE3e6PWiLXYAFTBaFoNXGNXQIBAB1E42AmAIAH1EZgycijJgIJjsajxgA3DJ4AHsdqTdyyDbjfnjBkEQUIDIAKkFdGxNN2UwAIuNKXh0BBWcR2Q5OUCZRB2lNeesBeNrMKmgQDAo9gqALTcfUnI3IUXECVC8ZYIwiYDsdDUlFW8YAiggMlk37MMker3sCAy0jjWwAVQsFnjSZT8akADYzRa9a4DUbcfjCcBxvMCOIeTKq3L7XyBXgqOMILnLfL5eNVlyq4WjQKKwHiwSCOrRBAo6IfX7afm%2B/3xlR5nTJ97ML6ZXOHQLa9v%2BRWerRy6T65t3HWIesZQovMw%2BuMAPIGB/4gCKBlf3PnONHBlU4wAMVQVAv25OsCxOPdFWhWFmChL4DCxPBgBsdBjXoHE8AAL0wMEi1/f9pAyUDdwgt5zxOC1DkA4CAyfF8QHfV98SA1BT0gjYTXGT1rBbHseSgrjmFPfC8RQbphRuG5FQeJ4VWYdptRRXUvmksBBgAVh0Wh1JEgVhzQAxJOmaSSXJSkZzpBTVOmcZdK0nTBjI8FDQFVjxgcPT%2BQMiSbJ0GTHmVCAHEUnUexM2z7O03TnNE/FDOMnRTNJClZMs4LwqSyLNOipyDSg%2Bi3w/fEiOIG4AE5yuWQUvJ/MSEr8gK5PpULlMytScsc2qfKMxqzNSx50uQdrsvEByYvyht91JQ8u3Y89%2Bk6VgQH6DT%2BlIUx%2BlWdbUBWpKZDkHFul6WUzk4daCBW7b2k6ABrEANNWIQVu4dbNu20hdv6daFBAJ7Lq2xbSDgWAYEQcSYTwdgyAoelUEh6GQGAAAOVxSCoKGoWIX7gqu9bAWRYg7hW87SDQIxaXoB9aFYYnAdIVd2Dxhm8HmFJmUwX76cwH5kiMgYPpNZRmdYPAHGIDI7j0LASYu9UjFlzoaHoJg2A4Hh%2BEEYRRBQOQ5CEMXfsgTpUC8QouetXF5QkA6ZE4dxxmtB9XB%2BpIUg0CBzHqXJSHMFoKhcPIwn8OhvdCXwQ9of3YkqRo3cKYo6n0HJBCUApUlqUprHKGPA8UTOw8aTPo7aThOgUY6%2Bi4JaVrWjbma%2Bn5kaza0s24YlkGQcZkaBVwW1wQgSEmM74z0BHnGH1wy/GfbZBkC68Zu0h7se57%2Ble0gFazHv3CzVZXFcVYNPcZGNM4SReHenaVp%2Bv7SAB67gbBiAkAkrwjPIShya8KHY99/AiB52VowFgTMNYAHcJZeEVmvOuV9PorSGJwcY4DCAIHGE3FubcO5dx7i7e%2Bi9OgIAWFgFwuo14bwVlPIEZxypZizOVbgkgeDI13kfeu9Mvq33%2BoQ5eD0nrLX6Pg%2BBXCCGAyXoIyQb0G43zEddToHNsYBBANwIAA%3D)

可以從結果看到後者可讀性較高

![封面照片 - 執行結果](https://lh3.googleusercontent.com/pw/ACtC-3cFVFsP6QcLV2K8_d7pOf3SfR4bWEjy5oM8KqVHXHST8h7ysiSwCAJd4-oZOfWB_v54ekhXZ5OSM36lAtLS0EhN-YoDXIkuRVkDPU6sH41P5jrtNhPYsvgnIeg55ZGXouiUQe-vblaoFGLo40Y315J0=w1708-h1112-no)

我發佈後才被 YouTube 推薦...，不過我最近也看一堆他的影片。
{{< youtube "https://www.youtube.com/watch?v=uX99t7GmuDc" >}}

# References
+ [C++ Get name of type in template](https://stackoverflow.com/a/19123821)
+ [Unmangling the result of std::type_info::name](https://stackoverflow.com/a/4541470)