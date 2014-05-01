
## Vim 自动补全, 以及 `strl+s` 保存

不喜欢 Vim, 有图形界面时用 Vim 主要把问题变复杂的
但在 Sublime Text 无法用中文时还是要求助 Vim, 基本的配置

需要的功能是 `ctrl+s` 时保存文件, 网上这个办法实现了
http://fatkun.com/2011/05/vim-ctrl-s.html

然后是空格和缩进的基本配置, 搜到了对的版本, 加在 `~/.vim` 即可
http://vim.wikia.com/wiki/Converting_tabs_to_spaces
```vimscript
set tabstop=2
set shiftwidth=2
set expandtab
```

接着, 自动补全也加上吧, 虽然我觉得不会怎么好的
```vimscript
imap " <C-V>"<C-V>"<Left>
imap { <C-V>{<C-V>}<Left>
imap ( <C-V>(<C-V>)<Left>
imap [ <C-V>[<C-V>]<Left>
```
http://stackoverflow.com/questions/4904898/vim-auto-complete-with-cursor-adjustment
