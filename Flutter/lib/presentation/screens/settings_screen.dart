import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: themeProv.isDark,
            onChanged: (v) => themeProv.toggleDark(v),
            title: const Text(
              'Dark Mode',
              style: TextStyle(color: Colors.white),
            ),
            secondary: const Icon(Icons.dark_mode, color: Colors.white),
          ),
          ListTile(
            leading: Icon(Icons.color_lens, color: themeProv.accent),
            title: const Text(
              'Accent color',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '#${themeProv.accent.toARGB32().toRadixString(16).toUpperCase().substring(2)}',
              style: const TextStyle(color: Colors.white70),
            ),
            onTap: () async {
              Color picked = themeProv.accent;
              await showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Pick Accent Color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: themeProv.accent,
                          onColorChanged: (c) => picked = c,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            themeProv.setAccent(picked);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Select'),
                        ),
                      ],
                    ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.notifications_active,
              color: Colors.white,
            ),
            title: const Text(
              'Test Notification',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              await NotificationService.scheduleNotification(
                id: 999999,
                title: 'Test',
                body: 'This is a test notification',
                scheduledDate: DateTime.now().add(const Duration(seconds: 2)),
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Test notification scheduled (2s)'),
                ),
              );
            },
          ),
          const Spacer(),
          const Text('Version 1.0.0', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
