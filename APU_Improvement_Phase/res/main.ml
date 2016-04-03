(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 12:38:12 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/03 12:39:04 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let (w, h, verts_l, verts_count) as tup = Make_edge_array.of_stdin () in

	Printf.eprintf "#%d vertices\n%!" verts_count;
	print_endline "0 0 2 0 1";
