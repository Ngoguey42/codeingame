(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   morse_trie.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/27 10:53:28 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 12:29:59 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Morse_Trie =
  struct
    module BT = Binary_Trie

    let empty = BT.empty

    let insert_string str trie =
      Printf.eprintf "(%s)\n%!" str;
      let dirs = Morse.dirs_of_word str in
      let f = function None -> Some 1
                     | Some count -> Some (count + 1)
      in
      BT.change ~dirs ~f trie

    class iterator ctor_trie =
    object (self)
      inherit [int, int] BT.iterator as super

      method fold : int BT.t -> dirs:(BT.dir list) -> init:int -> int =
        fun trie ~dirs ~init ->
        (* Printf.eprintf "Morse fold\n%!"; *)
        match trie, dirs with
        | BT.Leaf, _ ->
           0
        | BT.Node {BT.dat = None}, [] ->
           0
        | BT.Node {BT.dat = Some fact}, [] ->
           fact
        | BT.Node {BT.dat = None}, _ ->
           super#fold trie ~dirs ~init
        | BT.Node {BT.dat = Some fact}, _ ->
           let fact' = self#fold ctor_trie ~dirs ~init:0 in

           super#fold trie ~dirs ~init:(init + fact' * fact)

           (* super#fold trie ~dirs ~init *)
    end


  end
