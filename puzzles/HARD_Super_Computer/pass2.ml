(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   pass2.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/23 10:47:48 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/23 12:58:09 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Task_overlap_count_and_overlapsPq =
  struct
    module T = Task
    module E = Task.Event
    module O = Task.Overlap
    module EventPq = Task.EventPq
    module OverlapPq = Task.OverlapPq

    let of_pass1 = fun (n, infoArr, eventsPq) ->
      let overlapsPq = OverlapPq.create n in
      let opentaskHTbl = Hashtbl.create 100 in

      let rec aux () =
        if not @@ EventPq.is_empty eventsPq
        then aux' ()
      and aux' () =
        let {E.day; E.id; E.info} = EventPq.pop_maximum eventsPq in
        match info with
        | E.Start ->
           (* Printf.eprintf "Day%02d: id(%d) Start\n%!" day id; *)
           Hashtbl.iter (fun openid count ->
               (* Incrementing opentaskHTbl.(openid) instead of infoArr.(openid)
                * for Memory Coalescing *)
               Hashtbl.replace opentaskHTbl openid (count + 1)) opentaskHTbl;
           (* Printf.eprintf "%d\n%!" @@ Hashtbl.length opentaskHTbl; *)
           Hashtbl.add opentaskHTbl id @@ Hashtbl.length opentaskHTbl;
           let {T.right} = infoArr.(id) in
           EventPq.add eventsPq { E.day = right
                                ; E.id
                                ; E.info = E.End };
           aux ()
        | E.End ->
           let overlap_count = Hashtbl.find opentaskHTbl id in
           (* Printf.eprintf "Day%02d: id(%d) Ends with overlap_count(%d)\n%!" day id overlap_count; *)
           Hashtbl.remove opentaskHTbl id;
           infoArr.(id) <- {infoArr.(id) with T.overlap_count};
           OverlapPq.add overlapsPq {O.overlap_count; O.id};
           aux ()
      in
      aux ();
      overlapsPq

  end
