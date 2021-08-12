+++
title = "Use Matplotlib to Plot Academic Figures"
date = "2021-08-12T13:18:37+08:00"
url = "/posts/20210812-use-matplotlib-to-plot-academic-figures"
description = "Use matplotlib and SciencePlots to plot basic academic figures in windows 10 with powershell"
image = "https://lh3.googleusercontent.com/pw/AM-JKLXWLmIX4NOWNKG3tit6cQ4QqxAljv5FeRz38FrMnccL6D7r8D2YVe2MXIeoBizxWh7e_vgOQsorNL5pKIG8FSACeBUnkywjCUdfWh2XZLiGPDY1ku5Y_pbknfw3Aif_71nbMFdRT75hE_uhe7KmK9tL9A=w1891-h1080-no"
credit = ""
thumbnail = ""
comments = true
categories = ["軟體工具"]
tags = ["python", "matplotlib", "powershell"]
toc = true
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

輕鬆畫出有學術質感的圖表

<!--more-->

# 前言

本篇示範一個用 matplotlib 畫一個基本的折線圖，在 ubuntu 跟 windows 10 都有試過，不過本篇以 windows 10 的指令為主。

雖然有想過寫成一個工具，使用者只要提供資料，就可以自動畫出圖。不過後來發現這個想法是不實際，因為每張圖幾乎都需要客製化，所以就改成提供一個模板，要做任何調整會比較方便。

# 安裝套件

## Python3.9

Windows 直接到官網下載即可，Ubuntu 需要使用 PPA[^py39]。

[^py39]: https://tecadmin.net/how-to-install-python-3-9-on-ubuntu-18-04/

