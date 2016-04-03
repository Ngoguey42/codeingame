(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   make_graph.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 13:25:20 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/03 16:03:36 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Make_graph = (
  struct



	let make () =
	  let (vertArr, vCount, capSum, xVertTbl, yVertTbl) =
		Make_vertices_data.make ()
	  in
	  Printf.eprintf "#%d vertices\n%!" vCount;
	  let edgeArr =
		Make_edges_data.make vertArr xVertTbl yVertTbl
	  in
	  for i = 0 to Array.length edgeArr - 1 do
		Printf.eprintf "%s\n%!" @@ ToString.edge_id vertArr edgeArr i
	  done;

	  ignore(edgeArr);
	  ()



  end)
