import 'package:flutter/material.dart';
import 'package:test_app/gauge.dart';

Map<String, double> chine = {
  "Loyauté": 0.4,
  "Dénonciation": 0.7,
  "Communisme": 0.6,
  "Le chien a été mangé": 0.8,
  "Haine envers les Américains": 0.5,
  "Soumission": 0.9,
};

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              child: Image.asset('assets/photo/chineseSmiley.png',
                  height: 150,
                  fit: BoxFit.fill),
            ),
            const SizedBox(height: 10),
            for (var skill in chine.entries) Gauge(skill.key, skill.value),
          ],
        ),
      ),
    );
  }
}
