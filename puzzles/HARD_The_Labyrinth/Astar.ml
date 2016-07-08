(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Astar.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/07/08 15:05:30 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/07/08 16:11:43 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Astar =
  struct

    module type Elt_intf =
      sig
        type t
        type graph

        include Hashtbl.HashedType
                with type t := t

        val heuristic : src:t -> goal:t -> int
        val cost : src:t -> next:t -> int
        val neighbors : graph -> t -> t list
      end

    module Make(Elt : Elt_intf) :
    sig
      type graph = Elt.graph

      val run : graph:graph -> src:Elt.t -> goal:Elt.t -> exp_node_count:int
                -> Elt.t list
    end =
      struct
        type graph = Elt.graph

        module NodeInfo =
          struct
            type t = {
                parent_opt : t option
              ; g : int (* cost *)
              ; h : int (* heuristic *)
              ; state : [`Open | `Close]
              }

            let create parent_opt g h =
              { parent_opt
              ; g
              ; h
              ; state = `Open
              }
          end
        module NodeCandidate =
          struct
            type t = {
                g : int (* cost *)
              ; h : int (* heuristic *)
              ; data : Elt.t
              }

            let create g h data =
              {g; h; data}

            let compare a b =
              a.g + a.h - b.g - b.h
          end

        module PQ = BinHeap.Make(NodeCandidate)
        module HT = Hashtbl.Make(Elt)

        let loop ~graph ~goal ~nodestbl ~nodespq =
          let rec extract_top () =
            let cdt = PQ.pop_maximum nodespq in
            let info = HT.find nodestbl cdt.NodeCandidate.data in
            if Elt.equal goal cdt.NodeCandidate.data
            then info
            else get_neighbors cdt info
          and get_neighbors cdt info =
            match info.NodeInfo.state with
            | `Close ->
               extract_top ()
            | `Open ->
            let neighbors = Elt.neighbors graph cdt.NodeCandidate.data in

          in
          ()

        let run ~graph ~src ~goal ~exp_node_count =
          let nodestbl = HT.create exp_node_count in
          let nodespq = PQ.create exp_node_count in
          let src_h = Elt.heuristic ~src ~goal in
          let src_info = NodeInfo.create None 0 src_h in
          let src_cdt = NodeCandidate.create 0 src_h src in
          HT.add nodestbl src src_info;
          PQ.add nodespq src_cdt;
          loop graph goal nodestbl nodespq
          |> ignore;
          []

      end
  end
