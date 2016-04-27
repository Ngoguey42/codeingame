(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   binary_trie.ml                                     :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/26 14:41:05 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 13:18:00 by ngoguey          ###   ########.fr       *)
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
           aux (prefix ^ "l") l;
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
(*   morse.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/27 12:07:51 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 12:12:45 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Morse =
  struct
    let dirs_of_char = function
      | 'A' -> [`Left; `Right; ]
      | 'B' -> [`Right; `Left; `Left; `Left; ]
      | 'C' -> [`Right; `Left; `Right; `Left; ]
      | 'D' -> [`Right; `Left; `Left; ]
      | 'E' -> [`Left; ]
      | 'F' -> [`Left; `Left; `Right; `Left; ]
      | 'G' -> [`Right; `Right; `Left; ]
      | 'H' -> [`Left; `Left; `Left; `Left; ]
      | 'I' -> [`Left; `Left; ]
      | 'J' -> [`Left; `Right; `Right; `Right; ]
      | 'K' -> [`Right; `Left; `Right; ]
      | 'L' -> [`Left; `Right; `Left; `Left; ]
      | 'M' -> [`Right; `Right; ]
      | 'N' -> [`Right; `Left; ]
      | 'O' -> [`Right; `Right; `Right; ]
      | 'P' -> [`Left; `Right; `Right; `Left; ]
      | 'Q' -> [`Right; `Right; `Left; `Right; ]
      | 'R' -> [`Left; `Right; `Left; ]
      | 'S' -> [`Left; `Left; `Left; ]
      | 'T' -> [`Right; ]
      | 'U' -> [`Left; `Left; `Right; ]
      | 'V' -> [`Left; `Left; `Left; `Right; ]
      | 'W' -> [`Left; `Right; `Right; ]
      | 'X' -> [`Right; `Left; `Left; `Right; ]
      | 'Y' -> [`Right; `Left; `Right; `Right; ]
      | 'Z' -> [`Right; `Right; `Left; `Left; ]
      | _ -> assert false

    let dirs_of_word str =

      (* Read chars from end to begin *)
      let rec aux i acc =
        if i < 0
        then acc
        else (dirs_of_char (String.get str i))::acc
             |> aux (i - 1)
      in
      aux (String.length str - 1) []
    |> List.concat


    let dirs_of_string str =

      (* Read chars from end to begin *)
      let rec aux i acc =
        if i < 0
        then acc
        else (match String.get str i with
              | '.' -> `Left
              | '-' -> `Right
              | _ -> assert false
             ) :: acc
             |> aux (i - 1)
      in
      aux (String.length str - 1) []


  end
(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   morse_trie.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/27 10:53:28 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 13:17:32 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Morse_Trie =
  struct
    module BT = Binary_Trie

    let empty = BT.empty

    let insert_string str trie =
      (* Printf.eprintf "(%s)\n%!" str; *)
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
        match trie, dirs with
        | BT.Leaf, _ ->
           init
        | BT.Node {BT.dat = None}, [] ->
           init
        | BT.Node {BT.dat = Some fact}, [] ->
          init + fact
        | BT.Node {BT.dat = None}, _ ->
           super#fold trie ~dirs ~init
        | BT.Node {BT.dat = Some fact}, _ ->
           let fact' = self#fold ctor_trie ~dirs ~init:0 in
           super#fold trie ~dirs ~init:(init + fact' * fact)

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
(*   Updated: 2016/04/27 13:18:47 by ngoguey          ###   ########.fr       *)
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
      Printf.eprintf "Hello World\n%!";
      let msg = input_line stdin in
      Printf.eprintf "MSG'%s'\n%!" msg;
      let msg_dirs = Morse.dirs_of_string msg in

      let trie = trie_of_stdin () in
      Binary_Trie.dump trie ~f:(fun n -> Printf.sprintf "%d" n);
      let it = new Morse_Trie.iterator trie in
      let count = it#fold ~dirs:msg_dirs ~init:0 trie in
      Printf.printf "%d\n%!" count;
      ()
    end
