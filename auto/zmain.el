(TeX-add-style-hook
 "zmain"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("aastex631" "tighten")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (TeX-run-style-hooks
    "latex2e"
    "affil"
    "aastex631"
    "aastex63110"
    "longtable"
    "hyperref"
    "url"
    "amsmath"
    "comment"
    "listings")
   (TeX-add-symbols
    '("keyword" 1)
    '("element" 1)
    '("subproperty" 1)
    '("property" 1)
    '("pending" 1)
    "vdag"
    "mosfit"
    "json")
   (LaTeX-add-labels
    "sec:schema"
    "sec:definitions"
    "sec:practices"
    "sec:elements"
    "subsec:value"
    "subsec:reference"
    "subsec:units"
    "subsec:type"
    "subsec:flag"
    "subsec:computed"
    "subsec:uui"
    "subsec:default"
    "subsec:comment"
    "sec:flags"
    "sec:required"
    "subsec:object_requirements"
    "subsec:param_requirements"
    "subsec:measurement_requirements"
    "sec:parameter"
    "sec:name"
    "sec:default_name"
    "sec:alias"
    "lst:example-json"
    "sec:coordinate"
    "sec:distance"
    "sec:date_reference"
    "sec:classification"
    "sec:photometry"
    "sec:host"
    "sec:metadata"
    "sec:reference_details"
    "sec:filter_alias"
    "sec:otter")
   (LaTeX-add-bibliographies
    "references")
   (LaTeX-add-listings-lstdefinestyles
    "json"))
 :latex)

