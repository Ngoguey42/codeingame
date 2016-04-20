(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   map.ml                                             :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/20 11:07:16 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/20 12:14:03 by ngoguey          ###   ########.fr       *)
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
      (* let  *)
      (* let rec incr_root pos = *)
      (*   let (rx, ry), count = get_root pos in *)
      (*   mat.(ry).(rx) <- V.Root (count + 1); *)
      (*   (rx, ry) *)
      (* in *)

      for y = 0 to h - 1 do

        let string_iterator x c =
          match c with
          | 'O' ->
             let vert =
               match (if x = 0 then `Land else mat.(y).(x - 1))
                   , (if y = 0 then `Land else mat.(y - 1).(x)) with
               | `Land, `Land ->
                  `Root ((x, y), 1)
               | (#V.water as n), `Land | `Land, (#V.water as n) ->
                  let (rx, ry) as rpos, count = root_info_of_water_vertex n in
                  mat.(ry).(rx) <- `Root (rpos, (count + 1));
                  `Pointer rpos
               | (#V.water as n), (#V.water as n') ->
                  let (rx, ry) as rpos, count = root_info_of_water_vertex n in
                  let (rx', ry'), count' = root_info_of_water_vertex n' in
                  mat.(ry).(rx) <- `Root (rpos, count + count' + 1);
                  mat.(ry').(rx') <- `Pointer rpos;
                  `Pointer rpos
             in
             mat.(y).(x) <- vert
          | _ -> ()

        in

        String.iteri string_iterator @@ input_line stdin;
        ()
      done;

  end
