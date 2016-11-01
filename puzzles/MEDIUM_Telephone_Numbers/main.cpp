// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   main.cpp                                           :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/11/01 13:01:26 by ngoguey           #+#    #+#             //
//   Updated: 2016/11/01 20:07:57 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <iostream>
#include <vector>
// #include "trie.hpp"

void iter(Trie<10, std::string> &t, std::vector<int> const &vec) {
  std::cout << "iter" << std::endl;
  auto it = t.iterator(vec.begin(), vec.end());
  std::string acc{""};

  while (!it.done()) {
    std::cout << "|" << acc ;

    if (it.has_value())
      std::cout << " -> " << *it;
    std::cout << std::endl;
    if (it.indices_forward() != vec.end())
      acc += ntos(*it.indices_forward());
    ++it;
  }

}

int test() {

  Trie<10, std::string> t;
  std::cout << "Hello world" << std::endl;

  auto push = [&](std::string const &s, std::vector<int> const &vec) {
    std::cout << "Add " << s << std::endl;
    t.insert(s, vec.begin(), vec.end());
    std::cout << "  new size:" << t.size_nodes() << std::endl;
  };

  push("yesterday", {2, 0, 1, 6, 1, 0, 3, 0});

  push("tomorow", {2, 0, 1, 6, 1, 1, 0, 2});

  push("empty", {});
  push("this year", {2, 0, 1, 6});
  push("november 2016", {2, 0, 1, 6, 1, 1});
  std::cout << std::endl;

  t.dump();
  std::cout <<  std::endl;

  iter(t, {});
  iter(t, {2});
  iter(t, {2, 0, 1, 6});
  iter(t, {2, 0, 1, 6, 1, 1, 0, 1});

  iter(t, {2, 0, 1, 7});
  iter(t, {2, 0, 1, 7, 1, 1, 0, 1});

  return 0;
}

std::vector<int> digits_of_string(std::string number_str) {
  std::vector<int> vec;

  for (char c : number_str) {
    assert(c >= '0');
    assert(c <= '9');
    vec.push_back(c - '0');
  }
  return (vec);
}

int main() {
  using std::cin;

  std::size_t count;
  std::string number_str;
  Trie<10, float> t;
  std::vector<int> digits;

  cin >> count;
  cin.ignore();
  for (std::size_t i = 0; i < count; i++) {
    cin >> number_str;
    cin.ignore();
    digits = digits_of_string(number_str);
    t.insert(42.0f, digits.cbegin(), digits.cend());
  }
  std::cout << t.size_nodes() - 1 << std::endl; // Error at 0
}
