// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   Dwarfs_standing_on_the_shoulders_of_gi...          :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/11/02 11:56:38 by ngoguey           #+#    #+#             //
//   Updated: 2016/11/02 12:26:39 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <unordered_map>
#include <unordered_set>
#include <iostream>

using std::size_t;

struct Person {

  /** 0 means not visited */
  /** 1 means root */
  size_t furthest_influencer;
  bool visited;

  Person()
    : furthest_influencer(0)
    , visited(false) {
  }

};

class Relationships {

  std::unordered_multimap<size_t, size_t> _edges;
  std::unordered_map<size_t, Person> _vertices;

public:
  Relationships();
  ~Relationships();
  Relationships(Relationships const &) = delete;
  Relationships &operator =(Relationships const &) = delete;

  void insert(size_t src, size_t dst);
  size_t compute_tree_height();

private:
  size_t _recurse(size_t src);

};

Relationships::Relationships() {
}

Relationships::~Relationships() {
}

void Relationships::insert(size_t src, size_t dst) {
  _edges.insert({src, dst});
  _vertices.insert({src, {}});
  _vertices.insert({dst, {}});
}

size_t Relationships::compute_tree_height() {
  size_t height = 0;

  for (auto const &it: _vertices)
    if (!it.second.visited)
      height = std::max(height, _recurse(it.first));
  return height;
}

size_t Relationships::_recurse(size_t src) {
  Person *dst;
  size_t height = 0;

  std::cerr << "visiting " << src << std::endl;
  for (auto pair = _edges.equal_range(src)
     ; pair.first != pair.second
     ; pair.first++) {
    dst = &_vertices[pair.first->second];
    if (!dst->visited)
      height = std::max(height, _recurse(pair.first->second));
    else
      height = std::max(height, dst->furthest_influencer);
  }
  _vertices[src].furthest_influencer = height + 1;
  _vertices[src].visited = true;
  std::cerr << "visiting " << src << "#DONE got: " << height + 1 << std::endl;
  return height + 1;
}

int main() {
  using std::cin;

  std::cerr << "Hello world" << std::endl;
  size_t count, src, dst;
  Relationships r;
  std::string line;

  cin >> count;
  cin.ignore();
  for (size_t i = 0; i < count; i++) {
    cin >> src;
    cin >> dst;
    cin.ignore();
    std::cerr << src << " " << dst << std::endl;
    r.insert(src, dst);
  }
  std::cout << r.compute_tree_height() << std::endl;
  return 0;
}
