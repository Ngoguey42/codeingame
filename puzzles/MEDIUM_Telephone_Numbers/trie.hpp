// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   trie.hpp                                           :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/31 11:14:36 by ngoguey           #+#    #+#             //
//   Updated: 2016/11/01 13:14:45 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#ifndef TRIE_HPP
# define TRIE_HPP

#include <array>
#include <iterator>
#include <iostream>



#include <string>
#include <sstream>

template <typename T>
std::string ntos(T pNumber)
{
  std::ostringstream oss;
  oss << pNumber;
  return oss.str();
}

template <std::size_t RADIX, typename T>
class Trie {

private:

  class _Node {

    T *_value;

  public:
    _Node()
      : _value(nullptr) {
    }

    virtual ~_Node() {
      if (_value != nullptr)
        delete _value;
    }

    _Node(_Node const &) = delete;
    _Node &operator =(_Node const &) = delete;

    virtual bool is_branch() {
      return false;
    }

    bool has_value() const {
      return _value != nullptr;
    }

    T &get_value() const {
      if (_value == nullptr)
        throw new std::exception();
      return *_value;
    }

    void set_value(T const &v) {
      if (_value != nullptr)
        delete _value;
      _value = new T{v};
    }

  };

  class _Branch: public _Node {

  public:
    std::array<_Node*, RADIX> sub_array;

    _Branch()
      : _Node()
      , sub_array{nullptr} {
    }

    ~_Branch() {
      for (_Node *ptr : sub_array) {
        if (ptr != nullptr)
          delete ptr;
      }
    }

    _Branch(_Branch const &) = delete;
    _Branch &operator =(_Branch const &) = delete;

    bool is_branch() override {
      return true;
    }

  };

  _Node *_top;

public:
  Trie();
  ~Trie();
  Trie(Trie const &);
  Trie & operator =(Trie const &);

  template <typename IndexIterator>
  void insert(T const &value, IndexIterator it, IndexIterator const &end);

  void dump() const {
    if (_top == nullptr)
      std::cout << "empty" << std::endl;
    else
      _dump(*_top, "");
  }

private:

  template <typename IndexIterator>
  void _insert(T const &value, IndexIterator &it, IndexIterator const &end,
               _Node *&mem_cell);

  void _dump(_Node &n, std::string acc) const {
    _Branch *b;

    std::cout << "|" << acc;
    if (n.has_value())
      std::cout << " -> " << n.get_value();
    std::cout << std::endl;
    if (n.is_branch()) {
      b = reinterpret_cast<_Branch*>(&n);

      for (std::size_t i = 0; i < RADIX; i++) {
        if (b->sub_array[i] != nullptr) {
          _dump(*b->sub_array[i], acc + ntos(i));
        }
      }
    }
  }

};

template <std::size_t RADIX, typename T>
Trie<RADIX, T>::Trie()
  : _top(nullptr) {
}

template <std::size_t RADIX, typename T>
Trie<RADIX, T>::~Trie() {
  if (_top != nullptr)
    delete _top;
}

template <std::size_t RADIX, typename T>
template <typename IndexIterator>
void Trie<RADIX, T>::insert(
T const &value, IndexIterator it, IndexIterator const &end) {
  this->_insert(value, it, end, _top);
}

template <std::size_t RADIX, typename T>
template <typename IndexIterator>
void Trie<RADIX, T>::_insert(
T const &value, IndexIterator &it, IndexIterator const &end, _Node *&mem_cell) {
  _Branch *tmp;
  _Node **dst;

  if (it == end) {
    if (mem_cell == nullptr)
      mem_cell = new _Node();
    mem_cell->set_value(value);
  }
  else {
    if (mem_cell == nullptr) {
      tmp = new _Branch();
      mem_cell = tmp;
    }
    else if (mem_cell->is_branch())
      tmp = reinterpret_cast<_Branch*>(mem_cell);
    else {
      tmp = new _Branch();
      if (mem_cell->has_value())
        tmp->set_value(mem_cell->get_value());
      delete mem_cell;
      mem_cell = tmp;
    }

    dst = &tmp->sub_array[static_cast<std::size_t>(*it)];
    _insert(value, ++it, end, *dst);
  }
}

#endif
