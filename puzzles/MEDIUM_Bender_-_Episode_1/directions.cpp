// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   directions.cpp                                     :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/28 14:10:22 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/28 16:22:18 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <iostream>

// Directions *************************************************************** **

class Dir {

private:
  enum class _dir {
    south, east, north, west,
  };

  _dir _d;

  Dir(_dir d)
    : _d(d) {
  }

public:
  static const Dir south;
  static const Dir east;
  static const Dir north;
  static const Dir west;

  Dir(Dir const &src)
    : _d(src._d) {
  }

  Dir &operator=(Dir const &rhs) {
    _d = rhs._d;
    return *this;
  }

  ~Dir() {
  }

  static Dir first(bool invert) {
    if (!invert)
      return south;
    else
      return west;
  }

  static Dir fallback(c::City const &c, c::Coord const &src,
                      bool inv, bool breaker) {
    Dir d = first(inv);
    c::cell dst_type;

    while (true) {
      // std::cerr << "fb " << d << std::endl;
      dst_type = c.cell_of_coord(src + d);
      if (dst_type == c::breakable && breaker)
        break ;
      else if (dst_type == c::breakable || dst_type == c::unbreakable) {
        d = d.next(inv);
      }
      else
        break;
    }
    return d;
  }

  bool operator ==(Dir const &rhs) const {
    return _d == rhs._d;
  }

  operator c::Coord() const {
    switch (_d) {
    case (_dir::south): return {0, 1};
    case (_dir::east): return {1, 0};
    case (_dir::north): return {0, -1};
    case (_dir::west): return {-1, 0};
    }
    assert(false);
    return {};
  }

  operator char const *() const {
    switch (_d) {
    case (_dir::south): return "SOUTH";
    case (_dir::east): return "EAST";
    case (_dir::north): return "NORTH";
    case (_dir::west): return "WEST";
    }
    assert(false);
    return {};
  }

  Dir next(bool invert) const {
    const int i = (static_cast<int>(_d) + (invert ? -1 : 1) + 4) % 4;

    return Dir(static_cast<_dir>(i));
  }

};

const Dir Dir::south = Dir(_dir::south);
const Dir Dir::east = Dir(_dir::east);
const Dir Dir::north = Dir(_dir::north);
const Dir Dir::west = Dir(_dir::west);
