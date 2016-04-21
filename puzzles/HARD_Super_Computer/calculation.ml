(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   calculation.ml                                     :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/21 16:06:44 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/21 16:39:39 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)


(* module IntMap = *)
(*   Map.Make( *)
(*       struct *)
(*         type t = int *)
(*         let compare = compare *)
(*       end) *)

module Calc =
  struct

    module type Event_intf =
      sig
        type info = Start | End
        type t = { day : int
                 ; id : int
                 ; info : info }
        include BinHeap.Ordered with type t := t
      end
    module Event : Event_intf =
      struct
        type info = Start | End
        type t = { day : int
                 ; id : int
                 ; info : info }

        (* Reversed day and day' in compare to get a min_pq of the
         * max_pq implementation *)
        let compare {day} {day = day'} =
          day' - day
      end
    module EventPq = BinHeap.Make(Event)


    module Overlap =
      struct
        type t = { overlap_count : int
                 ; id : int
                 }
        let compare {overlap_count} {overlap_count = overlap_count'} =
          overlap_count' - overlap_count
      end
    module OverlapPq = BinHeap.Make(Overlap)


    let events_of_stdin () =
      let n = int_of_string (input_line stdin) in
      let events = EventPq.create (n * 2) in

      for i = 0 to n - 1 do
        let line = input_line stdin in
        let start, len = Scanf.sscanf line "%d %d" (fun j d -> (j, d)) in

        EventPq.add events { Event.day = start
                           ; Event.id = i
                           ; Event.info = Event.Start
                           };
        EventPq.add events { Event.day = start + len
                           ; Event.id = i
                           ; Event.info = Event.End
                           };
        ()
      done;
      n, events


    let overlaps_per_id_of_events n events =

      let overlaps = OverlapPq.create n in

      let rec aux open_count =
        if not @@ EventPq.is_empty events then begin
            let { Event.day
                ; Event.id
                ; Event.info } = EventPq.pop_maximum events in
            match info with
            | Event.Start ->
               aux (open_count + 1)
            | Event.End ->
               Printf.eprintf "#%d overlaps %d times\n%!" id (open_count - 1);
               OverlapPq.add overlaps { Overlap.overlap_count = open_count - 1
                                      ; Overlap.id = id
                                      };
               aux (open_count - 1)
          end
      in
      aux 0;
      overlaps

  end
