//
// Created by Konstantin Gredeskoul on 5/16/17.
//
#include <array>
#include <cstddef>
#include <division/division.h>
#include <gtest/gtest.h>

namespace division {

using VI = std::array<long long, 4>;

class DividerTest : public ::testing::Test {

protected:
  static constexpr VI numerators = {5, 9, 17, 933345453464353416L};
  static constexpr VI denominators = {2, 3, 19, 978737423423423499L};
  static constexpr VI divisions = {2, 3, 0, 0};
  static constexpr VI remainders = {1, 0, 17, 933345453464353416};

  virtual void verify(size_t index) {
    const auto f = Fraction{
        .numerator = numerators.at(index), .denominator = denominators.at(index)
    };
    const auto expected = Result{
        .division = divisions.at(index), .remainder = remainders.at(index)
    };
    const auto result = Division(f).divide();
    EXPECT_EQ(result.division, expected.division);
    EXPECT_EQ(result.remainder, expected.remainder);
  }
};

TEST_F(DividerTest, 5_DivideBy_2) { verify(0); }

TEST_F(DividerTest, 9_DivideBy_3) { verify(1); }

TEST_F(DividerTest, 17_DivideBy_19) { verify(2); }

TEST_F(DividerTest, Long_DivideBy_Long) { verify(3); }

TEST_F(DividerTest, DivisionByZero) {
  const auto d = Division(Fraction{.numerator = 1, .denominator = 0});
  try {
    d.divide();
    FAIL() << "Expected divide() method to throw DivisionByZeroException";
  } catch (DivisionByZero const &err) {
    EXPECT_EQ(err.what(), DivisionByZero::MESSAGE);
  } catch (...) {
    FAIL() << "Expected DivisionByZeroException!";
  }
}

} // namespace division
