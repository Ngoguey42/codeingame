// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   Dwarfs_standing_on_the_shoulders_of_gi...          :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/11/02 10:42:49 by ngoguey           #+#    #+#             //
//   Updated: 2016/11/02 11:33:04 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <unordered_map>
#include <unordered_set>
#include <iostream>

using std::size_t;

struct Person {

  /** 0 means self */
  size_t furthest_influencer;
};

class Relationships {

  std::unordered_set<size_t> _roots;
  std::unordered_set<size_t> _not_roots;
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
  size_t _recurse(size_t src, size_t depth);

};

Relationships::Relationships() {
}

Relationships::~Relationships() {
}

void Relationships::insert(size_t src, size_t dst) {
  _edges.insert({src, dst});

  _vertices.insert({src, Person{0}});
  if (_not_roots.find(src) == _not_roots.end())
    _roots.insert(src);

  _vertices.insert({dst, Person{0}});
  _roots.erase(dst);
  _not_roots.insert(dst);
}

size_t Relationships::compute_tree_height() {
  size_t height = 0;

  for (size_t root: _roots) {
    std::cerr << "root " << root << std::endl;
    height = std::max(height, _recurse(root, 1));
  }
  return height;
}

size_t Relationships::_recurse(size_t src, size_t depth) {
  Person *dst;
  size_t height = depth;

  std::cerr << "visiting " << src << std::endl;
  for (auto pair = _edges.equal_range(src); pair.first != pair.second; pair.first++) {
    dst = &_vertices[pair.first->second];
    if (dst->furthest_influencer < depth + 1) {
      dst->furthest_influencer = depth + 1;
      height = std::max(height, _recurse(pair.first->second, depth + 1));
    }
  }
  return height;
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
