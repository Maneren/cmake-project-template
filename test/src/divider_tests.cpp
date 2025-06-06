//
// Created by Konstantin Gredeskoul on 5/16/17.
//
#include <division/division.h>
#include <gtest/gtest.h>

namespace division {

using VI = std::vector<long long>;

class DividerTest : public ::testing::Test {

protected:
  VI numerators = {5, 9, 17, 933345453464353416L};
  VI denominators = {2, 3, 19, 978737423423423499L};
  VI divisions = {2, 3, 0, 0};
  VI remainders = {1, 0, 17, 933345453464353416};

  virtual void SetUp() {};

  virtual void TearDown() {};

  virtual void verify(int index) {
    const auto f = Fraction{numerators.at(index), denominators.at(index)};
    const auto expected = Result{divisions.at(index), remainders.at(index)};
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
  const auto d = Division(Fraction{1, 0});
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
