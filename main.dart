import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lawrence\'s Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '';
  String _result = '';
  String _expression = '';

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '';
        _result = '';
        _expression = '';
      } else if (value == '=') {
        _result = _evaluateExpression(_expression);
      } else if (value == '^2') {
        _expression += '^2';
        _display += '²';
      } else {
        _expression += value;
        _display += value;
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      // Replace the custom square notation with the actual mathematical operation
      expression = expression.replaceAllMapped(RegExp(r'(\d+)\^2'), (match) {
        final number = match.group(1);
        return '($number * $number)';
      });

      const evaluator = ExpressionEvaluator();
      final parsedExpression = Expression.parse(expression);
      final result = evaluator.eval(parsedExpression, {});
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawrence\'s Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _display,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          _buildButtonRow(['7', '8', '9', '/']),
          _buildButtonRow(['4', '5', '6', '*']),
          _buildButtonRow(['1', '2', '3', '-']),
          _buildButtonRow(['C', '0', '=', '+']),
          _buildButtonRow(['^2']), // Add the new button row for squaring
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> values) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: values.map((value) {
          return Expanded(
            child: TextButton(
              onPressed: () => _onPressed(value),
              child: Text(
                value,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}