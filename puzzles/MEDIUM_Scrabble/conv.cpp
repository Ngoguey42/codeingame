// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   conv.cpp                                           :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/30 11:20:28 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/30 12:05:14 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <unordered_map>
#include <iostream>

namespace conv {

struct WordScore {
  int score;
  int index;
};


int score_of_letter(char c) {
  switch (c) {
  case ('e'): return 1;
  case ('a'): return 1;
  case ('i'): return 1;
  case ('o'): return 1;
  case ('n'): return 1;
  case ('r'): return 1;
  case ('t'): return 1;
  case ('l'): return 1;
  case ('s'): return 1;
  case ('u'): return 1;

  case ('d'): return 2;
  case ('g'): return 2;

  case ('b'): return 3;
  case ('c'): return 3;
  case ('m'): return 3;
  case ('p'): return 3;

  case ('f'): return 4;
  case ('h'): return 4;
  case ('v'): return 4;
  case ('w'): return 4;
  case ('y'): return 4;

  case ('k'): return 5;

  case ('j'): return 8;
  case ('x'): return 8;

  case ('q'): return 10;
  case ('z'): return 10;
  }
  throw new std::exception();
}

int score_of_word(std::string const &s) {
  int acc;

  for (char c : s)
    acc += score_of_letter(c);

  return acc;
}

std::unordered_map<std::string, WordScore> words_of_cin() {
  using std::cin;

  std::unordered_map<std::string, WordScore> words;
  int n, score;
  std::string s;

  cin >> n;
  cin.ignore();
  for (int i = 0; i < n; i++) {
    std::getline(cin, s);
    score = score_of_word(s);
    if (s.size() <= 7)
      words.emplace(std::move(s), WordScore{score, i});
  }

  return std::move(words);
}

}
