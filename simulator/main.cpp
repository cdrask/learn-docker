#include <iostream>

#include "egfx/dummy.hpp"

int main() {
    std::cout << "egfx simulator mock started: " << egfx::version() << '\n';
    std::cout << "2 + 3 = " << egfx::add(2, 3) << '\n';
    return 0;
}
