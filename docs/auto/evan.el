(TeX-add-style-hook "evan"
 (lambda ()
    (LaTeX-add-environments
     "conj"
     "corr"
     "prop"
     "thm")
    (TeX-add-symbols
     "two")
    (TeX-run-style-hooks
     "geometry"
     "margin=1.5in"
     "newtx"
     "amsthm"
     "amsmath"
     ""
     "latex2e"
     "art12"
     "article"
     "12pt")))

