import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'sfmc_platform_interface.dart';
import 'inbox_message.dart';

class SfmcWebMock extends SfmcPlatform {
  @override
  Future<String?> getSystemToken() async => "WEB-MOCK-TOKEN-12345";

  @override
  Future<bool?> isPushEnabled() async => true;

  @override
  Future<void> enablePush() async => print("Mock: Push Enabled");

  @override
  Future<void> disablePush() async => print("Mock: Push Disabled");

  @override
  Future<void> enableLogging() async => print("Mock: Logging Enabled");

  @override
  Future<void> disableLogging() async => print("Mock: Logging Disabled");

  @override
  Future<void> logSdkState() async => print("Mock: Logging SDK State");

  @override
  Future<String?> getDeviceId() async => "WEB-MOCK-DEVICE-ID";

  @override
  Future<Map<String, String>> getAttributes() async => {"example_attr": "mock_value"};

  @override
  Future<void> setAttribute(String key, String value) async => print("Mock: Set Attribute $key=$value");

  @override
  Future<void> clearAttribute(String key) async => print("Mock: Clear Attribute $key");

  @override
  Future<void> addTag(String tag) async => print("Mock: Add Tag $tag");

  @override
  Future<void> removeTag(String tag) async => print("Mock: Remove Tag $tag");

  @override
  Future<List<String>> getTags() async => ["mock-tag-1", "mock-tag-2"];

  @override
  Future<void> setContactKey(String contactKey) async => print("Mock: Set Contact Key $contactKey");

  @override
  Future<String?> getContactKey() async => "mock-contact-key";

  @override
  Future<void> trackEvent(Map<String, dynamic> eventJson) async => print("Mock: Track Event $eventJson");

  @override
  Future<void> setAnalyticsEnabled(bool analyticsEnabled) async => print("Mock: Analytics Enabled: $analyticsEnabled");

  @override
  Future<bool> isAnalyticsEnabled() async => true;

  @override
  Future<void> setPiAnalyticsEnabled(bool analyticsEnabled) async => print("Mock: PI Analytics Enabled: $analyticsEnabled");

  @override
  Future<bool> isPiAnalyticsEnabled() async => true;

  @override
  Future<List<InboxMessage>> getMessages() async => [];

  @override
  Future<List<InboxMessage>> getReadMessages() async => [];

  @override
  Future<List<InboxMessage>> getUnreadMessages() async => [];

  @override
  Future<List<InboxMessage>> getDeletedMessages() async => [];

  @override
  Future<void> setMessageRead(String id) async => print("Mock: Message Read $id");

  @override
  Future<void> deleteMessage(String id) async => print("Mock: Message Deleted $id");

  @override
  Future<int> getMessageCount() async => 0;

  @override
  Future<int> getReadMessageCount() async => 0;

  @override
  Future<int> getUnreadMessageCount() async => 0;

  @override
  Future<int> getDeletedMessageCount() async => 0;

  @override
  Future<void> markAllMessagesRead() async => print("Mock: Mark All Read");

  @override
  Future<void> markAllMessagesDeleted() async => print("Mock: Mark All Deleted");

  @override
  Future<bool> refreshInbox(dynamic callback) async => true;

  @override
  Future<void> registerInboxResponseListener(dynamic callback) async {}

  @override
  Future<void> unregisterInboxResponseListener(dynamic callback) async {}
}
