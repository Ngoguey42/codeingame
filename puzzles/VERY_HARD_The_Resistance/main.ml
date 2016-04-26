(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/26 14:24:47 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/26 14:41:02 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let () =
  Printf.eprintf "Hello World\n%!";
  let tr = Binary_Trie.empty in
  let tr = Binary_Trie.add ~dirs:[`Left; `Right; `Left] ~data:"lol" tr in
  let tr = Binary_Trie.add ~dirs:[`Left; `Right; `Right] ~data:"hello" tr in
  Binary_Trie.dump tr ~f:(fun s -> s);
  ()
