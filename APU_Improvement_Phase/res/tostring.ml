(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   tostring.ml                                        :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/04 07:34:24 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/04 08:52:16 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module type S_ToString_E =
  sig
    val t : Edge.t -> string
    val t_id : Vert.t array -> Edge.t array -> int -> string
  end
module type S_ToString_V =
  sig
    val t : Vert.t -> string
    val t_id : Vert.t array -> int -> string
    val t_id_list : Vert.t array -> int list -> string
    val var : Vert.varying -> string
    val var_id : Vert.varying array -> int -> string
  end
module type S_ToString =
  sig
    module V : S_ToString_V
    module E : S_ToString_E
  end

module ToString : S_ToString = (
  struct
    module Make_E (V : S_ToString_V) : S_ToString_E =
      struct
        let t { Edge.verts_id = (a, b)
              ; Edge.perp_edges_id
              ; Edge.capacity
              ; Edge.orientation} =
          let perpStr = String.concat ";" @@ List.map string_of_int perp_edges_id
          in
          let oriStr = match orientation with
            | Edge.Vertical x -> Printf.sprintf "(Vert x=%d)" x
            | Edge.Horizontal y -> Printf.sprintf "(Hori y=%d)" y
          in
          Printf.sprintf "(vIds(%d, %d), perpVIds(%s), cap(%d), ori(%s))"
                         a b perpStr capacity oriStr

        let t_id vArr eArr eId =
          let { Edge.verts_id = (aId, bId)
              ; Edge.perp_edges_id
              ; Edge.capacity
              ; Edge.orientation} = eArr.(eId) in
          let perpStr = String.concat ";" @@ List.map string_of_int perp_edges_id
          in
          let oriStr = match orientation with
            | Edge.Vertical x -> Printf.sprintf "(Vert x=%d)" x
            | Edge.Horizontal y -> Printf.sprintf "(Hori y=%d)" y
          in
          Printf.sprintf "#%02d(v(%s, %s), perpVIds(%s), cap(%d), ori(%s))"
                         eId
                         (V.t_id vArr aId)
                         (V.t_id vArr bId)
                         perpStr capacity oriStr
      end

    module Make_V (E : S_ToString_E) : S_ToString_V =
      struct
        let t {Vert.coords = (x, y); Vert.capacity} =
          Printf.sprintf "(x%d, y%d, c%d)" x y capacity

        let t_id arr i =
          let {Vert.coords = (x, y); Vert.capacity} = arr.(i) in
          Printf.sprintf "#%02d(x%d, y%d, c%d)" i x y capacity

        let t_id_list arr l =
          Printf.sprintf "[%s]" (String.concat "; " @@ List.map (t_id arr) l)



        let var { Vert.unlocked_edges
                ; Vert.residual
                ; Vert.group } =
          let unlockStr =
            String.concat ";" @@ List.map string_of_int unlocked_edges in
          let grpStr = match group with
            | Vert.Root -> "Root"
            | Vert.Pointer i -> Printf.sprintf "Ptr#%d" i
          in
          Printf.sprintf "unlockEdges(%s), resi(%d), %s"
                         unlockStr residual grpStr

        let var_id arr i =
          Printf.sprintf "#%02d(%s)" i @@ var arr.(i)

      end

    module rec E : S_ToString_E = Make_E(V)
       and V : S_ToString_V = Make_V(E)

  end)
