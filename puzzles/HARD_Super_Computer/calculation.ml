(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   calculation.ml                                     :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/21 16:06:44 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/21 17:27:51 by ngoguey          ###   ########.fr       *)
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
        let compare {day; info} {day = day'; info = info'} =
          if day = day' then
            match info, info' with
            | Start, End -> -1
            | End, Start -> 1
            | _, _ -> 0
          else
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

    let of_stdin () =
      let n = int_of_string (input_line stdin) in
      let events = EventPq.create (n * 2) in
      let calc_info = Hashtbl.create n in

      for i = 0 to n - 1 do
        let line = input_line stdin in
        let start, len = Scanf.sscanf line "%d %d" (fun j d -> (j, d)) in

        Hashtbl.add calc_info i (start, start + len);
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
      n, calc_info, events


    let overlaps_per_id_of_events n events =

      let overlaps = OverlapPq.create n in

      let rec aux open_count prev_day prev_acc =
        if not @@ EventPq.is_empty events then begin
            let { Event.day; Event.id; Event.info }
              = EventPq.pop_maximum events in
            let open_count, prev_acc =
              if prev_day <> day then (
                Printf.eprintf "decrementing open_count of %d\n%!" prev_acc;
                open_count - prev_acc, 0)
              else
                open_count, prev_acc
            in
            match info with
            | Event.Start ->
               Printf.eprintf "day(%d) calc%d start!\n%!" day id;
               aux (open_count + 1) prev_day prev_acc
            | Event.End ->
               Printf.eprintf "day(%d) calc%d end (%d overlap)!\n%!"
                              day id (open_count - 1);
               OverlapPq.add overlaps { Overlap.overlap_count = open_count - 1
                                      ; Overlap.id = id };
               aux open_count day (prev_acc + 1)
          end
      in
      aux 0 0 0;
      overlaps

  end
