import 'package:flutter/material.dart';

class Gauge extends StatelessWidget {
  final String skillName;
  final double progressBarLvl;
  const Gauge(this.skillName, this.progressBarLvl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Chip(label: Text(skillName )),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: progressBarLvl,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
                minHeight: 10,
              ),
            ),
          ],
        ),
      ]

    );
  }
}