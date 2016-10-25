// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   MEDIUM_Network_Cabling.cpp                         :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/25 12:04:29 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/25 14:53:06 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <iterator>
#include <iostream>
#include <set>
#include <limits>

struct House {

  // ATTR
  const int x;
  const int y;

  // CONSTRUCTION
  ~House(){
  }

  House(int x, int y)
    : x(x), y(y) {
  }

  House(House const &rhs)
    : x(rhs.x), y(rhs.y) {
  }
  House &operator=(House const&) = delete;

  // OTHER
  struct Compare {
    bool operator()(House const &a, House const &b) {
      return a.y < b.y;
    }
  };

  using mset_t = std::multiset<House, Compare>;

};

struct Data {

public:
  const House::mset_t mset;
  const int min_x;
  const int max_x;
  const int median_y;

  Data(House::mset_t &&mset, int min_x, int max_x)
    : mset(mset)
    , min_x(min_x)
    , max_x(max_x)
    , median_y(_median_y_of_mset(this->mset)) {
    std::cerr << "min_x " << min_x << std::endl;
    std::cerr << "max_x " << max_x << std::endl;
    std::cerr << "median_y " << median_y << std::endl;

    for (auto const &h : mset)
      std::cerr << h.x << ',' << h.y << std::endl;
  }

private:
  static int _median_y_of_mset(House::mset_t mset) {
    auto it = mset.begin();

    std::advance(it, mset.size() / 2);
    return it->y;
  }

};

Data data_from_cin() {
  using std::cin;

  int house_count;
  House::mset_t mset;
  int min_x = std::numeric_limits<int>::max();
  int max_x = std::numeric_limits<int>::min();
  int x, y;

  cin >> house_count;
  for (int i = 0; i < house_count; i++) {
    cin >> x;
    cin >> y;
    min_x = std::min(min_x, x);
    max_x = std::max(max_x, x);
    mset.emplace(x, y);
  }
  return Data(std::move(mset), min_x, max_x);
}

int main() {
  auto const data = data_from_cin();
  size_t acc = 0;

  for (auto const &h : data.mset)
    acc += std::abs(h.y - data.median_y);
  std::cout << acc + (data.max_x - data.min_x) << '\n';
}
