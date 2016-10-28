// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   states.hpp                                         :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/28 15:40:34 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/28 16:49:19 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#ifndef STATES_HPP
# define STATES_HPP

#include <unordered_set>
#include <vector>

class Bender;

struct State {

  c::Coord src;
  c::Coord dst;
  bool inv;
  bool breaker;

  bool operator==(State const &rhs) const;

};

namespace std {

template <>
class hash<State> {

public:
  int operator()(State const &s) const;

};

}

class States {

private:
  std::vector<Dir> _moves;
  std::unordered_set<State> _states;

public:
  // Call before bender's move, and before city wall destruction
  void notify(Bender const &b, c::Coord const &dst, c::City const &c);

  void dump_moves();

};

#endif
