(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/26 14:24:47 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 15:12:06 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let trie_of_stdin () =

  let n = int_of_string (input_line stdin) in
  let rec aux i acc =
    if i >= n
    then acc
    else Morse_Trie.insert_string (input_line stdin) acc
         |> aux (i + 1)
  in
  aux 0 Morse_Trie.empty


let () =
  Printf.eprintf "%s\n%!" Sys.executable_name;
  if Sys.executable_name <> "/tmp/native" then begin
      (* Nasty hack to get native ocaml *)
      ignore (Sys.command "ocamlopt /tmp/Answer.ml -o /tmp/native");
      ignore (Sys.command "/tmp/native")
    end
  else
    begin
      let msg = input_line stdin in
      let msg_dirs = Morse.dirs_of_string msg in
      let trie = trie_of_stdin () in
      (* Binary_Trie.dump trie ~f:(fun n -> Printf.sprintf "%d" n); *)
      let it = new Morse_Trie.iterator trie in
      let {Morse_Trie.fact} =
        it#fold ~dirs:msg_dirs ~init:{ Morse_Trie.fact = 0
                                     ; Morse_Trie.trie_depth = 0
                                     ; Morse_Trie.msg_depth = 0
                                     } trie
      in
      Printf.printf "%d\n%!" fact;
      ()
    end
