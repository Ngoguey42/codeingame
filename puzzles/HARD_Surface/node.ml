(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   node.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/20 11:18:35 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/20 12:14:11 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Vertex =
  struct
    type water = [ `Root of (int * int) * int (* self coords / count *)
                 | `Pointer of (int * int) ](* root coords *)
    type t = [ water
             | `Land ]

  end
