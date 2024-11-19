import 'dart:math';

import 'package:flutter/material.dart';

/// Main Screen of this app
/// change background color to random on a click
class HomeScreen extends StatefulWidget {
  /// Creates the [HomeScreen] widget.
  ///
  /// This constructor doesn't take any required parameters but creates
  /// a stateful widget that will manage the counter and dynamic background.
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// The counter that gets incremented each time the user taps on the screen.
  ///
  /// This starts at 1, and each tap adds 1 to this value. The counter also
  /// affects how the background color is displayed (solid or gradient).
  int _counter = 1;

  /// A multiplier used to determine if the counter is a multiple of 5, which
  /// will trigger the gradient background effect.
  final int _gradientMultiple = 5;

  /// A multiplier used to determine if the counter is a multiple of 2, which
  /// will affect the direction of the gradient (either horizontal or vertical).
  final int _gradientSymmetricMultiple = 2;

  /// A flag that checks if the background color is dark or light, which helps
  /// us decide what color the text should be for better readability.
  bool isDarkColor = false;

  // MARK: - Color generation with random RGB values.
  // We use 256^3 possible colors, but if we want even more variation,
  // we could include an alpha channel to generate 256^4 unique colors.

  /// Generates a random color by randomly picking red, green, and blue values.
  ///
  /// It also checks whether the color is light or dark using a brightness
  /// calculation, which helps us adjust the text color accordingly.
  ///
  /// Example:
  /// ```dart
  /// Color randomColor = _getRandomColor();
  /// ```
  Color _getRandomColor() {
    final random = Random();
    final randomRed = random.nextInt(256);
    final randomGreen = random.nextInt(256);
    final randomBlue = random.nextInt(256);

    analyzeColorBrightnessFrom(randomRed, randomGreen, randomBlue);

    return Color.fromRGBO(randomRed, randomGreen, randomBlue, 1.0);
  }

  /// This method helps determine if the background color is dark or light so
  /// we can change the text color for better contrast.
  /// [red], [green], and [blue] are the RGB values of the generated color.
  void analyzeColorBrightnessFrom(int red, int green, int blue) {
    const greyScaleDarkPoint = 128;
    final grayScale = (0.299 * red) + (0.587 * green) + (0.114 * blue);
    isDarkColor = grayScale > greyScaleDarkPoint;
  }

  /// A helper method that checks if the counter is a multiple of a given number.
  ///
  /// This is used to decide when to apply a gradient background or when to show
  /// a solid color instead. For example, if the counter is a multiple of 5,
  /// we show a gradient background.
  ///
  /// [value] is the number to check divisibility against.
  bool _multipleOf(int value) {
    return (_counter % value == 0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GestureDetector(
          onTap: () {
            setState(() {
              _counter++;
            });
          },
          child: Container(
            // If the counter is a multiple of 5, apply a gradient background.
            decoration: _multipleOf(_gradientMultiple)
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: _multipleOf(_gradientSymmetricMultiple)
                          ? Alignment.centerLeft
                          : Alignment.topCenter,
                      end: _multipleOf(_gradientSymmetricMultiple)
                          ? Alignment.centerRight
                          : Alignment.bottomCenter,
                      colors: [_getRandomColor(), _getRandomColor()],
                    ),
                  )
                : null,
            // If no gradient, apply a solid random color as the background.
            color: _multipleOf(_gradientMultiple) ? null : _getRandomColor(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello there",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: isDarkColor ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                  ),
                  Text(
                    "Count - $_counter",
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      color: isDarkColor ? Colors.white : Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 21,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
