module type S_Foldable = sig
    type t
    type elt
    
    val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
    val cardinal : t -> int
end

module type S_FoldableOp = sig
    type t
    type elt
    
    val find_index_opt : t -> int -> elt option
    val median_exn : t -> elt
end

module type S_MakeFoldableOp =
    functor (Foldable: S_Foldable) ->
    S_FoldableOp with type t := Foldable.t and type elt := Foldable.elt

module MakeFoldableOp : S_MakeFoldableOp =
    functor (Foldable: S_Foldable) ->
    struct
        type t = Foldable.t
        type elt = Foldable.elt
        
        let rec find_index_opt cont index =
            
            let aux elt (i, res) =
                if i == index
                then ((i + 1), Some elt)
                else ((i + 1), res)
            in
            
            let _, elt_opt = Foldable.fold aux cont (0, None) in
            elt_opt
            
        and median_exn cont =
            
            let len = Foldable.cardinal cont in
            
            match find_index_opt cont (len / 2) with
            | None -> failwith "empty container"
            | Some med -> med
        
    end

module IntSet = Set.Make(struct type t = int let compare = compare end)
module IntSetFoldableOp = MakeFoldableOp(IntSet)

;; (* End of Modules declaration *)

let int_div nbr div =
    match nbr >= 0, div > 0 with
    | false, false | true, true -> (nbr + div / 2) / div
    | true, false | false, true -> (nbr - div / 2) / div
in

let read_stdin () =

    let count = int_of_string (input_line stdin) in
    let arry =  Array.make count 0 in

    let rec aux (minx, maxx) sumy i sety =
        if i >= count then
            (minx, maxx), sumy, sety
        else begin
            let line = input_line stdin in
            let x, y = Scanf.sscanf line "%d %d" (fun x y -> (x, y)) in

            (* Printf.eprintf "#(%d, %d)\n%!" x y; *)
            arry.(i) <- y;
            aux (min minx x, max maxx x) (sumy + y) (i + 1) (IntSet.add y sety)
        end
    in
    
    let (minx, maxx), sumy, sety = aux (max_int, min_int) 0 0 (IntSet.empty)in
    
    ((minx, maxx), sumy, count, arry, sety)
in

let (minx, maxx), sumy, count, arry, sety = read_stdin () in

(*
    avgy UNUSED
    -> sumy UNUSED
    -> count UNUSED
    
    arry and sety are REDUNDENT 
*)

let avgy = int_div sumy count in
let mediany = IntSetFoldableOp.median_exn sety in

let horiz_len = maxx - minx in
let vert_len = Array.fold_left (fun acc y -> acc + abs (y - mediany)) 0 arry in

Printf.eprintf "#%d minx\n%!" minx;
Printf.eprintf "#%d maxx\n%!" maxx;
Printf.eprintf "#%d horiz_len\n%!" horiz_len;
prerr_endline "";
Printf.eprintf "#%d sumy\n%!" sumy;
Printf.eprintf "#%d count\n%!" count;
Printf.eprintf "#%d mediany\n%!" mediany;
Printf.eprintf "#%d avgy\n%!" avgy;
Printf.eprintf "#%d vert_len\n%!" vert_len;

Printf.printf "%d\n%!" (horiz_len + vert_len);