{{< summary "示意圖" >}}
![windows python3.9](https://lh3.googleusercontent.com/pw/AM-JKLXjOlfhfiQNgWI02_rZb4Wb574Fu4Wur9o6OKhoyNMjexMuCOxm0CCZcVHN_2J3unY1gLHsXw-brNYZcu-_ZTs391zX9dh568EJUTUZevMF626zka1_CuOirPByW0xVteY8pA5Wj3hcah8FtnX_cDPFsQ=w1705-h1291-no)
{{< /summary >}}

### 安裝 virtualenv 並進入虛擬環境

```powershell
> pip install virtualenv
```

要進入虛擬環境時需要執行 active 的腳本，在 Ubuntu 就很方便執行 `$ source venv/bin/activate`，但是 powershell 有權限問題，所以要先設定[^exec]。
```powershell
> mkdir matplotlib_test
> cd matplotlib_test
> virtualenv --python python3.9 venv
> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
> .\venv\Scripts\activate.ps1
(venv)> pip list
```

![pip list of a clear venv](https://lh3.googleusercontent.com/pw/AM-JKLV60iyL8ezSo7VKOvo5mleP9Ur5NEK2nNV2ABbdR9zMWJZGaaqMQYJLTaQNxPHcPQ56avYFMRh1-cZFBRqFOPDMJbhZ_lMI_UL4ZdddicANA6fAitgOUyzkxRt7ncqv9vVcZuKrkQuuXns2epiRY7NDvw=w624-h148-no)

[^exec]: [virtualenv in PowerShell?](https://stackoverflow.com/a/59815372)

### Matplotlib and SciencePlots

圖表樣式主要靠 SciencePlots[^sc] 來完成，所以我們只要專注使用 Matplotlib 來製作圖表即可。

[^sc]: https://github.com/garrettj403/SciencePlots

```powershell
(venv)> pip install matplotlib==3.4.2
(venv)> pip install SciencePlots==1.0.8
(venv)> pip list # 詳細版本資訊參考用
Package         Version
--------------- -------
cycler          0.10.0
kiwisolver      1.3.1
matplotlib      3.4.2
numpy           1.21.1
Pillow          8.3.1
pip             21.2.3
pyparsing       2.4.7
python-dateutil 2.8.2
SciencePlots    1.0.8
setuptools      57.4.0
six             1.16.0
wheel           0.37.0
```

# 畫圖技巧

強烈建議先去看一下這篇 [matplotlib：先搞明白plt. /ax./ fig再画](https://zhuanlan.zhihu.com/p/93423829)。我原先用 matplotlib 也是亂用，看過之後了解大概的區塊是哪個模組在控制。

下圖的各個部位的名稱可以大概記一下，這樣在搜尋時會比較方便。主要中心思想就是關於實際畫圖的都使用 `ax`，只有在建立跟輸出時才用 `plt`。下方會有範例。
![Parts of a Figure](https://lh3.googleusercontent.com/pw/AM-JKLV39YBiIYsdoJnTbBEfB23amAIXrpG65S-cq4ozucbJ13wlQNkKfsV7w0pWLeCnIDAYgVkj6tTpEv1tIPdm_v5S2Vv8n_Uvw1102twnZMG9OZhC2yxgNj6-c-hFpnRggyEL4nNPjpwzf5-fUcWH0ZUHBg=w385-h401-no) [^p1src]

![components of a Matplotlib figure](https://lh3.googleusercontent.com/pw/AM-JKLX_WJxX_h8KTZjCPicenrC56Y2v4B4Trd6ft1DHJDG_YxycOsar94WCx073O9GWS7wSZZKH0QSSEQrWRAosK3zz16F73MvbT3J0O6ERQB0U2dCbhSis7RlQdWDSG95_TQmYua9DBi3kdTFpw4DmqwtHSA=s800-no) [^p2src]

[^p1src]: https://matplotlib.org/1.5.1/faq/usage_faq.html#parts-of-a-figure
[^p2src]: https://matplotlib.org/stable/tutorials/introductory/usage.html#parts-of-a-figure

# 實際範例

+ `data.csv`:

```txt
n,A,B,C,D
10,1,2,1,6
100,3,3,6,6
1000,2,9,1,6
10000,3,7,7,6
100000,3,10,8,6
1000000,16,19,2,6
10000000,125,86,41,6
```

+ `plot.py`:

```python {linenos=table}
import matplotlib.pyplot as plt
import numpy as np

# Config
fin = "data.csv"
fout = "result.pdf"
x_str = "x label"
y_str = "y label"
title_str = "Title"
col_names =         ['n', 'A', 'B', 'C', 'D'] # cannot contain any special char
col_label_names =   ['A (a)', 'B (b)', 'C']
skip_cols = ['D']
label_cols = ['A', 'C']
add_dot_points = [(10000, 'B'), (1000000, 'A')]
colors = ['red', 'black', 'blue', 'green']

# Read data
table = np.genfromtxt(fin, delimiter=',', skip_header=1, names=col_names)
print(table)

# Plot the figure
with plt.style.context(['science', 'ieee']):
    fig, ax = plt.subplots()

    color_idx = 0
    for i, col_name in enumerate(col_names[1:]):
        if col_name in skip_cols:
            continue
        
        # Plot line
        line = ax.plot(table[col_names[0]], table[col_name], label=col_label_names[i], color=colors[color_idx])
        color_idx += 1

        # Plot data label
        if col_name in label_cols:
            for x, y in zip(table[col_names[0]], table[col_name]):
                ax.annotate(f"{y:.1f}", xy=(x-0.0*x, y-0.2*y), textcoords='data', fontsize=4, color=line[0].get_color())
        
        # Plot special points
        for x, y in zip(table[col_names[0]], table[col_name]):
            if (x, col_name) in add_dot_points:
                ax.plot(x, y, marker=".", markersize=4, color=line[0].get_color())


    ax.legend(fontsize=6) # according to col_label_names
    # ax.set_title(title_str) # not used by default
    # x, y label
    ax.set_xlabel(x_str, fontsize=6)
    ax.set_ylabel(y_str, fontsize=7)

    # x, y tick
    ax.set_xscale('log', base=2)
    ax.set_yscale('log')
    ax.xaxis.set_tick_params(labelsize=5)
    ax.yaxis.set_tick_params(labelsize=5)
    ax.yaxis.tick_left()

    ax.autoscale()
    plt.tight_layout()
    # plt.show()
    plt.savefig(fout, bbox_inches='tight')
```

+ 程式碼解釋
    + [10], [11] 會有兩個 name 主要是因為讀取時的欄位名稱不能有特殊符號，所以在繪製時才綁定顯示名稱 [31]
    + [12] 某些資料要跳過但是檔案裡還是會有
    + [13] 哪些需要標出資料標籤的數值
    + [14] 哪些資料點需要特別用圓點標記
    + [37] `f"{y:.1f}"` 可設定資料標籤輸出格式，例如: 取到小數點第一位。`x-0.0*x, y-0.2*y` 後方有減去一個位移是用來避免線段與資料標籤重疊
    + [46] 一般論文中的圖表標題是用 Latex 語法 (caption) 來定義，所以生成時不需要，不過若是要拿來做簡報的話有標題會比較好。
    + [48] ~ [56] 設定 x、y 軸資訊
    + [61] 存成 pdf
+ 成果
![折線圖](https://lh3.googleusercontent.com/pw/AM-JKLVRuXJ_D4kAHvBiLUnd0ZWrsFPlulrVEN38RvmizykmT85sxj3YvLEKvhSlvPg3TuEArI9VyFbEMxSUnTH0x6I3U1IR1ulU_xDOpyiZa-yO9KTioHJLjxhOVzzc4S559_IPZY_kdHSszjQhDndC8PtUYw=w1738-h1301-no)

# 其他

用 Matplotlib 在一個 Figure 中塞入多個 Axes 是可以的，不過我目前遇到的都是用 Latex 的 minipage 來完成，這樣就可以有各自的 label 可以分開 ref。如下，不過這就有點離題了。

```latex
\begin{table}[tbh!]
  \centering
  \begin{minipage}[t]{.47\linewidth}
    \includegraphics[width=\linewidth]{figures/A.pdf}
    \captionof{figure}{AAA}
    \label{fig:A}
  \end{minipage}
  \qquad
  \begin{minipage}[t]{.47\linewidth}
    \includegraphics[width=\linewidth]{figures/B.pdf}
    \captionof{figure}{BBB}
    \label{fig:B}
  \end{minipage}
\end{table}
```

# 錯誤排除

## `FileNotFoundError: missing font metrics file: rsfs10`

Solution [^sol1]
```powershell
> miktex-maketfm.exe rsfs10
```

[^sol1]: https://stackoverflow.com/a/65965075


## `PermissionError: [Errno 13] Permission denied: 'result.pdf'`

輸出覆寫 pdf 時有視窗開著該檔案，把 result.pdf 關掉即可。