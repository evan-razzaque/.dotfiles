hi link phpKeyword Conditional
hi link phpJumpKeyword Statement
hi link phpCommands phpFunctions

syntax keyword phpJumpKeyword continue break goto return containedin=phpRegion,phpKeyword contained
syntax keyword phpCommands echo die unset exit list clone print isset instanceof eval containedin=phpRegion,phpKeyword contained
