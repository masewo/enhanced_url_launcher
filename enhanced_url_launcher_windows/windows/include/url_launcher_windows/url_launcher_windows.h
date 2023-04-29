// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#ifndef PACKAGES_enhanced_url_launcher_enhanced_url_launcher_WINDOWS_WINDOWS_INCLUDE_enhanced_url_launcher_WINDOWS_enhanced_url_launcher_PLUGIN_H_
#define PACKAGES_enhanced_url_launcher_enhanced_url_launcher_WINDOWS_WINDOWS_INCLUDE_enhanced_url_launcher_WINDOWS_enhanced_url_launcher_PLUGIN_H_

#include <flutter_plugin_registrar.h>

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FLUTTER_PLUGIN_EXPORT __declspec(dllimport)
#endif

#if defined(__cplusplus)
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void UrlLauncherWindowsRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // PACKAGES_enhanced_url_launcher_enhanced_url_launcher_WINDOWS_WINDOWS_INCLUDE_enhanced_url_launcher_WINDOWS_enhanced_url_launcher_PLUGIN_H_
