; NOTE: Don't make them @constructor like in the original code, just label them a tag for uniform highlighting

; <Component>
(jsx_opening_element ((identifier) @tag
 (#lua-match? @tag "^[A-Z]")))

; Handle the dot operator effectively - <My.Component>
(jsx_opening_element ((nested_identifier (identifier) @tag (identifier) @tag)))

; <Component />
(jsx_closing_element ((identifier) @tag
 (#lua-match? @tag "^[A-Z]")))

; Handle the dot operator effectively - </My.Component>
(jsx_closing_element ((nested_identifier (identifier) @tag (identifier) @tag)))

; <Component />
(jsx_self_closing_element ((identifier) @tag
 (#lua-match? @tag "^[A-Z]")))

; Handle the dot operator effectively - <My.Component />
(jsx_self_closing_element ((nested_identifier (identifier) @tag (identifier) @tag)))

