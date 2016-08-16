(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   bit_array.ml                                       :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/07/08 13:11:12 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/07/08 14:36:10 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Bit_array =
  struct
    type t = {
        arr : int array
      ; len : int
      }

    let int_bits =
      let rec aux acc = function
        | 0 -> acc
        | v -> aux (acc + 1) (v lsl 1)
      in
      aux 0 1

    let make ~len v =
      assert(len >= 0);
      let arrlen = (len + int_bits - 1) / int_bits in
      let arrv = match v with
        | 0 -> 0
        | 1 -> -1
        | _ -> assert (false)
      in
      { arr = Array.make arrlen arrv
      ; len}

    let unsafe_set {arr} i =
      let celli = i / int_bits in
      Array.get arr celli
      |> (lor) (1 lsl (i mod int_bits))
      |> Array.set arr celli

    let unsafe_unset {arr} i =
      let celli = i / int_bits in
      Array.get arr celli
      |> (land) (lnot (1 lsl (i mod int_bits)))
      |> Array.set arr celli

    let unsafe_get {arr} i =
      let celli = i / int_bits in
      Array.get arr celli
      |> (land) (1 lsl (i mod int_bits))

    let set ({len} as v) i =
      assert (i < len);
      unsafe_set v i

    let unset ({len} as v) i =
      assert (i < len);
      unsafe_unset v i

    let get ({len} as v) i =
      assert (i < len);
      unsafe_get v i

    let size {len} =
      len
  end
