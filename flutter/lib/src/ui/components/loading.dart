import 'package:flutter/material.dart';
import 'package:magnific_ui/magnific_ui.dart';

class SliverLoading extends StatelessWidget {
  const SliverLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            MiniCircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
