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
     bracket_tmpfile
     (fun (fn, chn) ->
        let () = close_out chn in
        let () = 
          assert_command 
            !ocamlmod ["test/data/test01.mod"; "-o"; fn]
        in
        let lst = 
          let lst = ref [] in
          let chn = open_in fn in
          let () = 
            try
              while true do 
                lst := (input_line chn) :: !lst 
              done
            with End_of_file ->
              close_in chn
          in
            List.rev !lst
        in
        let find_reg reg = 
          let reg = Str.regexp reg in
            List.exists
              (fun str -> Str.string_match reg str 0)
              lst
        in

          ignore "(*";
          assert_bool 
            "Contains SHOULD BE THERE"
            (find_reg " *(\\* SHOULD BE THERE \\*)");
          ignore "(*";
          assert_bool
            "Doesn't contain SHOULD NOT BE THERE"
            (not (find_reg " *(\\* SHOULD NOT BE THERE \\*)"));
          assert_bool
            "Doesn't contain with odn"
            (not (find_reg ".*with *odn"));
          ()))
