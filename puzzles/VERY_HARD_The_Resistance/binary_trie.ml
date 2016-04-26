(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   binary_trie.ml                                     :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/26 14:41:05 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/26 14:41:51 by ngoguey          ###   ########.fr       *)
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

    let add : dirs:dir list -> data:'a -> 'a t -> 'a t = fun ~dirs ~data trie ->

      let rec aux dirs trie = (* Shadowing trie & dirs *)
        match dirs, trie with
        | `Left::tl, Node ({l} as n) -> Node {n with l = aux tl l}
        | `Right::tl, Node ({r} as n) -> Node {n with r = aux tl r}
        | [], Node {dat = Some _} -> failwith "data already in trie"
        | [], Node n -> Node {n with dat = Some data}
        | `Left::tl, Leaf -> Node {l = aux tl Leaf; dat = None; r = Leaf}
        | `Right::tl, Leaf -> Node {l = Leaf; dat = None; r = aux tl Leaf}
        | [], Leaf -> Node {l = Leaf; dat = Some data; r = Leaf}
      in
      aux dirs trie


    let dump : f:('a -> string) -> 'a t -> unit = fun ~f trie ->

      let rec aux depth trie = (* Shadowing trie *)
        match trie with
        | Leaf ->
           ()
        | Node {l; dat; r} ->
           (match dat with
           | None -> "None"
           | Some data -> Printf.sprintf "Some \"%s\"" @@ f data)
           |> Printf.eprintf "%-*d%s\n%!" (depth + 2) depth;
           Printf.eprintf "%-*dL...\n%!" (depth + 2) depth;
           aux (depth + 1) l;
           Printf.eprintf "%-*dR...\n%!" (depth + 2) depth;
           aux (depth + 1) r;
           ()
      in
      aux 1 trie

  end
