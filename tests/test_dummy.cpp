#include <cassert>

#include "egfx/dummy.hpp"

int main() {
    assert(egfx::add(2, 2) == 4);
    assert(egfx::version()[0] != '\0');
    return 0;
}
