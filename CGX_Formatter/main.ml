(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/17 13:13:59 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/17 14:38:40 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let () =
  let n = int_of_string (input_line stdin) in
  let stream = Stream.create n in
  Cfg.element stream 0
  (* for i = 0 to n - 1 do *)
  (*   let cgxline = input_line stdin in *)
  (*   (); *)
  (* done; *)
  (* (\* To debug: prerr_endline "Debug message"; *\) *)
  (* print_endline "answer" *)
