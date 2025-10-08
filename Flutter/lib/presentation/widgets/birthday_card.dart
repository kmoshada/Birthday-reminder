import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:helpbuddy/models/birthday.dart';
import 'package:helpbuddy/providers/birthday_provider.dart';
import 'package:helpbuddy/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BirthdayCard extends StatefulWidget {
  final Birthday birthday;
  const BirthdayCard({required this.birthday, super.key});

  @override
  State<BirthdayCard> createState() => _BirthdayCardState();
}

class _BirthdayCardState extends State<BirthdayCard> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    _confetti = ConfettiController(duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Provider.of<ThemeProvider>(context).accent;
    final isToday =
        widget.birthday.date.month == DateTime.now().month &&
        widget.birthday.date.day == DateTime.now().day;

    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: accent,
              child: const Icon(Icons.cake, color: Colors.white),
            ),
            title: Text(
              widget.birthday.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${DateFormat('MMM dd').format(widget.birthday.date)} • ${widget.birthday.note ?? ''}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isToday)
                  IconButton(
                    icon: const Icon(Icons.celebration),
                    onPressed: () {
                      _confetti.play();
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed:
                      () => Provider.of<BirthdayProvider>(
                        context,
                        listen: false,
                      ).deleteBirthday(widget.birthday.id),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.white,
                  Colors.pink,
                  Colors.yellow,
                  Colors.purple,
                ],
                createParticlePath: drawStar,
                numberOfParticles: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // optional star path for confetti
  Path drawStar(Size size) {
    // simple star
    const numPoints = 5;
    final halfWidth = size.width / 2;
    final halfHeight = size.height / 2;
    final path = Path();
    for (int i = 0; i < numPoints; i++) {
      final angle = (i * (360 / numPoints)) * (3.14159 / 180);
      final x = halfWidth + halfWidth * 0.5 * math.cos(angle);
      final y = halfHeight + halfHeight * 0.5 * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }
}
