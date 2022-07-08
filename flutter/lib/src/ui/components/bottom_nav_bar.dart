import 'package:flutter/material.dart';

class MainBottomAppBar extends StatelessWidget {
  const MainBottomAppBar({
    Key? key,
    required this.selectedIndex,
    required this.options,
    this.onItemTap,
  }) : super(key: key);

  final int selectedIndex;
  final ValueChanged<int>? onItemTap;
  final List<BottomNavigationBarItem> options;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectedBottomNavbarOptionIndicator(
            selectedIndex: selectedIndex,
            length: options.length,
          ),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: options,
            currentIndex: selectedIndex,
            onTap: onItemTap,
            selectedIconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedBottomNavbarOptionIndicator extends StatelessWidget {
  const SelectedBottomNavbarOptionIndicator({
    Key? key,
    required this.length,
    required this.selectedIndex,
  }) : super(key: key);

  final int length;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final selectedItemIndicatorDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
    );

    const itemIndicatorDecoration = BoxDecoration(
      color: Colors.transparent,
    );

    const selectedIndicatorHeight = 3.0;
    const selectedIndicatorWidth = 60.0;

    return Row(
      children: [
        for (int i = 0; i < length; i++)
          Expanded(
            child: Center(
              child: AnimatedContainer(
                height: i == selectedIndex ? selectedIndicatorHeight : 0.0,
                width: i == selectedIndex ? selectedIndicatorWidth : 0.0,
                decoration: i == selectedIndex
                    ? selectedItemIndicatorDecoration
                    : itemIndicatorDecoration,
                duration: const Duration(
                  milliseconds: 200,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
