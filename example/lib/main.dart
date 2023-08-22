// ignore_for_file: public_member_api_docs

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flame/flame.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:spritexp/spritexp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: flutterNesTheme(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final _expressionController = TextEditingController();

  bool _onError = false;
  ui.Image? _image;
  late Uint8List? _imageBytes;
  List<Sprite> _sprites = [];

  @override
  void dispose() {
    _expressionController.dispose();
    super.dispose();
  }

  void _onChangeExpression() {
    if (_expressionController.text.isEmpty) {
      setState(() {
        _sprites = [];
      });
      return;
    }

    final expression = _expressionController.text;

    try {
      final spriteExp = SpritExp(expression: expression);

      setState(() {
        _onError = false;
      });

      if (_image == null) return;

      final sprites = spriteExp / _image!;
      setState(() {
        _sprites = sprites;
      });
    } catch (_) {
      setState(() {
        _onError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            NesContainer(
              label: 'Expression',
              child: TextFormField(
                controller: _expressionController,
                onChanged: (_) => _onChangeExpression(),
                decoration: InputDecoration(
                  errorText: _onError ? 'Invalid expression' : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_image == null)
              Expanded(
                child: NesContainer(
                  label: 'No image selected',
                  width: double.infinity,
                  child: Center(
                    child: NesButton(
                      type: NesButtonType.primary,
                      child: const Text('Select image'),
                      onPressed: () async {
                        const typeGroup = XTypeGroup(
                          label: 'images',
                          extensions: <String>['jpg', 'png'],
                        );
                        final file = await openFile(
                          acceptedTypeGroups: <XTypeGroup>[typeGroup],
                        );

                        if (file == null) return;

                        final bytes = await file.readAsBytes();
                        final image = await Flame.images.fetchOrGenerate(
                          file.path,
                          () => decodeImageFromList(bytes),
                        );

                        setState(() {
                          _image = image;
                          _imageBytes = bytes;
                        });

                        _onChangeExpression();
                      },
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: NesContainer(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: NesContainer(
                            label: 'Original image',
                            child: Image.memory(
                              _imageBytes!,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: NesContainer(
                            label: 'Sprites',
                            height: double.infinity,
                            child: Wrap(
                              children: [
                                for (final sprite in _sprites)
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SpriteWidget(sprite: sprite),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
