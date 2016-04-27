(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/26 14:24:47 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 11:43:12 by ngoguey          ###   ########.fr       *)
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


  let l = input_line stdin in

  let trie = trie_of_stdin () in
  Binary_Trie.dump trie ~f:(fun n ->
                     Printf.sprintf "%d" n
                   );

  (* Printf.eprintf "Hello World\n%!"; *)
  (* let tr = Binary_Trie.empty in *)
  (* let tr = Binary_Trie.add ~dirs:[`Left; `Right; `Left] ~data:"lol" tr in *)
  (* let tr = Binary_Trie.add ~dirs:[`Left; `Right; `Right] ~data:"hello" tr in *)
  ()
