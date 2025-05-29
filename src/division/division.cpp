#include <division/division.h>

namespace division {

Result Division::divide() const {
  if (fraction.denominator == 0L)
    throw DivisionByZero();

  Result result = Result{
      fraction.numerator / fraction.denominator,
      fraction.numerator % fraction.denominator
  };

  return result;
}

} // namespace division
