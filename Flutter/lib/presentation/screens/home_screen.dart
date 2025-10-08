import 'package:flutter/material.dart';
import 'package:helpbuddy/core/app_colors.dart';
import 'package:helpbuddy/presentation/screens/add_birthday_screen.dart';
import 'package:helpbuddy/presentation/screens/settings_screen.dart';
import 'package:helpbuddy/presentation/screens/upcoming_screen.dart';
import 'package:helpbuddy/presentation/widgets/birthday_card.dart';
import 'package:helpbuddy/providers/birthday_provider.dart';
import 'package:helpbuddy/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    TodayPage(),
    UpcomingScreen(),
    SettingsScreen(),
  ];

  void _onTabTapped(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    final accent = Provider.of<ThemeProvider>(context).accent;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.vibrantGradient(accent)),
        child: SafeArea(child: _pages[_selectedIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddBirthdayScreen()),
            ),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.white.withAlpha((255 * 0.7).round()),
        selectedItemColor: accent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cake_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Upcoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BirthdayProvider>(context);
    final today = DateTime.now();
    final todayList =
        provider.items
            .where(
              (b) => b.date.month == today.month && b.date.day == today.day,
            )
            .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Birthdays",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child:
                todayList.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.card_giftcard,
                            size: 70,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No birthdays today!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: todayList.length,
                      itemBuilder:
                          (context, i) => BirthdayCard(birthday: todayList[i]),
                    ),
          ),
        ],
      ),
    );
  }
}
