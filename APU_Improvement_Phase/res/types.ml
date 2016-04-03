(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   types.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 12:22:46 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/03 15:03:00 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Edge = (
  struct
	type orientation = Vertical of int | Horizontal of int
	type t = {
		verts_id : int * int; (* vertex a and vertex b *)
		perp_edges_id : int list; (* egdes crossed *)
		capacity : int; (* max 2 a.capacity b.capacity -> {1; 2} *)
		orientation : orientation;
	  }
	type varying = {
		prune : bool; (* saturation of a vertex
									or blocked by other edge *)
		flux : int; (* capacity left -> {0; 1; 2} *)
	  }
	let to_string { verts_id = (a, b)
				  ; perp_edges_id
				  ; capacity
				  ; orientation} =
	  let perpStr = String.concat ";" @@ List.map string_of_int perp_edges_id
	  in
	  let oriStr = match orientation with
		| Vertical x -> Printf.sprintf "(Vert x=%d)" x
		| Horizontal y -> Printf.sprintf "(Hori y=%d)" y
	  in
	  Printf.sprintf "(vIds(%d, %d), perpVIds(%s), cap(%d), ori(%s))"
					 a b perpStr capacity oriStr

  end)

module Connection = (
  struct
	(* A vertex is either
						- Root of a group
						- Pointing to top or left parent *)
	type t = Root | Pointer of int
  end)

module Vert = (
  struct
	type t = {
		coords : int * int; (* from stdin *)
		capacity : int; (* from stdin *)
	  }
	type varying = {
		unlocked_edges : int list; (* adjacent edges with
												prune == false && flux > 0 *)
		deficit : int; (* capacity left -> {0-capacity} *)
		group : Connection.t;
	  }
	let to_string {coords = (x, y); capacity} =
	  Printf.sprintf "(x%d, y%d, c%d)" x y capacity

	let id_to_string arr i =
	  let {coords = (x, y); capacity} = arr.(i) in
	  Printf.sprintf "#%d(x%d, y%d, c%d)" i x y capacity

	let id_list_to_string arr l =
	  Printf.sprintf "[%s]" (String.concat "; " @@ List.map (id_to_string arr) l)

  end)

module Graph = (
  struct
	type t = {
		verts : Vert.t array;
		edges : Edge.t array;
		num_verts : int;
		num_edges : int;
		num_bridges : int; (* (Sum (Vert.capacity)) / 2 *)
	  }
	type varying = {
		verts : Vert.varying array; (* TODO: rename or move *)
		edges : Edge.varying array;
		num_roots : int; (* (Sum (Vert.group | Root -> 1 | _ -> 0))
										start at num_verts *)
		bridges_left : int; (* num_bridges - (Sum (Vert.defict))
											/ 2 Start at 0 *)
	  }
  end)
