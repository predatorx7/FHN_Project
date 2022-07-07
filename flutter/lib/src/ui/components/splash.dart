import 'package:magnific_ui/magnific_ui.dart';
import 'package:shopping/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class _AppSplashFragment extends StatelessWidget {
  const _AppSplashFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Center(
        child: ImageIcon2(
          AssetImage(
            Assets.icons.brand.icon.path,
          ),
          ignoreIconColor: true,
          size: 250,
        ),
      ),
    );
  }
}

const splashWithoutAnimationUI = _AppSplashFragment();

const durationOfSplashWithoutAnimations = Duration(milliseconds: 1500);
