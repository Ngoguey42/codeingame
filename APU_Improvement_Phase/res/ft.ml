(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   ft.ml                                              :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 13:51:25 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/03 13:54:41 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module FtString = (
  struct

	let foldi : (int -> 'a -> char -> 'a) -> 'a -> string -> 'a = fun f acc str ->

	  let strlen = String.length str in

	  let rec aux i acc =
		if i >= strlen
		then acc
		else aux (i + 1) (f i acc (String.get str i))
	  in
	  aux 0 acc

  end)

module FtList = (
  struct

	let reduce : 'a list -> f:('a -> 'a -> 'a) -> 'a option = fun l ~f ->

	  match l with
	  | [] -> None
	  | hd::tl -> Some (List.fold_left f hd tl)

  end)
