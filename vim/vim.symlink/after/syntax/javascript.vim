syntax keyword flowTypeKeyword type nextgroup=flowTypeIdentifier
syntax region flowTypeIdentifier contained start=/\%(\s\+\k\)/ end=/=\@=/ nextgroup=jsFlowTypeValue
syntax match flowObjectProps contained /[0-9a-zA-Z_$?]*\(\s*:\)\@=/ skipwhite skipempty nextgroup=jsFlowTypeValue containedin=jsFlowObject

highlight link jsThis jsReturn
highlight link jsStorageClass jsClassKeyword
highlight link jsModuleKeywords jsClassKeyword
highlight link jsModuleOperators jsClassKeyword
highlight link jsArrowFunction NONE
highlight link jsImport jsClassKeyword
highlight link jsFrom jsClassKeyword
highlight link jsExport jsClassKeyword
highlight link jsExportDefault jsFuncName
highlight link jsFlowTypeKeyword Keyword
highlight link flowTypeKeyword Keyword
highlight link flowTypeIdentifier Function
highlight link flowObjectProps Special
