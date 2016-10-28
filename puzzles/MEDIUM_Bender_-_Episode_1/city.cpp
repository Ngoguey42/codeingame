// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   city.cpp                                           :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/28 13:51:28 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/28 16:50:18 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <exception>
#include <vector>
#include <cassert>

namespace c {

// Coordinates ************************************************************** **
struct Coord {
  int x;
  int y;

  Coord operator+(Coord const &rhs) const {
    return {x + rhs.x, y + rhs.y};
  }

  Coord operator-(Coord const &rhs) const {
    return {x - rhs.x, y - rhs.y};
  }

  bool operator==(Coord const &rhs) const {
    return x == rhs.x && y == rhs.y;
  }

};

// Cells ******************************************************************** **

// breaker and breakable too close, source of mistyping
enum cell {
  start, end, unbreakable, breakable, empty,
    south, east, north, west, inverter, breaker,
    teleport
};

cell cell_of_char(char c) {
  switch (c) {
  case ('@'): return start;
  case ('$'): return end;
  case ('#'): return unbreakable;
  case ('X'): return breakable;
  case (' '): return empty;
  case ('S'): return south;
  case ('E'): return east;
  case ('N'): return north;
  case ('W'): return west;
  case ('I'): return inverter;
  case ('B'): return breaker;
  case ('T'): return teleport;
  default: throw new std::exception();
  }
}

char char_of_cell(cell c) {
  switch (c) {
  case (start): return '@';
  case (end): return '$';
  case (unbreakable): return '#';
  case (breakable): return 'X';
  case (empty): return ' ';
  case (south): return 'S';
  case (east): return 'E';
  case (north): return 'N';
  case (west): return 'W';
  case (inverter): return 'I';
  case (breaker): return 'B';
  case (teleport): return 'T';
  default: throw new std::exception();
  }
}

// TELEPORTER *************************************************************** **
class Teleporter {

  const bool _some;

public:
  const Coord a;
  const Coord b;

  Teleporter(int coord_count, Coord const (&coords)[2])
    : _some(coord_count == 2)
    , a(coords[0])
    , b(coords[1]) {
  }

  Coord other(Coord const &o) const {
    if (a.x == o.x && a.y == o.y)
      return b;
    else {
      assert(b.x == o.x && b.y == o.y);
      return a;
    }
  }

};

// CITY ********************************************************************* **
class City {

private:
  std::vector<cell> _matrix;

public:
  const int w, h;
  const Teleporter tp;
  const Coord start, end;

  City(int w, int h, std::vector<cell> &&matrix, Teleporter const &tp,
       Coord const &start, Coord const &end)
    : _matrix(matrix)
    , w(w)
    , h(h)
    , tp(tp)
    , start(start)
    , end(end) {
  }

  cell cell_of_coord(Coord const &c) const {
    return _cell_of_coord2(c.x, c.y);
  }

  void break_wall(Coord const &c) {
    assert(_matrix[w * c.y + c.x] == breakable);
    _matrix[w * c.y + c.x] =empty;
  }

private:
  cell _cell_of_coord2(int x, int y) const {
    return _matrix[w * y + x];
  }

};

}
