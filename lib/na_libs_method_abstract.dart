

import 'package:flutter/material.dart';

abstract class NaLibsMethodAbstract {

  @protected
  Future<dynamic> requestPermission();

  @protected
  Future<dynamic> openLibrary();

  @protected
  Future<dynamic> updateLicenseFile();

  /// android
  @protected
  Future<dynamic> closedEventsListener();

  @protected
  Future<dynamic> setPermissions({
    int? permissionCode
  });

  @protected
  Future<dynamic> closedLibrary();

  @protected
  Future<dynamic> findReader();

  @protected
  Future<dynamic> selectReader({
    String? deviceName
  });

  @protected
  Future<dynamic> deselectReader();

  @protected
  Future<dynamic> connectCard();

  @protected
  Future<dynamic> disconnectCard();

  @protected
  Future<dynamic> getLicenseInfo();

  @protected
  Future<dynamic> getReaderInfo();

  @protected
  Future<dynamic> getSoftwareInfo();

  @protected
  Future<dynamic> getIDCardNumber();

  @protected
  Future<dynamic> getIDCardText();

  /// android
  /// ios not used params
  @protected
  Future<dynamic> getIDCardTextWithArgument({
    int? optionNumber
  });

  @protected
  Future<dynamic> getPhotoByteImage();

  @protected
  Future<dynamic> getCardStatus();

  /// ios
  @protected
  Future<dynamic> setReaderType({
    bool? disabledBLEMode
  });

  /// ios
  @protected
  Future<dynamic> stopFindReader();

  /// ios
  @protected
  Future<dynamic> getReaderList();


}