(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   make_edges_data.ml                                 :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 13:28:44 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/03 14:25:49 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Make_edges_data : (
  sig
	val make : Vert.t array -> (int, int) Hashtbl.t -> (int, int) Hashtbl.t
			   -> unit
  end) = (
  struct

	type dimAcc = {
		prevDimVal : int option;
		vLst : int list;
		eLst : Edge.t list;
		eCount : int;
	  }
	type vertIdAcc = {

		prevVertId : int option;
		eLst' : Edge.t list;
		eCount' : int;

	  }

	let orientationAnalysis :
		  (int, int) Hashtbl.t
		  -> (int -> int) -> Edge.orientation
		  -> Edge.t list -> int
		  -> unit =
	  fun dimVertTbl getOtherDim orientation initELst initECount ->

	  let dimEdgeTbl = Hashtbl.create 100 in

	  let edgesOfVertices dimVal vLst eLst eCount =

		match vLst with
		| [] ->
		   assert false
		| [_] ->
		   (eLst, eCount)
		| _ ->
		   let vertIdFolder {prevVertId = prevVertIdOpt; eLst'; eCount'} vId =
			 match prevVertIdOpt with
			 | None ->
				{prevVertId = Some vId; eLst'; eCount'}
			 | Some prevVertId ->
				let e = { Edge.verts_id = (prevVertId, vId)
						; Edge.perp_edges_id = []
						; Edge.capacity = 0
						; Edge.orientation = orientation } in
				Printf.eprintf "New edge TODO\n%!";
				Hashtbl.add dimEdgeTbl dimVal eCount';
				{ prevVertId = Some vId
				; eLst' = e :: eLst'
				; eCount' = eCount' + 1 }
		   in
		   let {eLst'; eCount'} =
			 List.sort (fun a b -> getOtherDim a - getOtherDim b) vLst
			 |> List.fold_left vertIdFolder { prevVertId = None
											; eLst' = eLst
											; eCount' = eCount }
		   in
		   (eLst', eCount')
	  in

	  let vertTblFolder dimVal vId ({ prevDimVal = prevDimValOpt
									; vLst; eLst; eCount } as acc) =

		match prevDimValOpt with
		| None ->
		   {acc with prevDimVal = Some dimVal; vLst = [vId]}
		| Some prevDimVal when prevDimVal <> dimVal ->
		   let eLst, eCount =
			 edgesOfVertices prevDimVal (vId::vLst) eLst eCount in
		   {prevDimVal = Some dimVal; vLst = [vId]; eLst ; eCount}
		| Some prevDimVal ->
		   {acc with vLst = vId::vLst}
	  in

	  let _ =
		Hashtbl.fold vertTblFolder dimVertTbl { prevDimVal = None
											  ; vLst = []
											  ; eLst = initELst
											  ; eCount = initECount }
	  in
	  (* TODO: handle last line *)
	  ()

	let make vertArr xVertTbl yVertTbl =

	  ()


  end)
