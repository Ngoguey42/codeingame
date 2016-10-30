// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   main.cpp                                           :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/30 11:11:46 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/30 12:00:41 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //


int main() {
  const Dict d{};
  std::string letters;

  std::getline(std::cin, letters);
  std::cerr << letters << std::endl;


  std::string word;

  std::list<char> l{letters.begin(), letters.end()};

  auto it = d.best_word_of_letters(l, word, d.words.end());

  if (it != d.words.end())
    std::cout << it->first << std::endl;


  return 0;
}
