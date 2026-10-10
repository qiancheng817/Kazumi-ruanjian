import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 是否运行在 Android TV 上（启动时通过 [detectAndroidTV] 检测并缓存）
bool isAndroidTV = false;

/// 通过原生通道检测当前设备是否为 Android TV
Future<void> detectAndroidTV() async {
  if (!Platform.isAndroid) {
    isAndroidTV = false;
    return;
  }
  try {
    isAndroidTV = await const MethodChannel('com.predidit.kazumi/intent')
            .invokeMethod<bool>('isAndroidTV') ??
        false;
  } catch (_) {
    isAndroidTV = false;
  }
}

Future<bool> isLowResolution() async {
  if (Platform.isMacOS) {
    return false;
  }
  final screenInfo = await getScreenInfo();
  return screenInfo['height']! / screenInfo['ratio']! < 900;
}

Future<Map<String, double>> getScreenInfo() async {
  final mediaQuery = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.first,
  );
  final screenSize =
      WidgetsBinding.instance.platformDispatcher.displays.first.size;
  return {
    'width': screenSize.width,
    'height': screenSize.height,
    'ratio': mediaQuery.devicePixelRatio,
  };
}

bool isDesktop() {
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}
