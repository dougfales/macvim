Vim - the text editor - for Mac OS X

This is the official GitHub repository for MacVim, the macOS port of [vim](https://github.com/vim/vim). It is based on
[Björn Winckler's repository](https://github.com/b4winckler/macvim), which was official until he stepped down as the
maintainer of the port.

- MacVim homepage http://macvim-dev.github.io/macvim

- Vim README https://github.com/macvim-dev/macvim/blob/master/README_vim.md

- Travis CI <a href="https://travis-ci.org/macvim-dev/macvim"><img src="https://travis-ci.org/macvim-dev/macvim.svg?branch=master" alt="Build Status"></a><a href="https://travis-ci.org/macvim-dev/homebrew-macvim"><img src="https://travis-ci.org/macvim-dev/homebrew-macvim.svg?branch=master" alt="Build Status"></a>


## MVP (MacVim-Project)

This fork contains a small set of extensions I (dougfales) wrote for my own use as a developer who loves MacVim and uses it everyday.

I called these extensions MacVim-Project, or MVP, because the idea was to make some of the project-related features you'd find in a modern IDE available in MacVim. 

I realize most or all of these features are available in other, more popular and better maintained, plugins like NERDtree. I also realize it is unlikely this fork will ever be brought into the main MacVim repo. I'm ok with both of these things. These features are something I wanted for my own use, and that is the only reason I wrote them. I am sharing them now simply because I've been using them for four or five years and I thought it might be good to post them somewhere publicly.

## Features

The limited features provided by this fork are:

* A **project drawer** with a view of the directory your project is based in
* A **fast open dialog (`⌘-shift-d`)** which helps you open a file quickly
* A **find in project dialog (`⌘-shift-f`)** which helps you find text in your project quickly

I'm slowly adding things as I need them, so some functionality is incomplete. For instance, you can right-click on a file in the drawer and view it in Finder or on GitHub, but you can't yet right click on a line in a file to view it on GitHub.


## Building & Running

This project should build in just the same way as MacVim. To get started, I do this:

1. `cd src`
2. `make`
3. `open MacVim/MacVim.xcodeproj` 
4. Build and run in Xcode.

## Screenshots

![MacVim-Project](https://user-images.githubusercontent.com/10288/30515719-51ba3406-9aea-11e7-8e49-904a026b5bb7.png)

