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
  int _counter = 0;
  final int _gradientMultiple = 5;
  final int _gradientSymmetricMultiple = 2;
  bool isDarkColor = false;

  // MARK: - Color generation with random RGB values.
  // We use 256^3 possible colors, but if we want even more variation,
  // we could include an alpha channel to generate 256^4 unique colors.

  /// Generates a random RGB color
  ///
  /// It also checks whether the color is light or dark using a brightness
  /// calculation, which helps us adjust the text color accordingly.
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

  /// A helper method that show a gradient background for every 5 click
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
