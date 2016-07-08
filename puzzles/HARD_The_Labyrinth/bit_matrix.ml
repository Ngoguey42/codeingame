(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   bit_matrix.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/07/08 14:07:16 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/07/08 14:37:14 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Bit_matrix =
  struct
    (* Row major setup, left hand rule, (0,0) at top left
     * 0 <= j < n; (Col) (x)
     * 0 <= i < m; (Row) (y)
     *)

    type t = Bit_array.t array

    let exists ~i ~j t =
      let m = Array.length t in
      let n = match m with
        | 0 -> max_int
        | _ -> Array.get t 0 |> Bit_array.size
      in
      i < m && j < n

    let make ~m ~n v =
      assert(v >= 0 && v <= 1);
      ArrayLabels.init m ~f:(fun _ -> Bit_array.make ~len:n v)

    let unsafe_set ~i ~j t =
      Bit_array.unsafe_set (Array.get t i) j

    let unsafe_unset ~i ~j t =
      Bit_array.unsafe_unset (Array.get t i) j

    let unsafe_get ~i ~j t =
      Bit_array.unsafe_get (Array.get t i) j

    let set ~i ~j t =
      assert (exists ~i ~j t);
      unsafe_set ~i ~j t

    let unset ~i ~j t =
      assert (exists ~i ~j t);
      unsafe_unset ~i ~j t

    let get ~i ~j t =
      assert (exists ~i ~j t);
      unsafe_get ~i ~j t

  end
