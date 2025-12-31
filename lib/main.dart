import 'package:flutter/material.dart';
import 'package:valuta/theme.dart';
import 'package:valuta/screens/home_page.dart';
import 'package:valuta/screens/converter_page.dart';
import 'package:valuta/screens/about_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valuta: Currency Converter',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  bool _showNav = true;
  bool? _lastHeightWasSmall;
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ConverterPage(),
    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool isLargeWidth = screenWidth > 1200;
    bool isSmallHeightNow = screenHeight < 400;

    if (_lastHeightWasSmall != isSmallHeightNow) {
      _lastHeightWasSmall = isSmallHeightNow;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _showNav = !isSmallHeightNow;
        });
      });
    }

    bool shouldShowBar = isLargeWidth || _showNav;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: _pages[_selectedPageIndex],
        ),
      ),
      bottomNavigationBar: shouldShowBar
          ? Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: NavigationBar(
                  selectedIndex: _selectedPageIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedPageIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.trending_up),
                      label: 'Rates',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.calculate),
                      label: 'Converter',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person),
                      label: 'About',
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButton: isLargeWidth
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showNav = !_showNav;
                });
              },
              child: Icon(
                (shouldShowBar)
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                color: Colors.purple,
              ),
            ),
    );
  }
}
