(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   make_varying_parts.ml                              :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/04 07:13:01 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/04 08:51:32 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Make_varying_parts =
  struct

    let make_edges eArr =
      Array.map (fun {Edge.capacity} -> { Edge.prune = false
                                        ; Edge.residual = capacity }) eArr

    let make_vertices vArr eArr =
      let vVarArr = Array.map (fun {Vert.capacity} -> { Vert.unlocked_edges = []
                                                      ; Vert.residual = capacity
                                                      ; Vert.group = Vert.Root
                              }) vArr in
      Array.iteri (fun eId {Edge.verts_id = (aId, bId)} ->
          let ({Vert.unlocked_edges = aLst} as a) = vVarArr.(aId) in
          let ({Vert.unlocked_edges = bLst} as b) = vVarArr.(bId) in
          vVarArr.(aId) <- {a with Vert.unlocked_edges = eId::aLst};
          vVarArr.(bId) <- {b with Vert.unlocked_edges = eId::bLst};
        ) eArr;
      vVarArr
  end
