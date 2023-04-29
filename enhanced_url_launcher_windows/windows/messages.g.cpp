// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v5.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#undef _HAS_EXCEPTIONS

#include "messages.g.h"

#include <flutter/basic_message_channel.h>
#include <flutter/binary_messenger.h>
#include <flutter/encodable_value.h>
#include <flutter/standard_message_codec.h>

#include <map>
#include <optional>
#include <string>

namespace enhanced_url_launcher_windows {

/// The codec used by UrlLauncherApi.
const flutter::StandardMessageCodec& UrlLauncherApi::GetCodec() {
  return flutter::StandardMessageCodec::GetInstance(
      &flutter::StandardCodecSerializer::GetInstance());
}

// Sets up an instance of `UrlLauncherApi` to handle messages through the
// `binary_messenger`.
void UrlLauncherApi::SetUp(flutter::BinaryMessenger* binary_messenger,
                           UrlLauncherApi* api) {
  {
    auto channel =
        std::make_unique<flutter::BasicMessageChannel<flutter::EncodableValue>>(
            binary_messenger, "dev.flutter.pigeon.UrlLauncherApi.canLaunchUrl",
            &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const flutter::EncodableValue& message,
                const flutter::MessageReply<flutter::EncodableValue>& reply) {
            try {
              const auto& args = std::get<flutter::EncodableList>(message);
              const auto& encodable_url_arg = args.at(0);
              if (encodable_url_arg.IsNull()) {
                reply(WrapError("url_arg unexpectedly null."));
                return;
              }
              const auto& url_arg = std::get<std::string>(encodable_url_arg);
              ErrorOr<bool> output = api->CanLaunchUrl(url_arg);
              if (output.has_error()) {
                reply(WrapError(output.error()));
                return;
              }
              flutter::EncodableList wrapped;
              wrapped.push_back(
                  flutter::EncodableValue(std::move(output).TakeValue()));
              reply(flutter::EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
  {
    auto channel =
        std::make_unique<flutter::BasicMessageChannel<flutter::EncodableValue>>(
            binary_messenger, "dev.flutter.pigeon.UrlLauncherApi.launchUrl",
            &GetCodec());
    if (api != nullptr) {
      channel->SetMessageHandler(
          [api](const flutter::EncodableValue& message,
                const flutter::MessageReply<flutter::EncodableValue>& reply) {
            try {
              const auto& args = std::get<flutter::EncodableList>(message);
              const auto& encodable_url_arg = args.at(0);
              if (encodable_url_arg.IsNull()) {
                reply(WrapError("url_arg unexpectedly null."));
                return;
              }
              const auto& url_arg = std::get<std::string>(encodable_url_arg);
              std::optional<FlutterError> output = api->LaunchUrl(url_arg);
              if (output.has_value()) {
                reply(WrapError(output.value()));
                return;
              }
              flutter::EncodableList wrapped;
              wrapped.push_back(flutter::EncodableValue());
              reply(flutter::EncodableValue(std::move(wrapped)));
            } catch (const std::exception& exception) {
              reply(WrapError(exception.what()));
            }
          });
    } else {
      channel->SetMessageHandler(nullptr);
    }
  }
}

flutter::EncodableValue UrlLauncherApi::WrapError(
    std::string_view error_message) {
  return flutter::EncodableValue(flutter::EncodableList{
      flutter::EncodableValue(std::string(error_message)),
      flutter::EncodableValue("Error"), flutter::EncodableValue()});
}
flutter::EncodableValue UrlLauncherApi::WrapError(const FlutterError& error) {
  return flutter::EncodableValue(flutter::EncodableList{
      flutter::EncodableValue(error.message()),
      flutter::EncodableValue(error.code()), error.details()});
}

}  // namespace enhanced_url_launcher_windows
