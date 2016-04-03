(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   ft_string.ml                                       :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 12:36:11 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/03 12:36:23 by ngoguey          ###   ########.fr       *)
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
