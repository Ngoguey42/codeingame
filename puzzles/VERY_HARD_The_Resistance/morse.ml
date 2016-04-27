(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   morse.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/27 12:07:51 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 15:11:11 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Morse =
  struct
    let dirs_of_char = function
      | 'A' -> [`Left; `Right; ]
      | 'B' -> [`Right; `Left; `Left; `Left; ]
      | 'C' -> [`Right; `Left; `Right; `Left; ]
      | 'D' -> [`Right; `Left; `Left; ]
      | 'E' -> [`Left; ]
      | 'F' -> [`Left; `Left; `Right; `Left; ]
      | 'G' -> [`Right; `Right; `Left; ]
      | 'H' -> [`Left; `Left; `Left; `Left; ]
      | 'I' -> [`Left; `Left; ]
      | 'J' -> [`Left; `Right; `Right; `Right; ]
      | 'K' -> [`Right; `Left; `Right; ]
      | 'L' -> [`Left; `Right; `Left; `Left; ]
      | 'M' -> [`Right; `Right; ]
      | 'N' -> [`Right; `Left; ]
      | 'O' -> [`Right; `Right; `Right; ]
      | 'P' -> [`Left; `Right; `Right; `Left; ]
      | 'Q' -> [`Right; `Right; `Left; `Right; ]
      | 'R' -> [`Left; `Right; `Left; ]
      | 'S' -> [`Left; `Left; `Left; ]
      | 'T' -> [`Right; ]
      | 'U' -> [`Left; `Left; `Right; ]
      | 'V' -> [`Left; `Left; `Left; `Right; ]
      | 'W' -> [`Left; `Right; `Right; ]
      | 'X' -> [`Right; `Left; `Left; `Right; ]
      | 'Y' -> [`Right; `Left; `Right; `Right; ]
      | 'Z' -> [`Right; `Right; `Left; `Left; ]
      | _ -> assert false


    let dirs_of_word str =

      (* Read chars from end to begin *)
      let rec aux i acc =
        if i < 0
        then acc
        else (dirs_of_char (String.get str i))::acc
             |> aux (i - 1)
      in
      aux (String.length str - 1) []
    |> List.concat


    let string_of_dirs dirs = (* debug *)

      List.map (function `Left -> "l" | `Right -> "r") dirs
      |> String.concat ""


    let dirs_of_string str =

      (* Read chars from end to begin *)
      let rec aux i acc =
        if i < 0
        then acc
        else (match String.get str i with
              | '.' -> `Left
              | '-' -> `Right
              | _ -> assert false
             ) :: acc
             |> aux (i - 1)
      in
      aux (String.length str - 1) []

  end
