import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../providers/birthday_provider.dart';
import 'package:intl/intl.dart';

class UpcomingScreen extends StatelessWidget {
  const UpcomingScreen({super.key});

  int daysLeft(DateTime date) {
    final now = DateTime.now();
    var next = DateTime(now.year, date.month, date.day);
    if (next.isBefore(DateTime(now.year, now.month, now.day))) {
      next = DateTime(now.year + 1, date.month, date.day);
    }
    return next.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BirthdayProvider>(context);
    final items =
        provider.items.toList()..sort((a, b) {
          final now = DateTime.now();
          DateTime na = DateTime(now.year, a.date.month, a.date.day);
          DateTime nb = DateTime(now.year, b.date.month, b.date.day);
          if (na.isBefore(DateTime(now.year, now.month, now.day))) {
            na = DateTime(now.year + 1, a.date.month, a.date.day);
          }
          if (nb.isBefore(DateTime(now.year, now.month, now.day))) {
            nb = DateTime(now.year + 1, b.date.month, b.date.day);
          }
          return na.compareTo(nb);
        });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Birthdays',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child:
                items.isEmpty
                    ? const Center(
                      child: Text(
                        'No birthdays added',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                    : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final b = items[i];
                        final d = daysLeft(b.date);
                        final percent = (365 - d) / 365;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircularPercentIndicator(
                              radius: 25.0,
                              lineWidth: 4.0,
                              percent: percent.clamp(0.0, 1.0),
                              center: const Icon(Icons.cake, size: 25),
                              progressColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            title: Text(b.name),
                            subtitle: Text(
                              DateFormat('MMMM dd').format(b.date),
                            ),
                            trailing: Text('$d days'),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
