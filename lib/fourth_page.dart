import 'package:flutter/material.dart';
import 'package:test_app/gauge.dart';

Map<String, double> chine = {
  "忠诚": 0.4,
  "揭发": 0.7,
  "共产主义": 0.6,
  "狗被吃掉了": 0.8,
  "对美国人的仇恨": 0.5,
  "提交": 0.9,
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
                  // width: 300,
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
