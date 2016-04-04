(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   make_graph.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 13:25:20 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/04 06:57:08 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Make_graph = (
  struct


    let make () =
      let (vertArr, vCount, capSum, xVertTbl, yVertTbl) =
        Make_vertices_data.make ()
      in
      Printf.eprintf "#%d vertices\n%!" vCount;
      let edgeArr, eCount =
        Make_edges_data.make vertArr xVertTbl yVertTbl
      in
      Printf.eprintf "#%d edges\n%!" eCount;
      for i = 0 to Array.length edgeArr - 1 do
        Printf.eprintf "%s\n%!" @@ ToString.edge_id vertArr edgeArr i
      done;

      ignore(edgeArr);
      ()



  end)
