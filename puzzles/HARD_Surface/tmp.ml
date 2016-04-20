(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   node.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/20 11:18:35 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/20 12:14:11 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Vertex =
  struct
    type water = [ `Root of (int * int) * int (* self coords / count *)
                 | `Pointer of (int * int) ](* root coords *)
    type t = [ water
             | `Land ]

  end
(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   map.ml                                             :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/20 11:07:16 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/20 12:37:23 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Map =
  struct

    module V = Vertex

    type t = {
        h : int;
        w : int;
        mat : V.t array array;
      }

    let empty_of_stdin () =
      let l = int_of_string (input_line stdin) in
      let h = int_of_string (input_line stdin) in
      { h
      ; w = l
      ; mat = Array.make_matrix l h `Land}


    let fill {h; mat} =

      let rec root_info_of_pos ((x, y) as pos) =
        match mat.(y).(x) with
        | `Land -> assert false
        | `Root (_, count) -> pos, count
        | `Pointer pos' -> root_info_of_pos pos'
      in
      let rec root_info_of_water_vertex (wvert : V.water) =
        match wvert with
        | `Root (pos, count) -> pos, count
        | `Pointer (pos) -> root_info_of_pos pos
      in

      for y = 0 to h - 1 do

        let string_iterator x c =
          match c with
          | 'O' ->
             let vert =
               match (if x = 0 then `Land else mat.(y).(x - 1))
                   , (if y = 0 then `Land else mat.(y - 1).(x)) with
               | `Land, `Land ->
                  Printf.eprintf "(%d, %d) is now root\n%!" x y;
                  `Root ((x, y), 1)
               | (#V.water as n), (#V.water as n') when n <> n' ->
                  let (rx, ry) as rpos, count = root_info_of_water_vertex n in
                  let (rx', ry'), count' = root_info_of_water_vertex n' in
                  Printf.eprintf "(%d, %d) is now points to (%d, %d){\n%!" x y rx ry;
                  Printf.eprintf "\t(%d, %d) updated to point to (%d, %d)}\n%!"
                                 rx' ry' rx ry;
                  mat.(ry).(rx) <- `Root (rpos, count + count' + 1);
                  mat.(ry').(rx') <- `Pointer rpos;
                  `Pointer rpos
               | (#V.water as n), _ | _, (#V.water as n) ->
                  let (rx, ry) as rpos, count = root_info_of_water_vertex n in
                  Printf.eprintf "(%d, %d) is now points to (%d, %d)\n%!" x y rx ry;
                  mat.(ry).(rx) <- `Root (rpos, (count + 1));
                  `Pointer rpos
             in
             mat.(y).(x) <- vert
          | _ -> ()

        in

        String.iteri string_iterator @@ input_line stdin;
        ()
      done

    let dump {mat} = (* debug *)
      (* val iter : ('a -> unit) -> 'a array -> unit *)
      Array.iter (fun line ->
          Array.iter (fun vert ->
              match vert with
              | `Land -> Printf.eprintf " # %!"
              | `Root (_, _) -> Printf.eprintf " R %!"
              | `Pointer _ -> Printf.eprintf " O %!"
            ) line;
          Printf.eprintf "\n%!"
        ) mat;
      ()


  end
;; (* End of modules declaration *)
(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/20 11:06:02 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/20 12:33:23 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let () =
  Printf.eprintf "Hello world\n%!";
  let map = Map.empty_of_stdin () in
  Printf.eprintf "TAMERE1\n%!";
  Map.fill map;
  Printf.eprintf "TAMERE2\n%!";
  Map.dump map;
  ()
