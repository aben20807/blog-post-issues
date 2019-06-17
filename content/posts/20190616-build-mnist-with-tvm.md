+++
title = "Build MNIST with TVM"
date = "2019-06-16T17:40:59+08:00"
url = "/posts/20190616-build-mnist-with-tvm"
description = ""
image = "https://drive.google.com/uc?export=view&id=1qSdoAYPCxNk5tlI0ELivCieDWCQO9IOV"
credit = ""
thumbnail = ""
comments = true
categories = ["深度學習"]
tags = ["dnn", "python", "tvm", "keras", "mnist"]
toc = true
draft = false
+++
<!-- https://drive.google.com/uc?export=view&id= -->

真的是隔很久....藉口就不多說了 OuO

這篇主要在造輪子，主要原因就是幾乎找不到這類輪子了，而剛好自己需要，又卡了很久才完成，不如記錄一下 OuO

<!--more-->

# 前言

最近在做 TVM 相關的事，它支援頗多前端，基於方便我就隨便挑一個 Keras 了 (先說我不會 AI @@  
然後因為現在頗多都在做 ImageNet 或更之後的應用，MNIST 的資料反而偏少，尤其是幾乎找不到訓練好的模型，說幾乎是因為還真的被我找到，傳送門：[EN10/KerasMNIST](https://github.com/EN10/KerasMNIST)，如果只是要用 Keras 來操作 MNIST 的話可以用這個連結，我已經確認過是可以直接執行XDD

~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-  
2019.06.17 更新：扯，原來官網就有....https://keras.io/examples/mnist_cnn/  
然後我發現我整篇都把 MNIST 打成 MINST....  
~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-  

話說原本以為模型被存成檔案的話只有權重，結果是有兩種，也可以跟整個模型存在一起，詳情就去 Keras 官網 [How can I save a Keras model?](https://keras.io/getting-started/faq/#how-can-i-save-a-keras-model) 看看吧。

所以上面那個做 MNIST 的是把整個模型存起來，這主要不是我要的＠＠，不過還是先用看看。

P.S. 一些相依性檔案例如 Keras, Tensorflow, TVM 的安裝就不一一記錄囉 OuO

# 環境

+ ubuntu 18.04
+ TVM 0.6.dev (6a4d71ff40915611bd42b62994992b879e6be610)

# 一堆程式碼上菜囉

## 原始 `cnnPredict.py`
注意要下載或複製那個程式碼，`cnn.h5` 跟 `test3.png` 一樣要放對位置。
```python
from scipy.misc import imread, imresize
import numpy as np
x = imread('test3.png',mode='L')
# Compute a bit-wise inversion so black becomes white and vice versa
x = np.invert(x)
# Make it the right size
x = imresize(x,(28,28))
# Convert to a 4D tensor to feed into our model
x = x.reshape(1,28,28,1)
x = x.astype('float32')
x /= 255

# Perform the prediction
from keras.models import load_model
model = load_model('cnn.h5')
out = model.predict(x)
print(np.argmax(out))
```
很好，可以執行～
```bash
$ python3 cnnPredict.py
3
```

## 加入 TVM 囉
```python
import nnvm
import tvm
import tvm.relay as relay
from scipy.misc import imread, imresize
import numpy as np
import keras
from keras.models import load_model

x = imread('test3.png',mode='L')
# Compute a bit-wise inversion so black becomes white and vice versa
x = np.invert(x)
# Make it the right size
x = imresize(x,(28,28))
# Convert to a 4D tensor to feed into our model
x = x.reshape(1,28,28,1)
x = x.astype('float32')
x /= 255

# Load model from pre-trained file
model = load_model('cnn.h5')

# Compile with tvm
shape_dict = {'input_1': (1, 1, 28, 28)}
func, params = relay.frontend.from_keras(model, shape_dict)
target = "llvm"
ctx = tvm.cpu(0)
with relay.build_config(opt_level=3):
    executor = relay.build_module.create_executor('graph', func, ctx, target)

# Perform the prediction
dtype = 'float32'
tvm_out = executor.evaluate(func)(tvm.nd.array(x.astype(dtype)), **params)
print(np.argmax(tvm_out.asnumpy()[0]))
```
```bash
$ python3 cnnPredict_tvm.py
In `main`: 
v0.0.1
fn (%conv2d_1_input, %v_param_1: Tensor[(32, 1, 3, 3), float32], %v_param_2: Tensor[(32,), float32], %v_param_3: Tensor[(64, 32, 3, 3), float32], %v_param_4: Tensor[(64,), float32], %v_param_5: Tensor[(128, 9216), float32], %v_param_6: Tensor[(128,), float32], %v_param_7: Tensor[(10, 128), float32], %v_param_8: Tensor[(10,), float32]) {
  %0 = nn.conv2d(%conv2d_1_input, %v_param_1, channels=32, kernel_size=[3, 3])
  %1 = nn.bias_add(%0, %v_param_2)
  %2 = nn.relu(%1)
  %3 = nn.conv2d(%2, %v_param_3, channels=64, kernel_size=[3, 3])
  %4 = nn.bias_add(%3, %v_param_4)
  %5 = nn.relu(%4)
  %6 = nn.max_pool2d(%5, pool_size=[2, 2], strides=[2, 2])an internal invariant was violated while typechecking your program [22:05:21] tvm/src/relay/op/nn/pooling.cc:73: Check failed: data != nullptr: 
; 
  %7 = transpose(%6, axes=[0, 2, 3, 1])
  %8 = nn.batch_flatten(%7)
  %9 = nn.dense(%8, %v_param_5, units=128)
  %10 = nn.bias_add(%9, %v_param_6)
  %11 = nn.relu(%10)
  %12 = nn.dense(%11, %v_param_7, units=10)
  %13 = nn.bias_add(%12, %v_param_8)
  nn.softmax(%13, axis=1)
}
```
扯，竟然不行＠＠，而且完全不知道錯哪，找了一些資料說是 shape 錯了，我試了各種排列組合也都不行....

## 只存 MNIST 的權重

只好使用上面提到 Keras 官網 [How can I save a Keras model?](https://keras.io/getting-started/faq/#how-can-i-save-a-keras-model) 的方式只存權重出來，這裡我們只需要改最後一行，`save` 改成 `save_weights`

```python
import keras
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers import Conv2D, MaxPooling2D
from keras import backend as K

batch_size = 128
num_classes = 10
epochs = 12

# input image dimensions
img_rows, img_cols = 28, 28

# the data, shuffled and split between train and test sets
(x_train, y_train), (x_test, y_test) = mnist.load_data()

x_train = x_train.reshape(x_train.shape[0], img_rows, img_cols, 1)
x_test = x_test.reshape(x_test.shape[0], img_rows, img_cols, 1)
input_shape = (img_rows, img_cols, 1)

x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255
print('x_train shape:', x_train.shape)
print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')

# convert class vectors to binary class matrices
y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3),
                 activation='relu',
                 input_shape=input_shape))
model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(128, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(num_classes, activation='softmax'))

model.compile(loss=keras.losses.categorical_crossentropy,
              optimizer=keras.optimizers.Adadelta(),
              metrics=['accuracy'])

model.fit(x_train, y_train,
          batch_size=batch_size,
          epochs=epochs,
          verbose=1,
          validation_data=(x_test, y_test))
score = model.evaluate(x_test, y_test, verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1])
model.save_weights('mnist_weights.h5')
```
跑了頗久，不過跟其應該比 ImageNet 快很多了。結果如下圖。
![google-train a MNIST model with Keras](https://drive.google.com/open?id=1qSdoAYPCxNk5tlI0ELivCieDWCQO9IOV)

## 自己用 Keras 建構一個 MNIST 再餵給 TVM

把上面產生的權重餵給自己建構的模型

```python
import nnvm
import tvm
import tvm.relay as relay
from scipy.misc import imread, imresize
import numpy as np
import keras
from keras.models import load_model
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, InputLayer
from keras.layers import Conv2D, MaxPooling2D
num_classes = 10

x = imread('test3.png',mode='L')
# Compute a bit-wise inversion so black becomes white and vice versa
x = np.invert(x)
# Make it the right size
x = imresize(x,(28,28))
# Convert to a 4D tensor to feed into our model
x = x.reshape(1,28,28,1)
x = x.astype('float32')
x /= 255

# Construct a MNIST model
model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3), activation='relu', input_shape=(28,28,1)))
model.add(Conv2D(64, kernel_size=(3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(128, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(num_classes, activation='softmax'))

# Load the weights that we get from last program
model.load_weights('mnist_weights.h5')

shape_dict = {'input_1': (1, 1, 28, 28)}
func, params = relay.frontend.from_keras(model, shape_dict)
target = "llvm"
ctx = tvm.cpu(0)
with relay.build_config(opt_level=3):
    executor = relay.build_module.create_executor('graph', func, ctx, target)

# Perform the prediction
dtype = 'float32'
tvm_out = executor.evaluate(func)(tvm.nd.array(x.astype(dtype)), **params)
print(np.argmax(tvm_out.asnumpy()[0]))
```
```bash
$ python3 cnnPredict_tvm.py
In `main`: 
v0.0.1
fn (%conv2d_1_input, %v_param_1: Tensor[(32, 1, 3, 3), float32], %v_param_2: Tensor[(32,), float32], %v_param_3: Tensor[(64, 32, 3, 3), float32], %v_param_4: Tensor[(64,), float32], %v_param_5: Tensor[(128, 9216), float32], %v_param_6: Tensor[(128,), float32], %v_param_7: Tensor[(10, 128), float32], %v_param_8: Tensor[(10,), float32]) {
  %0 = nn.conv2d(%conv2d_1_input, %v_param_1, channels=32, kernel_size=[3, 3])
  %1 = nn.bias_add(%0, %v_param_2)
  %2 = nn.relu(%1)
  %3 = nn.conv2d(%2, %v_param_3, channels=64, kernel_size=[3, 3])
  %4 = nn.bias_add(%3, %v_param_4)
  %5 = nn.relu(%4)
  %6 = nn.max_pool2d(%5, pool_size=[2, 2], strides=[2, 2])an internal invariant was violated while typechecking your program [22:21:27] tvm/src/relay/op/nn/pooling.cc:73: Check failed: data != nullptr: 
; 
  %7 = transpose(%6, axes=[0, 2, 3, 1])
  %8 = nn.batch_flatten(%7)
  %9 = nn.dense(%8, %v_param_5, units=128)
  %10 = nn.bias_add(%9, %v_param_6)
  %11 = nn.relu(%10)
  %12 = nn.dense(%11, %v_param_7, units=10)
  %13 = nn.bias_add(%12, %v_param_8)
  nn.softmax(%13, axis=1)
}
```
扯，結果竟然一模一樣。

## 檢驗剛剛建立的模型是否正確

總之先試試看是不是跟直接讀 `cnn.h5` 一樣。

```python
import nnvm
import tvm
import tvm.relay as relay
from scipy.misc import imread, imresize
import numpy as np
import keras
from keras.models import load_model
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, InputLayer
from keras.layers import Conv2D, MaxPooling2D
num_classes = 10

x = imread('test3.png',mode='L')
# Compute a bit-wise inversion so black becomes white and vice versa
x = np.invert(x)
# Make it the right size
x = imresize(x,(28,28))
# Convert to a 4D tensor to feed into our model
x = x.reshape(1,28,28,1)
x = x.astype('float32')
x /= 255

# Construct a MNIST model
model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3), activation='relu', input_shape=(28,28,1)))
model.add(Conv2D(64, kernel_size=(3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(128, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(num_classes, activation='softmax'))

# Load the weights that we get from last program
model.load_weights('mnist_weights.h5')

# Perform the prediction
out = model.predict(x)
print(np.argmax(out))
```
很好，是一樣....
```bash
$ python3 cnnPredict.py
3
```

## 突破，加個輸入層？

在找解決方式的過程中突然看到[這裡](https://stackoverflow.com/a/49600827/6734174)提到有 `InputLayer`，不如加看看。
```python
import nnvm
import tvm
import tvm.relay as relay
from scipy.misc import imread, imresize
import numpy as np
import keras
from keras.models import load_model
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, InputLayer
from keras.layers import Conv2D, MaxPooling2D
num_classes = 10
input_shape = (28, 28, 1)

x = imread('test3.png',mode='L')
# Compute a bit-wise inversion so black becomes white and vice versa
x = np.invert(x)
# Make it the right size
x = imresize(x,(28,28))
# Convert to a 4D tensor to feed into our model
x = x.reshape(1,28,28,1)
x = x.astype('float32')
x /= 255

# model = load_model('cnn.h5')
# Construct a MNIST model
model = Sequential()
model.add(InputLayer(input_shape=input_shape))
model.add(Conv2D(32, kernel_size=(3, 3), activation='relu', input_shape=input_shape))
model.add(Conv2D(64, kernel_size=(3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(128, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(num_classes, activation='softmax'))

# Load the weights that we get from last program
model.load_weights('mnist_weights.h5')

shape_dict = {'input_1': (1, 1, 28, 28)}
func, params = relay.frontend.from_keras(model, shape_dict)
target = "llvm"
ctx = tvm.cpu(0)
with relay.build_config(opt_level=3):
    executor = relay.build_module.create_executor('graph', func, ctx, target)

# Pperform the prediction
dtype = 'float32'
tvm_out = executor.evaluate(func)(tvm.nd.array(x.astype(dtype)), **params)
print(np.argmax(tvm_out.asnumpy()[0]))
```
```bash
$ python3 test_mnist.py
3
```
扯，竟然過了 QuQ

# 其他

## [`lutzroeder/netron`](https://github.com/lutzroeder/netron)
發現了一個視覺化工具可以看模型。
![google-NETRON](https://drive.google.com/open?id=18rjO-BiQTXRsSDAtisBkyEEhkO2sIBoP)

## 想看中間的 shape 的話
```python
for layer in model.layers:
    print(layer.input_shape)
    print(layer.input)
    print(layer.output_shape)
    print(layer.output)
    print("---")
```