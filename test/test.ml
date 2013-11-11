(******************************************************************************)
(* ocamlmod: Generate OCaml modules from source files                         *)
(*                                                                            *)
(* Copyright (C) 2011, OCamlCore SARL                                         *)
(* Copyright (C) 2013, Sylvain Le Gall                                        *)
(*                                                                            *)
(* This library is free software; you can redistribute it and/or modify it    *)
(* under the terms of the GNU Lesser General Public License as published by   *)
(* the Free Software Foundation; either version 2.1 of the License, or (at    *)
(* your option) any later version, with the OCaml static compilation          *)
(* exception.                                                                 *)
(*                                                                            *)
(* This library is distributed in the hope that it will be useful, but        *)
(* WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *)
(* or FITNESS FOR A PARTICULAR PURPOSE. See the file COPYING for more         *)
(* details.                                                                   *)
(*                                                                            *)
(* You should have received a copy of the GNU Lesser General Public License   *)
(* along with this library; if not, write to the Free Software Foundation,    *)
(* Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA              *)
(******************************************************************************)

open OUnit2

let ocamlmod = Conf.make_exec "ocamlmod"

let () =
  run_test_tt_main
    ("ocamlmod">::
     (fun test_ctxt ->
        let fn, chn = bracket_tmpfile test_ctxt in
        let () = close_out chn in
        let () =
          assert_command ~ctxt:test_ctxt
            (ocamlmod test_ctxt)
            [(in_testdata_dir test_ctxt ["test01.mod"]);
             "-o"; fn]
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
              (fun str ->
                 if Str.string_match reg str 0 then begin
                   logf test_ctxt `Info "%S" str;
                   true
                 end else begin
                   false
                 end)
              lst
        in
        List.iter
          (fun line -> logf test_ctxt `Info "%S" line) lst;

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
          assert_bool
            "No blank at end of line."
            (not (find_reg ".*  *$"));
          ()))
