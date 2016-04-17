(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/17 12:18:21 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/17 12:18:24 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

(* Auto-generated code below aims at helping you parse *)
(* the standard input according to the problem statement. *)

let n = int_of_string (input_line stdin) in
    for i = 0 to n - 1 do
      let cgxline = input_line stdin in
      ();
    done;


    (*
O(N) algorithm, on-the-fly output


read_write_cur_* all take stream on the first char, and leave stream on the first char after end

let read_write_cur_keyword stream = a trie would do great here!!!
    assert (match stream#cur with Some 'a'..'z' -> true | _ -> false);
    let cur_word =
        let rec aux char_wrap acc =
            match char_wrap with
            | Some ('a'..'z' as c) -> aux stream#next (acc ^ c)
            | _ -> acc
        in
        aux stream#cur ""
    in
    match cur_word with
    | "false" | "true" | "null" -> print cur_word
    | _ -> failwith @@ "unknown keyword: \"" ^ cur_word ^ "\""


let read_write_cur_number stream =
    let rec aux char_wrap =
        match char_wrap with
        | Some ('0'..'9' as c) -> print c; aux stream#next
        | _ -> ()
    in
    assert (match stream#cur with Some '0'..'9' -> true | _ -> false);
    aux stream#cur


let read_write_cur_string stream =
    let rec aux char_wrap =
        match char_wrap with
        | Some '\'' -> ()
        | Some c -> print c; aux stream#next
        | None -> failwith "Reached EOS before closing quote \"'\""
    in
    assert (stream#cur = Some '\'');
    print '\'';
    aux stream#next;
    print '\'';
    ignore(stream#next)




let entry_keyword stream indent_lvl =
    read_write_cur_keyword stream;
    match read_cur_word stream with

    | _ -> assert false

primitive_past_lhsString
    | ' ' | '\t' | '\n' -> repeat
    | '=' ->

primitive_lhsString
    | '\'' -> primitive_past_lhsString
    | '_' -> repeat

block_closing
    | ' ' | '\t' | '\n' -> repeat
    | ';' -> ()
    | <EOS> -> ()
    | _ -> assert false

and entry_paren stream indent_lvl =
    block stream (indent_lvl + 1)
    match stream#cur with
    | None -> failwith "Missing closing paren at EOS"
    | ')' -> ()


and block stream indent_lvl =
    match stream#next with
    | Some ' ' | Some '\t' | Some '\n' -> block stream indent_lvl
    | Some '(' -> entry_paren stream indent_lvl
    | Some '\'' ->
    | Some '0'..'9' ->
    | Some ')' | None -> ()
    | Some _ -> entry_keyword stream indent_lvl

     *)

    (* Write an action using print_endline *)
    (* To debug: prerr_endline "Debug message"; *)

    print_endline "answer";
