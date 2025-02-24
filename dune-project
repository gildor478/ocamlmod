(lang dune 3.17)

(name ocamlmod)

(generate_opam_files true)

(source
 (github gildor478/ocamlmod))

(authors "Sylvain Le Gall")
(maintainers "Sylvain Le Gall <sylvain+ocaml@le-gall.net>")
(license "LGPL-2.1-or-later WITH OCaml-LGPL-linking-exception")

(package
 (name ocamlmod)
 (synopsis "Generate OCaml modules from source files")
 (depends
   (ocaml (>= 4.14.1))
   (ounit2 (and (>= 2.0.0) :with-test))))

