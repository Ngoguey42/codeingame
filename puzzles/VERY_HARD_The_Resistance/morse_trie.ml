(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   morse_trie.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/27 10:53:28 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 15:14:25 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Morse_Trie =
  struct
    module BT = Binary_Trie

    type acc = { fact : int
               ; trie_depth : int
               ; msg_depth : int }


    let empty = BT.empty


    let insert_string str trie =

      let dirs = Morse.dirs_of_word str in
      let f = function None -> Some 1
                     | Some count -> Some (count + 1)
      in
      BT.change ~dirs ~f trie


    class iterator ctor_trie =
    object (self)
      inherit [int, acc] BT.iterator as super


      (* Hashtbl for Dynamic Programming *)
      val patterns = Hashtbl.create 10000


      method fold : int BT.t -> dirs:(BT.dir list) -> init:acc -> acc =
        fun trie ~dirs ~init ->

        (* How to unpack init on previous line??? *)
        let {trie_depth; fact; msg_depth} = init in
        match trie, dirs with
        | BT.Leaf, _ ->
           (* End of iteration, no match *)
           init
        | BT.Node {BT.dat = None}, [] ->
           (* End of iteration, no match *)
           init
        | BT.Node {BT.dat = Some fact'}, [] ->
           (* End of iteration, match *)
           {init with fact = fact + fact'}
        | BT.Node {BT.dat = None}, _ ->
           (* Step in iteration, no match
            * - Call SUPER to go on with iteration *)
           super#fold trie ~dirs ~init:{init with trie_depth = trie_depth + 1
                                                ; msg_depth = msg_depth + 1}
        | BT.Node {BT.dat = Some fact'}, _ ->
           (* Step in iteration, match
            * - Check in patterns was previously encountered
            * OR Launch recursion and save pattern results
            * - Call SUPER to go on with iteration *)
           let fact'' =
             if Hashtbl.mem patterns (trie_depth, msg_depth) then
               Hashtbl.find patterns (trie_depth, msg_depth)
             else begin
                 let {fact = fact''} =
                   self#fold ctor_trie ~dirs ~init:{ init with fact = 0
                                                             ; trie_depth = 0 }
                 in
                 Hashtbl.add patterns (trie_depth, msg_depth) fact'';
                 fact''
               end
           in
           super#fold trie ~dirs ~init:{ fact = (fact + fact' * fact'')
                                       ; trie_depth = trie_depth + 1
                                       ; msg_depth = msg_depth + 1 }
    end
  end
