# SpritExp

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Kinda like a regular expression language, but for Sprites

![](./banner.png)

## Installation 💻

**❗ In order to start using SpritExp you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Add `spritexp` to your `pubspec.yaml`:

```yaml
dependencies:
  spritexp:
```

Install it:

```sh
flutter packages get
```

## Using it

SpritExp basic syntax structure is the following:

```
{SPRITE COORDINATES AND SIZE}[ * MULTIPLIERS]
```

Breaking it down, coordinates and size of the sprite are informed by numbers separated by commas, and
a couple of formats are accepted:

```
// {Size} - position defaults to 0,0
{16}
// {X and Y, Width and Height}
{16, 32}
// {X, Y, Width, Height}
{0, 16, 32, 32}
```

Multipliers are meant to create a sequential list of sprites, based in a a sprite definition explained above.

So, to generate a horizontal list of 2 sprites, the following example can be used:

```
{0, 16} * 2x
```

The above will generate two sprites, the first starting at X0 Y0, with a square dimension of 16, and
the second at X16 Y0, also with the same dimension.

On the other hand, the following:
```
{0, 16} * 2y
```

Will generate two sprites, the first starting at X0 Y0, with a square dimension of 16, and
the second at X0 Y16, also with the same dimension.

You can also get a grid of sprites by adding both `x` and `y` to the expression:

```
{0, 16} * 2xy
```

By default, SpritExp assumes that multipliers are horizontal, so the `x` can be omitted, meaning
that `{0, 16} * 2` and `{0, 16} * 2x` are the same expression.

## Online editor

A simple online editor where you can test expressions is available at: https://erickzanardo.github.io/spritexp/

---
[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
