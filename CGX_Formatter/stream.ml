(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   stream.ml                                          :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/17 14:24:07 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/17 15:06:36 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Stream =
  struct

    type t = {
        num_line : int;
        mutable line_index : int;
        mutable line : string;
        mutable char_index : int;
        mutable char_opt : char option;
      }

    let cur {char_opt} =
      char_opt

    (* Required to use input line *)
    let rec next stream =
      stream.char_index <- stream.char_index + 1;
      if stream.char_index < String.length stream.line then (
        (* Next char on line *)
        stream.char_opt <- Some (String.get stream.line stream.char_index);
        cur stream
      ) else if stream.char_index = String.length stream.line then (
        (* Emulating a \n *)
        stream.char_opt <- Some '\n';
        cur stream
      ) else (
        (* Reached end of line *)
        stream.line_index <- stream.line_index + 1;
        if stream.line_index >= stream.num_line then (
          (* Reached end of input *)
          stream.char_opt <- None;
          cur stream
        ) else (
          (* Loading next line *)
          let cgxline = input_line stdin in
          Printf.eprintf "LOADING \"%s\"\n%!" cgxline;
          stream.line <- cgxline;
          stream.char_index <- 0;
          next stream
          (* stream.char_opt <- Some (String.get stream.line stream.char_index) *)
        )
      )


    let _create num_line line char_opt = {
        num_line; line_index = 0; line; char_index = 0; char_opt = char_opt
      }

    let create num_line =
      if num_line <= 0 then
        _create 0 "" None
      else begin
          let cgxline = input_line stdin in
          Printf.eprintf "INIT WITH \"%s\" num_line=%d\n%!" cgxline num_line;
          let char_opt = match cgxline with
            | "" -> Some '\n'
            | _ -> Some (String.get cgxline 0)
          in
          _create num_line cgxline char_opt
        end

  end
