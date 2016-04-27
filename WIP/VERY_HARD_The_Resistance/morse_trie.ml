(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   morse_trie.ml                                      :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2016/04/27 10:53:28 by ngoguey           #+#    #+#             *)
(*   Updated: 2016/04/27 10:59:33 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Morse_Trie =
  struct



    class iterator =
    object (self)
      inherit [int, int] Binary_Trie.iterator as super

    end


  end
