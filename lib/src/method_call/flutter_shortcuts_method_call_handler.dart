/* 

            Copyright (c) 2021 divshekhar (Divyanshu Shekhar).
                          All rights reserved.

The plugin is governed by the BSD-3-clause License. Please see the LICENSE file
for more details.

*/

import 'package:flutter/services.dart';
import 'package:flutter_shortcuts/src/platform/flutter_shortcuts_platform.dart';
import 'package:flutter_shortcuts/src/helper/helper.dart';

class FlutterShortcutsMethodCallHandler extends FlutterShortcutsPlatform {
  final MethodChannel _channel =
      MethodChannel('com.divyanshushekhar.flutter_shortcuts');

  MethodChannel get channel => _channel;

  @override
  Future<void> initialize(FlutterShortcutAction actionHandler) async {
    channel.setMethodCallHandler((MethodCall call) async {
      assert(call.method == 'launch');
      actionHandler(call.arguments);
    });
    final String action = await channel.invokeMethod<String>('getLaunchAction');
    if (action != null) {
      actionHandler(action);
    }
  }

  @override
  Future<int> getMaxShortcutLimit() {
    return channel.invokeMethod<int>('getMaxShortcutLimit');
  }

  @override
  Future<void> setShortcutItems(List<FlutterShortcutItem> items) async {
    final List<Map<String, String>> itemsList =
        items.map(_serializeItem).toList();
    await channel.invokeMethod<void>('setShortcutItems', itemsList);
  }

  @override
  Future<void> clearShortcutItems() async {
    await channel.invokeMethod<void>('clearShortcutItems');
  }

  @override
  Future<void> pushShortcutItem(FlutterShortcutItem shortcut) async {
    final Map<String, String> item = _serializeItem(shortcut);
    await channel.invokeMethod<void>('pushShortcutItem', [item]);
  }

  @override
  Future<void> updateAllShortcutItems(List<FlutterShortcutItem> items) async {
    final List<Map<String, String>> itemsList =
        items.map(_serializeItem).toList();
    await channel.invokeMethod<void>('updateAllShortcutItems', itemsList);
  }

  @override
  Future<void> addShortcutItems(List<FlutterShortcutItem> items) async {
    final List<Map<String, String>> itemsList =
        items.map(_serializeItem).toList();
    await channel.invokeMethod<void>('addShortcutItems', itemsList);
  }

  @override
  Future<void> updateShortcutItem(
      String id, FlutterShortcutItem shortcut) async {
    final Map<String, String> item = _serializeItem(shortcut);
    await channel.invokeMethod<void>('updateShortcutItem', [item]);
  }

  @override
  Future<void> changeShortcutItemIcon(String id, String icon) async {
    await channel.invokeMethod<void>('changeShortcutItemIcon', [id, icon]);
  }

  Map<String, String> _serializeItem(FlutterShortcutItem item) {
    return <String, String>{
      'id': item.id,
      'action': item.action,
      'shortLabel': item.shortLabel,
      'longLabel': item.longLabel,
      'icon': item.icon,
    };
  }
}