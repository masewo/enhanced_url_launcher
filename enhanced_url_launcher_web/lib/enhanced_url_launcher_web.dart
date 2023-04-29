// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:enhanced_url_launcher_platform_interface/link.dart';
import 'package:enhanced_url_launcher_platform_interface/enhanced_url_launcher_platform_interface.dart';

import 'src/link.dart';
import 'src/shims/dart_ui.dart' as ui;
import 'src/third_party/platform_detect/browser.dart';

const Set<String> _safariTargetTopSchemes = <String>{
  'mailto',
  'tel',
  'sms',
};

String? _getUrlScheme(String url) => Uri.tryParse(url)?.scheme;

bool _isSafariTargetTopScheme(String url) =>
    _safariTargetTopSchemes.contains(_getUrlScheme(url));

/// The web implementation of [UrlLauncherPlatform].
///
/// This class implements the `package:enhanced_url_launcher` functionality for the web.
class UrlLauncherPlugin extends UrlLauncherPlatform {
  /// A constructor that allows tests to override the window object used by the plugin.
  UrlLauncherPlugin({@visibleForTesting html.Window? debugWindow})
      : _window = debugWindow ?? html.window {
    _isSafari = navigatorIsSafari(_window.navigator);
  }

  final html.Window _window;
  bool _isSafari = false;
  html.WindowBase? _lastWindow;

  // The set of schemes that can be handled by the plugin
  static final Set<String> _supportedSchemes = <String>{
    'http',
    'https',
  }.union(_safariTargetTopSchemes);

  /// Registers this class as the default instance of [UrlLauncherPlatform].
  static void registerWith(Registrar registrar) {
    UrlLauncherPlatform.instance = UrlLauncherPlugin();
    ui.platformViewRegistry
        .registerViewFactory(linkViewType, linkViewFactory, isVisible: false);
  }

  @override
  LinkDelegate get linkDelegate {
    return (LinkInfo linkInfo) => WebLinkDelegate(linkInfo);
  }

  /// Opens the given [url] in the specified [webOnlyWindowName].
  ///
  /// Returns the newly created window.
  @visibleForTesting
  html.WindowBase openNewWindow(
    String url, {
    String? webOnlyWindowName,
    String? webOnlyOptions,
  }) {
    // We need to open mailto, tel and sms urls on the _top window context on safari browsers.
    // See https://github.com/flutter/flutter/issues/51461 for reference.
    final String target = webOnlyWindowName ??
        ((_isSafari && _isSafariTargetTopScheme(url)) ? '_top' : '');
    // ignore: unsafe_html
    return _window.open(url, target, webOnlyOptions);
  }

  @override
  Future<bool> canLaunch(String url) {
    return Future<bool>.value(_supportedSchemes.contains(_getUrlScheme(url)));
  }

  @override
  Future<bool> launch(
    String url, {
    bool useSafariVC = false,
    bool useWebView = false,
    bool enableJavaScript = false,
    bool enableDomStorage = false,
    bool universalLinksOnly = false,
    Map<String, String> headers = const <String, String>{},
    String? webOnlyWindowName,
    String? webOnlyOptions,
  }) {
    _lastWindow = openNewWindow(
      url,
      webOnlyWindowName: webOnlyWindowName,
      webOnlyOptions: webOnlyOptions,
    );
    return Future<bool>.value(_lastWindow != null);
  }

  @override
  bool? isLastWindowClosed() {
    return _lastWindow?.closed;
  }

  @override
  void downloadBlob(
    List<int> bytes, {
    String? types,
    String? endings,
    String? fileName,
  }) {
    var blob = html.Blob([bytes], types, endings);

    var anchor = html.AnchorElement(
      href: html.Url.createObjectUrlFromBlob(blob).toString(),
    );

    if (fileName != null) anchor.setAttribute("download", fileName);

    anchor.click();
  }

  @override
  math.Point getNewWindowLocation(int width, int height) {
    var dualScreenLeft = html.window.screenLeft ?? html.window.screenX ?? 0;
    var dualScreenTop = html.window.screenTop ?? html.window.screenY ?? 0;

    var innerWidth = html.window.innerWidth ??
        (html.document.documentElement?.clientWidth ??
            html.window.screen?.width) ??
        1920;
    var innerHeight = html.window.innerHeight ??
        (html.document.documentElement?.clientHeight ??
            html.window.screen?.height) ??
        1080;

    var systemZoomW =
        innerWidth / (html.window.screen?.available.width ?? 1920);
    var systemZoomH =
        innerHeight / (html.window.screen?.available.height ?? 1080);

    var left = (innerWidth - width) / 2 / systemZoomW + dualScreenLeft;
    var top = (innerHeight - height) / 2 / systemZoomH + dualScreenTop;

    left = math.max(left, 0);
    top = math.max(top, 0);

    return math.Point(left, top);
  }
}
