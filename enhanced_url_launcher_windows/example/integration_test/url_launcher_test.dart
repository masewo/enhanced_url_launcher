// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:enhanced_url_launcher_platform_interface/enhanced_url_launcher_platform_interface.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('canLaunch', (WidgetTester _) async {
    final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;

    expect(await launcher.canLaunch('randomstring'), false);

    // Generally all devices should have some default browser.
    expect(await launcher.canLaunch('http://flutter.dev'), true);
  });
}
