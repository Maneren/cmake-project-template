export module division;

import std;

export namespace division {

class DivisionByZero : public std::exception {
public:
  static constexpr std::string_view MESSAGE = "Division by zero is illegal";
  const char *what() const noexcept override { return MESSAGE.data(); }
};

struct Fraction {
  long long numerator;
  long long denominator;
};

struct Result {
  long long division;
  long long remainder;

  friend bool operator==(const Result &lhs, const Result &rhs) {
    return lhs.division == rhs.division ? lhs.remainder < rhs.remainder
                                        : lhs.division < rhs.division;
  }
};

class Division {
public:
  explicit Division(Fraction fraction) { this->fraction = fraction; }

  ~Division() {};

  Result divide() const;

protected:
  Fraction fraction;
  Result result;
};

} // namespace division
