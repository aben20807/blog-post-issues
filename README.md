# Blog Post

This repo is used for maintenance of [https://aben20807.github.io/](https://aben20807.github.io/). The repo of the static website can be accessed at [here](https://github.com/aben20807/aben20807.github.io).

# Theme

This theme ([hugOuO](https://github.com/aben20807/hugOuO)) of the blog is made up of [story](https://github.com/xaprb/story) by [xaprb](https://github.com/xaprb) and [AllinOne](https://github.com/orianna-zzo/AllinOne) by [Orianna](https://github.com/orianna-zzo).
I have to thank them for providing good themes and giving those MIT license so that I can make good use of.

# Blogging!

```bash
$ git clone --recursive git@github.com:aben20807/blog-post.git
$ cd blog-post
$ git clone git@github.com:aben20807/aben20807.github.io.git 
$ mv aben20807.github.io/ public/
```

# Wishlist

You can submit the issue [here](https://github.com/aben20807/blog-post/issues).

# Tools

## hued

+ An editor make you edit the post file easily with completion that skip the middle directories.
+ Notice: some parts are hardcode. the directory is "content/posts/"

### Install

1. Make sure you have bash completion.
```bash
$ ls /etc/ | grep --color bash_completion.d
```
2. Copy the script file into conpletion directory. (Update)
```bash
$ sudo cp hued.sh /etc/bash_completion.d/
```
3. Close the current shell and reopen it.
