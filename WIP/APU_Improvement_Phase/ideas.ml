(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   ideas.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/03/26 13:35:18 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/03/26 14:47:20 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type conclusion = Update of int | Unchanged | Invalid

let rec make_conclusion graph cur_flux end_flux ... =

	if cur_flux < end_flux then (
		match Graph.scan_nodes graph ... with
		| Update new_flux ->
			make_conclusion graph new_flux end_flux ... (* Tail recursion *)
		| Invalid ->
			Fail (* Return value *)
		| Unchanged ->
			forall_assumptions graph cur_flux end_flux ... (* Iteration before recursion *)

	) else (
		Success graph (* Return value *)
	)

(* Try all assumptions one by one with f(), until one returns a Success  *)
and forall_assumptions graph cur_flux end_flux ... =

	let graph_cp = Graph.clone graph in

	let rec aux ... =
		match ... with
		| NoMoreAssumption -> Fail (* Return value *)
		| _ ->
			let new_flux = some_way_of_making_an_assumption graph_cp cur_flux ... in

			match make_conclusion graph_cp new_flux end_flux with (* Recursion *)
			| Fail -> Graph.restore graph_cp graph; aux ... (* Iteration *)
			| success -> success (* Return value (transmission) *)

	in
	aux ...

in
