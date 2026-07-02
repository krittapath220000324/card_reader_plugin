
import "package:card_reader_plugin/na_libs_method_abstract.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

import "card_reader_plugin_method_channel.dart";

abstract class CardReaderPluginPlatform extends PlatformInterface 
    implements NaLibsMethodAbstract{
  
  /// Constructs a CardReaderPluginPlatform.
  CardReaderPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static CardReaderPluginPlatform _instance = MethodChannelCardReaderPlugin();

  /// The default instance of [CardReaderPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCardReaderPlugin].
  static CardReaderPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CardReaderPluginPlatform] when
  /// they register themselves.
  static set instance(CardReaderPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError(
        "getPlatformVersion() has not been implemented."
    );
  }

  @override
  Future<dynamic> getCardStatus() {
    throw UnimplementedError(
        "getCardStatus() has not been implemented."
    );
  }

  @override
  Future<dynamic> getPhotoByteImage() {
    throw UnimplementedError(
        "getPhotoByteImage() has not been implemented."
    );
  }

  @override
  Future<dynamic> getIDCardTextWithArgument({
    int? optionNumber
  }) {
    throw UnimplementedError(
        "getIDCardTextWithArgument() has not been implemented."
    );
  }

  @override
  Future<dynamic> getIDCardText() {
    throw UnimplementedError(
        "getIDCardText() has not been implemented."
    );
  }

  @override
  Future<dynamic> getIDCardNumber() {
    throw UnimplementedError(
        "getIDCardNumber() has not been implemented."
    );
  }

  @override
  Future<dynamic> getSoftwareInfo() {
    throw UnimplementedError(
        "getSoftwareInfo() has not been implemented."
    );
  }

  @override
  Future<dynamic> getReaderInfo() {
    throw UnimplementedError(
        "getReaderInfo() has not been implemented."
    );
  }

  @override
  Future<dynamic> getLicenseInfo() {
    throw UnimplementedError(
        "getLicenseInfo() has not been implemented."
    );
  }

  @override
  Future<dynamic> disconnectCard() {
    throw UnimplementedError(
        "disconnectCard() has not been implemented."
    );
  }

  @override
  Future<dynamic> connectCard() {
    throw UnimplementedError(
        "connectCard() has not been implemented."
    );
  }

  @override
  Future<dynamic> deselectReader() {
    throw UnimplementedError(
        "deselectReader() has not been implemented."
    );
  }

  @override
  Future<dynamic> selectReader({
    String? deviceName
  }) {
    throw UnimplementedError(
        "selectReader() has not been implemented."
    );
  }

  @override
  Future<dynamic> findReader({
    int? timeoutIOS
  }) {
    throw UnimplementedError(
        "findReader() has not been implemented."
    );
  }

  @override
  Future<dynamic> closedLibrary() {
    throw UnimplementedError(
        "closedLibrary() has not been implemented."
    );
  }

  @override
  Future<dynamic> setPermissions({
    int? permissionCode
  }) {
    throw UnimplementedError(
        "setPermissions() has not been implemented."
    );
  }

  @override
  Future<dynamic> closedEventsListener() {
    throw UnimplementedError(
        "closedEventsListener() has not been implemented."
    );
  }

  @override
  Future<dynamic> updateLicenseFile() {
    throw UnimplementedError(
        "updateLicenseFile() has not been implemented."
    );
  }

  @override
  Future<dynamic> openLibrary() {
    throw UnimplementedError(
        "openLibrary() has not been implemented."
    );
  }

  @override
  Future<dynamic> requestPermission() {
    throw UnimplementedError(
        "requestPermission() has not been implemented."
    );
  }

  /// ios
  @override
  Future<dynamic> getReaderList() async {
    throw UnimplementedError(
        "getReaderList() has not been implemented."
    );
  }

  /// ios
  @override
  Future<dynamic> setReaderType({
    bool? disabledBLEMode
  }) async {
    throw UnimplementedError(
        "setReaderType() has not been implemented."
    );
  }

  /// ios
  @override
  Future<dynamic> stopFindReader() async {
    throw UnimplementedError(
        "stopFindReader() has not been implemented."
    );
  }

}
