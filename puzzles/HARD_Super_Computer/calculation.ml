(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   calculation.ml                                     :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/21 16:06:44 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/21 16:18:45 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module type EventInfo_intf =
  sig
    type info = Start | End
    type t = { day : int
             ; id : int
             ; info : info }
    include BinHeap.Ordered with type t := t
  end

module EventInfo : EventInfo_intf =
  struct
    type info = Start | End
    type t = { day : int
             ; id : int
             ; info : info }
    (* Reversed day and day' in compare to get a min_pq of the
     * max_pq implementation*)

    let compare {day} {day = day'} =
      day' - day
  end

module EventPq = BinHeap.Make(EventInfo)

module Calc =
  struct

    let events_of_stdin () =
      let n = int_of_string (input_line stdin) in
      let events = EventPq.create n in

      for i = 0 to n - 1 do
        let line = input_line stdin in
        let start, len = Scanf.sscanf line "%d %d" (fun j d -> (j, d)) in

        EventPq.add events { EventInfo.day = start
                           ; EventInfo.id = i
                           ; EventInfo.info = EventInfo.Start
                           };
        EventPq.add events { EventInfo.day = start + len
                           ; EventInfo.id = i
                           ; EventInfo.info = EventInfo.End
                           };
        ()
      done;
      n, events
  end
