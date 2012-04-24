open OUnit

let ocamlmod = 
  ref "false"

let _lst : test_result list = 
  run_test_tt_main
    ~arg_specs:
    ["--ocamlmod",
     Arg.Set_string ocamlmod,
     "fn ocamlmod executable."]
    ("ocamlmod">::
     (fun () ->
        assert_command !ocamlmod ["test/data/test01.mod"]))
