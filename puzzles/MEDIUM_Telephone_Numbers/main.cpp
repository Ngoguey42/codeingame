// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   main.cpp                                           :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/11/01 13:01:26 by ngoguey           #+#    #+#             //
//   Updated: 2016/11/01 13:01:41 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <iostream>
#include <vector>
#include "trie.hpp"


int main() {

  Trie<10, std::string> t;
  std::cout << "Hello world" << std::endl;

  auto push = [&](std::string const &s, std::vector<int> const &vec) {
    t.insert(s, vec.begin(), vec.end());

  };

  push("today", {2, 0, 1, 6, 1, 1, 0, 1});
  push("yesterday", {2, 0, 1, 6, 1, 0, 3, 0});
  push("tomorow", {2, 0, 1, 6, 1, 1, 0, 2});

  push("this year", {2, 0, 1, 6});
  push("november 2016", {2, 0, 1, 6, 1, 1});

  t.dump();

  return 0;
}
