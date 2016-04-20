(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/20 11:06:02 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/20 14:18:08 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let () =
  Printf.eprintf "Hello world\n%!";
  let map = Map.empty_of_stdin () in
  Map.fill map;
  (* Map.dump map; *)
  let n = int_of_string (input_line stdin) in
  for i = 0 to n - 1 do
    let line = input_line stdin in
    let _, count =
      Scanf.sscanf line "%d %d" (fun x y -> (x, y))
      |> Map.root_info_of_pos map
    in
    Printf.printf "%d\n%!" count;
    ()
  done;
  ()
