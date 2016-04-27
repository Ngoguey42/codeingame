(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   binary_trie.ml                                     :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/26 14:41:05 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 11:08:28 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Binary_Trie =
  struct

    type dir = [`Left | `Right]

    type 'a node = { l : 'a t
                   ; dat : 'a option
                   ; r : 'a t }
     and 'a t = Leaf | Node of 'a node

    let empty = Leaf

    let change : dirs:dir list -> f:('a option -> 'a option) -> 'a t -> 'a t =
      fun ~dirs ~f trie ->

      let rec aux dirs trie = (* Shadowing trie & dirs *)
        match dirs, trie with
        | `Left::tl, Node ({l} as n) -> Node {n with l = aux tl l}
        | `Right::tl, Node ({r} as n) -> Node {n with r = aux tl r}
        | [], Node ({dat} as n) -> Node {n with dat = f dat}
        | `Left::tl, Leaf -> Node {l = aux tl Leaf; dat = None; r = Leaf}
        | `Right::tl, Leaf -> Node {l = Leaf; dat = None; r = aux tl Leaf}
        | [], Leaf -> Node {l = Leaf; dat = f None; r = Leaf}
      in
      aux dirs trie

    let add : dirs:dir list -> data:'a -> 'a t -> 'a t =
      fun ~dirs ~data trie ->

      change ~dirs ~f:(function None -> Some data
                              | Some _ -> failwith "data already in trie" ) trie


    let dump : f:('a -> string) -> 'a t -> unit = fun ~f trie ->

      let rec aux prefix trie = (* Shadowing trie *)
        match trie with
        | Leaf ->
           ()
        | Node {l; dat; r} ->
           (match dat with
            | None -> Printf.eprintf "%s None\n" prefix
            | Some data -> Printf.eprintf "%s Some \"%s\"\n" prefix @@ f data
           );

                           (* |> Printf.eprintf "%-*d%s\n%!" (depth + 2) depth; *)
           (* Printf.eprintf "%-*dL...\n%!" (depth + 2) depth; *)
           aux (prefix ^ "l") l;
           (* Printf.eprintf "%-*dR...\n%!" (depth + 2) depth; *)
           aux (prefix ^ "r") r;
           ()
      in
      aux ">" trie

    class ['elt, 'acc] iterator =
    object (self)

      method fold : 'elt t -> dirs:(dir list) -> init:'acc -> 'acc =
        fun trie ~dirs ~init ->
        match trie, dirs with
        | Leaf, _ | _, [] -> init
        | Node {l}, `Left::tl -> self#fold l ~dirs:tl ~init
        | Node {r}, `Right::tl -> self#fold r ~dirs:tl ~init

    end

  end
(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   morse_trie.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/27 10:53:28 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 10:59:33 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Morse_Trie =
  struct



    class iterator =
    object (self)
      inherit [int, int] Binary_Trie.iterator as super

    end


  end
;; (* End of modules declaration *)
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
