(* String.set(...) is not deprecated yet in this version *)

module Map = (struct
    type tp = Zero | One of (int * int) | Two of (int * int * int * int)
    type t = {m_imp : string array; w : int; h : int; tp : (int * int * int * int) option}
    
    let warp_coords {tp} x y =
        match tp with
        | Some (s, t, p, q) when x = s && y = t -> (p, q)
        | Some (s, t, p, q) when x = p && y = q -> (s, t)
        | _ -> assert false
end)

module Dir = (struct
    include (struct type t = South | East | North | West end)
    
    let rec to_string = function
        | South -> "SOUTH"
        | East -> "EAST"
        | North -> "NORTH"
        | West -> "WEST"
        
    and to_delta = function
        | South -> (0, 1)
        | East -> (1, 0)
        | North -> (0, -1)
        | West -> (-1, 0)
    
    and to_stdout d =
        Printf.printf "%s\n%!" @@ to_string d
    (** Returns the direction to follow when Bender face a 'X' or a '#' *)
    and of_obtacle_ahead {Map.m_imp; Map.w; Map.h} (px, py) inv =
        let dir_set = match inv with
            | false -> [South ; East ; North ; West]
            | true ->  [West ; North ; East ; South]
        in
        List.find (fun dir ->
            let dx, dy = to_delta dir in
            let x, y = px + dx, py + dy in
            Printf.eprintf "%s?;" @@ to_string dir;
            if x < 0 || x >= w || y < 0 || y >= h then
                false
            else match String.get m_imp.(y) x with
                | '#' | 'X' -> false
                | _ -> Printf.eprintf "Kept\n%!"; true
        ) dir_set
end)

module LoopGuard = (struct

    module SSet = Set.Make(struct
        type t = int * int * Dir.t * bool * bool
        let compare = compare
    end)
    
    type t = SSet.t
    exception Looping
    
    let empty = SSet.empty
    let touch set tup =
        if SSet.mem tup set
        then raise Looping
        else SSet.add tup set

end)

module Bender = (struct
    type t = {x : int; y : int; face : Dir.t; inv : bool; beer : bool; loop_guard : LoopGuard.t; move_q : Dir.t Queue.t}
    
    let of_coord x y =
        {x; y; face = Dir.South; inv = false; beer = false; loop_guard = LoopGuard.empty; move_q = Queue.create ()}
end)

;; (* end of Modules declaration *)

let string_fold : ('a -> char -> 'a) -> 'a -> string -> 'a = fun f acc str ->

    let strlen = String.length str in

    let rec aux i acc =
        if i >= strlen
        then acc
        else aux (i + 1) (f acc (String.get str i))
    in
    aux 0 acc
in


let read_stdin () =
    
    let line = input_line stdin in
    let l, c = Scanf.sscanf line "%d %d" (fun l c -> (l, c)) in
    let arr = Array.init l (fun _ -> let ln = input_line stdin in ln) in
    
    let line_reader (y, start, tp) line =
        prerr_endline line; 

        let _, start, tp = string_fold (fun (x, start, tp) c ->
            match c, tp with
            | '@', _ ->
                ((x + 1), (x, y), tp)
            | 'T', Map.Zero ->
                ((x + 1), start, Map.One (x, y))
            | 'T', Map.One (px, py) ->
                ((x + 1), start, Map.Two (px, py, x, y))
            | _, _ -> ((x + 1), start, tp)
        ) (0, start, tp) line in
        
        (y + 1, start, tp)
    in
    
    let _, start, tp = Array.fold_left line_reader (0, (0, 0), Map.Zero) arr in
    
    ({Map.m_imp = arr; w = c; h = l; tp = (match tp with Map.Two tup -> Some tup | _ -> None)}
    , start)
in


let ({Map.m_imp; Map.w; Map.h} as map), (start_x, start_y) = read_stdin () in

let rec pick_dir ({Bender.face; Bender.x; Bender.y; Bender.inv; Bender.beer} as be) =
    let dx, dy = Dir.to_delta face in
    let tx, ty = x + dx, y + dy in
    Printf.eprintf "pick_dir while at (%d, %d ('%c')) beer(%b) inv(%b) facing '%s'(%d, %d ('%c')) \n%!"
        x y (String.get m_imp.(y) x)
        beer inv
        (Dir.to_string face)
        tx ty (String.get m_imp.(ty) tx);
    match String.get m_imp.(ty) tx with
    | ' ' | 'E' | 'N' | 'W' | 'S' | 'B' | 'I' | 'T' | '$' -> walk {be with Bender.loop_guard = LoopGuard.touch be.Bender.loop_guard (x, y, face, inv, beer)}
    | 'X' when beer -> walk {be with Bender.loop_guard = LoopGuard.empty}
    | '#' | 'X' -> walk {be with Bender.face = Dir.of_obtacle_ahead map (x, y) inv}
        
and walk ({Bender.face; Bender.x; Bender.y} as be) = 
    let dx, dy = Dir.to_delta face in
    let x, y = x + dx, y + dy in
    
    Queue.add face be.Bender.move_q;
    match String.get m_imp.(y) x with
    | 'X' -> String.set m_imp.(y) x ' '; pick_dir {be with Bender.x; Bender.y;}
    | 'E' -> pick_dir {be with Bender.x; Bender.y; Bender.face = Dir.East}
    | 'N' -> pick_dir {be with Bender.x; Bender.y; Bender.face = Dir.North}
    | 'W' -> pick_dir {be with Bender.x; Bender.y; Bender.face = Dir.West}
    | 'S' -> pick_dir {be with Bender.x; Bender.y; Bender.face = Dir.South}
    | 'B' -> pick_dir {be with Bender.x; Bender.y; Bender.beer = not be.Bender.beer}
    | 'I' -> pick_dir {be with Bender.x; Bender.y; Bender.inv = not be.Bender.inv}
    | 'T' -> let x, y = Map.warp_coords map x y in pick_dir {be with Bender.x; Bender.y;}
    | ' ' -> pick_dir {be with Bender.x; Bender.y;}
    | '$' -> be

    
in
try begin
    let {Bender.move_q} = pick_dir (Bender.of_coord start_x start_y) in
    Queue.iter Dir.to_stdout move_q
end with
    LoopGuard.Looping -> print_endline "LOOP"
