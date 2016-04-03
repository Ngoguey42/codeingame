(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   make_graph.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 13:25:20 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/03 13:28:19 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Make_graph = (
  struct



	let make () =
	  let (vertArr, vCount, capSum, xVertTbl, yVertTbl) =
		Make_vertices_data.make () in

	  Printf.eprintf "#%d vertices\n%!" vCount;
	  ()



  end)