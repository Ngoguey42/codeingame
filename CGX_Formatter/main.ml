(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/17 13:13:59 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/17 14:00:31 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Cfg =
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
         assert false
      | Some '(' ->
         block stream indent_lvl
      | Some '\'' ->
         Read_write_primitive.cur_string stream
      | Some '0'..'9' ->
         number stream indent_lvl
      | Some _ ->
         keyword stream indent_lvl

    and string_or_assoc stream indent_lvl =
      Read_write_primitive.cur_string stream;
      Read_write_primitive.cur_spaces stream;
      match char_opt with
      | Some ' ' | Some '\t' | Some '\n' ->
         assert false
      | Some '=' ->
         assoc_rhs stream indent_lvl
      | Some c ->
         assert (match c with ')' | ';' -> true | -> false);
         ()
      | None ->
         ()


    and block stream indent_lvl =

      let rec aux char_opt =


      in
      aux @@ String.cur


    and element stream indent_lvl =
      Read_write_primitive.cur_spaces stream;
      match Stream.cur stream with
      | Some ' ' | Some '\t' | Some '\n' ->
         assert false
      | Some '(' ->
         block stream indent_lvl
      | Some '\'' ->
         string_or_assoc stream indent_lvl
      | Some '0'..'9' ->
         number stream indent_lvl
      | Some _ ->
         keyword stream indent_lvl
      | None ->
         ()

  end

    (* Write an action using print_endline *)
    (* To debug: prerr_endline "Debug message"; *)

    print_endline "answer";
