// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:enhanced_url_launcher_platform_interface/link.dart';
import 'package:enhanced_url_launcher_platform_interface/method_channel_enhanced_url_launcher.dart';
import 'package:enhanced_url_launcher_platform_interface/enhanced_url_launcher_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Store the initial instance before any tests change it.
  final UrlLauncherPlatform initialInstance = UrlLauncherPlatform.instance;

  group('$UrlLauncherPlatform', () {
    test('$MethodChannelUrlLauncher() is the default instance', () {
      expect(initialInstance, isInstanceOf<MethodChannelUrlLauncher>());
    });

    test('Cannot be implemented with `implements`', () {
      expect(() {
        UrlLauncherPlatform.instance = ImplementsUrlLauncherPlatform();
        // In versions of `package:plugin_platform_interface` prior to fixing
        // https://github.com/flutter/flutter/issues/109339, an attempt to
        // implement a platform interface using `implements` would sometimes
        // throw a `NoSuchMethodError` and other times throw an
        // `AssertionError`.  After the issue is fixed, an `AssertionError` will
        // always be thrown.  For the purpose of this test, we don't really care
        // what exception is thrown, so just allow any exception.
      }, throwsA(anything));
    });

    test('Can be mocked with `implements`', () {
      final UrlLauncherPlatformMock mock = UrlLauncherPlatformMock();
      UrlLauncherPlatform.instance = mock;
    });

    test('Can be extended', () {
      UrlLauncherPlatform.instance = ExtendsUrlLauncherPlatform();
    });
  });

  group('$MethodChannelUrlLauncher', () {
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/enhanced_url_launcher');
    final List<MethodCall> log = <MethodCall>[];
    _ambiguate(TestDefaultBinaryMessengerBinding.instance)!
        .defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);

      // Return null explicitly instead of relying on the implicit null
      // returned by the method channel if no return statement is specified.
      return null;
    });

    final MethodChannelUrlLauncher launcher = MethodChannelUrlLauncher();

    tearDown(() {
      log.clear();
    });

    test('canLaunch', () async {
      await launcher.canLaunch('http://example.com/');
      expect(
        log,
        <Matcher>[
          isMethodCall('canLaunch', arguments: <String, Object>{
            'url': 'http://example.com/',
          })
        ],
      );
    });

    test('canLaunch should return false if platform returns null', () async {
      final bool canLaunch = await launcher.canLaunch('http://example.com/');

      expect(canLaunch, false);
    });

    test('launch', () async {
      await launcher.launch(
        'http://example.com/',
        useSafariVC: true,
        useWebView: false,
        enableJavaScript: false,
        enableDomStorage: false,
        universalLinksOnly: false,
        headers: const <String, String>{},
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('launch', arguments: <String, Object>{
            'url': 'http://example.com/',
            'useSafariVC': true,
            'useWebView': false,
            'enableJavaScript': false,
            'enableDomStorage': false,
            'universalLinksOnly': false,
            'headers': <String, String>{},
          })
        ],
      );
    });

    test('launch with headers', () async {
      await launcher.launch(
        'http://example.com/',
        useSafariVC: true,
        useWebView: false,
        enableJavaScript: false,
        enableDomStorage: false,
        universalLinksOnly: false,
        headers: const <String, String>{'key': 'value'},
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('launch', arguments: <String, Object>{
            'url': 'http://example.com/',
            'useSafariVC': true,
            'useWebView': false,
            'enableJavaScript': false,
            'enableDomStorage': false,
            'universalLinksOnly': false,
            'headers': <String, String>{'key': 'value'},
          })
        ],
      );
    });

    test('launch force SafariVC', () async {
      await launcher.launch(
        'http://example.com/',
        useSafariVC: true,
        useWebView: false,
        enableJavaScript: false,
        enableDomStorage: false,
        universalLinksOnly: false,
        headers: const <String, String>{},
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('launch', arguments: <String, Object>{
            'url': 'http://example.com/',
            'useSafariVC': true,
            'useWebView': false,
            'enableJavaScript': false,
            'enableDomStorage': false,
            'universalLinksOnly': false,
            'headers': <String, String>{},
          })
        ],
      );
    });

    test('launch universal links only', () async {
      await launcher.launch(
        'http://example.com/',
        useSafariVC: false,
        useWebView: false,
        enableJavaScript: false,
        enableDomStorage: false,
        universalLinksOnly: true,
        headers: const <String, String>{},
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('launch', arguments: <String, Object>{
            'url': 'http://example.com/',
            'useSafariVC': false,
            'useWebView': false,
            'enableJavaScript': false,
            'enableDomStorage': false,
            'universalLinksOnly': true,
            'headers': <String, String>{},
          })
        ],
      );
    });

    test('launch force WebView', () async {
      await launcher.launch(
        'http://example.com/',
        useSafariVC: true,
        useWebView: true,
        enableJavaScript: false,
        enableDomStorage: false,
        universalLinksOnly: false,
        headers: const <String, String>{},
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('launch', arguments: <String, Object>{
            'url': 'http://example.com/',
            'useSafariVC': true,
            'useWebView': true,
            'enableJavaScript': false,
            'enableDomStorage': false,
            'universalLinksOnly': false,
            'headers': <String, String>{},
          })
        ],
      );
    });

    test('launch force WebView enable javascript', () async {
      await launcher.launch(
        'http://example.com/',
        useSafariVC: true,
        useWebView: true,
        enableJavaScript: true,
        enableDomStorage: false,
        universalLinksOnly: false,
        headers: const <String, String>{},
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('launch', arguments: <String, Object>{
            'url': 'http://example.com/',
            'useSafariVC': true,
            'useWebView': true,
            'enableJavaScript': true,
            'enableDomStorage': false,
            'universalLinksOnly': false,
            'headers': <String, String>{},
          })
        ],
      );
    });

    test('launch force WebView enable DOM storage', () async {
      await launcher.launch(
        'http://example.com/',
        useSafariVC: true,
        useWebView: true,
        enableJavaScript: false,
        enableDomStorage: true,
        universalLinksOnly: false,
        headers: const <String, String>{},
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('launch', arguments: <String, Object>{
            'url': 'http://example.com/',
            'useSafariVC': true,
            'useWebView': true,
            'enableJavaScript': false,
            'enableDomStorage': true,
            'universalLinksOnly': false,
            'headers': <String, String>{},
          })
        ],
      );
    });

    test('launch force SafariVC to false', () async {
      await launcher.launch(
        'http://example.com/',
        useSafariVC: false,
        useWebView: false,
        enableJavaScript: false,
        enableDomStorage: false,
        universalLinksOnly: false,
        headers: const <String, String>{},
      );
      expect(
        log,
        <Matcher>[
          isMethodCall('launch', arguments: <String, Object>{
            'url': 'http://example.com/',
            'useSafariVC': false,
            'useWebView': false,
            'enableJavaScript': false,
            'enableDomStorage': false,
            'universalLinksOnly': false,
            'headers': <String, String>{},
          })
        ],
      );
    });

    test('launch should return false if platform returns null', () async {
      final bool launched = await launcher.launch(
        'http://example.com/',
        useSafariVC: true,
        useWebView: false,
        enableJavaScript: false,
        enableDomStorage: false,
        universalLinksOnly: false,
        headers: const <String, String>{},
      );

      expect(launched, false);
    });

    test('closeWebView default behavior', () async {
      await launcher.closeWebView();
      expect(
        log,
        <Matcher>[isMethodCall('closeWebView', arguments: null)],
      );
    });
  });
}

class UrlLauncherPlatformMock extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class ImplementsUrlLauncherPlatform extends Mock
    implements UrlLauncherPlatform {}

class ExtendsUrlLauncherPlatform extends UrlLauncherPlatform {
  @override
  final LinkDelegate? linkDelegate = null;
}

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
T? _ambiguate<T>(T? value) => value;
