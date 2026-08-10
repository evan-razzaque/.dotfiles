hi link CocSemTypeFunction Normal
hi link CocSemTypeParameter Normal
hi link CocSemTypeProperty Normal
hi link CocSemTypeVariable Normal
hi link CocSemTypeLabel Number
hi link CocSemTypeClass Operator
hi link CocSemTypeVariable NONE
hi link CocSemTypeModVariableDefaultLibrary Number

syntax region cSnip matchgroup=Snip start=/^\s*```c$/ end=/^\s*```/ containedin=cComment contains=TOP

hi link Snip SpecialComment
