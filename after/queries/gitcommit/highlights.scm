;; extends

; Conventional-commit prefixes (`fix:`, `feat(scope):`, `refactor!:`, …).
;
; The bundled gitcommit query already parses these and captures the type as
; @keyword. But in sonokai @keyword is the same red as @markup.heading (the
; subject line), so the label blends in. Re-capture the prefix parts to
; dedicated groups so the label stands out from the rest of the subject.
; Captures here run after the base query, so they win at equal priority.
;
; Highlights for these groups are defined in lua/plugins/colorscheme.lua.
(prefix
  (type) @keyword.conventional)

(prefix
  (scope) @keyword.conventional.scope)

(prefix
  [
    "("
    ")"
    ":"
  ] @keyword.conventional.delimiter)

; `!` breaking-change marker, e.g. `feat!:`
(prefix
  "!" @keyword.conventional.breaking)
