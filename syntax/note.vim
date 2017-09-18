" Vim syntax file
" Language: Custom notes (markdown variant)

if exists("b:current_syntax")
  finish
endif

syn match META /<\/*META[^>]*>/ conceal

syn match noteH1 "^\s*=.*$"
syn match noteH2 "^\s*==.*$"
syn match noteComment "#.*$"

syn match noteBlockCmd "CMDLIST" contains=@NoSpell
syn match noteCmdListCmd "^[^}]\S*" contained contains=@NoSpell
syn region noteCmdListBlock start="{" end="}" fold transparent contains=noteCmdListCmd

hi def link noteComment Comment


color custom
