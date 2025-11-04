#pragma once

#include <format>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace {

template <typename T>
concept formattable = std::semiregular<std::formatter<T>>;

template <typename... Args>
concept all_formattable = (formattable<Args> && ...);

// base formatter template that handles the parse boilerplate
template <typename t> struct static_formatter {
  static constexpr auto parse(std::format_parse_context &ctx) {
    return ctx.begin();
  }
};

} // namespace

template <typename T, typename A>
  requires(formattable<T>)
struct std::formatter<std::vector<T, A>> : static_formatter<std::vector<T, A>> {
  static auto format(auto &obj, std::format_context &ctx) {
    std::format_to(ctx.out(), "[");
    for (const auto &item : obj) {
      if (&item != &obj.front()) {
        std::format_to(ctx.out(), ", ");
      }
      std::format_to(ctx.out(), "{}", item);
    }
    return std::format_to(ctx.out(), "]");
  }
};

template <typename T, typename H, typename P, typename A>
  requires(formattable<T>)
struct std::formatter<std::unordered_set<T, H, P, A>>
    : static_formatter<std::unordered_set<T, H, P, A>> {
  static auto format(auto &obj, std::format_context &ctx) {
    std::format_to(ctx.out(), "{{");
    bool first = true;
    for (const auto &item : obj) {
      if (!first) {
        std::format_to(ctx.out(), ", ");
      }
      std::format_to(ctx.out(), "{}", item);
      first = false;
    }
    return std::format_to(ctx.out(), "}}");
  }
};

template <typename T, typename U, typename H, typename P, typename A>
  requires(all_formattable<T, U>)
struct std::formatter<std::unordered_map<T, U, H, P, A>>
    : static_formatter<std::unordered_map<T, U, H, P, A>> {
  static auto format(auto &obj, std::format_context &ctx) {
    std::format_to(ctx.out(), "{{");
    bool first = true;
    for (const auto &[key, value] : obj) {
      if (!first) {
        std::format_to(ctx.out(), ", ");
      }
      std::format_to(ctx.out(), "{}: {}", key, value);
      first = false;
    }
    return std::format_to(ctx.out(), "}}");
  }
};

template <typename T>
  requires(formattable<T>)
struct std::formatter<std::optional<T>> : static_formatter<std::optional<T>> {
  static auto format(auto &obj, std::format_context &ctx) {
    if (obj.has_value()) {
      return std::format_to(ctx.out(), "{}", obj.value());
    }
    return std::format_to(ctx.out(), "nullopt");
  }
};

template <typename T>
  requires(formattable<T>)
struct std::formatter<std::pair<T, T>> : static_formatter<std::pair<T, T>> {
  static auto format(auto &obj, std::format_context &ctx) {
    return std::format_to(ctx.out(), "({}, {})", obj.first, obj.second);
  }
};
