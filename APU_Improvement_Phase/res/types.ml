(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   types.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 12:22:46 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/04 09:00:59 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Edge = (
  struct
    type orientation = Vertical of int | Horizontal of int
    type t = {
        verts_id : int * int; (* vertex a and vertex b *)
        perp_edges_id : int list; (* egdes crossed *)
        capacity : int; (* max 2 a.capacity b.capacity -> {1; 2} *)
        orientation : orientation;
      }
    type varying = {
        prune : bool; (* saturation of a vertex
                  or blocked by other edge *)
        residual : int; (* capacity left -> {0; 1; 2} *)
      }

  end)

module Vert = (
  struct
    (* A vertex is either
            - Root of a group
            - Pointing to top or left parent *)
    type connection = Root | Pointer of int
    type t = {
        coords : int * int; (* from stdin *)
        capacity : int; (* from stdin *)
      }
    type varying = {
        unlocked_edges : int list; (* adjacent edges with
                  prune == false && flux > 0 *)
        residual : int; (* capacity left -> {0-capacity} *)
        group : connection;
      }

  end)

module Graph = (
  struct
    type t = {
        verts : Vert.t array;
        edges : Edge.t array;
        vertsCount : int;
        edgesCount : int;
        bridgesCount : int; (* (Sum (Vert.capacity)) / 2 *)
      }
    type varying = {
        vertsVar : Vert.varying array; (* TODO: rename or move *)
        edgesVar: Edge.varying array;
        rootsCount : int; (* (Sum (Vert.group | Root -> 1 | _ -> 0))
                             start at num_verts *)
        bridgesResidual : int; (* num_bridges - (Sum (Vert.residual)) / 2 Start at 0 *)
      }
  end)
