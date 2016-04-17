(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   stream.ml                                          :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/17 14:24:07 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/17 14:32:20 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Stream =
  struct

    type t = {
        num_line : int;
        mutable str_index : int;
        mutable str : string;
        mutable index : int;
      }

    let cur {str; index} =
      Some (String.get str index)

    let next ({str; index} as stream) =
      stream.index <- index + 1;
      cur stream

    let create num_line = {
        num_line; str_index = 0; str = ""; index = 0
      }

  end
