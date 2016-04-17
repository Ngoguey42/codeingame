(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   cfg.ml                                             :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/17 14:22:54 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/17 14:37:07 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Cfg = (* See "cfg" file for details *)
  struct

    let rec keyword stream indent_lvl =
      Read_write_primitive.cur_keyword stream


    and number stream indent_lvl =
      Read_write_primitive.cur_number stream


    and assoc_rhs stream indent_lvl =
      ignore(Stream.next stream); (* skipping '=' *)
      Read_write_primitive.cur_spaces stream;
      match Stream.cur stream with
      | Some ' ' | Some '\t' | Some '\n' ->
         assert false (*unreachable*)
      | Some '(' ->
         block stream indent_lvl
      | Some '\'' ->
         Read_write_primitive.cur_string stream
      | Some '0'..'9' ->
         number stream indent_lvl
      | Some _ ->
         keyword stream indent_lvl
      | None ->
         failwith "Reached EOS while expecting an assoc value"


    and string_or_assoc stream indent_lvl =
      Read_write_primitive.cur_string stream;
      Read_write_primitive.cur_spaces stream;
      match Stream.cur stream with
      | Some ' ' | Some '\t' | Some '\n' ->
         assert false (*unreachable*)
      | Some '=' ->
         assoc_rhs stream indent_lvl
      | Some c ->
         assert (match c with ')' | ';' -> true | _ -> false);
         ()
      | None ->
         ()


    and block stream indent_lvl =
      ignore(Stream.next stream); (* skipping '(' *)
      Read_write_primitive.cur_spaces stream;
      match Stream.cur stream with (* segregate empty / non-empty block case *)
      | Some ')' ->
         ignore(Stream.next stream); (* skipping ')' *)
         ()
      | None ->
         failwith "Reached EOS while expecting a closing paren for empty block"
      | Some _ ->
         let rec aux () =
           element stream (indent_lvl + 1);
           Read_write_primitive.cur_spaces stream;
           match Stream.cur stream with
           | Some ';' ->
              ignore(Stream.next stream); (* skipping ';' *)
              aux ()
           | Some ')' ->
              ignore(Stream.next stream); (* skipping ')' *)
              ()
           | None ->
              failwith "Reached EOS while expecting a closing paren for non-empty block"
           | Some c ->
              failwith @@ Printf.sprintf "Unexpected char '%c' inside block" c
         in
         aux ()


    and element stream indent_lvl =
      Read_write_primitive.cur_spaces stream;
      match Stream.cur stream with
      | Some ' ' | Some '\t' | Some '\n' ->
         assert false (*unreachable*)
      | Some '(' ->
         block stream indent_lvl
      | Some '\'' ->
         string_or_assoc stream indent_lvl
      | Some '0'..'9' ->
         number stream indent_lvl
      | Some _ ->
         keyword stream indent_lvl
      | None ->
         failwith "Reached EOS while expecting an element"

  end