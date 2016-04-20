(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/20 11:06:02 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/20 12:33:23 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let () =
  Printf.eprintf "Hello world\n%!";
  let map = Map.empty_of_stdin () in
  Printf.eprintf "TAMERE1\n%!";
  Map.fill map;
  Printf.eprintf "TAMERE2\n%!";
  Map.dump map;
  ()
