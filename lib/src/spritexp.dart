import 'dart:ui';

import 'package:flame/components.dart';

/// {@template spritexp}
/// Kinda like a regular expression language, but for Sprites.
/// {@endtemplate}
class SpritExp {
  /// {@macro spritexp}
  SpritExp({
    required String expression,
  }) : _expression = expression {
    _calcValues();
  }

  final String _expression;

  late final _rects = <Rect>[];

  void _calcValues() {
    final regExp = RegExp(
      r'{([0-9]+)[,]?([0-9]+)?[,]?([0-9]+)?[,]?([0-9]+)?}(\*[0-9]+([xy]+)?)?',
    );

    final matches = regExp.firstMatch(
      _expression.replaceAll(' ', ''),
    );

    if (matches == null) {
      throw ArgumentError(
        'Invalid SpritExp expression: $_expression',
      );
    } else {
      late final Rect firstRect;
      if (matches.group(2) != null &&
          matches.group(3) != null &&
          matches.group(4) != null) {
        firstRect = Rect.fromLTWH(
          double.parse(matches.group(1)!),
          double.parse(matches.group(2)!),
          double.parse(matches.group(3)!),
          double.parse(matches.group(4)!),
        );
      } else if (matches.group(2) != null) {
        firstRect = Rect.fromLTWH(
          double.parse(matches.group(1)!),
          double.parse(matches.group(1)!),
          double.parse(matches.group(2)!),
          double.parse(matches.group(2)!),
        );
      } else {
        firstRect = Rect.fromLTWH(
          0,
          0,
          double.parse(matches.group(1)!),
          double.parse(matches.group(1)!),
        );
      }

      _rects.add(firstRect);

      if (matches.group(5) != null) {
        final multiplerRegExp = RegExp(
          '([0-9]+)([xy]+)?',
        );

        final multiplerExpression = matches.group(5)!.replaceAll('*', '');
        final multiplerMatches = multiplerRegExp.firstMatch(
          multiplerExpression,
        );

        final value = double.parse(multiplerMatches!.group(1)!);
        final group = multiplerMatches.group(2);
        final vertical = group?.contains('y') ?? false;
        final horizontal = group?.contains('x') ?? true;

        if (horizontal && vertical) {
          for (var y = 0; y < value; y++) {
            for (var x = 0; x < value; x++) {
              if (y == 0 && x == 0) continue;
              _rects.add(
                firstRect.translate(
                  firstRect.width * x,
                  firstRect.height * y,
                ),
              );
            }
          }
        } else if (horizontal) {
          for (var i = 1; i < value; i++) {
            _rects.add(
              firstRect.translate(
                firstRect.width * i,
                0,
              ),
            );
          }
        } else if (vertical) {
          for (var i = 1; i < value; i++) {
            _rects.add(
              firstRect.translate(
                0,
                firstRect.height * i,
              ),
            );
          }
        }
      }
    }
  }

  /// Returns the [Rect]s representation of this [SpritExp].
  List<Rect> get rects => _rects;

  /// Returns a list of [Sprite]s.
  List<Sprite> operator /(Object other) {
    if (other is Image) {
      return _rects.map((rect) {
        return Sprite(
          other,
          srcPosition: Vector2(rect.left, rect.top),
          srcSize: Vector2(rect.width, rect.height),
        );
      }).toList();
    } else {
      throw ArgumentError(
        'SpritExp can only be divided by an Image',
      );
    }
  }
}
