import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'card_reader_plugin_platform_interface.dart';


class MethodChannelCardReaderPlugin extends CardReaderPluginPlatform {

  @visibleForTesting
  final MethodChannel _channel = const MethodChannel("THAI_ID_CARD_READER");

  @override
  Future<String?> getPlatformVersion() async {
    final String version = await _channel.invokeMethod<String>(
      "GET_PLATFORM_VERSION",
    ) ?? "";
    return version;
  }

  @override
  Future<dynamic> requestPermission() async {
    return await _channel.invokeMethod<dynamic>(
      "REQUEST_PERMISSIONS",
    );
  }

  @override
  Future<dynamic> openLibrary() async {
    return await _channel.invokeMethod<dynamic>(
      "OPEN_LIBS",
    );
  }

  @override
  Future<dynamic> updateLicenseFile() async {
    return await _channel.invokeMethod<dynamic>(
      "UPDATE_LICENSE_FILE",
    );
  }

  @override
  Future<dynamic> closedEventsListener() async {
    return await _channel.invokeMethod<dynamic>(
      "CLOSED_EVENTS_LISTENER",
    );
  }

  @override
  Future<dynamic> setPermissions({
    int? permissionCode
  }) async {
    return await _channel.invokeMethod<dynamic>(
      "SET_PERMISSIONS",
      permissionCode
    );
  }

  @override
  Future<dynamic> closedLibrary() async {
    return await _channel.invokeMethod<dynamic>(
      "CLOSED_LIBS",
    );
  }

  @override
  Future<dynamic> findReader({
    int? timeoutIOS
  }) async {
    return await _channel.invokeMethod<dynamic>(
      "FIND_READER",
      timeoutIOS
    );
  }

  @override
  Future<dynamic> selectReader({
    String? deviceName
  }) async {
    return await _channel.invokeMethod<dynamic>(
      "SELECT_READER",
      deviceName
    );
  }

  @override
  Future<dynamic> deselectReader() async {
    return await _channel.invokeMethod<dynamic>(
      "DESELECT_READER",
    );
  }

  @override
  Future<dynamic> connectCard() async {
    return await _channel.invokeMethod<dynamic>(
      "CONNECTED_CARD",
    );
  }

  @override
  Future<dynamic> disconnectCard() async {
    return await _channel.invokeMethod<dynamic>(
      "DISCONNECTED_CARD",
    );
  }

  @override
  Future<dynamic> getLicenseInfo() async {
    return await _channel.invokeMethod<dynamic>(
      "GET_LICENSE_INFO",
    );
  }

  @override
  Future<dynamic> getReaderInfo() async {
    return await _channel.invokeMethod<dynamic>(
      "GET_READER_INFO",
    );
  }

  @override
  Future<dynamic> getSoftwareInfo() async {
    return await _channel.invokeMethod<dynamic>(
      "GET_SOFTWARE_INFO",
    );
  }

  @override
  Future<dynamic> getIDCardNumber() async {
    return await _channel.invokeMethod<dynamic>(
      "ID_CARD_NUMBER",
    );
  }

  @override
  Future<dynamic> getIDCardText() async {
    return await _channel.invokeMethod<dynamic>(
      "ID_CARD_TEXT",
    );
  }

  @override
  Future<dynamic> getIDCardTextWithArgument({
    int? optionNumber
  }) async {
    return await _channel.invokeMethod<dynamic>(
      "ID_CARD_TEXT_WITH_OPTIONS",
      optionNumber
    );
  }

  @override
  Future<dynamic> getPhotoByteImage() async {
    return await _channel.invokeMethod<dynamic>(
      "ID_CARD_PHOTO",
    );
  }

  @override
  Future<dynamic> getCardStatus() async {
    return await _channel.invokeMethod<dynamic>(
      "CARD_STATUS",
    );
  }

  /// ios
  @override
  Future<dynamic> getReaderList() async {
    return await _channel.invokeMethod<dynamic>(
      "READER_LIST",
    );
  }

  /// ios
  @override
  Future<dynamic> setReaderType({
    bool? disabledBLEMode
  }) async {
    return await _channel.invokeMethod<dynamic>(
      "SET_READER_TYPE",
      disabledBLEMode
    );
  }

  /// ios
  @override
  Future<dynamic> stopFindReader() async {
    return await _channel.invokeMethod<dynamic>(
        "STOP_FIND_READER"
    );
  }

}
