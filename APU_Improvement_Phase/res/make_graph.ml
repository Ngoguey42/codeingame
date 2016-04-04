(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   make_graph.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 13:25:20 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/04 09:27:00 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Make_graph =
  struct

    let make () =
      let (vertArr, vCount, capSum, xVertTbl, yVertTbl) =
        Make_vertices_data.make ()
      in
      assert (capSum mod 2 = 0);
      Printf.eprintf "#%d vertices\n%!" vCount;
      let edgeArr, eCount =
        Make_edges_data.make vertArr xVertTbl yVertTbl
      in
      Printf.eprintf "#%d edges\n%!" eCount;
      for i = 0 to Array.length edgeArr - 1 do
        Printf.eprintf "%s\n%!" @@ ToString.E.t_id vertArr edgeArr i
      done;

      let eVarArr = Make_varying_parts.make_edges edgeArr in
      let vVarArr = Make_varying_parts.make_vertices vertArr edgeArr in

      for i = 0 to Array.length vVarArr - 1 do
        Printf.eprintf "%s\n%!" @@ ToString.V.var_id vVarArr i
      done;

      ({ Graph.verts = vertArr
       ; Graph.edges = edgeArr
       ; Graph.vertsCount = vCount
       ; Graph.edgesCount = eCount
       ; Graph.bridgesCount = capSum / 2 },
       { Graph.vertsVar = vVarArr
       ; Graph.edgesVar = eVarArr
       ; Graph.rootsCount = vCount
       ; Graph.bridgesResidual = capSum / 2 })

  end
