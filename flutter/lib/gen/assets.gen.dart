/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  $AssetsIconsBrandGen get brand => const $AssetsIconsBrandGen();

  /// File path: assets/icons/broken_wire.png
  AssetGenImage get brokenWire =>
      const AssetGenImage('assets/icons/broken_wire.png');

  /// File path: assets/icons/cancel.png
  AssetGenImage get cancel => const AssetGenImage('assets/icons/cancel.png');

  /// File path: assets/icons/pinch_zoom.png
  AssetGenImage get pinchZoom =>
      const AssetGenImage('assets/icons/pinch_zoom.png');

  /// File path: assets/icons/under_const.png
  AssetGenImage get underConst =>
      const AssetGenImage('assets/icons/under_const.png');

  /// File path: assets/icons/user.png
  AssetGenImage get user => const AssetGenImage('assets/icons/user.png');
}

class $AssetsIconsBrandGen {
  const $AssetsIconsBrandGen();

  /// File path: assets/icons/brand/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/icons/brand/icon.png');

  /// File path: assets/icons/brand/icon_background.png
  AssetGenImage get iconBackground =>
      const AssetGenImage('assets/icons/brand/icon_background.png');

  /// File path: assets/icons/brand/icon_single-01.png
  AssetGenImage get iconSingle01 =>
      const AssetGenImage('assets/icons/brand/icon_single-01.png');
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
