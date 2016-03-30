
module Edge = (struct
				type t = {
					verts_id : int * int; (* vertex a and vertex b *)
					perp_edges_id : int list; (* egdes crossed *)
					capacity : int; (* max 2 a.capacity b.capacity -> {1; 2} *)
				  }
				type varying = {
					prune : bool; (* saturation of a vertex
									or blocked by other edge *)
					flux : int; (* capacity left -> {0; 1; 2} *)
				  }

			  end)

module Connection = (struct
					  (* A vertex is either
						- Root of a group
						- Pointing to top or left parent *)
					  type t = Root | Pointer of int
					end)

module Vert = (struct
				type t = {
					coords : int * int; (* from stdin *)
					capacity : int; (* from stdin *)
				  }
				type varying = {
					unlocked_edges : int list; (* adjacent edges with
												prune == false && flux > 0 *)
					deficit : int; (* capacity left -> {0-capacity} *)
					group : Connection.t;
				  }

			  end)


module Graph = (struct
				 type t = {
					 verts : Vert.t array;
					 edges : Edge.t array;
				   }
				 type varying = {
					 verts : Vert.varying array;
					 edges : Edge.varying array;
				   }

			   end)


;; (* End of modules declaration *)
