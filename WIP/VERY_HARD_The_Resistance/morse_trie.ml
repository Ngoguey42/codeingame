(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   morse_trie.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/27 10:53:28 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 14:33:26 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Morse_Trie =
  struct
    module BT = Binary_Trie

    type acc = { fact : int
               ; trie_depth : int
               }

    let empty = BT.empty

    let insert_string str trie =
      let dirs = Morse.dirs_of_word str in
      Printf.eprintf "'%s' '%s'\n%!" str @@ Morse.string_of_dirs dirs;
      let f = function None -> Some 1
                     | Some count -> Some (count + 1)
      in
      BT.change ~dirs ~f trie

    class iterator ctor_trie =
    object (self)
      inherit [int, acc] BT.iterator as super

      method fold : int BT.t -> dirs:(BT.dir list) -> init:acc -> acc =
        fun trie ~dirs ~init ->
        match trie, dirs with
        | BT.Leaf, _ ->
           init
        | BT.Node {BT.dat = None}, [] ->
           init
        | BT.Node {BT.dat = Some fact}, [] ->
           {init with fact = init.fact + fact}
        | BT.Node {BT.dat = None}, _ ->
           super#fold trie ~dirs ~init
        | BT.Node {BT.dat = Some fact}, _ ->
           let {fact = fact'} =
             self#fold ctor_trie ~dirs ~init:{ fact = 0; trie_depth = 0 }
           in
           super#fold trie ~dirs ~init:{ fact = (init.fact + fact' * fact)
                                       ; trie_depth = 0 }

    end


  end
