# https://git.sr.ht/~sircmpwn/scdoc
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.]scd %{
    set-option buffer filetype scdoc
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=scdoc %{
    require-module scdoc
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window scdoc-.+ }
}

hook -group scdoc-highlight global WinSetOption filetype=scdoc %{
    add-highlighter window/scdoc ref scdoc
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/scdoc}
}


provide-module scdoc %{

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/scdoc regions
add-highlighter shared/scdoc/inline default-region regions
add-highlighter shared/scdoc/inline/text default-region group

add-highlighter shared/scdoc/inline/text/ regex \
	'(?<!# )((?<!\\)|\\\\)\*(\n?[^\n])*?((?<!\\)|\\\\)\*' 0:bold
add-highlighter shared/scdoc/inline/text/ regex \
	'(?<!# )((?<!\\)|\\\\)\b_(\n?[^\n])*?((?<!\\)|\\\\)_\b' 0:italic
# Let’s break this down:
# (?<!# ) Tretead literally in headings
# ((?<!\\)|\\\\) Treated literally after \ but not after \\
# (\n?[^\n]) Line break is allowed but not a paragraph break

# TODO: foo \\_bar_ is correctly highlighted as italic but
#       foo\\_bar_ is wrongly highlighted as italic

add-highlighter shared/scdoc/inline/text/ regex '^; [^\n]*' 0:comment
add-highlighter shared/scdoc/inline/text/ regex '^##? [^\n]*' 0:header
add-highlighter shared/scdoc/inline/text/ regex '\\.' 0:meta

add-highlighter shared/scdoc/codeblock region -match-capture \
    ^\t?```$ \
    ^\t?```$ \
    fill meta
}
