(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   read_write_primitive.ml                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/17 13:22:54 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/17 14:00:23 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Read_write_primitive =
  struct
    (*
     * All functions take stream on the first char,
     *   and leave stream on the first char after end of primitive.
     *)

    let cur_keyword stream = (* a trie would do great here!!! *)
      assert (match Stream.cur stream with Some 'a'..'z' -> true | _ -> false);
      let cur_word =
        let rec aux char_wrap acc =
          match char_wrap with
          | Some ('a'..'z' as c) -> aux (Stream.next stream) (acc ^ c)
          | _ -> acc
        in
        aux (Stream.cur stream) ""
      in
      match cur_word with
      | "false" | "true" | "null" -> print_string cur_word
      | _ -> failwith @@ "unknown keyword: \"" ^ cur_word ^ "\""


    let cur_number stream =
      let rec aux char_wrap =
        match char_wrap with
        | Some ('0'..'9' as c) -> print_char c; aux @@ Stream.next stream
        | _ -> ()
      in
      assert (match Stream.cur stream with Some '0'..'9' -> true | _ -> false);
      aux @@ Stream.cur stream


    let cur_string stream =
      let rec aux char_wrap =
        match char_wrap with
        | Some '\'' -> ()
        | Some c -> print_char c; aux @@ Stream.next stream
        | None -> failwith "Reached EOS before closing quote \"'\""
      in
      assert (Stream.cur stream = Some '\'');
      print '\'';
      aux @@ Stream.next stream;
      print '\'';
      ignore(Stream.next stream)


    let cur_spaces stream =
      match Stream.cur stream with
      | Some ' ' | Some '\t' | Some '\n' ->
         ignore(Stream.next stream);
         cur_spaces stream
      | _ -> ()

  end
