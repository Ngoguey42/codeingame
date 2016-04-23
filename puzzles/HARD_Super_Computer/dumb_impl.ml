(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   dumb_impl.ml                                       :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/23 14:23:46 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/23 15:21:47 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Dumb_implementation =
  struct
    (* O(N^3) implementation for debugging purpose *)
    module T = Task

    let add itv left right =
      Interval.add itv ~low:(left * 2 + 1) ~high:(right * 2 - 1) ~data:()
    let intersects itv left right =
      Interval.intersects itv ~low:(left * 2) ~high:(right * 2)


    let array_foldi_left_partial :
          (int -> 'a -> 'b -> 'a) -> 'a -> 'b array -> int -> 'a =
      fun f init arr starti ->
      let rec aux i acc =
        if i >= Array.length arr
        then acc
        else aux (i + 1) (f i acc arr.(i))
      in
      aux starti init

    let nonoverlapping_count_of_infoArr infoArr =
      let count_tasks = Array.length infoArr in
      let task_residual index =
        count_tasks - index
      in

      let rec iter_tasks itv index best_count cur_count =

        (* val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b array -> 'a *)
        (* Printf.eprintf "iter_tasks index(%d) best_count(%d) cur_count(%d)\n%!" *)
        (*                index best_count cur_count; *)
        let rec task_folder i (best_count') {T.left; T.right} =

          if index = 0 then
            Printf.eprintf "%d of %d\n%!" i count_tasks;

          (* Printf.eprintf "fold_tasks index(%d) best_count(%d) cur_count(%d) ->%!" *)
          (*                i best_count' cur_count; *)
          if intersects itv left right then (
            (* Printf.eprintf "REJECT\n%!"; *)
            (best_count')
          )
          else begin
              (* Printf.eprintf "task_folder id(%d) FIT\n%!" i; *)
              (* Printf.eprintf "ADD %d\n%!" i; *)
              let new_count = check_recursion_level
                                (add itv left right) (i + 1)
                                best_count' (cur_count + 1)
              in
              (* Printf.eprintf "REM %d\n%!" i; *)
              if new_count > best_count' then
                (new_count)
              else
                (best_count')
            end

        in
        let (best_count') =
          array_foldi_left_partial task_folder (best_count) infoArr index
        in
        best_count'
        (* max best_count' best_count *)
      and check_recursion_level itv index best_count cur_count =
        (* Printf.eprintf "check_recursion_level...\n%!"; *)
        if index >= count_tasks then
          (* Reached end of recursion *)
          cur_count
        else if task_residual index + cur_count < best_count then
          (* Won't do better than best_count at end of recursion *)
          cur_count
        else
          (* Proceed with this level of recursion *)
          iter_tasks itv index best_count cur_count
      in
      check_recursion_level Interval.empty 0 0 0

  end
