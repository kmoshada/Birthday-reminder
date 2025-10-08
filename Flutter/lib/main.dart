import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/birthday_provider.dart';
import 'providers/theme_provider.dart';
import 'services/notification_service.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Birthday Buddy',
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
