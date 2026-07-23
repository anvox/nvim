; extends

; Absinthe GraphQL sigils (~G, ~GQL, ~g, ~gql)
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "G" "GQL" "g" "gql")
  (#set! injection.language "graphql"))
