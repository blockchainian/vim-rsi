# rsi.vim

Improved line editing inspired by Readline without meta keys.

## Features

* Mappings are provided in insert mode and command line mode.  Normal mode is
  deliberately omitted.
* Important Vim key bindings (like insert mode's C-n and C-p completion) are
  not overridden.
* Meta key bindings are replaced with custom control key bindings.
* C-e, and C-f are mapped such that they perform the Readline behavior in the
  middle of the line and the Vim behavior at the end.  (Think about it.)

## Installation

If you don't have a preferred installation method, I recommend
installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and
then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/blockchainian/vim-rsi.git

Once help tags have been generated, you can view the manual with
`:help rsi`.

## License

Copyright © Tim Pope, etal.  Distributed under the same terms as Vim itself.
See `:help license`.
