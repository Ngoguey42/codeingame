(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   pass3.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/23 13:46:33 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/23 14:11:54 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Task_nonoverlapping_count =
  struct
    module T = Task
    module O = Task.Overlap
    module OverlapPq = Task.OverlapPq

    (* Operations to make 'exclusive bounds' out of
     * the 'inclusive bounds' implementation *)
    let add itv left right =
      Interval.add itv ~low:(left * 2 + 1) ~high:(right * 2 - 1) ~data:()
    let intersects itv left right =
      Interval.intersects itv ~low:(left * 2) ~high:(right * 2)


    let of_pass2 (n, infoArr, eventsPq) overlapsPq =

      let rec aux itv count =
        if not @@ OverlapPq.is_empty overlapsPq
        then aux' itv count
        else count
      and aux' itv count =
        let {O.overlap_count; O.id} = OverlapPq.pop_maximum overlapsPq in
        let {T.left; T.right} = infoArr.(id) in
        (* Printf.eprintf "count(%02d) %!" overlap_count; *)
        if intersects itv left right
        then begin
            (* Printf.eprintf "id(%02d) rejected\n%!" id; *)
            aux itv count
          end
        else begin
            (* Printf.eprintf "id(%02d) accepted\n%!" id; *)
            aux (add itv left right) (count + 1)
          end
      in
      aux Interval.empty 0

  end
