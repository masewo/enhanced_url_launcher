// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <windows.h>

#include <memory>
#include <optional>
#include <sstream>
#include <string>

#include "messages.g.h"
#include "system_apis.h"

namespace enhanced_url_launcher_windows {

class EnhancedUrlLauncherPlugin : public flutter::Plugin, public UrlLauncherApi {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrar* registrar);

  EnhancedUrlLauncherPlugin();

  // Creates a plugin instance with the given SystemApi instance.
  //
  // Exists for unit testing with mock implementations.
  EnhancedUrlLauncherPlugin(std::unique_ptr<SystemApis> system_apis);

  virtual ~EnhancedUrlLauncherPlugin();

  // Disallow copy and move.
  EnhancedUrlLauncherPlugin(const EnhancedUrlLauncherPlugin&) = delete;
  EnhancedUrlLauncherPlugin& operator=(const EnhancedUrlLauncherPlugin&) = delete;

  // UrlLauncherApi:
  ErrorOr<bool> CanLaunchUrl(const std::string& url) override;
  std::optional<FlutterError> LaunchUrl(const std::string& url) override;

 private:
  std::unique_ptr<SystemApis> system_apis_;
};

}  // namespace enhanced_url_launcher_windows
