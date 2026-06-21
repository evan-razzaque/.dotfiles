hi link shLoop shConditional
hi link shIf shConditional

syn clear shRepeat
syn clear shDo
syn clear shIf

" Using shIf becuase idk how to make a new syntax group in this case
syn keyword shIf if then else elif fi for select while until do done in
