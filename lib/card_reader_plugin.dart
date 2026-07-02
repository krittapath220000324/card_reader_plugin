
import 'card_reader_plugin_platform_interface.dart';

class CardReaderPlugin {

  CardReaderPlugin._private();
  static final CardReaderPlugin _instance = CardReaderPlugin._private();
  factory CardReaderPlugin() => _instance;

  final CardReaderPluginPlatform _pluginPlatform = CardReaderPluginPlatform.instance;

  Future<String?> getPlatformVersion() async {
    return await _pluginPlatform.getPlatformVersion();
  }
  
  Future<dynamic> requestPermission() async {
    return await _pluginPlatform.requestPermission();
  }

  Future<dynamic> openLibrary() async {
    return await _pluginPlatform.openLibrary();
  }

  Future<dynamic> updateLicenseFile() async {
    return await _pluginPlatform.updateLicenseFile();
  }

  /// android
  Future<dynamic> closedEventsListenerAndroid() async {
    return await _pluginPlatform.closedEventsListener();
  }

  /// android
  Future<dynamic> setPermissionsAndroid({
    int? permissionCode
  }) async {
    return await _pluginPlatform.setPermissions(
      permissionCode: permissionCode
    );
  }

  Future<dynamic> closedLibrary() async {
    return await _pluginPlatform.closedLibrary();
  }

  Future<dynamic> findReader({
    int? timeoutIOS
  }) async {
    return await _pluginPlatform.findReader(
      timeoutIOS: timeoutIOS
    );
  }

  Future<dynamic> selectReader({
    String? deviceName
  }) async {
    return await _pluginPlatform.selectReader(
      deviceName: deviceName
    );
  }
  
  Future<dynamic> deselectReader() async {
    return await _pluginPlatform.deselectReader();
  }

  Future<dynamic> connectCard() async {
    return await _pluginPlatform.connectCard();
  }

  Future<dynamic> disconnectCard() async {
    return await _pluginPlatform.disconnectCard();
  }

  Future<dynamic> getLicenseInfo() async {
    return await _pluginPlatform.getLicenseInfo();
  }
  
  Future<dynamic> getReaderInfo() async {
    return await _pluginPlatform.getReaderInfo();
  }
  
  Future<dynamic> getSoftwareInfo() async {
    return await _pluginPlatform.getSoftwareInfo();
  }
  
  Future<dynamic> getIDCardNumber() async {
    return await _pluginPlatform.getIDCardNumber();
  }
  
  Future<dynamic> getIDCardText() async {
    return await _pluginPlatform.getIDCardText();
  }

  Future<dynamic> getIDCardTextWithArgument({
    int? optionNumber
  }) async {
    return await _pluginPlatform.getIDCardTextWithArgument(
      optionNumber: optionNumber
    );
  }
  
  Future<dynamic> getPhotoByteImage() async {
    return await _pluginPlatform.getPhotoByteImage();
  }

  Future<dynamic> getCardStatus() async {
    return await _pluginPlatform.getCardStatus();
  }

  /// ios
  Future<dynamic> getReaderListIos() async {
    return await _pluginPlatform.getReaderList();
  }

  /// ios
  Future<dynamic> setReaderTypeIos({
    bool? disabledBLEMode
  }) async {
    return await _pluginPlatform.setReaderType(
      disabledBLEMode: disabledBLEMode
    );
  }

  /// ios
  Future<dynamic> stopFindReaderIos() async {
    return await _pluginPlatform.stopFindReader();
  }

}
