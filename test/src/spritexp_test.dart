// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spritexp/spritexp.dart';

class _MockImage extends Mock implements Image {}

void main() {
  group('SpritExp', () {
    test('can be instantiated', () {
      expect(
        SpritExp(expression: '{10,20,30,40}'),
        isNotNull,
      );
    });

    test('parses the values correctly when all values are informed', () {
      expect(
        SpritExp(expression: '{10,20,30,40}').rects,
        equals([
          Rect.fromLTWH(10, 20, 30, 40),
        ]),
      );
    });

    test('parses the values correctly when just the size is informed', () {
      expect(
        SpritExp(expression: '{40}').rects,
        equals(
          [
            Rect.fromLTWH(0, 0, 40, 40),
          ],
        ),
      );
    });

    test(
      'parses the values correctly when repeating values for '
      'position and size',
      () {
        expect(
          SpritExp(expression: '{16,40}').rects,
          equals(
            [
              Rect.fromLTWH(16, 16, 40, 40),
            ],
          ),
        );
      },
    );

    test('parses correctly when have white spaces', () {
      expect(
        SpritExp(expression: '{40, 16}').rects,
        equals(
          [
            Rect.fromLTWH(40, 40, 16, 16),
          ],
        ),
      );
    });

    test('throws an error if the expression is invalid', () {
      expect(
        () => SpritExp(expression: '{10,20,30,40'),
        throwsArgumentError,
      );
    });

    group('multiplers', () {
      test('correctly parse when only have size', () {
        expect(
          SpritExp(expression: '{10} * 2').rects,
          equals(
            [
              Rect.fromLTWH(0, 0, 10, 10),
              Rect.fromLTWH(10, 0, 10, 10),
            ],
          ),
        );
      });

      test('correctly parse when only have size and is vertical', () {
        expect(
          SpritExp(expression: '{10} * 2y').rects,
          equals(
            [
              Rect.fromLTWH(0, 0, 10, 10),
              Rect.fromLTWH(0, 10, 10, 10),
            ],
          ),
        );
      });

      test(
        'correctly parse when only have size and position and is vertical',
        () {
          expect(
            SpritExp(expression: '{10,20} * 2y').rects,
            equals(
              [
                Rect.fromLTWH(10, 10, 20, 20),
                Rect.fromLTWH(10, 30, 20, 20),
              ],
            ),
          );
        },
      );

      test(
        'correctly parse when only have size and is both vertical and '
        'horizontal',
        () {
          expect(
            SpritExp(expression: '{10} * 2xy').rects,
            equals(
              [
                Rect.fromLTWH(0, 0, 10, 10),
                Rect.fromLTWH(10, 0, 10, 10),
                Rect.fromLTWH(0, 10, 10, 10),
                Rect.fromLTWH(10, 10, 10, 10),
              ],
            ),
          );
        },
      );
    });

    group('/ by image', () {
      test('returns the correct sprites', () {
        expect(
          SpritExp(expression: '{16}') / _MockImage(),
          isA<List<Sprite>>()
              .having((list) => list.length, 'length', equals(1))
              .having(
                (list) => list.first,
                'sprite',
                isA<Sprite>().having(
                  (sprite) => sprite.src,
                  'sprite.src',
                  equals(Rect.fromLTWH(0, 0, 16, 16)),
                ),
              ),
        );
      });

      test('cannot divide by something that is not an image', () {
        expect(
          () => SpritExp(expression: '{16}') / '',
          throwsArgumentError,
        );
      });
    });
  });
}
