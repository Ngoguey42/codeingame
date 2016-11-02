// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   There_is_no_Spoon_-_Episode_1.cpp                  :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/11/02 09:52:50 by ngoguey           #+#    #+#             //
//   Updated: 2016/11/02 10:26:49 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <iostream>
#include <set>
#include <cassert>

struct Coord {

  std::size_t x;
  std::size_t y;

  struct RowMajorLesser {
    bool operator()(Coord const &lhs, Coord const &rhs) const {
      if (lhs.y < rhs.y)
        return true;
      else if (lhs.y == rhs.y)
        return lhs.x < rhs.x;
      else
        return false;
    }
  };

  struct ColMajorLesser {
    bool operator()(Coord const &lhs, Coord const &rhs) const {
      if (lhs.x < rhs.x)
        return true;
      else if (lhs.x == rhs.x)
        return lhs.y < rhs.y;
      else
        return false;
    }
  };

};

class Grid {

private:
  using set_rowmajor_t = std::set<Coord, Coord::RowMajorLesser>;
  using set_colmajor_t = std::set<Coord, Coord::ColMajorLesser>;

  set_rowmajor_t _row_major;
  set_colmajor_t _col_major;

public:
  Grid();
  ~Grid();
  Grid(Grid const &) = delete;
  Grid &operator =(Grid const &) = delete;

  void insert(Coord const &);
  set_rowmajor_t const &row_major_set() const;
  Coord const *node_right_opt(Coord const &) const;
  Coord const *node_bottom_opt(Coord const &) const;

};

Grid::Grid() {
}

Grid::~Grid() {
}

void Grid::insert(Coord const &node) {
  _row_major.insert(node);
  _col_major.insert(node);
}

Grid::set_rowmajor_t const &Grid::row_major_set() const {
  return _row_major;
}

Coord const *Grid::node_right_opt(Coord const &node) const {
  auto it = _row_major.find(node);

  if (it == _row_major.end())
    assert(false);
  ++it;
  if (it == _row_major.end() || it->y != node.y)
    return nullptr;
  else
    return &*it;
}

Coord const *Grid::node_bottom_opt(Coord const &node) const {
  auto it = _col_major.find(node);

  if (it == _col_major.end())
    assert(false);
  ++it;
  if (it == _col_major.end() || it->x != node.x)
    return nullptr;
  else
    return &*it;
}

void job(Grid const &g) {
  auto dump_neighbor_opt = [](Coord const *neighbor) {
    if (neighbor == nullptr)
      std::cout << " -1 -1";
    else
      std::cout << " " << neighbor->x << " " << neighbor->y;
  };
  for (Coord const &node: g.row_major_set()) {
    std::cout << node.x << " " << node.y;
    dump_neighbor_opt(g.node_right_opt(node));
    dump_neighbor_opt(g.node_bottom_opt(node));
    std::cout << std::endl;
  }
}

int main() {
  using std::cin;

  Grid g{};
  std::size_t w, h, x;
  std::string line;

  cin >> w;
  cin.ignore();
  cin >> h;
  cin.ignore();
  for (std::size_t y = 0; y < h; y++) {
    cin >> line;
    cin.ignore();
    x = 0;
    for (char c: line) {
      if (c == '0')
        g.insert({x, y});
      x++;
    }
  }
  job(g);
  return 0;
}
