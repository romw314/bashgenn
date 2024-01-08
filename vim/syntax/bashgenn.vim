if exists("b:current_syntax")
	finish
endif

syn keyword bashgennStatement READ ECHO NONL COPY FIRST LAST STOREFIRST STORELAST nextgroup=bashgennVarName
syn keyword bashgennStatement CHINC CHDEC STORECHINC STORECHDEC STRRANGE STRRANGELESS STRCAT FIND
syn keyword bashgennStatement CONST_SET CONSTSET nextgroup=bashgennConstName
syn keyword bashgennStatement STOP KILL
syn keyword bashgennIReqStatement CONST_COPY CONSTCOPY CONST_WRITE CONSTWRITE
syn keyword bashgennCompilerDirective _MSG _WARN _ERR _OPT
syn keyword rbgnStatement STATIC_STR_VAR nextgroup=bashgennConstName
syn keyword rbgnStatement STATIC_STR_SPACE nextgroup=bashgennVarName

syn match bashgennVarName '[A-Za-z0-9_.+-]+$' contained
syn match bashgennConstName ' [^ ]+' contained nextgroup=bashgennConstValue
syn match bashgennConstValue '.+$' contained

syn region bashgennBlock matchgroup=bashgennStatement start="\<REPEAT\>" end="\<DONE\>" fold transparent
syn region bashgennBlock matchgroup=bashgennStatement start="\<STDIN\>" end="\<DONE\>" fold transparent
syn region bashgennBlock matchgroup=bashgennStatement start="\<STRGET\>" end="\<DONE\>" fold transparent
syn region bashgennBlock matchgroup=bashgennStatement start="\<CONST_\=SCAN\>" end="\<DONE\>" fold transparent
syn region bashgennIReqBlock matchgroup=bashgennIReqStatement start="\<RREPT\>" end="\<DONE\>" fold transparent

syn keyword bashgennTodo contained TODO FIXME XXX NOTE
syn region bashgennComment start="^[ \t]*-" end="$" contains=bashgennTodo

let b:current_syntax = "bashgenn"

hi def link rbgnStatement bashgennStatement
hi def link bashgennIReqStatement bashgennStatement
hi def link bashgennConstName Identifier
hi def link bashgennVarName Identifier
hi def link bashgennConstValue String
hi def link bashgennStatement Statement
hi def link bashgennCompilerDirective PreProc
hi def link bashgennComment Comment
