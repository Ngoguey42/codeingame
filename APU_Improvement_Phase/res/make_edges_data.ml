(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   make_edges_data.ml                                 :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/03 13:28:44 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/03 16:57:36 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Make_edges_data : (
  sig
	val make : Vert.t array -> (int, int) Hashtbl.t -> (int, int) Hashtbl.t
			   -> (Edge.t array * int)
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

	let debugArr = ref [||] (* TODO: Remove *)

	let orientationAnalysis :
		  (int, int) Hashtbl.t
		  -> (int -> int) -> (int -> Edge.orientation)
		  -> Edge.t list -> int
		  -> (Edge.t list * int * (int, int) Hashtbl.t) =
	  fun dimVertTbl getOtherDim getOrientation initELst initECount ->

	  let dimEdgeTbl = Hashtbl.create 100 in

	  let edgesOfVertices dimVal vLst eLst eCount =

		(* Printf.eprintf "edgesOfVertices dimVal=%d vLst=(%s)\n%!" dimVal *)
		(* @@ Vert.id_list_to_string !debugArr vLst; *)
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
						; Edge.orientation = getOrientation dimVal } in
				(* Printf.eprintf "New edge: %s \n%!" *)
				(* @@ Edge.to_string e; *)

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

	  (* Exploiting a feature of Hashtbl.fold:
	   * "[...] if the table contains several bindings for the same key,
	   *  they are [...] passed [...] in [...] order [...]" *)
	  let vertTblFolder dimVal vId ({ prevDimVal = prevDimValOpt
									; vLst; eLst; eCount } as acc) =

		(* Printf.eprintf "vertTblFolder vId=%d dimVal=%d\n%!" vId dimVal; *)
		match prevDimValOpt with
		| None ->
		   {acc with prevDimVal = Some dimVal; vLst = [vId]}
		| Some prevDimVal when prevDimVal <> dimVal ->
		   let eLst, eCount =
			 edgesOfVertices prevDimVal vLst eLst eCount in
		   {prevDimVal = Some dimVal; vLst = [vId]; eLst ; eCount}
		| Some prevDimVal ->
		   {acc with vLst = vId::vLst}
	  in

	  let { prevDimVal = prevDimValOpt; vLst; eLst; eCount } =
		Hashtbl.fold vertTblFolder dimVertTbl { prevDimVal = None
											  ; vLst = []
											  ; eLst = initELst
											  ; eCount = initECount }
	  in
	  let eLst, eCount = match prevDimValOpt with
		| None ->
		   assert false
		| Some prevDimVal ->
		   edgesOfVertices prevDimVal vLst eLst eCount
	  in
	  (eLst, eCount, dimEdgeTbl)


	(*
	 * 		- xVertTbl unused, it was unforeseen
	 * 		- the combo Hashtbl/forloop could be improved a lot with a combo
	 * 	Set/Range-iteration. Sadly range-iteration doen't exist in standard lib,
	 *	nor in core.set, nor in batteries.set  (nor in c++ std::set). It would
	 *	be easy to implement though.
	 *)
	let genPerpIds vArr eArr xVertTbl yVertTbl =

	  let aux eId {Edge.orientation; Edge.verts_id = (aId, bId)} =

		match orientation with
		| Edge.Vertical edgeX ->
		   let {Vert.coords = (_, aY)} = vArr.(aId) in
		   let {Vert.coords = (_, bY)} = vArr.(bId) in
		   let edgeTopY, edgeBotY = if aY < bY then aY, bY else bY, aY in

		   for edge'Y = edgeTopY + 1 to edgeBotY - 1 do
			 Hashtbl.find_all yVertTbl edge'Y
			 |> List.iter (fun eId' ->
		   			let {Edge.verts_id = (cId, dId)} = eArr.(eId') in
		   			let {Vert.coords = (cX, _)} = vArr.(cId) in
		   			let {Vert.coords = (dX, _)} = vArr.(dId) in
					let leftX, rightX = if cX < dX then cX, dX else dX, cX in

					if edge'Y = 1 && edgeX = 3 then (
					  Printf.eprintf "salut verEdge#%d horizEdge#%d \n%!"
									 eId eId';

					);

					if leftX < edgeX && rightX > edgeX
					   && edgeTopY < edge'Y && edgeBotY > edge'Y
					then begin
					  let {Edge.perp_edges_id} as edge = eArr.(eId) in
					  eArr.(eId) <- {edge with
									  Edge.perp_edges_id = eId'::perp_edges_id};
					  let {Edge.perp_edges_id} as edge = eArr.(eId') in
					  eArr.(eId') <- {edge with
									  Edge.perp_edges_id = eId::perp_edges_id}
					  end
		   		  )
		   done
		| _ -> ()

	  in
	  Array.iteri aux eArr
	let make vertArr xVertTbl yVertTbl =

	  debugArr := vertArr;
	  let (eLst_tmp, eCount_tmp, xEdgeTbl) =
		orientationAnalysis
		  xVertTbl
		  (fun vId -> let {Vert.coords = (_, y)} = vertArr.(vId) in y)
		  (fun x -> Edge.Vertical x) [] 0
	  in
	  let (eLst, eCount, yEdgeTbl) =
		orientationAnalysis
		  yVertTbl
		  (fun vId -> let {Vert.coords = (x, _)} = vertArr.(vId) in x)
		  (fun y -> Edge.Horizontal y) eLst_tmp eCount_tmp
	  in
	  let eArr = Array.make eCount { Edge.verts_id = (0, 0)
								   ; Edge.perp_edges_id = []
								   ; Edge.capacity = 0
								   ; Edge.orientation = Edge.Vertical 0 }
	  in
	  let eCapa {Edge.verts_id = (aId, bId)} =
		let {Vert.capacity = aCap}, {Vert.capacity = bCap} =
		  vertArr.(aId), vertArr.(bId)
		in
		match aCap, bCap with
		| 1, _ | _, 1 -> 1
		| _, _ -> 2
	  in
	  let _ =
		List.fold_left
		  (fun i e -> eArr.(i) <- {e with Edge.capacity = eCapa e }; i - 1)
		  (eCount - 1) eLst
	  in
	  genPerpIds vertArr eArr xEdgeTbl yEdgeTbl;
	  (eArr, eCount)


  end)
