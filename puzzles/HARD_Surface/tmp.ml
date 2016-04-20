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
(*   Updated: 2016/04/20 14:11:01 by ngoguey          ###   ########.fr       *)
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
      let w = int_of_string (input_line stdin) in
      let h = int_of_string (input_line stdin) in
      Printf.eprintf "Making matrix of w = %d, h = %d\n%!" w h;
      { h
      ; w
      ; mat = Array.make_matrix h w `Land}

    let dump {mat} = (* debug *)
      Array.iter (fun line ->
          Array.iter (fun vert ->
              match vert with
              | `Land -> Printf.eprintf "  #  %!"
              | `Root (_, co) -> Printf.eprintf " R%2d %!" co
              | `Pointer (x, y) -> Printf.eprintf "(%d,%d)%!" x y
            ) line;
          Printf.eprintf "\n%!"
        ) mat;
      ()

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
                  (* Adjacent to 2 lands *)
                  `Root ((x, y), 1)
               | (#V.water as n), (#V.water as n') -> begin
                   match root_info_of_water_vertex n
                       , root_info_of_water_vertex n' with
                   | ((rx, ry) as rpos, count), ((rx', ry') as rpos', count')
                        when rpos = rpos' ->
                      (* Adjacent to 2 waters to SAME root *)
                      mat.(ry).(rx) <- `Root (rpos, (count + 1));
                      `Pointer rpos
                   | ((rx, ry) as rpos, count), ((rx', ry'), count')
                        when count > count' ->
                      (* Adjacent to 2 waters w/ DIFFERENT roots, Keep left *)
                      mat.(ry).(rx) <- `Root (rpos, count + count' + 1);
                      mat.(ry').(rx') <- `Pointer rpos;
                      `Pointer rpos
                   | ((rx', ry'), count'), ((rx, ry) as rpos, count) ->
                      (* Adjacent to 2 waters w/ DIFFERENT roots, Keep top *)
                      mat.(ry).(rx) <- `Root (rpos, count + count' + 1);
                      mat.(ry').(rx') <- `Pointer rpos;
                      `Pointer rpos
                 end
               | (#V.water as n), `Land | `Land, (#V.water as n) ->
                  (* Adjacent to 1 water *)
                  let (rx, ry) as rpos, count = root_info_of_water_vertex n in
                  mat.(ry).(rx) <- `Root (rpos, (count + 1));
                  `Pointer rpos
             in
             mat.(y).(x) <- vert
             (* ;dump map (\*debug *\) *)

          | _ -> ()

        in
        String.iteri string_iterator @@ input_line stdin;
        ()
      done



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
(*   Updated: 2016/04/20 13:48:34 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let () =
  Printf.eprintf "Hello world\n%!";
  let map = Map.empty_of_stdin () in
  Map.fill map;
  Map.dump map;
  ()
