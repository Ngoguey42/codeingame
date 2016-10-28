// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   bender.hpp                                         :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/28 15:38:06 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/28 16:49:08 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#ifndef BENDER_HPP
# define BENDER_HPP

// # include "states.hpp" // Comment because of file concatenation

// class States; // Comment because of file concatenation

class Bender {

  c::City &_city;
  States _states;

  void _move(c::Coord dst);

public:
  c::Coord coord;
  Dir dir;
  bool inv, breaker, done;

  Bender(c::City &c);
  ~Bender();

  void operator()();

};

#endif
