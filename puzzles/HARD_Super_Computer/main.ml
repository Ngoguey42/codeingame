(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/21 16:06:45 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/23 15:22:52 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let () =
  Printf.eprintf "%s\n%!" Sys.executable_name;
  (* if Sys.executable_name <> "/tmp/native" then begin *)
  (*     (\* Nasty hack to get native ocaml *\) *)
  (*     ignore (Sys.command "ocamlopt /tmp/Answer.ml -o /tmp/native"); *)
  (*     ignore (Sys.command "/tmp/native") *)
  (*   end *)
  (* else *)
    begin
      Printf.eprintf "Phase1\n%!";
      let ((n, infoArr, eventsPq) as pass1) = Task_infoArr_and_eventsPq.of_stdin () in
      Printf.eprintf "Phase2\n%!";
      let overlapsPq = Task_overlap_count_and_overlapsPq.of_pass1 pass1 in
      Printf.eprintf "Phase3\n%!";
      let count = Task_nonoverlapping_count.of_pass2 pass1 overlapsPq in
      Printf.printf "algo1: %d\n%!" count;


      Printf.eprintf "Debug\n%!";
      let count_debug = Dumb_implementation.nonoverlapping_count_of_infoArr
                          infoArr in
      Printf.printf "algo2: %d\n%!" count_debug;
      if count_debug <> count
      then exit 1
    end
