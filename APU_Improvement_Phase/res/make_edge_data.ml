(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   make_edge_data.ml                                  :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 13:00:26 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/03 13:21:12 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Make_edge_data : (
  sig
	val make : unit -> (Vert.t array * int * int
						* (int, int) Hashtbl.t * (int, int) Hashtbl.t)
  end) = (
  struct

	type acc = {
		vCount : int;
		capSum : int;
		l : Vert.t list;
	  }

	let make () =

	  let _ = int_of_string (input_line stdin) in
	  let h = int_of_string (input_line stdin) in
	  let xVertTbl = Hashtbl.create 100 in
	  let yVertTbl = Hashtbl.create 100 in

	  let rec aux y acc =
		if y >= h then
		  acc
		else (
	  	  let lineStr = input_line stdin in
	  	  Printf.eprintf "%s\n" lineStr;

	  	  FtString.foldi (fun x ({vCount; capSum; l} as acc') c ->
	  		  match c with
	  		  | '.' -> acc'
	  		  | _ -> let cap = int_of_char c - int_of_char '0' in
					 Hashtbl.add yVertTbl y vCount;
					 Hashtbl.add xVertTbl x vCount;
					 { vCount = vCount + 1
					 ; capSum = capSum + cap
					 ; l = { Vert.coords = (x, y)
						   ; Vert.capacity = cap }
						   ::l }
	  		) acc lineStr
		  |> aux (y + 1)

		)
	  in
	  let {vCount; capSum; l} = aux 0 {vCount = 0; capSum = 0; l = []} in

	  let vertArr = Array.make vCount { Vert.coords = (0, 0)
									  ; Vert.capacity = 0 } in

	  let _ =
		List.fold_left (fun i vrtx -> vertArr.(i) <- vrtx; i - 1) (vCount - 1) l
	  in

	  (vertArr, vCount, capSum, xVertTbl, yVertTbl)

  end)
