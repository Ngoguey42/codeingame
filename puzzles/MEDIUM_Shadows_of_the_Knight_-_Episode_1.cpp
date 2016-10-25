// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   MEDIUM_Shadows_of_the_Knight_-_Episode...          :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/25 15:02:24 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/25 16:33:32 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#pragma GCC diagnostic error "-Wall"
#pragma GCC diagnostic error "-Wextra"

#include <iostream>
#include <map>
#include <exception>

enum class HDir {
  Left, None, Right,
};

enum class VDir {
  Up, None, Down,
};

class Movement {

public:
  const HDir h;
  const VDir v;

  Movement(std::string const &str)
    : Movement(_dirs_of_string(str)) {
  }

  Movement(std::pair<HDir, VDir> &&pair)
    : h(pair.first)
    , v(pair.second) {
  }

private:
  static std::pair<HDir, VDir> _dirs_of_string(std::string const &str) {
    if (str == "U") return {HDir::None, VDir::Up};
    else if (str == "UR") return {HDir::Right, VDir::Up};
    else if (str == "UL") return {HDir::Left, VDir::Up};
    else if (str == "D") return {HDir::None, VDir::Down};
    else if (str == "DR") return {HDir::Right, VDir::Down};
    else if (str == "DL") return {HDir::Left, VDir::Down};
    else if (str == "R") return {HDir::Right, VDir::None};
    else if (str == "L") return {HDir::Left, VDir::None};
    else throw new std::exception();
  }

};

class Loop {

private:
  int x, y;
  int const h, w;
  int minx, maxx, miny, maxy;

public:
  Loop(int x0, int y0, int h, int w)
    : x(x0)
    , y(y0)
    , h(h)
    , w(w)
    , minx(0)
    , maxx(w - 1)
    , miny(0)
    , maxy(h - 1) {
  }

  void operator()() {
    using std::cin;

    std::string movement_str;

    while (true) {
      cin >> movement_str;
      _process_direction(Movement{movement_str});
    }
  }

private:
  void _process_direction(Movement const &m) {
    int dstx, dsty;

    switch (m.h) {
    case (HDir::Left):
      dstx = (x + minx) / 2;
      maxx = x - 1;
      break;
    case (HDir::Right):
      dstx = (x + maxx + 1) / 2;
      minx = x + 1;
      break ;
    case (HDir::None):
      dstx = x;
      break ;
    }
    switch (m.v) {
    case (VDir::Up):
      dsty = (y + miny) / 2;
      maxy = y - 1;
      break;
    case (VDir::Down):
      dsty = (y + maxy + 1) / 2;
      miny = y + 1;
      break ;
    case (VDir::None):
      dsty = y;
      break ;
    }
    std::cout << dstx << " " << dsty << std::endl;
    x = dstx;
    y = dsty;
  }

};

Loop loop_from_cin() {
  using std::cin;

  int w, h, n, x0, y0;

  cin >> w;
  cin >> h;
  cin >> n;
  cin >> x0;
  cin >> y0;
  return Loop(x0, y0, h, w);
}

int main() {
  loop_from_cin()();
}
