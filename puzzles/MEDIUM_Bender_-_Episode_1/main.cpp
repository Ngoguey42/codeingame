// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   main.cpp                                           :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/28 13:51:14 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/28 16:48:52 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <iostream>

// #include "states.hpp" // Comment because of file concatenation
// #include "bender.hpp" // Comment because of file concatenation

/*
 * City
 * '@' start
 * '$' end

 * '#' obstacle
 * 'X' obstacle
 * ' ' empty

 * 'S|E|N|W' direction change
 * 'I' priority inversion
 * 'B' break mode (makes X mutables)
 * 'T' teleport

 * on obstacle ahead: S -> E -> N -> W (rev on I == true)

 * Loop
 */

// STATES ******************************************************************* **
bool State::operator==(State const &rhs) const {
  return src == rhs.src &&
    dst == rhs.dst &&
    inv == rhs.inv &&
    breaker == rhs.breaker;
}

int std::hash<State>::operator()(State const &s) const {
  int h = 0;

  if (s.inv)
    h |= 0b1;
  if (s.breaker)
    h |= 0b10;
  h = h | (s.src.x << 2);
  h = h | (s.src.y << 7);
  h = h | (s.dst.x << 12);
  h = h | (s.dst.y << 17);
  return h;
}

// Call before bender's move, and before city wall destroy
void States::notify(Bender const &b, c::Coord const &dst, c::City const &c) {
  const State s{b.coord, dst, b.inv, b.breaker};

  if (c.cell_of_coord(dst) == c::breakable)
    _states.clear();
  if (_states.find(s) != _states.end())
    throw 42;
  _states.insert(s);
  _moves.push_back(b.dir);
}

void States::dump_moves() {
  for (Dir d: _moves)
    std::cout << d << std::endl;
}

// BENDER ******************************************************************* **
Bender::Bender(c::City &c)
  : _city(c)
  , coord(c.start)
  , dir(Dir::first(false))
  , inv(false)
  , breaker(false)
  , done(false) {
}

Bender::~Bender() {
}

void Bender::operator()() {

  c::Coord ahead_coord;
  c::cell ahead_type;

  while (!done) {
    ahead_coord = coord + dir;
    ahead_type = _city.cell_of_coord(ahead_coord);

    if ((ahead_type == c::breakable && !breaker) ||
        ahead_type == c::unbreakable) {
      dir = Dir::fallback(_city, coord, inv, breaker);
      ahead_coord = coord + dir;
      ahead_type = _city.cell_of_coord(ahead_coord);
    }

    switch (ahead_type) {
    case (c::end):
      _move(coord + dir);
      done = true;
      break;
    case (c::breakable):
      assert(breaker);
      _move(coord + dir);
      break ;
    case (c::unbreakable):
      assert(false);
      break;
    case (c::start):
    case (c::empty):
      _move(coord + dir);
    break;

    case (c::south):
      _move(coord + dir);
      dir = Dir::south;
      break;
    case (c::east):
      _move(coord + dir);
      dir = Dir::east;
      break;
    case (c::north):
      _move(coord + dir);
      dir = Dir::north;
      break;
    case (c::west):
      _move(coord + dir);
      dir = Dir::west;
      break;

    case (c::inverter):
      _move(coord + dir);
      inv = inv ? false : true;
      break;
    case (c::breaker):
      _move(coord + dir);
      breaker = breaker ? false : true;
      break;
    case (c::teleport):
      _move(_city.tp.other(coord + dir));
      break;
    }
  }
  _states.dump_moves();
}

void Bender::_move(c::Coord dst) {
  _states.notify(*this, dst, _city);

  std::cerr
    << "'" << c::char_of_cell(_city.cell_of_coord(coord)) << "' "
    << "x:" << coord.x << " "
    << "y:" << coord.y << " "
    << "to: " << dir << " "
    << "'" << c::char_of_cell(_city.cell_of_coord(dst)) << "' "
    << std::endl;

  coord = dst;
  if (_city.cell_of_coord(dst) == c::breakable)
    _city.break_wall(dst);
}


c::City *city_of_cin() {
  using std::cin;

  int w, h;
  std::string line;
  std::vector<c::cell> city;
  c::Coord start, end;
  c::Coord tp[2];
  int tp_count = 0;
  c::cell c;

  cin >> h;
  cin >> w;
  cin.ignore();

  city.reserve(h * w);
  for (int y = 0; y < h; y++) {
    std::getline(cin, line);
    std::cerr << line << std::endl;

    for (int j = 0; j < w; j++) {
      c = c::cell_of_char(line[j]);
      city.push_back(c);
      switch (c) {
      case (c::teleport):
        tp[tp_count++] = c::Coord{j, y};
        break;
      case (c::start):
        start = c::Coord{j, y};
        break;
      case (c::end):
        end = c::Coord{j, y};
        break;
      default:
        break;
      }
    }
  }
  return
    new c::City(w, h, std::move(city), c::Teleporter(tp_count, tp), start, end);
}


int main() {

  auto c = city_of_cin();

  try {
    Bender{*c}();
  }
  catch (int) {
    std::cout << "LOOP" << std::endl;
  }
  delete c;
  return 0;
}
