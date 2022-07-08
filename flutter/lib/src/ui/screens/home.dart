import 'package:flutter/material.dart';
import 'package:shopping/src/ui/components/destination_tab_view.dart';
import '../components/bottom_nav_bar.dart';
import 'browsing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ValueNotifier<int> _tabIndexNotifier;

  @override
  void initState() {
    super.initState();
    _tabIndexNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _tabIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const BrowsingScreen(),
      Container(
        color: Colors.blue,
      ),
    ];

    const options = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag),
        label: 'Explore',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'My Stuff',
      ),
    ];

    return Scaffold(
      body: DestinationTabView(
        index: _tabIndexNotifier,
        tabs: tabs,
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _tabIndexNotifier,
        builder: (context, _) {
          return MainBottomAppBar(
            selectedIndex: _tabIndexNotifier.value,
            options: options,
            onItemTap: (index) {
              _tabIndexNotifier.value = index;
            },
          );
        },
      ),
    );
  }
}
