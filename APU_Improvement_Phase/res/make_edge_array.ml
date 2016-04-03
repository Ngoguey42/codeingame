(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   make_edge_array.ml                                 :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 12:33:12 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/03 12:40:44 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Make_edge_array = (
  struct

	let of_stdin () =

	  let w = int_of_string (input_line stdin) in
	  let h = int_of_string (input_line stdin) in
	  let verts_count = ref 0 in

	  let rec aux y acc =
		if y >= h then
		  acc
		else (
		  let line = input_line stdin in
		  let acc =
			FtString.foldi (fun x acc c ->
				match c with
				| '.' -> acc
				| _ -> incr verts_count; (x, y, int_of_char c - int_of_char '0')::acc
			  ) acc line
		  in

		  Printf.eprintf "%s %d\n" line !verts_count;
		  aux (y + 1) acc
		)
	  in

	  let l =  aux 0 [] in
	  (w, h, l, !verts_count)

  end)
