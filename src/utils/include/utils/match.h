#pragma once

#include <type_traits>
#include <variant>

namespace match {

/// A utility function for pattern matching on std::variant.
/// Combines multiple lambdas into a single callable object and applies them to
/// the given variant.
/// @tparam T The type of the variant.
/// @tparam Args The types of the lambdas.
/// @param t The variant to match.
/// @param args The lambdas to apply.
/// @return The result of applying the appropriate lambda to the variant.
template <typename T, typename... Args>
constexpr auto match(T const &t, Args &&...args) noexcept(
    (std::is_nothrow_invocable_v<Args, decltype(std::get<0>(t))> && ...)
) {
  struct Overloaded : Args... {
    using Args::operator()...;
  };
  return std::visit(Overloaded{std::forward<Args>(args)...}, t);
}

/// A utility function for pattern matching on std::variant.
/// Combines multiple lambdas into a single callable object and applies them to
/// the given variant.
/// @tparam T The type of the variant.
/// @tparam Args The types of the lambdas.
/// @param t The variant to match.
/// @param args The lambdas to apply.
/// @return The result of applying the appropriate lambda to the variant.
template <typename T, typename... Args>
constexpr auto match(T &t, Args &&...args) noexcept(
    (std::is_nothrow_invocable_v<Args, decltype(std::get<0>(t))> && ...)
) {
  struct Overloaded : Args... {
    using Args::operator()...;
  };
  return std::visit(Overloaded{std::forward<Args>(args)...}, t);
}

} // namespace match
