// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   main.cpp                                           :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2016/10/30 17:34:51 by ngoguey           #+#    #+#             //
//   Updated: 2016/10/30 18:00:55 by ngoguey          ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include <set>
#include <iostream>

struct Data {
  using set_t = std::multiset<std::size_t>;

  std::size_t price;
  set_t budgets;
  std::size_t budgets_sum;

  Data()
    : budgets_sum(0) {
    using std::cin;

    int count;
    int budget;

    cin >> count;
    cin.ignore();
    cin >> price;
    cin.ignore();
    for (int i = 0; i < count; i++) {
      cin >> budget;
      cin.ignore();
      budgets.insert(budget);
      budgets_sum += budget;
    }
  }

};

void print_flat_distribution(int price, int count) {
  const int high_paying = price % count;

  for (int i = 0; i < count - high_paying; i++)
    std::cout << price / count << std::endl;
  for (int i = 0; i < high_paying; i++)
    std::cout << price / count + 1 << std::endl;
}

void print_distribution(Data const &d) {
  std::size_t oods_left_to_pay = d.budgets.size();
  std::size_t money_left_to_pay = d.price;
  auto lowest_budget_ood = d.budgets.begin();

  while (true) {
    if (money_left_to_pay <= *lowest_budget_ood * oods_left_to_pay) {
      print_flat_distribution(money_left_to_pay, oods_left_to_pay);
      break ;
    }
    else {
      std::cout << *lowest_budget_ood << std::endl;
      money_left_to_pay -= *lowest_budget_ood;
      lowest_budget_ood++;
      oods_left_to_pay--;
    }
  }
}

int main() {
  const Data d{};

  if (d.price > d.budgets_sum)
    std::cout << "IMPOSSIBLE" << std::endl;
  else
    print_distribution(d);
  return 0;
}
