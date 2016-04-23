(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   pass1.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/23 10:39:02 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/23 13:42:43 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Task_infoArr_and_eventsPq =
  struct
    module T = Task
    module E = Task.Event
    module EventPq = Task.EventPq

    let of_stdin () =
      let n = int_of_string (input_line stdin) in
      let eventsPq = EventPq.create n in
      let infoArr =
        (fun i ->
          let line = input_line stdin in
          let start, len = Scanf.sscanf line "%d %d" (fun j d -> (j, d)) in
          EventPq.add eventsPq { E.day = start
                               ; E.id = i
                               ; E.info = E.Start };
          { T.left = start
          ; T.right = start + len
          ; T.overlap_count = 0 }
        ) |> Array.init n
      in
      n, infoArr, eventsPq

  end
