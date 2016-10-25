
let lowering_dichotomy v minbound maxbound =
    let maxbound' = min maxbound (v - 1) in
    let v' = (maxbound' + minbound) / 2 in (* round down division *)
    (v', maxbound')
in

let growing_dichotomy v minbound maxbound =
    let minbound' = max minbound (v + 1) in
    let v' = (minbound' + maxbound + 1) / 2 in (* round up division *)
    (v', minbound')
in

let rec loop ((x, y) as coord) ((left, right) as xbounds_incl) ((up, down) as ybounds_incl) =
    let line = input_line stdin in
    
    Printf.eprintf "%s\n%!" line;
    match line with
    | "U" ->
        let y', down' = lowering_dichotomy y up down in
        move (x, y') xbounds_incl (up, down')
    | "D" ->
        let y', up' = growing_dichotomy y up down in
        move (x, y') xbounds_incl (up', down)
        
    | "L" ->
        let x', right' = lowering_dichotomy x left right in
        move (x', y) (left, right') ybounds_incl
    | "R" ->
        let x', left' = growing_dichotomy x left right in
        move (x', y) (left', right) ybounds_incl
        
    | "UR" ->
        let y', down' = lowering_dichotomy y up down in
        let x', left' = growing_dichotomy x left right in
        move (x', y') (left', right) (up, down')
    | "DR" ->
        let y', up' = growing_dichotomy y up down in
        let x', left' = growing_dichotomy x left right in
        move (x', y') (left', right) (up', down)
    | "DL" ->
        let y', up' = growing_dichotomy y up down in
        let x', right' = lowering_dichotomy x left right in
        move (x', y') (left, right') (up', down)
    | "UL" ->
        let y', down' = lowering_dichotomy y up down in
        let x', right' = lowering_dichotomy x left right in
        move (x', y') (left, right') (up, down')
and move ((x, y) as coord) xbounds_incl ybounds_incl =
    Printf.printf "%d %d\n%!" x y;
    loop coord xbounds_incl ybounds_incl
in

let line = input_line stdin in
let w, h = Scanf.sscanf line "%d %d" (fun w h -> (w, h)) in
let _ = int_of_string (input_line stdin) in (* maximum number of turns before game over. *)

let line = input_line stdin in
let x0, y0 = Scanf.sscanf line "%d %d" (fun x0 y0 -> (x0, y0)) in

loop (x0, y0) (0, w - 1) (0, h - 1)
