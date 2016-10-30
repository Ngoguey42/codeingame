// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   dict.cpp                                           :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/30 11:08:36 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/30 12:06:58 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <unordered_map>
#include <list>


class Dict {

public:

  using map = std::unordered_map<std::string, conv::WordScore>;

  // ATTRIBUTES
  const map words;

  // CONSTRUCTION
  Dict()
    : words(conv::words_of_cin()) {
    std::cerr << words.size() << std::endl;
  }

  ~Dict() {
  }

  Dict(Dict const &) = delete;
  Dict &operator =(Dict const &) = delete;

  // PUBLIC
  map::const_iterator best_word_of_letters(
    std::list<char> &letters, std::string &word, map::const_iterator best) const {

    char c;
    const int size = letters.size();
    map::const_iterator it;

    if (size == 0)
      return best;
    for (int i = 0; i < size; i++) {
      c = letters.back();
      letters.pop_back();
      word.push_back(c);

      it = words.find(word);
      if (it != words.end()) {
        if (best == words.end())
          best = it;
        else if (it->second.score > best->second.score)
          best = it;
        else if (it->second.score == best->second.score &&
                 it->second.index < best->second.index)
          best = it;
      }
      it = best_word_of_letters(letters, word, best);
      if (it != words.end()) {
        if (best == words.end())
          best = it;
        else if (it->second.score > best->second.score)
          best = it;
        else if (it->second.score == best->second.score &&
                 it->second.index < best->second.index)
          best = it;
      }

      word.pop_back();
      letters.push_front(c);
    }

    return best;
  }



};
