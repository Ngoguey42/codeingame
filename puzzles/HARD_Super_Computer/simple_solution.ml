(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   simple_solution.ml                                 :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/24 08:38:10 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/24 09:20:23 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Simple_solution =
  struct

    module Task =
      struct
        type t = int
        let compare right right' =
          right - right'
      end

    module TaskMap = Map.Make(Task)

    let _add_map_if : 'key -> 'v -> 'map -> ('v -> 'v -> bool) -> 'map =
      fun k v m f ->
      if TaskMap.mem k m then
        let v' = TaskMap.find k m in
        if f v v'
        then TaskMap.add k v m
        else m
      else
        TaskMap.add k v m

    let _best_begin left left' =
      if left > left'
      then true
      else false

    let nonoverlapping_count_of_stdin () =
      let n = int_of_string (input_line stdin) in

      let rec aux i map =
        if i >= n
        then map
        else aux' i map
      and aux' i map =
        let line = input_line stdin in
        let start, len = Scanf.sscanf line "%d %d" (fun j d -> (j, d)) in
        _add_map_if (start + len) start map _best_begin
        |> aux (i + 1)
      in
      let count, _ =
        TaskMap.fold (fun right left ((count, leftmin) as cur) ->
            if left >= leftmin
            then (count + 1, right)
            else cur
          ) (aux 0 TaskMap.empty) (0, 0)
      in
      count

  end
