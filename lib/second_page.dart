import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int counter = 0;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      counter = -10;
    });
  }

  Color _greenFor(int value, TextStyle baseStyle) {
    final t = (value / 30).clamp(0.0, 1.0);
    final start = baseStyle.color ?? Colors.black;
    return Color.lerp(value < 0 ? Colors.red : start, Colors.green, t)!;
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.headlineMedium ??
        const TextStyle(fontSize: 24);
    final progress = (counter.clamp(0, 30) / 30).toDouble();
    final isNegative = counter < 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crédits sociaux de Tristan"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: baseStyle.copyWith(color: _greenFor(counter, baseStyle)),
              child: Text('$counter SOCIAL CREDIT'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedOpacity(
                    opacity: isNegative ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Image(
                      image: AssetImage('assets/photo/chingcolere.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isNegative ? 0.0 : (1 - progress),
                    duration: const Duration(milliseconds: 250),
                    child: const Image(
                      image: AssetImage('assets/photo/xi.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isNegative ? 0.0 : progress,
                    duration: const Duration(milliseconds: 250),
                    child: const Image(
                      image: AssetImage('assets/photo/gigaChine.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _resetCounter,
              child: const Text("Réinitialiser"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
