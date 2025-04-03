import 'package:calculatrice/componenets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MainApp());
}

// Evaluates the expression and returns a String. If the result is whole, it omits ".0"
String evaluateExpression(String expression) {
  try {
    Parser p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = ContextModel();
    double result = exp.evaluate(EvaluationType.REAL, cm);
    if (result % 1 == 0) {
      return result.toInt().toString();
    } else {
      return result.toString();
    }
  } catch (e) {
    return "Error";
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController resultController = TextEditingController();
  final TextEditingController historyController = TextEditingController();

  // Flag to indicate a result was just computed
  bool _resultComputed = false;

  // Button list (created once)
  final List<ButtonInfo> buttons = [
    ButtonInfo("C", Colors.black, Colors.red),
    ButtonInfo("CE", Colors.black, Colors.red),
    ButtonInfo("(", Colors.black, Colors.blueGrey),
    ButtonInfo(")", Colors.black, Colors.blueGrey),
    ButtonInfo("7", Colors.black, Colors.blue),
    ButtonInfo("8", Colors.black, Colors.blue),
    ButtonInfo("9", Colors.black, Colors.blue),
    ButtonInfo("+", Colors.white, Colors.green),
    ButtonInfo("4", Colors.black, Colors.blue),
    ButtonInfo("5", Colors.black, Colors.blue),
    ButtonInfo("6", Colors.black, Colors.blue),
    ButtonInfo("-", Colors.white, Colors.green),
    ButtonInfo("1", Colors.black, Colors.blue),
    ButtonInfo("2", Colors.black, Colors.blue),
    ButtonInfo("3", Colors.black, Colors.blue),
    ButtonInfo("*", Colors.white, Colors.green),
    ButtonInfo("0", Colors.black, Colors.blue),
    ButtonInfo(".", Colors.black, Colors.blue),
    ButtonInfo("=", Colors.black, Colors.red),
    ButtonInfo("/", Colors.white, Colors.green),
  ];

  // Set of operator symbols for easy checking
  final Set<String> operators = {"+", "-", "*", "/"};

  @override
  void dispose() {
    resultController.dispose();
    historyController.dispose();
    super.dispose();
  }

  // Helper function to handle button presses with haptic feedback.
  void _onButtonPressed(String label) {
    // Trigger a light haptic feedback on every press.
    HapticFeedback.lightImpact();

    setState(() {
      // If a result was computed and the user presses a digit, decimal, or "(",
      // clear the result field to start a new calculation.
      if (_resultComputed) {
        // If the new input is an operator, allow it and simply reset the flag.
        if (operators.contains(label)) {
          _resultComputed = false;
          // Continue without clearing the result.
        } else if (RegExp(r'[0-9\.(]').hasMatch(label)) {
          // Save the computed result to history and clear the result field.
          historyController.text = resultController.text;
          resultController.clear();
          _resultComputed = false;
        }
      }

      if (label == "C") {
        resultController.clear();

        historyController.clear();
      } else if (label == "CE") {
        if (resultController.text.isNotEmpty) {
          resultController.text = resultController.text
              .substring(0, resultController.text.length - 1);
        }
      } else if (label == "=") {
        if (resultController.text.isNotEmpty) {
          historyController.text = resultController.text;
          resultController.text = evaluateExpression(resultController.text);
          _resultComputed = true;
        }
      } else if (operators.contains(label)) {
        // Only append an operator if the last character is not already an operator.
        if (resultController.text.isNotEmpty) {
          String lastChar =
              resultController.text[resultController.text.length - 1];
          if (!operators.contains(lastChar)) {
            resultController.text += label;
          }
        }
      } else {
        resultController.text += label;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: MaterialApp(
        title: "Calculatrice",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey.shade300,
          body: Column(
            children: [
              // Display section (history and result) with shadow and rounded corners
              Expanded(
                flex: 3,
                child: Container(
                  width: screenWidth,
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        controller: historyController,
                        showCursor: false,
                        maxLines: 1,
                        readOnly: true,
                        enabled: false,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(),
                          border: UnderlineInputBorder(),
                          hintText: "History",
                          hintStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70),
                        ),
                      ),
                      TextFormField(
                        controller: resultController,
                        showCursor: false,
                        maxLines: 2,
                        readOnly: true,
                        style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Result",
                          hintStyle: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Button grid section with a footer text
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Developed specifically for Medjdoub Said",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: buttons.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (context, index) {
                          final button = buttons[index];
                          // Wrap each button with a container for a shadow effect.
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: MyButton(
                              label: button.label,
                              fontColor: button.fontColor,
                              backColor: button.backColor,
                              onClick: () => _onButtonPressed(button.label),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
