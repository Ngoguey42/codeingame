// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   trie.hpp                                           :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/31 11:14:36 by ngoguey           #+#    #+#             //
//   Updated: 2016/11/01 19:51:50 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#ifndef TRIE_HPP
# define TRIE_HPP

#include <array>
#include <iterator>
#include <iostream>
#include <cassert>



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

    virtual bool is_branch() const {
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

    bool is_branch() const override {
      return true;
    }

  };

  template <typename IndexIterator>
  class ConstStringIterator {

  private:
    _Node const *_n;
    IndexIterator _it;
    IndexIterator const _end;

  public:
    ConstStringIterator() = delete;

    ConstStringIterator(_Node const *n, IndexIterator const &it, IndexIterator const &end)
      : _n(n)
      , _it(it)
      , _end(end) {
    }

    ~ConstStringIterator() {
    }

    ConstStringIterator(ConstStringIterator const &src)
      : _n(src._n)
      , _it(src._it)
      , _end(src._end) {
    }

    ConstStringIterator &operator =(ConstStringIterator const &rhs) {
      _n = rhs._n;
      _it = rhs._it;
      _end = rhs._end;
    }

    IndexIterator const &indices_forward() const {
      return _it;
    }

    bool done() const {
      return _n == nullptr;
    }

    bool has_value() const {
      assert(_n != nullptr);
      return _n->has_value();
    }

    T &operator*() const {
      assert(_n != nullptr);
      return _n->get_value();
    }

    ConstStringIterator &operator ++() {
      if (_n == nullptr)
        assert(false);
      else if (_it == _end)
        _n = nullptr;
      else if (_n->is_branch()) {
        _n = reinterpret_cast<_Branch const*>(_n)->sub_array[*_it];
        ++_it;
      }
      else
        _n = nullptr;
      return *this;
    }

  };

  // class ConstIterator {

  // private:
  //   _Node const *_n;
  //   std::size_t _i;
  //   std::stack<std::pair<_Branch const *, std::size_t>> _parents;

  // public:
  //   ConstIterator() = delete;

  //   ConstIterator(_Node const *n)
  //     : _n(n) {
  //   }

  //   ~ConstIterator() {
  //   }

  //   ConstIterator(ConstIterator const &src)
  //     : _n(src._n)
  //     , _i(src_i)
  //     , _parents(src._parents) {
  //   }

  //   ConstIterator &operator =(ConstIterator const &rhs) {
  //     _n = rhs._n;
  //     _i = rhs._i;
  //     _parents = rhs._parents;
  //   }

  //   bool done() const {
  //     return _n == nullptr;
  //   }

  //   bool has_value() const {
  //     assert(_n != nullptr);
  //     return _n->has_value();
  //   }

  //   T &operator*() const {
  //     assert(_n != nullptr);
  //     return _n->get_value();
  //   }

  //   ConstIterator &operator ++() {
  //     if (_n == nullptr)
  //       assert(false);
  //     if (_n->is_branch()) {
  //       while (true) {
  //         if (_i >= RADIX)
  //       }
  //     }

  //     return *this;
  //   }

  // };

  _Node *_top;

public:
  Trie();
  ~Trie();
  Trie(Trie const &);
  Trie &operator =(Trie const &);

  template <typename IndexIterator>
  void insert(T const &value, IndexIterator it, IndexIterator const &end);

  template <typename IndexIterator>
  ConstStringIterator<IndexIterator> iterator(
  IndexIterator const &it, IndexIterator const &end) const {
    return ConstStringIterator<IndexIterator>{_top, it, end};
  }

  std::size_t size_nodes() const {
    return _size_nodes(_top);
  }

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

  std::size_t _size_nodes(_Node const *n) const {
    std::size_t acc;

    if (n == nullptr)
      return 0;
    if (!n->is_branch())
      return 1;
    else {
      acc = 0;
      for (_Node const *o: reinterpret_cast<_Branch const *>(n)->sub_array)
        acc += _size_nodes(o);
      return acc + 1;
    }
  }

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
